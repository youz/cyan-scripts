
### List utilities

def(List.car)^: []   # [].car() => []
def(List.cdr)^: []   # [].cdr() => []
def(List.cadr)^: .cdr().car()
def(List.caddr)^: .cdr().cdr().car()
def(List.(+))^(l):[*self | l]

def(List.ncdr)^(n):
  if (n <= 0 || .null?()):
    self
   else:
    .cdr().ncdr(n - 1)

def(List.subseq)^(a, &opt b):
  .ncdr(a).take((b || .length())- a)

def(List.join)^(&opt sep = ""):
  .cdr().foldl(.car().to_s())^(a, e): a + sep + e.to_s()


mac(make_finder)^(name, cond, result, &opt acc0, acc_next, fin):
  func := Function.new($(arg),`{
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

make_finder(find, arg == .car(), .car())  
make_finder(find_if, arg(.car()), .car())  
make_finder(member, arg == .car(), self)  
make_finder(member_if, arg(.car()), self)  
make_finder(position, arg == .car(), acc, 0, acc + 1)
make_finder(position_if, arg(.car()), acc, 0, acc + 1)  
make_finder(remove, arg == .car(), rec(.cdr(), acc), [], acc.append([.car()]), acc)
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
  func := Function.new($(fun), `{
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


List.part=^(_,f):&([],[])
def(Pair.part)^(f):
  x:=.car()
  $(a,b):=.cdr().part(f)
  f(x)&&&([x|a],b)||&(a,[x|b])

List.qsort=^(_,f):[]
def(Pair.qsort)^(f):
  x:=.car()
  $(l,r):=.cdr().part^(y):f(y,x)
  [*l.qsort(f),x|r.qsort(f)]


def(List.group)^(n):
  if (n == 0): error("zero length")
  let(rec)^(&opt l = self, acc = []):
    aif (l.ncdr(n)):
      rec(it, [*acc, l.subseq(0, n)])
     else:
      [*acc, l]

def(List.split_if)^(f):
  let(rec)^(&opt self=self, acc, result):
    if (.null?()):
      result
     else:
      if (f(.car())):
        rec(.cdr(), [], result+acc)
       else:
        rec(.cdr(), acc+[.car()], result)
