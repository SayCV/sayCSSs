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

print_headline "Checking that script is using UNIX line endings"
mount | grep textmode && die
print_done

function print_project_standard_directory_ayout {
    print_headline  "Print project standard directory ayout"
    inform          "gradle and maven are the same"
    
    inform          "Introduction to the Standard Directory Layout"
    inform          "http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html"
    
    inform          " \n
    rc/main/java        #Application/Library sources \n
    src/main/resources  #Application/Library resources \n
    src/main/filters    #Resource filter files \n
    src/main/assembly   #Assembly descriptors \n
    src/main/config     #Configuration files \n
    src/main/scripts    #Application/Library scripts \n
    src/main/webapp     #Web application sources \n
    src/test/java       #Test sources \n
    src/test/resources  #Test resources \n
    src/test/filters    #Test resource filter files \n
    src/site            #Site \n
    LICENSE.txt         #Project's license \n
    NOTICE.txt          #Notices and attributions required by libraries that the project depends on \n
    README.txt          #Project's readme \n
    "
}

function main {
	print_headline "Excute New Gradle or Maven project."
	print_project_standard_directory_ayout
	pause
	cd $NEW_PROJECT_HOME
	project_name=testProject
    mkdir -p ${project_name}
    cd ${project_name}
    mkdir -p src/main/{java,resources}
    mkdir -p src/test/{java,resources}
    # Web application sources
    # mkdir -p src/main/webapp
}

main || die
print_done || die
inform "$common_date" || die
print_done || die
pause 'Press any key to continue...' || die