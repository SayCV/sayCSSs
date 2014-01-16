#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# determine base directory; preserve where you're running from
common_realpath=$(readlink -f "$0")
# export basedir, so that module shell can use it. log.sh. e.g.
# export filename, so that module shell can use it. log.sh. e.g.
# basedir=$(dirname "$realpath")
export common_basedir=$(dirname "$common_realpath")
export common_filename=$(basename "$common_realpath") 

export PATH=$PATH:$common_basedir

if [ "$script_common" ]; then
        return
fi

export script_common="common.sh"

# get dir of the script
common_script_path=`dirname "$0"`

common_date="$(date +"%Y-%m-%d : %H-%M-%S")"
common_filename_date="$(date +"%Y_%m_%d_%H_%M_%S")"

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
	inform "======================================================================"
	inform "$1"
}

function print_done {
	inform "======================================================================"
}

function die() {
	ret="$?"
	inform "FAILED!"
	exit "$ret"
}

function pause() {
	read -n 1 -p "$*" INP
	if [ $INP != '' ] ; then
		echo -ne '\b \n'
	fi
}

function pause {
	read -n1 -p "Press any key to continue..."
}

function pack_archive() {
	print_headline "PACK ARCHIVE $1"
	
	local file=$1
	local extension="${file##*.}" 
	case $extension in
     "gz" )
           tar -zcvf $file $2
           ;;
     "bz2" )
           bz2unpack $2
           ;;
     "7z" )
           #7z a -tzip $file $2
           7z.exe a -t7z $file $2
           ;;
     * )
           warning "Archive format for extention '$extension' is not recognized."
           ;;
	esac

	print_done
}

function UNPACK_ARCHIVE() {
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,$(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.zip,     $(1)),unzip -qo '$(1)', \
    $(if $(filter %.exe,$(1)),cp '$(1)' ., \
    $(error Unknown archive format: $(1)))))))))
}

check_env(){
	print_headline "Start to check the environment..."
	
	HOST_OS=`uname -s`
	inform "Detected HOST_OS=${HOST_OS}"
	case ${HOST_OS} in
	Linux )
		inform "will not indeeded call cygpath"
		;;
	cygwin* | CYGWIN* )
#		inform "will call cygwin cygpath"
		export CYGPATH='cygpath -u'
		;;
	mingw* | MINGW*|*_NT-* )
#		inform "will call my mingw cygpath"
		export CYGPATH=${common_basedir}/../mingw/cygpath.sh
		;;
	* )
		error "Does not support current HOST_OS: ${HOST_OS}"
		;;
	esac
    
#    NDK_BUILD=`which ndk-build`
#    echo NDK_BUILD=${NDK_BUILD}
#    export PATH=/cygdrive/c/cygwin/bin:`dirname ${NDK_BUILD}`

     if [ "$boolean_skip_checking_stamp_h" = "0" ]; then
        export suffix_skip_checking_stamp_h="null"
     else
        export suffix_skip_checking_stamp_h=""
     fi
     echo "suffix_skip_checking_stamp_h = $suffix_skip_checking_stamp_h"
     print_done
}

printTime(){
    echo "Start  at ${common_date}"
    echo "Finish at `date +"%Y-%m-%d : %H-%M-%S"`"
}

print_headline "Checking that script is using UNIX line endings"
mount | grep textmode && die
print_done
