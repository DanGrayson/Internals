fib = n -> if n < 2 then n else fib(n - 1) + fib(n - 2)

elapsedTime fib(26)
elapsedTime apply(26, fib);

elapsedTime (
    t = schedule ((n) -> (fib(n)), 26);
    while not isReady t do nanosleep 1;
    taskResult t)

restart

fib' = n -> (
    if n < 2 then return n;
    t := schedule (() -> fib'(n - 2));
    a := fib'(n - 1);
    await t;
--    while not isReady t do nanosleep 10;
    a + taskResult t)

elapsedTime fib'(2)
elapsedTime fib'(3)
elapsedTime fib'(4)
elapsedTime fib'(5)
elapsedTime fib'(6)
elapsedTime fib'(8)
