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

if [ "$script_build_android_sasl_gnu_classpath" ]; then
        return
fi

export script_build_android_sasl_gnu_classpath="build_android_sasl_gnu_classpath.sh"

# get dir of the script
build_android_sasl_gnu_classpath_script_relaytive_path=`dirname "$0"`

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_android_ndk.sh

PRIVATE_BUILD_WORK_DIRECTORY=$HOME/android-sasl/classpath-0.98

check_requirements(){

	inform "GCJ absolutely requires ECJ for compiling Java sources. "
	inform "You can either download the necessary jar manually, as mentioned previously, "
	inform "or install the java-ecj package from Ports."
	local usr_share_java_root=/usr/share/java
    if ![ -f "${usr_share_java_root}/ecj.jar" ];then
		inform "Start to download ecj.jar"
		${WGET} ftp://sourceware.org/pub/java/ecj-latest.jar || die
		cd ${usr_share_java_root}
		mv ecj-latest.jar ecj.jar || die
    fi
}

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
			CFLAGS="-nostdlib -I${NDK_TOOLCHAINS_INCLUDE} -I${NDK_PLATFORM_INCLUDE}" \
			LDFLAGS="-nostdlib -L${NDK_PLATFORM_LIB} ${NDK_EXTRA_LIBS}" \
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

clean(){
    if [ "$1" = "clean" ];then
		echo "ndk-build clean"
		ndk-build clean
		#echo "rm bin libs obj -rf"
		rm bin libs obj -rf
		exit 0
    fi
}

function main {
	export_android_ndk_envirment || die
	fnct_build_gnu_classpath_for_android || die
}

#Check the environment.
check_env

#Check requirements.
#check_requirements

#check whether it is ndk-build clean,and exit.
#clean $1

main || die
print_done || die

#Print the start time and finish time.
printTime

#Hold here.
pause 'Press any key to continue...' || die