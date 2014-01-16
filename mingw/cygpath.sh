#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

mingw_cygpath_realpath=$(readlink -f "$0")
export mingw_cygpath_basedir=$(dirname "${mingw_cygpath_realpath}")
export mingw_cygpath_filename=$(basename "${mingw_cygpath_realpath}")
export PATH=$PATH:${mingw_cygpath_basedir}

if [ "${script_mingw_cygpath}" ]; then
        return
fi

export script_mingw_cygpath="cygpath.sh"

# get dir of the script
mingw_cygpath_script_relaytive_path=`dirname "$0"`

perl ${mingw_cygpath_basedir}/cygpath $1