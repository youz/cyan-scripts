require("ut-list.cy")
require("unit-test.cy")

deftest(ut_test)^:
  deftest(findtest)^:
    x := iota(10)
    pred := [^(n){ n < 10}, ^(n){ n < 0 }, ^(n){ n.even?() }]
    check:
      x.find(4) == 4
      x.find_if^(n){ n > 8 } == 9
      x.member(5) == [5, 6, 7, 8, 9]
      x.member_if^(n){ n * n > 10 } == [4, 5, 6, 7, 8, 9]
      x.position(6) == 6
      x.position_if^(n){ n.odd?() } == 1
      x.remove(5) == [0, 1, 2, 3, 4, 6, 7, 8, 9]
      x.remove_if^(n){ n.rem(3) == 0 } == [1, 2, 4, 5, 7, 8]
      pred.map^(f){ x.some(f) } == [true, false, true]
      pred.map^(f){ x.every(f) } == [true, false, false]
      pred.map^(f){ x.notevery(f) } == [false, true, true]
      pred.map^(f){ x.notany(f) } == [false, true, false]

  deftest(maptest)^:
    x := [iota(5), iota(5,5)]
    check:
      x.mapc^(a, b){ say(a * b) } == 36
      x.mapcar^(a, b){ [a, b] } == [[0, 5], [1, 6], [2, 7], [3, 8], [4, 9]]
      x.mapcan^(a, b){ [a, b] } == [0, 5, 1, 6, 2, 7, 3, 8, 4, 9]
      x.mapl^(a, b): say(a.append(b).foldl(0)^(c,d){ c + d })
      x.maplist^(a, b){ [*a | b] } == [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 2, 3, 4, 6, 7, 8, 9], [2, 3, 4, 7, 8, 9], [3, 4, 8, 9], [4, 9]]
      x.mapcon^(a, b){ [*a | b] } == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 6, 7, 8, 9, 2, 3, 4, 7, 8, 9, 3, 4, 8, 9, 4, 9]

  check:
    findtest()
    maptest()

ut_test()
