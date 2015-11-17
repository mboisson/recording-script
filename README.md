# README.md - `recording-script`

## To install on Mac: 

* Install `gsed`, `gawk` and `core-utils` using `brew`  (Because the tools provided by Apple are not GNU).

```
brew install gnu-sed gawk coreutils
```

* Clone the `https://github.com/mboisson/recording-script` repository, and add it to your PATH. 

```
git clone https://github.com/mboisson/recording-script
```
## To install on Linux: 

* Clone the `https://github.com/mboisson/recording-script` repository, and add it to your PATH. 

```
git clone https://github.com/mboisson/recording-script
```

## To use: 

```
recordsession.sh <-r|--repo url> [-f|--filename <name>] [-d|--delay <delay>] [-s|--short_path] [-h|--help] 
```

For example, the `.html` at [http://mboisson.github.io/testing/bash_lesson.html#end](http://mboisson.github.io/testing/bash_lesson.html#end) was recorded using the command

```
recordsession.sh --repo git@github.com:mboisson/testing.git --filename bash_lesson --delay 10
```

* The script pushes from the `gh-pages` branch, and creates one if it does not exist. It has been used with [Software Carpentry](http://software-carpentry.org/) event pages. 
* The delay is in seconds, and there is a default delay of 60 seconds between each sync. 
* This script assumes that your github is configured to use SSH keys. 
* The script uses a modified version of `ansi2html.sh`, which can be obtained from [`http://github.com/pixelb/scripts/commits/master/scripts/ansi2html.sh`](`http://github.com/pixelb/scripts/commits/master/scripts/ansi2html.sh`)

## To exit:

Issue `Ctrl-D` or `exit` at the prompt.
