# bru.sh 🪥

a minified library for shell scripts that contain assertions about the context. useful for
defensive programming when you want to make sure that your shell script won't explode on
something trivial.

writing robust shell scripts often means cluttering your procedure with safety code: "did the
file exist?", "was an argument passed?", "is this user root?", etc. these defensive checks are
important but repetitive, noisy, and easy to forget.

in brush, we refer to these assertions as sweeps. because brush use them to sweep away any
unwanted initial state.

in order to truly rely on your scripts, this type of defensive programming is very effective.
so using brush you simply save on writing 200 lines of bash that you likely need to write anyways.

## example

simply source the minified build output; bru.sh and then you have access to all sweeps.
for example if we want to 100% assert that we can execute this repo's hook:

```bash
source bru.sh
sweep_command bash shfmt shellcheck
./poli.sh
```

or we need to make sure that a git repo is clean before we do operations.
e.g. before we build, package and release some arbritrary software.

```bash
source bru.sh
cd to_a_repo
sweep_command git scp zip
sweep_git_is_clean

git pull
sweep_ok $? "could not fetch latest changes from remote"

./release_package.sh
sweep_ok $? "build failed, aborting"

mv build.zip latest.zip
scp latest.zip bot@build_server:~/builds
sweep_ok $? "scp latest build to build server failed"
```

# how to test

the CI/CD workloads will always test pushed commits. but if you want to test locally, you can do so:

```
./poli.sh [VERBOSE]
```

where verbose is optional, but if it is the literal word "VERBOSE" you will see more output

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

# comment on name convention

all file names that begins with "\_" are meant to always be sourced and never run bare.
all functions that begins with "\_" are meant to be used internally and are not part of external API.
you might find cases where you can safely run "\_" scripts or functions, but it is not supported.
