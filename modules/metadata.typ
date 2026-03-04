// ─────────────────────────────────────────────────────────────────────────────
// 개인 정보 및 이력서 데이터 (Personal Metadata)
// ─────────────────────────────────────────────────────────────────────────────

#let metadata = (
  name: (
    korean: "최지석",
    english: "Jiseok Choi",
  ),
  role: (
    ko: "소프트웨어 엔지니어",
    en: "Software Engineer",
  ),
  contact: (
    email: "jiseok.dev@gmail.com",
    github: "ever0de",
  ),
  bio: (
    ko: "시스템 내부가 실제로 어떻게 작동하는지 파고드는 것을 즐기는 프로그래머입니다.",
    en: "A programmer who finds joy in digging all the way down until the internals make sense.",
  ),
  skills: (
    (label-ko: "언어", label-en: "Languages", value: "Rust, Go, TypeScript"),
    (label-ko: "스토리지 엔진", label-en: "Storage Engines", value: "LSM-Tree, pager-based B+Tree"),
    (label-ko: "데이터베이스", label-en: "Databases", value: "MySQL, PostgreSQL"),
  ),
  work: (
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "Newmetric",
      org-en: "Newmetric",
      period-ko: "2023년 4월 – 2026년 3월",
      period-en: "Apr 2023 – Mar 2026",
      tags: ("Rust", "Go", "gRPC", "k8s", "pebble"),
      body-ko: [
        블록체인 RPC 인프라 및 분산 KV 스토어 설계·구현. 노드 소프트웨어부터 배포 자동화까지 백엔드 전반 담당.

        - 읽기/쓰기 노드 분리로 lock contention 제거 — 수평 확장이 불가능한 단일 노드 구조를 수평 확장 가능하게 전환.
          - CoW 스냅샷 체크포인트 + change sets 기반 merge on read로 time travel query 지원 — 읽기 빈도가 낮은 과거 height 상태를 change sets merge sort로 제공하여 스토리지 풋프린트 최소화.
          - 벤치마크: initia 메인넷 Day 1 약 140k ops/s, p90 = 26.1ms (동일 하드웨어 바닐라 노드 대비 17.5배 개선).
        - 네트워크 레이어에 이벤트 기반 비동기 네트워킹 도입 — zero-allocation 패킷 처리로 GC 압력 최소화.
        - cosmos-sdk의 멤풀을 Signer 기반 샤딩 멤풀으로 교체하여 CheckTx/RecheckTx 병렬화.
        - Sparse Merkle Tree witness 추출 + partial state re-execution 기반 L1↔L2 stateless verification 구현.
        - cosmos-sdk용 mainnet fork node 구현 (layered CoW DB 기반 height-level state fork).
        - 온체인 거버넌스 업그레이드 감지·rolling restart 자동화 Kubernetes operator 개발.
        - actions-runner-controller 기반 self-hosted GitHub Actions runner 5대 이상 운영.
      ],
      body-en: [
        - Read/write node split: eliminated lock contention and enabled horizontal scaling of a previously non-scalable single-node architecture.
          - Time travel queries via CoW snapshot checkpoints + merge-on-read over change sets — low-frequency historical height reads served by merge-sorting change sets, minimising storage footprint.
          - Benchmark: initia mainnet Day 1 ≈140k ops/s, p90 = 26.1ms (17.5× improvement vs single-node vanilla on identical hardware).
        - Adopted event-driven async networking for zero-allocation packet handling and GC pressure reduction.
        - Replaced the cosmos-sdk mempool with a Signer-based sharded mempool for parallel CheckTx/RecheckTx processing.
        - L1↔L2 stateless verification via sparse Merkle tree witness extraction + partial state re-execution.
        - cosmos-sdk mainnet fork node: height-level state fork via layered CoW DB.
        - k8s operator for on-chain governance upgrade detection and rolling restarts; 5+ self-hosted CI runners.
      ],
    ),
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "Manythings (구 Casting 인수)",
      org-en: "Manythings (acq. Casting)",
      period-ko: "2021년 10월 – 2023년 2월",
      period-en: "Oct 2021 – Feb 2023",
      tags: ("Rust", "Go", "TypeScript"),
      body-ko: [
        - 파츠 우선순위 순서대로 개별 아이템 이미지를 SVG로 레이어 합성 후 PNG 렌더링하는 이미지 서버 구현 — equip/unequip 요청 시 즉시 PNG 재생성.
        - ImmutableX L2 on-chain 이벤트 폴링 기반 배치 job으로 토큰 민팅 상태 인덱싱 — treasury burn 감지 후 상태 전이로 ERC721 burn-and-redeem 처리 보장.
        - Fastify 기반 REST API 서버 구현 — crafting(equip/unequip 트랜잭션), 메타데이터 관리, on-chain 서명 검증 포함.
        - JS로 구현된 PFP 이미지 생성기의 성능 문제(수 시간 소요)를 Rust로 재구현 — 병렬 스레드풀 이용으로 생성 시간을 분 단위로 단축.
        - Flow 블록체인 + Cadence 스마트 컨트랙트 기반 마켓플레이스 서버 구현 — on-chain 이벤트 폴링 기반 indexer로 최신 블록 이벤트를 MySQL에 적재하고 Fastify API 서버로 서빙.
        - 다중 체인 간 자산 이전을 위한 bridge 백엔드 아키텍처 설계 및 구현.
      ],
      body-en: [
        - Built a real-time image compositing server: stacks individual partz images as SVG layers in priority order, renders to PNG on demand; image regenerated on each equip/unequip request.
        - Implemented an ImmutableX L2 batch job polling on-chain events to index token mint state — detects treasury burns and drives an ERC721 burn-and-redeem state transition to guarantee delivery.
        - Built a Fastify REST API server covering crafting transactions (equip/unequip), metadata management, and on-chain signature verification.
        - Rewrote a JS PFP image generator (hours-long runtime) in Rust — thread-pool-based parallel layer compositing reduced generation time from hours to minutes.
        - Built a marketplace server for a Flow blockchain + Cadence smart-contract platform — implemented an on-chain event polling indexer that stores the latest block events in MySQL, served via a Fastify API server.
        - Designed and implemented a cross-chain bridge backend architecture for multi-chain asset transfer.
      ],
    ),
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "HYPERITHM Co., Ltd. · 산업기능요원",
      org-en: "HYPERITHM Co., Ltd. · Industrial Technical Personnel",
      period-ko: "2019년 1월 – 2021년 10월",
      period-en: "Jan 2019 – Oct 2021",
      tags: ("Rust", "Go", "TypeScript"),
      body-ko: [
        - 중앙화 거래소(CEX) REST·WebSocket·FIX 프로토콜 클라이언트 Rust로 구현.
        - OrderServer 추상화로 다중 거래소를 지원하는 Order Execution System 구축 — actix-web HTTP API로 전략에 주문 생성·취소·잔고·포지션 조회 제공, MongoDB 기반 주문 상태 관리.
        - alpha strategy 백테스팅을 위한 S3 + MongoDB + Parquet 데이터 파이프라인 구축 — crossbeam 기반 병렬 실행.
      ],
      body-en: [
        - Implemented Rust REST, WebSocket, and FIX protocol clients for centralised exchanges (CEX).
        - Built a multi-exchange Order Execution System with an OrderServer abstraction — actix-web HTTP API exposing order create/cancel, balance, and position queries to strategies; MongoDB-backed order state management.
        - Built an S3 + MongoDB + Parquet data pipeline for alpha strategy backtesting — parallel execution via crossbeam.
      ],
    ),
  ),
  contributhon: (
    (year: "2021", org: "GlueSQL", role-ko: "멘티", role-en: "Mentee"),
    (year: "2022", org: "GlueSQL", role-ko: "멘토", role-en: "Mentor"),
    (year: "2023", org: "GlueSQL", role-ko: "멘토", role-en: "Mentor"),
  ),
  oss: (
    (
      project: "RustPython",
      repo: "RustPython/RustPython",
      period-ko: "2025.07 – 현재",
      period-en: "Jul 2025 – Present",
      tags: ("Rust", "Python"),
      stats: "★21.8k · 56 PRs",
      about-ko: "Rust로 구현한 CPython 호환 Python 인터프리터.",
      about-en: "CPython-compatible Python interpreter written in Rust.",
      contrib-ko: "sqlite3 stdlib CPython 동작 일치화 집중 기여.",
      contrib-en: "sqlite3 stdlib CPython-parity focus.",
    ),
    (
      project: "python/cpython",
      repo: "python/cpython",
      period-ko: "2025.10",
      period-en: "Oct 2025",
      tags: ("C", "Python"),
      stats: "★71.8k · 1 PR",
      about-ko: "CPython 공식 저장소.",
      about-en: "The official CPython repository.",
      contrib-ko: "test_class.py의 Py_TPFLAGS_MANAGED_DICT 상수 오배 수정 (#136538).",
      contrib-en: "Fixed Py_TPFLAGS_MANAGED_DICT constant mislabeled in test_class.py (#136538).",
    ),
    (
      project: "GlueSQL",
      repo: "gluesql/gluesql",
      period-ko: "2021.08 – 2024.11",
      period-en: "Aug 2021 – Nov 2024",
      tags: ("Rust",),
      stats: "★3k · 89 PRs",
      about-ko: "Rust 기반 이식형 SQL 쿼리 엔진.",
      about-en: "Portable SQL query engine in Rust.",
      contrib-ko: "컨트리뷰톤 2021 멘티 → 2022–2023 멘토, 콜라보레이터.",
      contrib-en: "OSS Contributhon: 2021 mentee → 2022–2023 mentor, collaborator.",
    ),
    (
      project: "cdb64-rs",
      repo: "ever0de/cdb64-rs",
      period-ko: "2024 – 현재",
      period-en: "2024 – Present",
      tags: ("Rust",),
      stats: "author · ★17",
      about-ko: "cdb(cr.yp.to) 64비트 오프셋 확장 Rust 구현체.",
      about-en: "Rust implementation of cdb (cr.yp.to) with 64-bit offset extension.",
      contrib-ko: "C FFI·Python(PyO3)·Node(napi) 바인딩 제공.",
      contrib-en: "C FFI, Python (PyO3), Node (napi) bindings.",
    ),
    (
      project: "InjectiveLabs/cosmos-sdk",
      repo: "InjectiveLabs/cosmos-sdk",
      period-ko: "2025.09 – 2025.10",
      period-en: "Sep – Oct 2025",
      tags: ("Go",),
      stats: "1 PR",
      about-ko: "Injective 메인넷 구동 cosmos-sdk 포크.",
      about-en: "cosmos-sdk fork powering Injective mainnet.",
      contrib-ko: "CoW 인메모리 캐시(MemStore) warmup·lifecycle 구현 (#77).",
      contrib-en: "CoW in-memory cache (MemStore) warmup and lifecycle (#77).",
    ),
    (
      project: "cockroachdb/pebble",
      repo: "cockroachdb/pebble",
      period-ko: "2025.10",
      period-en: "Oct 2025",
      tags: ("Go",),
      stats: "★5.8k · 1 PR",
      about-ko: "CockroachDB 구동 Go LSM 스토리지 엔진.",
      about-en: "Go LSM storage engine powering CockroachDB.",
      contrib-ko: "TombstoneDenseCompactionThreshold 런타임 동적 재설정 지원 (#5458).",
      contrib-en: "Runtime dynamic reconfiguration for TombstoneDenseCompactionThreshold (#5458).",
    ),
    (
      project: "stc",
      repo: "dudykr/stc",
      period-ko: "2022.11",
      period-en: "Nov 2022",
      tags: ("Rust", "TypeScript"),
      stats: "★5.7k · 2 PRs",
      about-ko: "Rust 기반 TypeScript 타입 체커 (SWC 팀).",
      about-en: "Rust-based TypeScript type checker by the SWC team.",
      contrib-ko: "template literal type intrinsics 구현, 배열 패턴 기본값 오류 수정.",
      contrib-en: "Template literal type intrinsics and array pattern default value fix.",
    ),
    (
      project: "apache/opendal",
      repo: "apache/opendal",
      period-ko: "2024.12",
      period-en: "Dec 2024",
      tags: ("Rust",),
      stats: "★4.9k · 1 PR",
      about-ko: "다양한 스토리지 서비스를 단일 레이어로 추상화하는 Apache 프로젝트.",
      about-en: "Apache project providing a unified access layer over diverse storage services.",
      contrib-ko: "NonContiguous Buffer의 to_bytes에서 단일 청크일 때 불필요한 복사 제거 (#5388).",
      contrib-en: "Eliminated unnecessary copy in to_bytes when NonContiguous Buffer contains a single chunk (#5388).",
    ),
    (
      project: "tree-sitter-go-mod",
      repo: "camdencheek/tree-sitter-go-mod",
      period-ko: "2023.12 – 2024.06",
      period-en: "Dec 2023 – Jun 2024",
      tags: ("Rust",),
      stats: "★62 · 1 PR, 1 Issue",
      about-ko: "go.mod 파일용 tree-sitter 문법.",
      about-en: "tree-sitter grammar for go.mod files.",
      contrib-ko: "replace_directive 내 comment 파싱 오류 리포트 및 수정 방향 제안 (#16).",
      contrib-en: "Reported and proposed a fix for incorrect comment parsing inside replace_directive (#16).",
    ),
    (
      project: "simperby",
      repo: "postech-dao/simperby",
      period-ko: "2023.03",
      period-en: "Mar 2023",
      tags: ("Rust",),
      stats: "★74 · 3 PRs",
      about-ko: "분산 조직을 위한 BFT 블록체인 엔진.",
      about-en: "BFT blockchain engine for decentralized organizations.",
      contrib-ko: "ExtraAgendaTransaction 생성 통합 테스트 추가 및 Cargo.lock 관리 개선.",
      contrib-en: "Added integration test for ExtraAgendaTransaction creation; improved Cargo.lock management.",
    ),
    (
      project: "sqlparser-rs",
      repo: "sqlparser-rs/sqlparser-rs",
      period-ko: "2021.08",
      period-en: "Aug 2021",
      tags: ("Rust",),
      stats: "★3.3k · 2 PRs",
      about-ko: "Rust 기반 확장 가능한 SQL 렉서·파서.",
      about-en: "Extensible SQL lexer and parser in Rust.",
      contrib-ko: "TRIM 표현식 파싱용 TrimWhereField 추가 및 테스트 작성 (#334).",
      contrib-en: "Added TrimWhereField for parse_trim_expr with tests (#334).",
    ),
  ),
)
