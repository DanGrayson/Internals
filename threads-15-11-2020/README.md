Parallelization in Macaulay2
============================

## Why do we want it?

- faster engine operations (e.g. gb, syzygies, or even just matrix multiplication!)
- produce documentation examples and tests in parallel
- packages such as FastLinAlg and ThreadedGB

## What do we mean when we say "parallel"?

There are various notions that can be considered together or independently:

- Single Instruction, Multiple Data (SIMD) Vectorization
  - Adding 256x1 vector + 256x1 vector
    - 256 add ops; os
	- 256/4 add ops
  - SSE3

- Language Extensions (OpenMP)
  - all, any, same, uniform, ..

#pragma OpenMP parallel
for (int i = 0; i < 256; i++) 
{ ... }

- Task parallelism (TBB)
  - createTask or schedule
  - isReady
  - want: waitForTask

- Async/Await pattern (std::threads)

async f = n -> ( ... )
f(5) -- output a "Promise"
await f(5) -- 8

p = promiseAll( apply( 10, i -> f(i) < 100 ), f(20), f(30) ) -- gives a "Promise"
await p

- Multi-process parallelization (MPI)
  - especially for homotopy continuation

## Issues:

- Incomplete implementation

- Lack of documentation

- Thread safety
  - in the core and packages
  - in the engine and interpreter
    - printing is not thread-safe
  - in third-party libraries
