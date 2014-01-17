#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# determine base directory; preserve where you're running from
common_android_ndk_realpath=$(readlink -f "$0")
# export basedir, so that module shell can use it. log.sh. e.g.
# export filename, so that module shell can use it. log.sh. e.g.
# basedir=$(dirname "$realpath")
export common_android_ndk_basedir=$(dirname "$common_android_ndk_realpath")
export common_android_ndk_filename=$(basename "$common_android_ndk_realpath") 

export PATH=$PATH:$common_android_ndk_basedir

if [ "$script_common_android_ndk" ]; then
        return
fi

export script_common_android_ndk="common_android_ndk.sh"

# get dir of the script
common_android_ndk_script_path=`dirname "$0"`

function export_android_ndk_envirment {
	print_headline "Export Android NDK Envirment"
	
	echo ${NDKROOT}
	export NDK_ROOT=$($CYGPATH $NDKROOT)
#	export NDK_ROOT=$NDKROOT
	echo ${NDK_ROOT}
	export NDK_TOOLCHAINS_ROOT="${NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/windows"
	export NDK_TOOLCHAINS_PREFIX="$NDK_TOOLCHAINS_ROOT/bin/arm-linux-androideabi"
	export NDK_TOOLCHAINS_INCLUDE="$($CYGPATH -w $NDK_TOOLCHAINS_ROOT/lib/gcc/arm-linux-androideabi/4.8/include-fixed)"
	export PATH=$NDK_TOOLCHAINS_ROOT/bin:$PATH
	
	export ANDROID_STANDALONE_TOOLCHAIN=${NDK_TOOLCHAINS_ROOT}
	
	export NDK_PLATFORM_ROOT=$NDK_ROOT/platforms/android-18/arch-arm
	export NDK_PLATFORM_INCLUDE=$($CYGPATH -w $NDK_PLATFORM_ROOT/usr/include)
	export NDK_PLATFORM_LIB=$($CYGPATH -w $NDK_PLATFORM_ROOT/usr/lib)
	
	
	export NDK_EXTRA_OBJS="$NDK_PLATFORM_LIB/crtbegin_dynamic.o $NDK_PLATFORM_LIB/crtend_android.o"
	export NDK_LD_FLAGS="-Bdynamic -Wl,-dynamic-linker,/system/bin/linker -nostdlib"
	
	export NDK_EXTRA_LIBS_0="-lstdc++ \
												-lgcc \
												-lc"
	export NDK_EXTRA_LIBS_1="-lgnustl_static \
												-lstdc++ \
												-lgcc \
												-lc"
	export NDK_EXTRA_LIBS=
	export SYSROOT=${NDK_PLATFORM_ROOT}
	export ECLIPSE_JAVA_COMPILER_JAR="/usr/share/java/ecj.jar"
#	export CFLAGS="--sysroot=${SYSROOT} -I${NDK_TOOLCHAINS_INCLUDE} -I${NDK_PLATFORM_INCLUDE}"
#	export CC="${NDK_TOOLCHAINS_ROOT}/bin/arm-linux-androideabi-gcc --sysroot=${SYSROOT}"
#	export LDFLAGS="-L${NDK_PLATFORM_LIB} ${NDK_EXTRA_LIBS} -nostdlib"
	echo "CLASSPATH=${CLASSPATH}"
	export CLASSPATH=$($CYGPATH ${JAVA_HOME}/lib):$($CYGPATH ${JRE_HOME}/lib) || die
	echo "CLASSPATH=${CLASSPATH}"

	echo Enable or disable specific warnings
	echo -Xlint:{all,cast,deprecation,dep-ann,divzero,empty,fallthrough,finally,overrides,\
		path,processing,serial,unchecked,rawtypes,static,varargs,try,-cast,-deprecation,\
		-dep-ann,-divzero,-empty,-fallthrough,-finally,-overrides,-path,-processing,-serial,\
		-unchecked,-rawtypes,-static,-varargs,-try,none}
		
# Plan for enabling Xlint java compiler warnings in the next several beta/stable series:
#   3.3.x/3.4: cast, divzero, finally, path, overrides
#   3.5.x/3.6: fallthrough, serial, static, rawtypes, unchecked
#   3.7.x/3.8: -Xlint (Enable all recommended warnings)
# JDK6 (10): cast, deprecation, divzero, empty, fallthrough, finally, overrides, path, serial, unchecked
# JDK7 (18): cast, classfile, deprecation, dep-ann, divzero, empty, fallthrough, finally, options,
#                  overrides, path, processing, rawtypes, serial, static, try, unchecked, varargs	
	export CUSTOM_JAVAC_OPTS_ENABLE_WARNINGS="-Xlint:unchecked,cast,divzero,empty,finally,overrides"
	export CUSTOM_JAVAC_OPTS_DISABLE_WARNINGS="-Xlint:unchecked,cast,divzero,empty,finally,overrides"
	export CUSTOM_JAVA_OPTS_DISABLE_WARNINGS="-nowarn"
	export CUSTOM_JAVA_OPTS_ENABLE_DEBUG="-g"
	
	print_done
}
