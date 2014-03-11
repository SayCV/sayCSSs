#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# determine base directory; preserve where you're running from
common_rtems_ndk_realpath=$(readlink -f "$0")
# export basedir, so that module shell can use it. log.sh. e.g.
# export filename, so that module shell can use it. log.sh. e.g.
# basedir=$(dirname "$realpath")
export common_rtems_ndk_basedir=$(dirname "$common_rtems_ndk_realpath")
export common_rtems_ndk_filename=$(basename "$common_rtems_ndk_realpath") 

export PATH=$PATH:$common_rtems_ndk_basedir

if [ "$script_common_rtems_ndk" ]; then
        return
fi

export script_common_rtems_ndk="common_rtems_ndk.sh"

# get dir of the script
common_rtems_ndk_script_path=`dirname "$0"`

function export_rtems_ndk_envirment {
	print_headline "Export RTEMS NDK Envirment"
	
	RTEMS_NDKROOT=/opt/rtems-4.11-tools
	echo ${RTEMS_NDKROOT}
	export NDK_ROOT=$RTEMS_NDKROOT
	echo ${NDK_ROOT}

	export NDK_TOOLCHAINS_ROOT="${NDK_ROOT}"
	export NDK_TOOLCHAINS_PREFIX="$NDK_TOOLCHAINS_ROOT/bin/arm-rtemseabi4.11"

	export PATH=$NDK_TOOLCHAINS_ROOT/bin:$PATH
	
	export CYGWIN="winsymlinks:native"
#	export CYGWIN="winsymlinks:nativestrict"

	print_done
}

