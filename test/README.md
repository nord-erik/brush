# brush test suite

you can execute `all.sh` in order to run all tests. there are some things to know before you make
any changes. please read below.

## adding new tests

every test case is structured like so:

```bash
# do somethings
something
something_else

# assert exit code is 0
brush_assert $? "example_test_suite" "example_test_name"
```

there is also a helper function to make sure that a certain function is defined, used extensively
for testing brush's API definitions.

```bash
brush_defined function_under_test
brush_assert $? "example_test_suite" "example_test_function_defined"
```

usually a test file begins with a similar test to verify that the function under test actually
exists.

## tribal knowledge

there are some things among these tests that may not be very obvious upon first read. please keep
reading to get a rundown on some of them.

### exactly one assert per test

a test is defined per assertion basis. therefore it is only allowed to have one assert per test
case. this is very important because CI/CD can and will count how many tests exists by grepping
for `brush_assert` invocations.

### catching exits

some test cases try to test that a certain function did an exit (close shell) rather than return.
for example the test:

```bash
(
  sweep_nok 0
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_nok_exits_on_0"
```

this mechanic works because if `sweep_nok 0` returns rather than exits, then `return 0` will
execute. which is finally checked for in `test $? -eq 1`, ultimately test-asserted.

please PR this repo if you know a more consistent and readable way to test that functions exits.
there is probably some setup using `trap` that can be used.....
