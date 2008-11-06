require "cl.cy"

### macros
mac(assert)^(exp):
  `aif (?exp) { it } else { error "failed: " + ?(exp.to_s()) }

### Number


### List utilities

def(List.foreach_idx)^(fn, &opt i = 0):
  unless(.null?()):
    fn(i, .car())
    .cdr().foreach_idx(fn, i+1)

def(List.split)^(e):
  $(acc,result) := &([], [])
  let(rec)^(&opt l = self):
    if (l.null?()):
      push!(result, acc.reverse()).reverse()
     else:
      if (e.equal(l.car())):
        push!(result, acc.reverse())
        acc = []
       else:
        push!(acc, l.car())
      rec(l.cdr())

### String utilities

def(String.to_list)^:
  let^(&opt s = .istring(), l = []):
    awhile(s.readc()): push!(l, it)
    l.reverse()

def(String.char)^(i):
  #.to_list()[i]
  s := .istring()
  i.times: s.readc()
  s.readc()

def(String.subseq)^(start, &opt end):
  .to_list().subseq(start,end).join()

def(String.split)^(sep):
  if (sep == ""):
    .to_list()
   else:
    let^(&opt s = .istring(), l = [], acc = ""):
      awhile (s.readc()):
        if (it == sep):
          push!(l,acc)
          acc = ""
         else:
          acc += it
      push!(l, acc).reverse()

