# colordiff

<!-- md-toc-begin -->
* [colordiff](#colordiff)
* [Usage](#usage)
  * [`colordiff` options](#colordiff-options)
  * [Environment](#environment)
* [Requirements](#requirements)
* [See Also](#see-also)
* [License](#license)
<!-- md-toc-end -->

`colordiff` is a pure shell script acting as a wrapper for `diff`. It supports a lot of `diff` outputs and makes them looking prettier highlighting similar to `git diff`.

The script analysizes the command line options, select proper colorizing scheme, invokes `diff` and applies `sed` with the selected scheme.

# Usage

Use `colordiff` in the same way as well as `diff`:

```
colordiff [diff options] [colordiff options] file1 file2
```

Run the script with no options to learn how to use it -- not a long help page will be displayed.

The tool can be used as a standalone executable script or a shell function sourced from `~/.bashrc` or aliased as follows:

```sh
# Let's check and use diff itself or git diff
if diff --help 2>/dev/null | grep -q color
then
	# diff 3.4+ allows coloring
	alias diff='diff --color=auto'
elif which git > /dev/null 2>&1
then
	# git is available
	alias diff='git diff --no-index'
fi

# If one of these scripts exists, overwrite the alias for better colorizing
if which ~/bin/colordiff.posix > /dev/null 2>&1
then
	# Let's check and use POSIX-compliant shell script
	alias diff=~/bin/colordiff.posix
elif which ~/bin/colordiff.bash > /dev/null 2>&1
then
	# Let's check and use full-featured Bash script
	alias diff=~/bin/colordiff.bash
elif which colordiff > /dev/null 2>&1
then
	# Let's check and use well-known script from www.colordiff.org
	alias diff=colordiff
fi
```

## `colordiff` options

* `--color[=WHEN]`, `--colour[=WHEN]` - the colorizing method; `WHEN` stands for `never`, `auto` and `always` (default value, if not specified explicitly).

## Environment

* `CDIFF_WHEN` - the colorizing method has impact on all runs.
* `CDIFF_COLORS` - the colon-separated list of capabilities to colorize the separate parts of the `diff` output. Colors are defined in the terms of git-config and defaults to `meta=40;1;37:frag=36:old=31:new=32:mod=34` (bold white for metainformation or headers, cyan for hunk headers or line numbers, red for deleted lines, green for added lines and blue for modified lines, respectively).

# Requirements

The latest version of the script __was developed and successfully tested__ in the following environment:

* cygwin 1.45, 3.1.7
* bash 4.2, 4.4
* busybox 1.33.0
* sed 4.2, 4.4

# See Also

* grep(1) - for the `--color/--colour` options.
* git-config(1) - for the `color.diff.<slot>` parameters. `colordiff` uses the same terminology.
* Options to diff - including diff 3.4+ options https://www.gnu.org/software/diffutils/manual/html_node/diff-Options.html

There is another Perl script with the same functionality. It exists in two versions maintained by its authors:

* version 1.x: https://github.com/daveewart/colordiff
* version 2.x: https://github.com/kimmel/colordiff

# License

MIT License
