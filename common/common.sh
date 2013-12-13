#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# get dir of the script
common_script_path=`dirname "$0"`

common_date="$(date +"%Y-%m-%d-%H-%M-%S")"

# displays error message and exits
error() {
        case $? in
                0) local errorcode=1 ;;
                *) local errorcode=$? ;;
        esac

        echo -e "\e[1;31m*** ERROR:\e[0;0m ${1:-no error message provided}";
        exit ${errorcode};
}

# displays information message
inform() {
        echo -e "\e[1;32m*** Info:\e[0;0m ${1}";
}

# displays warning message only
warning() {
        echo -e "\e[1;33m*** Warning:\e[0;0m ${1}";
}

# displays command to stdout before execution
verbose() {
        echo "${@}"
        "${@}"
        return $?
}

# Helper functions
function print_headline {
	inform "==============================================================================="
	inform "$1"
}

function print_done {
	inform "==============================================================================="
}

function die {
	ret="$?"
	inform "FAILED!"
	exit "$ret"
}