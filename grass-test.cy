load "grass.cy"

def(rel)^: load("grass-test.cy")

def(test)^:
  test := "wwWWwWWWwvWwWWwWwwwwWwwwwwww"
  code := say(grass_parse_string(test))
  say grass_compile_code(['abs, 0, code],'[out, succ, in, w], :run true)
  grass_eval_string(test)

def(id)^:
  test := "ww"
  code := say(grass_parse_string(test))
  say grass_compile_code(['abs, 0, code],'[out, succ, in, w], :run false)
  grass_eval_string(test)

def(echo)^:
  grass_eval_string("wWWWWWwWWWwWWWwww")

def(stdin.read)^:
  let(rec)^(&opt buf = ""):
    aif(.readline()): rec(buf + it)
     else: buf


