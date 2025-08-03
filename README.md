# bru.sh 🪥

A minified library for shell scripts that contain assertions about the context. Useful for
defensive programming when you want to make sure that your shell script won't explode on
something trivial.

Writing robust shell scripts often means cluttering your procedure with safety code: "Did the
file exist?", "Was an argument passed?", "Is this user root?", etc. These defensive checks are
important but repetitive, noisy, and easy to forget.

In brush, we refer to these assertions as sweeps. Because brush use them to sweep away any
unwanted initial state.

## example

For example if we want to 100% assert that we can execute this repo's hook:

```bash
sweep_command bash
sweep_command shfmt
sweep_command shellcheck

./poli.sh
```

## test requirements

shfmt -- formatter

```bash
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

shellcheck -- linter

```bash
sudo dnf install shellcheck
```

git -- to test git addon

```
sudo dnf install git
```
