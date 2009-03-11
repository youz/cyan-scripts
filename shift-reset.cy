require("ut-macro.cy")
require("ut-list.cy")
require("unit-test.cy")

meta_continuation = ^(v): error("No top-level RESET" + v)

mac(reset)^(body):
    with_gensyms(mc, k, v, result):
        `begin:
            ?mc := meta_continuation
            callcc^(?k):
                meta_continuation = ^(?v):
                    meta_continuation = ?mc
                    (?k)(?v)
                ?result := begin(?body)
                meta_continuation(?result)

mac(shift)^(func):
    with_gensyms(k, v, result):
        `callcc^(?k):
            ?result := (?func)^(?v): reset: (?k)(?v)
            meta_continuation(?result)

deftest(test)^:
    say([1] + reset{ [2] + shift^(k){ [3] + k([4]) } + [5]})
    # => [1, 3, 2, 4, 5]
    x = [1] + reset:
            shift^(k){ [2] + k([3]) } +
                shift^(k){ [4] + k([5]) } + [6]
    say x
    #=> [1, 2, 4, 3, 5, 6]

