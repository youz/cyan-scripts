### CommonLisp like functions ###

mac(with_gensyms)^(&rest args):
  syms := args.butlast().map^(sym): `(?sym := Symbol.generate())
  `begin(?Block.new(syms.append(args.last1().list)))

mac(catch)^(label,body):
  sym = Symbol.generate()
  `callcc^(?sym):
    ?label.eval() = ?sym
    *(?body.list)

def(throw)^(label, v):
  label.eval()(v)

mac(debug_print)^(exp):
  say "#?= " + exp.to_s()
  `let^(&opt result = (?exp)):
    say "#?- " + result.to_s()
    result

_? = debug_print


### Operator functions
def(Object.equal)^(obj):
  (.parent == obj.parent) && (self == obj)


### List functions
def(List.car)^: []   # [].car() => []
def(List.cdr)^: []   # [].cdr() => []
def(List.cadr)^: .cdr().car()

def(List.ncdr)^(n):
  if (n <= 0 || .null?()):
    self
   else:
    .cdr().ncdr(n - 1)

def(List.subseq)^(a, &opt b):
  .ncdr(a).take((b || .length())- a)

def(List.join)^(&opt sep = ""):
  .cdr().foldl(.car().to_s(), ^(acc, e){ acc + sep + e.to_s() })


mac(make_finder)^(name, cond, result, &opt acc0, acc_next, fin):
#  self0 := Symbol.generate()
  func := Function.new($(arg),`{
#    ?self0 = self
    let(rec)^(&opt self = self, acc = ?acc0):
      if (.null?()):
        ?fin
       else:
        if (?cond):
          ?result
         else:
          rec(self.cdr(), ?acc_next)
  })
  Porter.new('def, &(Messenger.new('List, name), func))

make_finder(find, arg.equal(.car()), .car())  
make_finder(find_if, arg(.car()), .car())  
make_finder(member, arg.equal(.car()), self)  
make_finder(member_if, arg(.car()), self)  
make_finder(position, arg.equal(.car()), acc, 0, acc + 1)
make_finder(position_if, arg(.car()), acc, 0, acc + 1)  
make_finder(remove, arg.equal(.car()), rec(.cdr(), acc), [], acc.append([.car()]), acc)
make_finder(remove_if, arg(.car()),rec(.cdr(),acc), [], acc.append([.car()]), acc)
make_finder(some, arg(.car()), true, [], [], false)
make_finder(every, !arg(.car()), false, [], [], true)
make_finder(notevery, !arg(.car()), true, [], [], false)
make_finder(notany, arg(.car()), false, [], [], true)
#|
def(List.every)^(f): !.some(complement(f))
def(List.notevery)^(f): .some(complement(f))
def(List.notany)^(f): !.some(f)
|#


mac(make_mapper)^(name, args_form, acc_next):
#  self0 = Symbol.generate()
  func := Function.new($(fun), `{
#    ?self0 := self
    let(rec)^(&opt self = self, acc):
      args := ?args_form
      if (.some^(_){_.null?()}):
        acc
       else:
        rec(.map^(_){_.cdr()}, ?acc_next)
  })
  Porter.new('def, &(Messenger.new('List, name), func))

make_mapper(mapc, .map^(a){ a.car() }, fun(*args))
make_mapper(mapcar, .map^(a){ a.car() }, acc.append([fun(*args)]))
make_mapper(mapcan, .map^(a){ a.car() }, acc.append(fun(*args)))
make_mapper(mapl, self, fun(*args))
make_mapper(maplist, self, acc.append([fun(*args)]))
make_mapper(mapcon, self, acc.append(fun(*args)))


