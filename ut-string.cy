
### String utilities

def(String.to_list)^:
  $(s, l) := &(.istring(), [])
  awhile(s.readc()):
    l = [*l, it]
  l

def(String.char_at)^(i):
  #.to_list()[i]
  s := .istring()
  i.times: s.readc()
  s.readc()

def(String.subseq)^(start, &opt end):
  .to_list().subseq(start, end).join()

def(String.split)^(sep):
  if (sep == ""):
    .to_list()
   else:
    $(s, l, e) := &(.istring(), [], "")
    awhile (s.readc()):
      if (it == sep):
        l = [e | l]
        e = ""
       else:
        e += it
    [e | l].reverse()
