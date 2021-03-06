#!/usr/bin/env bash

# shellcheck shell=bash

# =========================================================================

# http://stackoverflow.com/q/8800578/100073
# https://retracile.net/blog/2013/06/01/22.00
# http://www.colordiff.org/
colordiff() {
	# Colors
	local ESC
	ESC="$( printf "\\033" )"

	# Because correct definition; no errors
	# shellcheck disable=SC1087
	local diff_c_reset="$ESC[0m"

	local diff_b_meta="40;1;37"	# white
	local diff_b_frag="36"		# cyan
	local diff_b_old="31"		# red
	local diff_b_new="32"		# green
	local diff_b_mod="34"		# blue

	[ $# -gt 0 ] || {
		cat - <<HELP
Usage: colordiff [OPTION]... FILES

Wrapper for diff to colorize the diff's output for better readability.
Try "diff --help" for more information.

OPTIONS

Diff options

All options will be passed to "diff".

Coloring options

--color[=WHEN], --colour[=WHEN]

Controls the colorizing method. WHEN can be one of "never", "auto" or
"always" (the default value if not specified explicitly). To make affect
globally, set one of these values to CDIFF_WHEN environment variable.

ENVIRONMENT VARIABLES

CDIFF_COLORS
This environment variable is used to specify colors to highlight the
separate parts of the diff output. Its value is a colon-separated list
of capabilities. Names and values of each capability correspond to the
configuration parameters "color.diff.<slot>" used in "git config".
Values are integers in decimal representation and can be concatenated with
semicolons. Further these values are assembled into ANSI escape codes.

meta=$diff_b_meta
Metainformation (names of compared files)

frag=$diff_b_frag
Hunk header (line numbers of changed lines)

old=$diff_b_old
Removed lines

new=$diff_b_new
Added lines

mod=$diff_b_mod
Modified lines

CDIFF_WHEN
Colorizing method does effect on all runs; assumes the same values as for
the "--color" option. The default value is "auto" and can be superseded
by the "--color" option.
HELP
		return
	}

	# Blocks
	local CDIFF_COLORS="${CDIFF_COLORS:-meta=$diff_b_meta:frag=$diff_b_frag:old=$diff_b_old:new=$diff_b_new:mod=$diff_b_mod}"

	local c
	for c in ${CDIFF_COLORS//:/ }
	do
		case "${c%%=*}" in
		meta | frag | old | new | mod )
			# Because correct definition; no errors
			# shellcheck disable=SC1087
			eval "diff_b_${c%%=*}='$ESC[${c#*=}m'"
			;;
		esac
	done

	# Schemes
	local diff_scheme_normal="
		# diff ...
		# File headers
		/^[A-Za-z]/ s/^/$diff_b_meta/;

		# Difference headers
		/^[0-9]/ s/^/$diff_b_frag/;

		# Changed lines
		/^< / s/^/$diff_b_old/;
		/^> / s/^/$diff_b_new/;
	"
	local diff_scheme_context="
		# diff -c ...
		# File headers
		/^[A-Za-z0-9]/ s/^/$diff_b_meta/;
		/^\*\**\$/ s/^/$diff_b_meta/;

		# File or difference headers
		/^\*\*\* / {
			/ \*\*\*\*\$/! s/^/$diff_b_meta/;
			/ \*\*\*\*\$/  s/^/$diff_b_frag/;
		};
		/^--- / {
			/ ----\$/! s/^/$diff_b_meta/;
			/ ----\$/  s/^/$diff_b_frag/;
		};

		# Changed lines
		/^! / s/^/$diff_b_mod/;
		/^- / s/^/$diff_b_old/;
		/^+ / s/^/$diff_b_new/;
	"
	local diff_scheme_unified="
		# diff -u ...
		# File headers: in the beginning
		1,/^+++ / {
			/^[A-Za-z]/ s/^/$diff_b_meta/;
			/^--- / s/^/$diff_b_meta/;
			/^+++ / s/^/$diff_b_meta/;
		}
		# File headers: others
		/^[A-Za-z]/,/^+++ / {
			/^[A-Za-z]/ s/^/$diff_b_meta/;
			/^--- / s/^/$diff_b_meta/;
			/^+++ / s/^/$diff_b_meta/;
		}

		# Difference headers
		/^@@ [^@]* [^@]* @@/ s/^/$diff_b_frag/;

		# Changed lines
		/^-/ s/^/$diff_b_old/;
		/^+/ s/^/$diff_b_new/;
	"
	local diff_scheme_ed="
		# diff -e ...
		# File headers
		/^diff \(-e\|--ed\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Difference headers
		/^\([0-9][0-9]*,\)\?[0-9][0-9]*[acd]\$/ {
			/a\$/ s/^/$diff_b_new/;
			/c\$/ s/^/$diff_b_mod/;
			/d\$/ s/^/$diff_b_old/;
		}
	"
	local diff_scheme_rcs="
		# diff -n ...
		# File headers
		/^diff \(-n\|--rcs\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Difference headers
		/^[ad][0-9][0-9]* [0-9][0-9]*\$/ {
			/^d/ s/^/$diff_b_old/;
			/^a/ s/^/$diff_b_new/;
		}
	"
	local diff_scheme_sidebyside="
		# diff -y ...
		# File headers
		/^diff \(-y\|--side-by-side\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Changed lines
		/^.* <\$/ s/^/$diff_b_old/;
		/^.*[\t ]*|\t.*$/ s/^/$diff_b_mod/;
		/^[\t ]*>$/ s/^/$diff_b_new/;
		/^[\t ]*>\t.*/ s/^/$diff_b_new/;
	"

	local diff_scheme="$diff_scheme_normal"

	local CDIFF_WHEN="$CDIFF_WHEN"

	# Validate environment variable
	case "$CDIFF_WHEN" in
	always | never | auto )
		# Do nothing: it is valid value
		;;
	* )
		# Invalid or empty value: skip it and setup "auto"
		CDIFF_WHEN="auto"
		;;
	esac

	local -a args

	local no_scheme=""

	while [ $# -gt 0 ]
	do
		case "$1" in
		--help | -v | --version | -q | --brief | -s | --report-identical-files )
			no_scheme=1
			break
			;;
		-- )
			break
			;;
		--color | --colour )
			CDIFF_WHEN=always
			;;
		--color=* | --colour=* )
			CDIFF_WHEN="${1#*=}"
			;;
		* )
			case "$1" in
			-c | -C* | --context | --context=* )
				diff_scheme="$diff_scheme_context"
				;;
			-p | --show-c-function )
				diff_scheme="$diff_scheme_context"
				;;
			-u | -U* | --unified | --unified=* )
				diff_scheme="$diff_scheme_unified"
				;;
			--normal )
				diff_scheme="$diff_scheme_normal"
				;;
			-e | --ed )
				diff_scheme="$diff_scheme_ed"
				;;
			-n | --rcs )
				diff_scheme="$diff_scheme_rcs"
				;;
			-y | --side-by-side )
				diff_scheme="$diff_scheme_sidebyside"
				;;
			esac
			args+=( "$1" )
			;;
		esac
		shift
	done

	args+=( "$@" )

	# Validate the option and re-define the function behavior
	case "$CDIFF_WHEN" in
	always )
		# Do nothing over defined by options
		;;
	never )
		# Skip colorizing at all
		no_scheme=1
		;;
	auto )
		# Skip colorizing, if not a terminal
		test -t 1 || no_scheme=1
		;;
	* )
		echo "Invalid color: '$CDIFF_WHEN'" >&2
		return 2
		;;
	esac

	[ -z "$no_scheme" ] || {
		command diff "${args[@]}"
		return $?
	}

	command diff "${args[@]}" | sed "$diff_scheme; s/\$/$diff_c_reset/"

	# Because the first item of the array required
	# shellcheck disable=SC2086,SC2128
	return $PIPESTATUS
}

# =========================================================================

# Escape if sourced
case "$-" in
*i* )
	return
	;;
esac

case "${0##*/}" in
sh | ash | dash | bash | ksh )
	return
	;;
esac

colordiff "$@"

# =========================================================================

# EOF
