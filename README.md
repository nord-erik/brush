# bru.sh 🪥

A minified library for shell scripts that contain assertions about the context. Useful for defensive programming when you want to make sure that your shell script won't explode on something trivial. 

Writing robust shell scripts often means cluttering your procedure with safety code: "Did the file exist?", "Was an argument passed?", "Is this user root?", etc. These defensive checks are important but repetitive, noisy, and easy to forget.

In brush, we refer to these assertions as sweeps. Because brush use them to sweep away any unwanted initial state. 

## example

```bash
TODO: show some examples of where brush shines
```

## test requirements

shfmt -- formatter

```
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

shellcheck -- linter

```
sudo dnf install shellcheck
```
