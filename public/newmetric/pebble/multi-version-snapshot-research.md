# Question

We're currently integrating MVCC atop a key-value Storage, enabling queries with snapshots of specific versions.

Q: What would be the most efficient approach to generate a "snapshot of a specific version" or an "index of a specific version" in this context?

> It seems like this should function akin to snapshots in btrfs.
> 

However, our requirements preclude traditional garbage collection. We necessitate that snapshots of all database versions persist in their accurate states. Without garbage collection, the key-space could expand unusually.

For example, consider a user storing orderbook data in the Storage. This data, closely resembling a UUID, is likely to produce a unique key for each version. Traditional MVCC storage methods would result in tombstoning upon deletion operations, leading to numerous keys to be read for a particular version.

e.g) 

```
bigendian-version | key...

- func SEARCH(start, end []byte, version uint64)
- func SET(key, value []byte, version uint64)
- func DELETE(key []byte, version uint64)

SEARCH(a, d, 1)
1: a -> aa -> ab -> b -> bb -> c -> cc

DELETE("aa", 2) & SEARCH(a, d, 2)
2: a -> aa -> ab -> b -> bb -> c -> cc
    (tombstone)

SET("aaa", 3) & SEARCH(a, d, 3)
3: a -> aa -> aaa -> ab -> b -> bb -> c -> cc
    (tombstone)
    
----
I don't want the “aa” key to be read in the “3” version.
	I think it should be "a -> aaa", and so on
	Just like a COW BTree!
```

> In the actual database, it is stored as follows.
key: `{user-key}{separator}{bigendian-version desc}`
value: `{tombstone or value}`
> 
> 
>     ref: [Our current schemas](https://www.notion.so/Our-current-schemas-ab7350932f1c4002acd2c74461ff43cc?pvs=21) 
> 

This scenario is currently a bottleneck for us. Queries utilizing only two iterators to retrieve the best bid and ask prices in the order book noticeably slow down with more tombstone keys.

key-value Database: https://github.com/cockroachdb/pebble `v1.1.0`

No tombstone keys at all: 40ms

→

Approximately 15,000,000 versions created: **3m~**

For example, why not create an index structure similar to the [vart](https://github.com/surrealdb/vart) created by surrealdb, but disk-persistent?

- This is an in-memory implementation.
    
    https://github.com/surrealdb/surrealkv/blob/142cc81f18846ed0f157651592a20e984c2c079a/src/storage/kv/store.rs#L353-L415
    
- ref: https://surrealdb.com/blog/vart-a-persistent-data-structure-for-snapshot-isolation

# Environment

1. We're restricted to utilizing specific interfaces that have been predefined.
    
    > Q: Can't change anything?
    A:
    > 
    > 
    > While we're unable to make broad modifications, we do have some flexibility within the provided interface. However, these adjustments are limited to the initialization phase of the database. When a user query is received, we establish a lightweight database wrapper, and within the constraints of the framework ([cosmos-sdk](https://github.com/cosmos/cosmos-sdk)), we can only manipulate version and query parameters.
    > 
    
    Here is an example Go interface
    
    ```go
    type Store interface {
      // Get existing keys from SST, WAL, and memtables.
    	Get(key []byte, version uint64) (value []byte, err error)
    	
    	// This is exactly the same as the single operation of `NewBatch`.
    	Set(key, value []byte, version uint64) (err error)
    	Delete(key []byte, version uint64) (err error)
    	
    	// lowerbound(inclusive), upperbound(exclusive)
    	//
    	// (start < end) && (start <= curr_key < end)
    	Iterator(start, end []byte, version uint64) (iter Iterator, err error)
    	ReverseIterator(start, end []byte, version uint64) (iter Iterator, err error)
    	
    	// Similar to Batch in pebble, this is a batch that is flushed to a memtable in lsm-tree.
    	NewBatch(version uint64) Batch
    }
    
    type Iterator interface {
      // Throws the current state's key, value.
      // If the Iterator is not currently Valid(), it throws nil.
    	Key() []byte
    	Value() []byte
    	
    	// Move to the next cursor.
    	Next()
    	
    	Valid() bool
    	
    	Close() error
    }
    
    // It has atomic commit capabilities and appends data to WALs and memtables.
    type Batch interface {
    	Set(key, value []byte) (err error)
    	Delete(key []byte) (err error)
    	
    	Write() (err error)
    	
    	Close() (err error)
    }
    ```
    
2. Data writing should be extremely lightweight.Although our data influx isn't substantial, we do receive periodic batches.
    
    We don't get a lot of data coming in, but periodically we get a `Batch` 
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a8b8ab97-5615-4ef6-aaa0-783a5821590c/a1d71c9b-9707-46ee-aa70-836f096e9312/Untitled.png)
    
    > The graph below illustrates the average record size per second.
    > 
    
    Normal case: 4s / ≥ 0.3MB
    
    Fastest case: 250ms / ≥ 0.06MB
    
    **→ This implies rapid versioning is essential.**
    
    > While it's not a strict requirement, lightweight processing is preferred. Heavy processes might necessitate segregating `archival` and `latest` data tables.
    
    -  Employ the same **`versioned values`** approach we currently utilize, but limit it to a specific version range from the current one, resembling a typical MVCC database (maintained as a tombstone). It's akin to maintaining a pruned snapshot list.
      ref:  [[1] cockroach versioned values](https://www.notion.so/1-cockroach-versioned-values-30b6eaff369e4a04ac43fd15b72ffb3d?pvs=21)
    > 

# Blockchain state database schema

How do components in the cosmos-sdk called Validators or Full-Nodes handle these queries?

- https://github.com/cosmos/iavl

The iavl+ implementation is built on top of key value storage, which is stored in copy-on-write form.

Get the root key of a particular version from `nodedb`, traverse the avl to find the key, or resolve a range iterator.

→ https://github.com/cosmos/iavl/blob/f0c410282d1ed8135d87b3dd43a6f91c675f5744/nodedb.go#L762-L815

## Our current schemas

We currently use “2” in production.

### 1. Pebble MVCC Comparer

> ref: https://github.com/ever0de/pebble/blob/01000f24cb4533f2322ba3192cb3bbbaf80a3d84/cmd/pebble/mvcc.go#L13-L224
> 

This method uses pebble's MVCC comparer implementation and `Iterator.NextPrefix()` to take a snapshot.

Implementations similar to this

https://github.com/sei-protocol/sei-db/blob/main/ss/pebbledb/iterator.go

### 2. Key, Archive Table

- key table: table that stores all keys that exist to date
`[byte-prefix, user-key...]`
- archive table: `[byte-prefix, user key..., bigendian version desc]`

```
// pseudo code

key_table := prefix_db.Wrap(db, KeyTablePrefix)
archive_table := prefix_db.Wrap(db, ArchiveTablePrefix)

key_iterator := key_table.Iterator(start, end)

records := []records{}
for ; key_iterator.Valid(); key_iterator.Next() {
	curr_key := key_iterator.Key()
	
	start_key := []byte{curr_key..., version...}
	end_key := []byte{curr_key..., BigEndian(0_u64)...}

	archive_iter := archive_table.Iterator(start_key, end_key)
	if archive_iter.Value() == Tombstone {
		continue
	} else {
		records.append(key_iterator.Key(), archive_iter.Value())
	}
}
```

## Anticipating future schemas

**Candidate**

1. Append-only | Copy-on-Write BTree?
    - e.g. https://github.com/khonsulabs/nebari
    
    This is a rust implementation of the append-only btree file format.
    However, new files can be created per version, and there is support for multiple versions of ACID Transaction on a root basis.
    
    We envision a file format very similar to this as a future schema.
    However, the nebari project is not a COW, so version 4 will not be able to read records written in versions 1, 2, and 3.
    
    → This is the biggest pain point I can think of right now.
    
    EDIT) replace nebari to [2] `sanakirja-core` cow btree 
    
2.  [3] immutable database (+ time-travel query)
    
    Perhaps the ultimate solution is a database that is immutable (with objstorage?) + time travel.
    
    However, instead of using a timestamp in the time travel function, you should use the blockchain's height (auto increment value on p2p)
    
3. Is there something you're thinking of? 👀

---

# Reference

### [1] cockroach versioned values

https://github.com/cockroachdb/cockroach/blob/master/docs/design.md#versioned-values

> Cockroach maintains historical versions of values by storing them with associated commit timestamps. Reads and scans can specify a snapshot time to return the most recent writes prior to the snapshot timestamp. Older versions of values are garbage collected by the system during compaction according to a user-specified expiration interval. In order to support long-running scans (e.g. for MapReduce), all versions have a minimum expiration.

Versioned values are supported via modifications to RocksDB to record commit timestamps and GC expirations per key.
> 

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a8b8ab97-5615-4ef6-aaa0-783a5821590c/08a5de46-4c22-403d-aff5-83952c38ba24/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a8b8ab97-5615-4ef6-aaa0-783a5821590c/cb41b924-b841-4d21-9d7f-4f217f65b0d4/Untitled.png)

### [2] `sanakirja-core` cow btree

> general key-value store designed specifically to implement efficient database *forks*
> 

https://pijul.org/posts/2022-01-07-compressed-sanakirja/

### [3] immutable database (+ time-travel query)

1. https://github.com/xtdb/xtdb
2. https://www.datomic.com/
