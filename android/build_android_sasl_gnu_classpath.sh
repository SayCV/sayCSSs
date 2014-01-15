#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# determine base directory; preserve where you're running from
realpath=$(readlink -f "$0")
# export basedir, so that module shell can use it. log.sh. e.g.
# export filename, so that module shell can use it. log.sh. e.g.
# basedir=$(dirname "$realpath")
export basedir=$(dirname "$realpath")
export filename=$(basename "$realpath") 

export PATH=$PATH:$basedir

# echo $basedir
# echo $filename
# echo $PATH

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_android_ndk.sh

PRIVATE_BUILD_WORK_DIRECTORY=$HOME/android-sasl/classpath-0.98

function fnct_autogen_gnu_classpath_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_autogen_gnu_classpath_for_android_h"; then
		print_headline "Autogen gnu classpath for android"
		./autogen.sh \
		|| die
		touch stamp_autogen_gnu_classpath_for_android_h
	fi
}

#			CFLAGS="--sysroot=$SYSROOT -nostdlib -I$NDK_TOOLCHAINS_INCLUDE -I$NDK_PLATFORM_INCLUDE"
function fnct_configure_gnu_classpath_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_configure_gnu_classpath_for_android_h"; then
		print_headline "Configure gnu classpath for android"
		./configure \
			--prefix=/tmp/classpath \
			--disable-gtk-peer --disable-gconf-peer --disable-plugin \
			--host=arm-linux-androideabi \
			--with-sysroot=$SYSROOT \
			CFLAGS="-nostdlib" \
		|| die
		touch stamp_configure_gnu_classpath_for_android_h
	fi
}

function fnct_make_gnu_classpath_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_make_gnu_classpath_for_android_h"; then
		print_headline "Make gnu classpath for android"
		make \
		|| die
		touch stamp_make_gnu_classpath_for_android_h
	fi
}

function fnct_build_gnu_classpath_for_android {
    cd $PRIVATE_BUILD_WORK_DIRECTORY || die
    if ! test -f "stamp_build_gnu_classpath_for_android$suffix_skip_checking_stamp_h"; then
        print_headline "Building gnu classpath for android"
            fnct_autogen_gnu_classpath_for_android
            fnct_configure_gnu_classpath_for_android
            fnct_make_gnu_classpath_for_android
        print_done
    fi
}

function main {
	export_android_ndk_envirment || die
	fnct_build_gnu_classpath_for_android || die
}

_common_fnct_setting_skip_checking_stamp_h
main || die
print_done || die
inform "$common_date" || die
print_done || die
pause 'Press any key to continue...' || die