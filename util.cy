
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



