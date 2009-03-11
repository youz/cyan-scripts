# Unit Test Framework
#   from Practical Common Lisp  Chapter 9
#   http://www.gigamonkeys.com/book/practical-building-a-unit-test-framework.html

test_name = []

require("ut-list.cy")

mac(deftest)^(name, func):
    body := [ `(test_name := [*test_name, '?name]), *func.body.list]
    `begin:
        def(?name, ?Function.new(func.params, Block.new(body)))
        '?name

mac(check)^(forms):
    body := forms.list.map^(f):
        `report_result(?f, '?f, test_name)
    `combine_results(?Block.new(body))

mac(combine_results)^(forms):
    result := Symbol.generate()
    body := forms.list.map^(f){ `unless(?f){ ?result = false } }
    `begin(?Block.new([`(?result := true), *body, result]))

def(report_result)^(result, form, &opt test_name):
    [result&&"pass"||"FAIL", " ... ", test_name.join("/"),
      ": ", form, "\n"].map(print)
    result

