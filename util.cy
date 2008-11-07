require "clut.cy"

### macros
mac(assert)^(exp):
  `aif (?exp) { it } else { error "failed: " + ?(exp.to_s()) }

### Stream
def(Stream.read)^:
  let(rec)^(&opt buf = ""):
    aif (.readc()): rec(buf + it)
     else: buf

(`class(Echo)^:
    def(init)^(ms, &opt es = stdout):
      .ms = ms
      .es = es

    def(peakc)^: .ms.peakc()
    def(to_s)^: .ms.to_s()
    ?*['write, 'writeline].map^(m):
      fun := `^(arg):
        ?Messenger.new('.ms, m, &('arg))
        ?Messenger.new('.es, m, &('arg))
      Porter.new('def, &(m, fun))

    ?*['readc, 'readline, 'read].map^(m):
      fun := `^:
        aif (?Messenger.new('.ms, m, &())):
          .es.write(it); it
      Porter.new('def, &(m, fun))
  ).eval()


### List utilities

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

