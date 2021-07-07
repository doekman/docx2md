#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

function usage {
	echo "Usage: $0 [install | uninstall]"
	echo
	if [[ -L "$BIN_PATH/$CMD_NAME" ]]; then
		echo "docx2md is already installed as '$BIN_PATH/$CMD_NAME'"
	else
		echo "docx2md is not yet installed in '$BIN_PATH'"
	fi
}

function do_install {
	if [[ -L "$BIN_PATH/$CMD_NAME" ]]; then
		echo "docx2md is already installed as '$BIN_PATH/$CMD_NAME'"
	else
		ln -s "$(pwd)/$BIN_NAME" "$BIN_PATH/$CMD_NAME"
		echo "docx2md is installed into '$BIN_PATH' as '$CMD_NAME'"
	fi
}

function do_uninstall {
	if [[ -L "$BIN_PATH/$CMD_NAME" ]]; then
		rm "$BIN_PATH/$CMD_NAME"
		echo "docx2md is removed from '$BIN_PATH'"
	else
		echo "docx2md is not yet installed in '$BIN_PATH'"
	fi
}

cd "$(dirname "$0")"
BIN_NAME="docx2md.sh"
BIN_PATH=/usr/local/bin
CMD_NAME="docx2md"

case "${1:-}" in
	install) do_install;;
	uninstall) do_uninstall;;
	*) usage;;
esac
