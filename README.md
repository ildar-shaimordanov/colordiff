# colordiff

`colordiff` is a pure shell script acting as a wrapper for `diff`. It supports a lot of `diff` outputs and makes them looking prettier highlighting similar to `git diff`.

The script analysizes the command line options, select proper colorizing scheme, invokes `diff` and applies `sed` with the selected scheme.

# Usage

Use `colordiff` in the same way as well as `diff`:

```
colordiff file1 file2
```

Run the script with no options to learn how to use it -- not a long help page will be displayed.

The tool can be used as a standalone executable script or a shell function sourced from `~/.bashrc`.

# See Also

There is another Perl script with the same functionality. It exists in two versions maintained by its authors:

* version 1.x: https://github.com/daveewart/colordiff
* version 2.x: https://github.com/kimmel/colordiff

# License

MIT License
