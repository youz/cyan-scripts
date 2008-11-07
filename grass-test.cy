require "grass.cy"

class(Echo)^:
  def(init)^(ms, &opt es = stdout):
    $(.ms, .es) = &(ms, es)
  def(write)^(obj): .ms.write(obj); .es.write(obj)
  def(to_s)^: .ms.to_s()

def(test)^(name, code, &key input = "", run = true, out, test):
  $(is, es) := &(input.istring(), Echo.new("".ostring()))
  def(judge)^(v): if (v) {"ok"} else {"failed"}
  say("\n" + name + ":")
  f := grass_eval_string(code, :run run, :output es, :input is)
  if (f):
    if (out): say("\n  => " + judge(out == es.to_s()))
    if (test): say("  " + test.to_s() + "\n   => " + judge(test(f)))
   else:
    say("\nfailed")

test("w x 16", "wwWWwWWWwvWwWWwWwwwwWwwwwwww",
     :out "wwwwwwwwwwwwwwww")
test("echo", "wwwvwWWWWWWwwWwWwwwwwWwWwwwwWWWWwwwwwwWwWw",
     :input "grass.cy", :out "grass.cy")
test("reverse", "wwwvwWWWWWWwwWwWwwwWwWwWWWWwwwwwwwwWwWwwwwwww",
     :input "grass.cy", :out "yc.ssarg")
test("ascii", "wWWwWWWWwvwwwwWWWwwWwwWWWWWWwwwwWwwvwwWWwvwWWWwwWwwwWWwWwwWWWWWWWwwwWwwwWWWWWWWWWwwwWwwWWWWWWWwWwwwwwwwwwwwwwwwWwwwwwwwwwwwwwwwwwWWWWWWWWWWwwwwwwwwwWWWWWWWWWWWwWWWWWWWWWWWWWWWWwWwwwwwwwWWWWWWWWWWWWWWWwWwwwwwwwwwwwwwwwwwwwwWwwwwwww",
     :out " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")

test("id", "w",
     :test ^(f){ [1, 2, 3].map(f) == [1, 2, 3]})
test("lambda true", "wWWWWwwww",
     :test ^(f) { f('a)('b) == 'a })
test("lambda false", "ww", :run false,
     :test ^(f) { f('a)('b) == 'b })
test("church-num 256", "wwWWwWWWwvWwWw",
     :test ^(f) { f(^(x){ x + 1 })(0) == 256 })
def(fact)^(f):
  ^(x):
    if (x < 2): 1
     else: x * f(x - 1)
test("y-combinator", "wwWWwwWwwvwwWWWwWWWwvwWWwWw", :run false,
     :test ^(y){ y(fact)(10) == 3628800 })

test("meadows", "wWWwwwwWWww")
