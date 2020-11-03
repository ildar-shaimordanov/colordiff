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

The tool can be used as a standalone executable script or a shell function sourced from `~/.bashrc`.

## `colordiff` options

* `--color[=WHEN]`, `--colour[=WHEN]` - the colorizing method; `WHEN` stands for `never`, `auto` and `always` (default value, if not specified explicitly).

## Environment

* `CDIFF_WHEN` - the colorizing method has impact on all runs.
* `CDIFF_COLORS` - the colon-separated list of capabilities to color the separate parts of the `diff` output.

# Requirements

The latest version of the script __was developed and successfully tested__ in the following environment:

* cygwin 3.1.7
* bash 4.4
* sed 4.4

# See Also

* grep(1) - for the `--color/--colour` options.
* git-config(1) - for the `color.diff.<slot>` parameters. `colordiff` uses the same terminology.

There is another Perl script with the same functionality. It exists in two versions maintained by its authors:

* version 1.x: https://github.com/daveewart/colordiff
* version 2.x: https://github.com/kimmel/colordiff

# License

MIT License
