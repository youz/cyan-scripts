
### macros

mac(with_gensyms)^(&rest args):
  syms := args.butlast().map^(sym): `(?sym := Symbol.generate())
  `begin(?Block.new(syms.append(args.last1().list)))


mac(catch)^(label,body):
  sym = Symbol.generate()
  `callcc^(?sym):
    ?label.eval() = ?sym
    ?*body.list

def(throw)^(label, v):
  label.eval()(v)



mac(assert)^(exp):
  `aif (?exp) { it } else { error "failed: " + ?(exp.to_s()) }


mac(debug_print)^(exp):
  say "#?= " + exp.to_s()
  `let^(&opt result = (?exp)):
    say "#?- " + result.to_s()
    result

_? = debug_print

