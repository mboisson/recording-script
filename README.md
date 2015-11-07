# README.md - `recording-script`

## To install on Mac: 

0. Install `gsed`, `gawk` and `core-utils` using `brew`  (Because the tools provided by Apple are not GNU).
1. Clone the `https://github.com/mboisson/recording-script` repository, and add it to your PATH. 

To use : 

```
recordsession.sh git@github.com:<user>/<repo>.git <filename> [delay]
```

For example, the above .html was recorded using the command

```
recordsession.sh git@github.com:mboisson/testing.git bash_lesson 10
```

* The script pushes from the `gh-pages` branch, and creates one if it does not exist. It has been used with [Software Carpentry](http://software-carpentry.org/) event pages. 
* The delay is in seconds, and there is a default delay of 60 seconds between each sync. 
* This script assumes that your github is configured to use SSH keys. 
* The script uses a modified version of `ansi2html.sh`, which can be obtained from [`http://github.com/pixelb/scripts/commits/master/scripts/ansi2html.sh`](`http://github.com/pixelb/scripts/commits/master/scripts/ansi2html.sh`)