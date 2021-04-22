#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

script_path="$(dirname "$(readlink "$0" || echo "$0")")"
script_name="$(basename "$(readlink "$0" || echo "$0")")"

function usage {
	echo "Usage: ${script_name/.sh/} WORD_DOCUMENT.DOCX"
	echo
}

function print_error {
	>&2 echo "$@"
	exit 1
}

function docx_to_md {
	source="$1"
	if [[ ! -r "$source" ]]; then
		>&2 echo "File '$source' does not exist."
		exit 1
	fi
	media="${source/.docx/}"

	pandoc "$source" -f docx -t markdown --extract-media="$media" --wrap=none --reference-links --markdown-headings=setext
}

function get_word_meta_data {
	unzip -p "$1" "docProps/core.xml"
}

function convert_xml_to_yaml_front_matter {
	"$script_path/convert.py"
}


# Requirements
if [[ ! $(which pandoc) ]]; then
	print_error "Fatal: can't find 'pandoc'."
fi
if [[ ! $(which python3) ]]; then
	print_error "Fatal: can't find 'python3'."
fi

# Handling arguments
if [[ $# -eq 0 ]]; then 
	usage
	print_error "No arguments supplied"
fi
source="$1"
if [[ ! -r "$source" ]]; then
	print_error "Fatal: file not found or unreadable."
fi
target="${source/.docx/.md}"
header="$(mktemp docx2md.XXXXXX)"

# Conversion
echo "create header: $header"
get_word_meta_data "$source" | convert_xml_to_yaml_front_matter > "$header"
echo "calling pandoc"
docx_to_md "$source" | cat "$header" - > "$target"
echo "removing temp"
rm "$header"
