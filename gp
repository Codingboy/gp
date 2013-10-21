#! /bin/bash

#your default e-mail
CONTACT="daniel.tkocz@gmx.de"
#your default name
DEVELOPER="Daniel Tkocz"
#your default license
LICENSE="bsd2"

echo "Please report all bugs of this script to daniel.tkocz@gmx.de"
echo "usage:"
echo "$0 -n <projectname> [-c <compiler> -h <headerfileextension> -s <sourcefileextension> -l <programminglanguage> -e <your e-mail> -d <your name> -m <license>]"
echo "valid languages:"
echo "c++"
echo "c"
echo "uc++"
echo "uc"
echo "valid licenses:"
echo "mit"
echo "gpl"
echo "lgpl"
echo "boost"
echo "bsd2"
echo "cc-zero"
echo "cc-by"
echo "cc-by-sa"
echo "cc-by-nc"
echo "cc-by-nc-sa"
echo "cc-by-nc-nd"
echo "cc-by-nd"

while getopts n:c:h:s:l:e:p:m: opt
do
	case $opt in
		n) PROJECTNAME=$OPTARG;;
		c) COMPILER=$OPTARG;;
		h) HEADERFILEEXTENSION=$OPTARG;;
		s) SOURCEFILEEXTENSION=$OPTARG;;
		l) LANGUAGE=$OPTARG;;
		e) CONTACT=$OPTARG;;
		d) DEVELOPER=$OPTARG;;
		m) LICENSE=$OPTARG;;
	esac
done

if [ -z "$DEVELOPER" ]
then
	echo "you need to specify your name"
	exit 1
fi

if [ -z "$CONTACT" ]
then
	echo "you need to specify your e-mail"
	exit 1
fi

#no projectname specified
if [ -z "$PROJECTNAME" ]
then
	echo "you need to specify a projectname"
	exit 1
fi

#no language specified
if [ -z "$LANGUAGE" ]
then
	echo "no language specified: using c++"
	LANGUAGE="c++"
fi
if [ "$LANGUAGE" != "c++" ] && [ "$LANGUAGE" != "c" ] && [ "$LANGUAGE" != "uc++" ] && [ "$LANGUAGE" != "uc" ]
then
	echo "specified language not supported"
	exit 1
fi

#no licence specified
if [ -z "$LICENSE" ]
then
	echo "no licence specified: using $bsd2"
	LICENSE="bsd2"
fi
if [ "$LICENSE" != "mit" ] && [ "$LICENSE" != "gpl" ] && [ "$LICENSE" != "lgpl" ] && [ "$LICENSE" != "boost" ] && [ "$LICENSE" != "cc-by" ] && [ "$LICENSE" != "cc-by-sa" ] && [ "$LICENSE" != "cc-by-nc" ] && [ "$LICENSE" != "cc-by-nc-sa" ] && [ "$LICENSE" != "cc-by-nd" ] && [ "$LICENSE" != "cc-by-nc-nd" ] && [ "$LICENSE" != "bsd2" ] && [ "$LICENSE" != "cc-zero" ]
then
	echo "specified license not supported"
	exit 1
fi

#set defaultvalues if no one are set
if [ "$LANGUAGE" = "c++" ]
then
	if [ -z "$COMPILER" ]
	then
		echo "no compiler specified: using g++"
		COMPILER="g++"
	fi
	if [ -z "$HEADERFILEEXTENSION" ]
	then
		echo "no headerfileextension specified: using hpp"
		HEADERFILEEXTENSION="hpp"
	fi
	if [ -z "$SOURCEFILEEXTENSION" ]
	then
		echo "no sourcefileextension specified: using cpp"
		SOURCEFILEEXTENSION="cpp"
	fi
fi
if [ "$LANGUAGE" = "c" ]
then
	if [ -z "$COMPILER" ]
	then
		echo "no compiler specified: using gcc"
		COMPILER="gcc"
	fi
	if [ -z "$HEADERFILEEXTENSION" ]
	then
		echo "no headerfileextension specified: using h"
		HEADERFILEEXTENSION="h"
	fi
	if [ -z "$SOURCEFILEEXTENSION" ]
	then
		echo "no sourcefileextension specified: using c"
		SOURCEFILEEXTENSION="c"
	fi
fi
if [ "$LANGUAGE" = "uc" ]
then
	if [ -z "$COMPILER" ]
	then
		echo "no compiler specified: using avr-gcc"
		COMPILER="avr-gcc"
	fi
	if [ -z "$HEADERFILEEXTENSION" ]
	then
		echo "no headerfileextension specified: using h"
		HEADERFILEEXTENSION="h"
	fi
	if [ -z "$SOURCEFILEEXTENSION" ]
	then
		echo "no sourcefileextension specified: using c"
		SOURCEFILEEXTENSION="c"
	fi
fi
if [ "$LANGUAGE" = "uc++" ]
then
	if [ -z "$COMPILER" ]
	then
		echo "no compiler specified: using avr-g++"
		COMPILER="avr-g++"
	fi
	if [ -z "$HEADERFILEEXTENSION" ]
	then
		echo "no headerfileextension specified: using hpp"
		HEADERFILEEXTENSION="hpp"
	fi
	if [ -z "$SOURCEFILEEXTENSION" ]
	then
		echo "no sourcefileextension specified: using cpp"
		SOURCEFILEEXTENSION="cpp"
	fi
fi

if [ -e "$PROJECTNAME" ]
then
	echo "a file or folder with name $PROJECTNAME already exists"
	return 1
fi

NAME=$PROJECTNAME
mkdir -pv "$NAME"
cd $NAME
NAME=${NAME##*/}

mkdir -pv include
mkdir -pv src
mkdir -pv extlib
mkdir -pv script
touch mainpage

cd script

if [ -e "v.py" ]
then
	echo "v.py already exists"
else
	echo "#! /usr/bin/env python" > v.py
	echo "" >> v.py
	echo "import sys" >> v.py
	echo "import re" >> v.py
	echo "" >> v.py
	echo "mode = 0;" >> v.py
	echo "#0 = print version" >> v.py
	echo "#1 = build" >> v.py
	echo "#2 = minor" >> v.py
	echo "#3 = major" >> v.py
	echo "filename = \"\"" >> v.py
	echo "for arg in sys.argv:" >> v.py
	echo "	if arg == \"--build\":" >> v.py
	echo "		mode = 1" >> v.py
	echo "	elif arg == \"--minor\":" >> v.py
	echo "		mode = 2" >> v.py
	echo "	elif arg == \"--major\":" >> v.py
	echo "		mode = 3" >> v.py
	echo "	elif arg != sys.argv[0]:" >> v.py
	echo "		filename = arg" >> v.py
	echo "file = open(filename, \"r\")" >> v.py
	echo "data = list()" >> v.py
	echo "for line in file:" >> v.py
	echo "	if \"#define VERSION \\\"\" in line:" >> v.py
	echo "		version = re.split(\"\\\"\", line)[1]" >> v.py
	echo "		versionarray = re.split(\"\\.\", version)" >> v.py
	echo "		major = versionarray[0]" >> v.py
	echo "		minor = versionarray[1]" >> v.py
	echo "		build = versionarray[2]" >> v.py
	echo "		if mode == 0:" >> v.py
	echo "			print version" >> v.py
	echo "			sys.exit()" >> v.py
	echo "		elif mode == 1:" >> v.py
	echo "			build = int(build) + 1" >> v.py
	echo "		elif mode == 2:" >> v.py
	echo "			minor = int(minor) + 1" >> v.py
	echo "			build = 0" >> v.py
	echo "		elif mode == 3:" >> v.py
	echo "			build = 0" >> v.py
	echo "			minor = 0" >> v.py
	echo "			major = int(major) + 1" >> v.py
	echo "		newversion = str(major) + \".\" + str(minor) + \".\" + str(build)" >> v.py
	echo "		newline = re.split(\"\\\"\", line)[0] + \"\\\"\" + newversion + \"\\\"\" + re.split(\"\\\"\", line)[2]" >> v.py
	echo "		line = newline" >> v.py
	echo "	data.append(line)" >> v.py
	echo "file.close()" >> v.py
	echo "file = open(filename, \"w\")" >> v.py
	echo "for line in data:" >> v.py
	echo "	file.write(line)" >> v.py
	echo "file.close()" >> v.py
	echo "created script/v.py"
	chmod u+x "v.py"
fi

cd ..
cd include

if [ -e "version.${HEADERFILEEXTENSION}" ]
then
	echo "version.${HEADERFILEEXTENSION} already exists"
else
	echo "#ifndef VERSION_${HEADERFILEEXTENSION^^}" > version.${HEADERFILEEXTENSION}
	echo "#define VERSION_${HEADERFILEEXTENSION^^}" >> version.${HEADERFILEEXTENSION}
	echo "" >> version.${HEADERFILEEXTENSION}
	echo "#define VERSION \"0.0.0\"" >> version.${HEADERFILEEXTENSION}
	echo "" >> version.${HEADERFILEEXTENSION}
	echo "#endif" >> version.${HEADERFILEEXTENSION}
	echo "created include/version.${HEADERFILEEXTENSION}"
fi

if [ "$LANGUAGE" = "uc" ]
then
	cp /etc/gp/uc/*.h .
fi

cd ..
cd src

if [ -e "${NAME}.${SOURCEFILEEXTENSION}" ]
then
	echo "${NAME}.${SOURCEFILEEXTENSION} already exists"
else
	echo "#include \"version.${HEADERFILEEXTENSION}\"" > ${NAME}.${SOURCEFILEEXTENSION}
	echo "" >> ${NAME}.${SOURCEFILEEXTENSION}
	if [ "$LANGUAGE" = "c++" ]
	then
		echo "using namespace std;" >> ${NAME}.${SOURCEFILEEXTENSION}
		echo "" >> ${NAME}.${SOURCEFILEEXTENSION}
	fi
	echo "int main(int argc, char* argv[])" >> ${NAME}.${SOURCEFILEEXTENSION}
	echo "{" >> ${NAME}.${SOURCEFILEEXTENSION}
	echo "	" >> ${NAME}.${SOURCEFILEEXTENSION}
	echo "	return 0;" >> ${NAME}.${SOURCEFILEEXTENSION}
	echo "}" >> ${NAME}.${SOURCEFILEEXTENSION}
	echo "created src/${NAME}.${SOURCEFILEEXTENSION}"
fi

if [ "$LANGUAGE" = "uc" ]
then
	cp /etc/gp/uc/*.c .
fi

cd ..

if [ -e ".gitignore" ]
then
	echo ".gitignore already exists"
else
	echo "bin/" > .gitignore
	echo "obj/" >> .gitignore
	echo "lib/" >> .gitignore
	echo "doc/" >> .gitignore
	echo ".trac/" >> .gitignore
	echo "" >> .gitignore
	echo "core" >> .gitignore
	echo "vgcore.*" >> .gitignore
	echo "" >> .gitignore
	echo "src/*~" >> .gitignore
	echo "include/*~" >> .gitignore
	echo "src/.*.swp" >> .gitignore
	echo "include/.*.swp" >> .gitignore
	echo "" >> .gitignore
	echo "*.tar.gz" >> .gitignore
	echo "" >> .gitignore
	echo "*.log" >> .gitignore
	echo "created .gitignore"
fi

if [ -e "README" ]
then
	echo "README already exists"
else
	echo "Author: ${DEVELOPER}" > README.md
	echo "Contact: ${CONTACT}" >> README.md
	echo "" >> README.md
	echo "src: contains sourcefiles" >> README.md
	echo "include: contains headerfiles" >> README.md
	echo "obj: contains objectfiles" >> README.md
	echo "bin: contains binaries" >> README.md
	echo "doc: contains documentation" >> README.md
	echo "lib: contains own libraries" >> README.md
	echo "extlib: contains libraries made by others" >> README.md
	echo "script: contains scriptfiles" >> README.md
	echo ".trac: contains configuations and data used for projectmanagement" >> README.md
	echo ".git: contains configuations and data used for versionmanagement" >> README.md
	echo "" >> README.md
	echo "Makefile: configurationfile to compile project automatically" >> README.md
	echo "Doxyfile: configurationfile to generate documantation" >> README.md
	echo "" >> README.md
	echo "mainpage contains some documentation for the project" >> README.md
	echo "created README"
fi

if [ -e "INSTALL" ]
then
	echo "INSTALL already exists"
else
	echo "make doc builds the documantation" > INSTALL.md
	echo "make ${NAME} builds the binaries" >> INSTALL.md
	echo "make all builds binaries and documentation" >> INSTALL.md
	echo "make install copies the binaries to /bin/" >> INSTALL.md
	echo "make clean removes all generated files and folders" >> INSTALL.md
	echo "make help shows nearly all makeoptions" >> INSTALL.md
	echo "created INSTALL"
fi

if [ -e "Makefile" ]
then
	echo "Makefile already exists"
else
	echo "BINDIR=bin" >> Makefile
	echo "SBINDIR=sbin" >> Makefile
	echo "SRCDIR=src" >> Makefile
	echo "OBJDIR=obj" >> Makefile
	echo "INCLUDEDIR=include" >> Makefile
	echo "LIBDIR=lib" >> Makefile
	echo "EXTLIBDIR=extlib" >> Makefile
	echo "SCRIPTDIR=script" >> Makefile
	echo "DOCDIR=doc" >> Makefile
	echo "" >> Makefile
	echo "TARGET=\$(BINDIR)/${NAME}" > Makefile
	echo "ARGS=" >> Makefile
	echo "" >> Makefile
	if [ "$LANGUAGE" = "uc" ] || [ "$LANGUAGE" = "uc++" ]
	then
		echo "MCU=atmega32u4" >> Makefile
		echo "ARCH=AVR8" >> Makefile
		echo "BOARD=USBKEY" >> Makefile
		echo "F_CPU=16000000" >> Makefile
		echo "F_USB=\$(F_CPU)" >> Makefile
		echo "F_CLOCK=\$(F_CPU)" >> Makefile
		echo "CONTROLLER=-mmcu=\$(MCU)" >> Makefile
	fi
	echo "" >> Makefile
	echo "CC=${COMPILER}" >> Makefile
	if [ "$LANGUAGE" = "c" ]
	then
		echo "CFLAGS=-std=c99 -g -Wall -c -I\$(INCLUDE) -Os" >> Makefile
	fi
	if [ "$LANGUAGE" = "c++" ]
	then
		echo "CFLAGS=-std=c++0x -g -Wall -c -Os -c -I\$(INCLUDE)" >> Makefile
	fi
	if [ "$LANGUAGE" = "uc" ]
	then
		echo "USBFLAGS=-DUSE_FLASH_DESCRIPTORS -DUSE_STATIC_OPTIONS=\"(USE_DEVICE_OPT_FULLSPEED | USB_OPT_AUTO_PLL)\" -DUSB_DEVICE_ONLY -DCONTROL_ONLY_DEVICE" >> Makefile
		echo "CFLAGS=-Wall -g -c -std=c99 -Os -I\$(INCLUDE) \$(CONTROLLER) -DF_CPU=\$(F_CPU) -DF_USB=\$(F_USB) -DMCU=\$(MCU) -DARCH=\$(ARCH) -DBOARD=\$(BOARD) -DF_CLOCK=\$(F_CLOCK) \$(USBFLAGS)" >> Makefile
	fi
	echo "LFLAGS=-L\$(LIB)" >> Makefile
	echo "" >> Makefile
	echo "MKDIR=mkdir -p" >> Makefile
	echo "RM=rm -f" >> Makefile
	echo "RMDIR=rm -rf" >> Makefile
	echo "CP=cp -f" >> Makefile
	echo "CPDIR=cp -rf" >> Makefile
	echo "MV=mv -f" >> Makefile
	echo "ECHO=@echo" >> Makefile
	echo "INSTALL=apt-get install -y" >> Makefile
	echo "" >> Makefile
	if [ "$LANGUAGE" = "uc" ]
	then
		echo "MODULES_=debug led button gpio" >> Makefile
	else
		echo "MODULES_=" >> Makefile
	fi
	echo "MODULES=\$(addsuffix .o, \$(addprefix \$(OBJ)/, \$(MODULES_)))" >> Makefile
	echo "" >> Makefile
	if [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "c++" ]
	then
		echo ".PHONY: all time help installdep version major minor build clean commit install uninstall doc debug leakcheck profile run trac strip ${NAME}" >> Makefile
	fi
	if [ "$LANGUAGE" = "uc" ] || [ "$LANGUAGE" = "uc++" ]
	then
		echo ".PHONY: all time help installdep version major minor build clean commit doc trac flash ${NAME}" >> Makefile
	fi
	echo "" >> Makefile
	echo "all: ${NAME}" >> Makefile
	echo "" >> Makefile
	echo "\$(SRCDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(INCLUDEDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(OBJDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(BINDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(LIBDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(EXTLIBDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "\$(DOCDIR):" >> Makefile
	echo "	$(MKDIR) $@" >> Makefile
	echo "" >> Makefile
	echo "help:" >> Makefile
	echo "	\$(ECHO) \"${NAME}\"" >> Makefile
	echo "	\$(ECHO) \"all\"" >> Makefile
	echo "	\$(ECHO) \"help\"" >> Makefile
	echo "	\$(ECHO) \"doc\"" >> Makefile
	echo "	\$(ECHO) \"major\"" >> Makefile
	echo "	\$(ECHO) \"minor\"" >> Makefile
	echo "	\$(ECHO) \"commit\"" >> Makefile
	echo "	\$(ECHO) \"version\"" >> Makefile
	echo "	\$(ECHO) \"clean\"" >> Makefile
	echo "	\$(ECHO) \"installdep\"" >> Makefile
	if [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "c++" ]
	then
		echo "	\$(ECHO) \"install\"" >> Makefile
		echo "	\$(ECHO) \"uninstall\"" >> Makefile
		echo "	\$(ECHO) \"debug\"" >> Makefile
		echo "	\$(ECHO) \"leakcheck\"" >> Makefile
		echo "	\$(ECHO) \"profile\"" >> Makefile
		echo "	\$(ECHO) \"run\"" >> Makefile
		echo "	\$(ECHO) \"strip\"" >> Makefile
	fi
	if [ "$LANGUAGE" = "uc" ] || [ "$LANGUAGE" = "uc++" ]
	then
		echo "	\$(ECHO) \"flash\"" >> Makefile
	fi
	echo "" >> Makefile
	echo "installdep:" >> Makefile
	echo "	\$(INSTALL) doxygen" >> Makefile
	echo "	\$(INSTALL) git" >> Makefile
	echo "	\$(INSTALL) firefox" >> Makefile
	echo "	\$(INSTALL) binutils" >> Makefile
	echo "	\$(INSTALL) tar" >> Makefile
	echo "	\$(INSTALL) python" >> Makefile
	echo "	\$(INSTALL) trac" >> Makefile
	echo "	\$(INSTALL) trac-git" >> Makefile
	if [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "c++" ]
	then
		echo "	\$(INSTALL) ${COMPILER}" >> Makefile
		echo "	\$(INSTALL) valgrind" >> Makefile
		echo "	\$(INSTALL) kcachegrind" >> Makefile
		echo "	\$(INSTALL) ddd" >> Makefile
		echo "	\$(INSTALL) gdb" >> Makefile
	fi
	if [ "$LANGUAGE" = "uc" ] || [ "$LANGUAGE" = "uc++" ]
	then
		echo "	\$(INSTALL) avr-libc" >> Makefile
		echo "	\$(INSTALL) gcc-avr" >> Makefile
		echo "	\$(INSTALL) binutils-avr" >> Makefile
		echo "	\$(INSTALL) avrdude" >> Makefile
	fi
	echo "" >> Makefile
	if [ "$LANGUAGE" = "uc" ] || [ "$LANGUAGE" = "uc++" ]
	then
		echo "flash: \$(BINDIR)/${NAME}.hex" >> Makefile
		echo "	avrdude -p m32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:$<:i" >> Makefile
		echo "	make build" >> Makefile
		echo "" >> Makefile
		echo "${NAME}: flash" >> Makefile
		echo "" >> Makefile
	fi
	if [ "$LANGUAGE" = "c" ] || [ "$LANGUAGE" = "c++" ]
	then
		echo "\$(BINDIR)/${NAME}: \$(BINDIR) \$(OBJDIR)/${NAME}.o \$(MODULES)" >> Makefile
		echo "	\$(CC) -o \$@ \$^ \$(LFLAGS)" >> Makefile
		echo "	make build" >> Makefile
		echo "" >> Makefile
		echo "install: all" >> Makefile
		echo "	\$(CP) \$(BINDIR)/${NAME} /bin/" >> Makefile
		echo "	chmod a+x /bin/${NAME}" >> Makefile
		echo "" >> Makefile
		echo "uninstall: all" >> Makefile
		echo "	\$(RM) /bin/${NAME}" >> Makefile
		echo "" >> Makefile
		echo "${NAME}: \$(BINDIR)/${NAME}" >> Makefile
		echo "" >> Makefile
		echo "debug: \$(TARGET)" >> Makefile
		echo "	ddd \$(TARGET) \$(ARGS)" >> Makefile
		echo "" >> Makefile
		echo "leakcheck: \$(TARGET)" >> Makefile
		echo "	valgrind --leak-check=full --track-origins=yes --show-reachable=yes \$(TARGET) \$(ARGS)" >> Makefile
		echo "" >> Makefile
		echo "profile: \$(TARGET)" >> Makefile
		echo "	valgrind --tool=cachegrind \$(TARGET) \$(ARGS)" >> Makefile
		echo "" >> Makefile
		echo "run: \$(TARGET)" >> Makefile
		echo "	\$(TARGET) \$(ARGS)" >> Makefile
		echo "" >> Makefile
		echo "time: \$(TARGET)" >> Makefile
		echo "	time \$(TARGET) \$(ARGS)" >> Makefile
		echo "" >> Makefile
		echo "strip: \$(TARGET)" >> Makefile
		echo "	strip -s \$<" >> Makefile
		echo "" >> Makefile
		echo "\$(LIBDIR)/lib${NAME}.a: \$(LIBDIR) \$(MODULES)" >> Makefile
		echo "	ar r \$@ \$^" >> Makefile
		echo "" >> Makefile
	fi
	echo "major: \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} \$(SRCDIR) \$(INCLUDEDIR)" >> Makefile
	echo "	python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} --major" >> Makefile
	echo "	git add \$(SRCDIR)/*" >> Makefile
	echo "	git add \$(INCLUDEDIR)/*" >> Makefile
	echo "	git commit -a" >> Makefile
	echo "	VERSION=\$\$(python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.hpp);\\" >> Makefile
	echo "	VERSION=\"v\"\$\$VERSION;\\" >> Makefile
	echo "	git tag -a \$\$VERSION -m \"major build\";\\" >> Makefile
	echo "	trac-admin ./.trac version add \$\$VERSION" >> Makefile
	echo "	git checkout development" >> Makefile
	echo "	git merge topic" >> Makefile
	echo "	git checkout release" >> Makefile
	echo "	git merge development" >> Makefile
	echo "	git checkout topic" >> Makefile
	echo "" >> Makefile
	echo "minor: \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} \$(SRCDIR) \$(INCLUDEDIR)" >> Makefile
	echo "	python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} --minor" >> Makefile
	echo "	git add \$(SRCDIR)/*" >> Makefile
	echo "	git add \$(INCLUDEDIR)/*" >> Makefile
	echo "	git commit -a" >> Makefile
	echo "	VERSION=\$\$(python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.hpp);\\" >> Makefile
	echo "	VERSION=\"v\"\$\$VERSION;\\" >> Makefile
	echo "	git tag -a \$\$VERSION -m \"minor build\";\\" >> Makefile
	echo "	trac-admin ./.trac version add \$\$VERSION" >> Makefile
	echo "	git checkout development" >> Makefile
	echo "	git merge topic" >> Makefile
	echo "	git checkout topic" >> Makefile
	echo "" >> Makefile
	echo "build: \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} \$(SRCDIR) \$(INCLUDEDIR)" >> Makefile
	echo "	python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION} --build" >> Makefile
	echo "	git add \$(SRCDIR)/*" >> Makefile
	echo "	git add \$(INCLUDEDIR)/*" >> Makefile
	echo "	git commit -am \"normal build\"" >> Makefile
	echo "	VERSION=\$\$(python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.hpp);\\" >> Makefile
	echo "	VERSION=\"v\"\$\$VERSION;\\" >> Makefile
	echo "	git tag -a \$\$VERSION -m \"normal build\";\\" >> Makefile
	echo "	trac-admin ./.trac version add \$\$VERSION" >> Makefile
	echo "" >> Makefile
	echo "commit: \$(SRCDIR) \$(INCLUDEDIR)" >> Makefile
	echo "	git add \$(SRCDIR)" >> Makefile
	echo "	git add \$(INCLUDEDIR)" >> Makefile
	echo "	git commit -a" >> Makefile
	echo "" >> Makefile
	echo "version: \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION}" >> Makefile
	echo "	python \$(SCRIPTDIR)/v.py \$(INCLUDEDIR)/version.${HEADERFILEEXTENSION}" >> Makefile
	echo "" >> Makefile
	echo "clean:" >> Makefile
	echo "	\$(RMDIR) \$(BINDIR)" >> Makefile
	echo "	\$(RMDIR) \$(OBJDIR)" >> Makefile
	echo "	\$(RMDIR) \$(LIBDIR)" >> Makefile
	echo "	\$(RMDIR) \$(DOCDIR)" >> Makefile
	echo "	\$(RM) cachegrind.*" >> Makefile
	echo "	\$(RM) core" >> Makefile
	echo "	\$(RM) vgcore.*" >> Makefile
	echo "	\$(RM) \$(SRCDIR)/.*.swp" >> Makefile
	echo "	\$(RM) \$(INCLUDEDIR)/.*.swp" >> Makefile
	echo "	\$(RM) \$(SRCDIR)/*~" >> Makefile
	echo "	\$(RM) \$(INCLUDEDIR)/*~" >> Makefile
	echo "	\$(RM) doxygen.log" >> Makefile
	echo "" >> Makefile
	echo "doc: Doxyfile \$(SRCDIR) \$(INCLUDEDIR) \$(DOCDIR) \$(SRCDIR)/* \$(INCLUDEDIR)/* mainpage" >> Makefile
	echo "	doxygen" >> Makefile
	echo "" >> Makefile
	echo "\$(OBJDIR)/%.o: \$(OBJDIR) \$(SRCDIR)/%.${SOURCEFILEEXTENSION}" >> Makefile
	echo "	\$(CC) \$(CFLAGS) -o \$@ \$<" >> Makefile
	echo "" >> Makefile
	echo "trac:" >> Makefile
	echo "	tracd -s --port 8000 ./.trac &" >> Makefile
	echo "created Makefile"
fi

if [ -e "COPYRIGHT" ]
then
	echo "COPYRIGHT already exists"
else
	if [ "$LICENSE" = "mit" ]
	then
		echo "Copyright (c) $(date +%Y) ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under the MIT License. To view this license, open LICENSE.txt." >> COPYRIGHT.txt
		echo "The MIT License (MIT)" > LICENSE.txt
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" >> LICENSE.txt
		cat /etc/gp/licenses/mit.txt >> LICENSE.txt
		cp /etc/gp/images/opensource.png OPENSOURCE.png
		cp /etc/gp/images/opensourcelicense.png OPENSOURCELICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "boost" ]
	then
		echo "Copyright (c) $(date +%Y) ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under the Boost Software License. To view a copy of this license, visit http://www.boost.org/LICENSE_1_0.txt or open LICENSE.txt." >> COPYRIGHT.txt
		cat /etc/gp/licenses/boost.txt > LICENSE.txt
		cp /etc/gp/images/opensource.png OPENSOURCE.png
		cp /etc/gp/images/opensourcelicense.png OPENSOURCELICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "bsd2" ]
	then
		echo "Copyright (c) $(date +%Y) ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under the BSD 2-Clause License. To view this license, open LICENSE.txt." >> COPYRIGHT.txt
		echo "Copyright (c) $(date +%Y), ${DEVELOPER}" > LICENSE.txt
		echo "All rights reserved." >> LICENSE.txt
		echo "" >> LICENSE.txt
		cat /etc/gp/licenses/bsd2.txt >> LICENSE.txt
		cp /etc/gp/images/opensource.png OPENSOURCE.png
		cp /etc/gp/images/opensourcelicense.png OPENSOURCELICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-zero" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Zero 1.0 Universal License. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-zero.png LICENSE.png
		cp /etc/gp/images/freeculturallicense.png FREECULTURALLICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by.png LICENSE.png
		cp /etc/gp/images/freeculturallicense.png FREECULTURALLICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by-sa" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by-sa.png LICENSE.png
		cp /etc/gp/images/freeculturallicense.png FREECULTURALLICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by-nc" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by-nc.png LICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by-nc-sa" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by-nc-sa.png LICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by-nc-nd" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by-nc-nd.png LICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "cc-by-nd" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under a Creative Commons Attribution-NoDerivs 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nd/3.0/." >> COPYRIGHT.txt
		cp /etc/gp/images/cc-by-nd.png LICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "gpl" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under the GNU GENERAL PUBLIC LICENSE. To view a copy of this license, visit http://www.gnu.org/licenses/gpl-3.0-standalone.html or open LICENSE.txt." >> COPYRIGHT.txt
		cat /etc/gp/licenses/gpl3.txt > LICENSE.txt
		cp /etc/gp/images/gpl3.png LICENSE.png
		cp /etc/gp/images/opensource.png OPENSOURCE.png
		cp /etc/gp/images/opensourcelicense.png OPENSOURCELICENSE.png
		echo "created COPYRIGHT"
	fi
	if [ "$LICENSE" = "lgpl" ]
	then
		echo "Copyright (c) $(date +%Y)  ${DEVELOPER}" > COPYRIGHT.txt
		echo "This work is licensed under the GNU LESSER GENERAL PUBLIC LICENSE. To view a copy of this license, visit http://www.gnu.org/licenses/lgpl-3.0-standalone.html or open LICENSE.txt." >> COPYRIGHT.txt
		cat /etc/gp/licenses/lgpl3.txt > LICENSE.txt
		cp /etc/gp/images/lgpl3.png LICENSE.png
		cp /etc/gp/images/opensource.png OPENSOURCE.png
		cp /etc/gp/images/opensourcelicense.png OPENSOURCELICENSE.png
		echo "created COPYRIGHT"
	fi
fi

if [ -e "Doxyfile" ]
then
	echo "Doxyfile already exists"
else
	echo "# Doxyfile 1.7.3" > Doxyfile
	echo "" >> Doxyfile
	echo "# This file describes the settings to be used by the documentation system" >> Doxyfile
	echo "# doxygen (www.doxygen.org) for a project." >> Doxyfile
	echo "#" >> Doxyfile
	echo "# All text after a hash (#) is considered a comment and will be ignored." >> Doxyfile
	echo "# The format is:" >> Doxyfile
	echo "#       TAG = value [value, ...]" >> Doxyfile
	echo "# For lists items can also be appended using:" >> Doxyfile
	echo "#       TAG += value [value, ...]" >> Doxyfile
	echo "# Values that contain spaces should be placed between quotes (\" \")." >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# Project related configuration options" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This tag specifies the encoding used for all characters in the config file" >> Doxyfile
	echo "# that follow. The default is UTF-8 which is also the encoding used for all" >> Doxyfile
	echo "# text before the first occurrence of this tag. Doxygen uses libiconv (or the" >> Doxyfile
	echo "# iconv built into libc) for the transcoding. See" >> Doxyfile
	echo "# http://www.gnu.org/software/libiconv for the list of possible encodings." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOXYFILE_ENCODING      = UTF-8" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The PROJECT_NAME tag is a single word (or a sequence of words surrounded" >> Doxyfile
	echo "# by quotes) that should identify the project." >> Doxyfile
	echo "" >> Doxyfile
	echo "PROJECT_NAME           = ${NAME}" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The PROJECT_NUMBER tag can be used to enter a project or revision number." >> Doxyfile
	echo "# This could be handy for archiving the generated documentation or" >> Doxyfile
	echo "# if some version control system is used." >> Doxyfile
	echo "" >> Doxyfile
	echo "PROJECT_NUMBER         =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Using the PROJECT_BRIEF tag one can provide an optional one line description for a project that appears at the top of each page and should give viewer a quick idea about the purpose of the project. Keep the description short." >> Doxyfile
	echo "" >> Doxyfile
	echo "PROJECT_BRIEF          =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# With the PROJECT_LOGO tag one can specify an logo or icon that is" >> Doxyfile
	echo "# included in the documentation. The maximum height of the logo should not" >> Doxyfile
	echo "# exceed 55 pixels and the maximum width should not exceed 200 pixels." >> Doxyfile
	echo "# Doxygen will copy the logo to the output directory." >> Doxyfile
	echo "" >> Doxyfile
	echo "PROJECT_LOGO           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The OUTPUT_DIRECTORY tag is used to specify the (relative or absolute)" >> Doxyfile
	echo "# base path where the generated documentation will be put." >> Doxyfile
	echo "# If a relative path is entered, it will be relative to the location" >> Doxyfile
	echo "# where doxygen was started. If left blank the current directory will be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "OUTPUT_DIRECTORY       = doc" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CREATE_SUBDIRS tag is set to YES, then doxygen will create" >> Doxyfile
	echo "# 4096 sub-directories (in 2 levels) under the output directory of each output" >> Doxyfile
	echo "# format and will distribute the generated files over these directories." >> Doxyfile
	echo "# Enabling this option can be useful when feeding doxygen a huge amount of" >> Doxyfile
	echo "# source files, where putting all generated files in the same directory would" >> Doxyfile
	echo "# otherwise cause performance problems for the file system." >> Doxyfile
	echo "" >> Doxyfile
	echo "CREATE_SUBDIRS         = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The OUTPUT_LANGUAGE tag is used to specify the language in which all" >> Doxyfile
	echo "# documentation generated by doxygen is written. Doxygen will use this" >> Doxyfile
	echo "# information to generate all constant output in the proper language." >> Doxyfile
	echo "# The default language is English, other supported languages are:" >> Doxyfile
	echo "# Afrikaans, Arabic, Brazilian, Catalan, Chinese, Chinese-Traditional," >> Doxyfile
	echo "# Croatian, Czech, Danish, Dutch, Esperanto, Farsi, Finnish, French, German," >> Doxyfile
	echo "# Greek, Hungarian, Italian, Japanese, Japanese-en (Japanese with English" >> Doxyfile
	echo "# messages), Korean, Korean-en, Lithuanian, Norwegian, Macedonian, Persian," >> Doxyfile
	echo "# Polish, Portuguese, Romanian, Russian, Serbian, Serbian-Cyrillic, Slovak," >> Doxyfile
	echo "# Slovene, Spanish, Swedish, Ukrainian, and Vietnamese." >> Doxyfile
	echo "" >> Doxyfile
	echo "OUTPUT_LANGUAGE        = English" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the BRIEF_MEMBER_DESC tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# include brief member descriptions after the members that are listed in" >> Doxyfile
	echo "# the file and class documentation (similar to JavaDoc)." >> Doxyfile
	echo "# Set to NO to disable this." >> Doxyfile
	echo "" >> Doxyfile
	echo "BRIEF_MEMBER_DESC      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the REPEAT_BRIEF tag is set to YES (the default) Doxygen will prepend" >> Doxyfile
	echo "# the brief description of a member or function before the detailed description." >> Doxyfile
	echo "# Note: if both HIDE_UNDOC_MEMBERS and BRIEF_MEMBER_DESC are set to NO, the" >> Doxyfile
	echo "# brief descriptions will be completely suppressed." >> Doxyfile
	echo "" >> Doxyfile
	echo "REPEAT_BRIEF           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This tag implements a quasi-intelligent brief description abbreviator" >> Doxyfile
	echo "# that is used to form the text in various listings. Each string" >> Doxyfile
	echo "# in this list, if found as the leading text of the brief description, will be" >> Doxyfile
	echo "# stripped from the text and the result after processing the whole list, is" >> Doxyfile
	echo "# used as the annotated text. Otherwise, the brief description is used as-is." >> Doxyfile
	echo "# If left blank, the following values are used (\"$name\" is automatically" >> Doxyfile
	echo "# replaced with the name of the entity): \"The $name class\" \"The $name widget\"" >> Doxyfile
	echo "# \"The $name file\" \"is\" \"provides\" \"specifies\" \"contains\"" >> Doxyfile
	echo "# \"represents\" \"a\" \"an\" \"the\"" >> Doxyfile
	echo "" >> Doxyfile
	echo "ABBREVIATE_BRIEF       =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ALWAYS_DETAILED_SEC and REPEAT_BRIEF tags are both set to YES then" >> Doxyfile
	echo "# Doxygen will generate a detailed section even if there is only a brief" >> Doxyfile
	echo "# description." >> Doxyfile
	echo "" >> Doxyfile
	echo "ALWAYS_DETAILED_SEC    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the INLINE_INHERITED_MEMB tag is set to YES, doxygen will show all" >> Doxyfile
	echo "# inherited members of a class in the documentation of that class as if those" >> Doxyfile
	echo "# members were ordinary class members. Constructors, destructors and assignment" >> Doxyfile
	echo "# operators of the base classes will not be shown." >> Doxyfile
	echo "" >> Doxyfile
	echo "INLINE_INHERITED_MEMB  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the FULL_PATH_NAMES tag is set to YES then Doxygen will prepend the full" >> Doxyfile
	echo "# path before files name in the file list and in the header files. If set" >> Doxyfile
	echo "# to NO the shortest path that makes the file name unique will be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "FULL_PATH_NAMES        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the FULL_PATH_NAMES tag is set to YES then the STRIP_FROM_PATH tag" >> Doxyfile
	echo "# can be used to strip a user-defined part of the path. Stripping is" >> Doxyfile
	echo "# only done if one of the specified strings matches the left-hand part of" >> Doxyfile
	echo "# the path. The tag can be used to show relative paths in the file list." >> Doxyfile
	echo "# If left blank the directory from which doxygen is run is used as the" >> Doxyfile
	echo "# path to strip." >> Doxyfile
	echo "" >> Doxyfile
	echo "STRIP_FROM_PATH        =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The STRIP_FROM_INC_PATH tag can be used to strip a user-defined part of" >> Doxyfile
	echo "# the path mentioned in the documentation of a class, which tells" >> Doxyfile
	echo "# the reader which header file to include in order to use a class." >> Doxyfile
	echo "# If left blank only the name of the header file containing the class" >> Doxyfile
	echo "# definition is used. Otherwise one should specify the include paths that" >> Doxyfile
	echo "# are normally passed to the compiler using the -I flag." >> Doxyfile
	echo "" >> Doxyfile
	echo "STRIP_FROM_INC_PATH    =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SHORT_NAMES tag is set to YES, doxygen will generate much shorter" >> Doxyfile
	echo "# (but less readable) file names. This can be useful if your file system" >> Doxyfile
	echo "# doesn\'t support long names like on DOS, Mac, or CD-ROM." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHORT_NAMES            = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the JAVADOC_AUTOBRIEF tag is set to YES then Doxygen" >> Doxyfile
	echo "# will interpret the first line (until the first dot) of a JavaDoc-style" >> Doxyfile
	echo "# comment as the brief description. If set to NO, the JavaDoc" >> Doxyfile
	echo "# comments will behave just like regular Qt-style comments" >> Doxyfile
	echo "# (thus requiring an explicit @brief command for a brief description.)" >> Doxyfile
	echo "" >> Doxyfile
	echo "JAVADOC_AUTOBRIEF      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the QT_AUTOBRIEF tag is set to YES then Doxygen will" >> Doxyfile
	echo "# interpret the first line (until the first dot) of a Qt-style" >> Doxyfile
	echo "# comment as the brief description. If set to NO, the comments" >> Doxyfile
	echo "# will behave just like regular Qt-style comments (thus requiring" >> Doxyfile
	echo "# an explicit \\brief command for a brief description.)" >> Doxyfile
	echo "" >> Doxyfile
	echo "QT_AUTOBRIEF           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MULTILINE_CPP_IS_BRIEF tag can be set to YES to make Doxygen" >> Doxyfile
	echo "# treat a multi-line C++ special comment block (i.e. a block of //! or ///" >> Doxyfile
	echo "# comments) as a brief description. This used to be the default behaviour." >> Doxyfile
	echo "# The new default is to treat a multi-line C++ comment block as a detailed" >> Doxyfile
	echo "# description. Set this tag to YES if you prefer the old behaviour instead." >> Doxyfile
	echo "" >> Doxyfile
	echo "MULTILINE_CPP_IS_BRIEF = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the INHERIT_DOCS tag is set to YES (the default) then an undocumented" >> Doxyfile
	echo "# member inherits the documentation from any documented member that it" >> Doxyfile
	echo "# re-implements." >> Doxyfile
	echo "" >> Doxyfile
	echo "INHERIT_DOCS           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SEPARATE_MEMBER_PAGES tag is set to YES, then doxygen will produce" >> Doxyfile
	echo "# a new page for each member. If set to NO, the documentation of a member will" >> Doxyfile
	echo "# be part of the file/class/namespace that contains it." >> Doxyfile
	echo "" >> Doxyfile
	echo "SEPARATE_MEMBER_PAGES  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The TAB_SIZE tag can be used to set the number of spaces in a tab." >> Doxyfile
	echo "# Doxygen uses this value to replace tabs by spaces in code fragments." >> Doxyfile
	echo "" >> Doxyfile
	echo "TAB_SIZE               = 4" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This tag can be used to specify a number of aliases that acts" >> Doxyfile
	echo "# as commands in the documentation. An alias has the form \"name=value\"." >> Doxyfile
	echo "# For example adding \"sideeffect=\\par Side Effects:\\n\" will allow you to" >> Doxyfile
	echo "# put the command \\sideeffect (or @sideeffect) in the documentation, which" >> Doxyfile
	echo "# will result in a user-defined paragraph with heading \"Side Effects:\"." >> Doxyfile
	echo "# You can put \\n\'s in the value part of an alias to insert newlines." >> Doxyfile
	echo "" >> Doxyfile
	echo "ALIASES                =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the OPTIMIZE_OUTPUT_FOR_C tag to YES if your project consists of C" >> Doxyfile
	echo "# sources only. Doxygen will then generate output that is more tailored for C." >> Doxyfile
	echo "# For instance, some of the names that are used will be different. The list" >> Doxyfile
	echo "# of all members will be omitted, etc." >> Doxyfile
	echo "" >> Doxyfile
	if [ "$LANGUAGE" = "c" ]
	then
		echo "OPTIMIZE_OUTPUT_FOR_C  = YES" >> Doxyfile
	else
		echo "OPTIMIZE_OUTPUT_FOR_C  = NO" >> Doxyfile
	fi
	echo "" >> Doxyfile
	echo "# Set the OPTIMIZE_OUTPUT_JAVA tag to YES if your project consists of Java" >> Doxyfile
	echo "# sources only. Doxygen will then generate output that is more tailored for" >> Doxyfile
	echo "# Java. For instance, namespaces will be presented as packages, qualified" >> Doxyfile
	echo "# scopes will look different, etc." >> Doxyfile
	echo "" >> Doxyfile
	echo "OPTIMIZE_OUTPUT_JAVA   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the OPTIMIZE_FOR_FORTRAN tag to YES if your project consists of Fortran" >> Doxyfile
	echo "# sources only. Doxygen will then generate output that is more tailored for" >> Doxyfile
	echo "# Fortran." >> Doxyfile
	echo "" >> Doxyfile
	echo "OPTIMIZE_FOR_FORTRAN   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the OPTIMIZE_OUTPUT_VHDL tag to YES if your project consists of VHDL" >> Doxyfile
	echo "# sources. Doxygen will then generate output that is tailored for" >> Doxyfile
	echo "# VHDL." >> Doxyfile
	echo "" >> Doxyfile
	echo "OPTIMIZE_OUTPUT_VHDL   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Doxygen selects the parser to use depending on the extension of the files it" >> Doxyfile
	echo "# parses. With this tag you can assign which parser to use for a given extension." >> Doxyfile
	echo "# Doxygen has a built-in mapping, but you can override or extend it using this" >> Doxyfile
	echo "# tag. The format is ext=language, where ext is a file extension, and language" >> Doxyfile
	echo "# is one of the parsers supported by doxygen: IDL, Java, Javascript, CSharp, C," >> Doxyfile
	echo "# C++, D, PHP, Objective-C, Python, Fortran, VHDL, C, C++. For instance to make" >> Doxyfile
	echo "# doxygen treat .inc files as Fortran files (default is PHP), and .f files as C" >> Doxyfile
	echo "# (default is Fortran), use: inc=Fortran f=C. Note that for custom extensions" >> Doxyfile
	echo "# you also need to set FILE_PATTERNS otherwise the files are not read by doxygen." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTENSION_MAPPING      =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If you use STL classes (i.e. std::string, std::vector, etc.) but do not want" >> Doxyfile
	echo "# to include (a tag file for) the STL sources as input, then you should" >> Doxyfile
	echo "# set this tag to YES in order to let doxygen match functions declarations and" >> Doxyfile
	echo "# definitions whose arguments contain STL classes (e.g. func(std::string); v.s." >> Doxyfile
	echo "# func(std::string) {}). This also makes the inheritance and collaboration" >> Doxyfile
	echo "# diagrams that involve STL classes more complete and accurate." >> Doxyfile
	echo "" >> Doxyfile
	echo "BUILTIN_STL_SUPPORT    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If you use Microsoft\'s C++/CLI language, you should set this option to YES to" >> Doxyfile
	echo "# enable parsing support." >> Doxyfile
	echo "" >> Doxyfile
	echo "CPP_CLI_SUPPORT        = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the SIP_SUPPORT tag to YES if your project consists of sip sources only." >> Doxyfile
	echo "# Doxygen will parse them like normal C++ but will assume all classes use public" >> Doxyfile
	echo "# instead of private inheritance when no explicit protection keyword is present." >> Doxyfile
	echo "" >> Doxyfile
	echo "SIP_SUPPORT            = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# For Microsoft\'s IDL there are propget and propput attributes to indicate getter" >> Doxyfile
	echo "# and setter methods for a property. Setting this option to YES (the default)" >> Doxyfile
	echo "# will make doxygen replace the get and set methods by a property in the" >> Doxyfile
	echo "# documentation. This will only work if the methods are indeed getting or" >> Doxyfile
	echo "# setting a simple type. If this is not the case, or you want to show the" >> Doxyfile
	echo "# methods anyway, you should set this option to NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "IDL_PROPERTY_SUPPORT   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If member grouping is used in the documentation and the DISTRIBUTE_GROUP_DOC" >> Doxyfile
	echo "# tag is set to YES, then doxygen will reuse the documentation of the first" >> Doxyfile
	echo "# member in the group (if any) for the other members of the group. By default" >> Doxyfile
	echo "# all members of a group must be documented explicitly." >> Doxyfile
	echo "" >> Doxyfile
	echo "DISTRIBUTE_GROUP_DOC   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the SUBGROUPING tag to YES (the default) to allow class member groups of" >> Doxyfile
	echo "# the same type (for instance a group of public functions) to be put as a" >> Doxyfile
	echo "# subgroup of that type (e.g. under the Public Functions section). Set it to" >> Doxyfile
	echo "# NO to prevent subgrouping. Alternatively, this can be done per class using" >> Doxyfile
	echo "# the \\nosubgrouping command." >> Doxyfile
	echo "" >> Doxyfile
	echo "SUBGROUPING            = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When TYPEDEF_HIDES_STRUCT is enabled, a typedef of a struct, union, or enum" >> Doxyfile
	echo "# is documented as struct, union, or enum with the name of the typedef. So" >> Doxyfile
	echo "# typedef struct TypeS {} TypeT, will appear in the documentation as a struct" >> Doxyfile
	echo "# with name TypeT. When disabled the typedef will appear as a member of a file," >> Doxyfile
	echo "# namespace, or class. And the struct will be named TypeS. This can typically" >> Doxyfile
	echo "# be useful for C code in case the coding convention dictates that all compound" >> Doxyfile
	echo "# types are typedef\'ed and only the typedef is referenced, never the tag name." >> Doxyfile
	echo "" >> Doxyfile
	echo "TYPEDEF_HIDES_STRUCT   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The SYMBOL_CACHE_SIZE determines the size of the internal cache use to" >> Doxyfile
	echo "# determine which symbols to keep in memory and which to flush to disk." >> Doxyfile
	echo "# When the cache is full, less often used symbols will be written to disk." >> Doxyfile
	echo "# For small to medium size projects (<1000 input files) the default value is" >> Doxyfile
	echo "# probably good enough. For larger projects a too small cache size can cause" >> Doxyfile
	echo "# doxygen to be busy swapping symbols to and from disk most of the time" >> Doxyfile
	echo "# causing a significant performance penalty." >> Doxyfile
	echo "# If the system has enough physical memory increasing the cache will improve the" >> Doxyfile
	echo "# performance by keeping more symbols in memory. Note that the value works on" >> Doxyfile
	echo "# a logarithmic scale so increasing the size by one will roughly double the" >> Doxyfile
	echo "# memory usage. The cache size is given by this formula:" >> Doxyfile
	echo "# 2^(16+SYMBOL_CACHE_SIZE). The valid range is 0..9, the default is 0," >> Doxyfile
	echo "# corresponding to a cache size of 2^16 = 65536 symbols" >> Doxyfile
	echo "" >> Doxyfile
	echo "SYMBOL_CACHE_SIZE      = 0" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# Build related configuration options" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXTRACT_ALL tag is set to YES doxygen will assume all entities in" >> Doxyfile
	echo "# documentation are documented, even if no documentation was available." >> Doxyfile
	echo "# Private class members and static file members will be hidden unless" >> Doxyfile
	echo "# the EXTRACT_PRIVATE and EXTRACT_STATIC tags are set to YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_ALL            = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXTRACT_PRIVATE tag is set to YES all private members of a class" >> Doxyfile
	echo "# will be included in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_PRIVATE        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXTRACT_STATIC tag is set to YES all static members of a file" >> Doxyfile
	echo "# will be included in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_STATIC         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXTRACT_LOCAL_CLASSES tag is set to YES classes (and structs)" >> Doxyfile
	echo "# defined locally in source files will be included in the documentation." >> Doxyfile
	echo "# If set to NO only classes defined in header files are included." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_LOCAL_CLASSES  = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This flag is only useful for Objective-C code. When set to YES local" >> Doxyfile
	echo "# methods, which are defined in the implementation section but not in" >> Doxyfile
	echo "# the interface are included in the documentation." >> Doxyfile
	echo "# If set to NO (the default) only methods in the interface are included." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_LOCAL_METHODS  = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If this flag is set to YES, the members of anonymous namespaces will be" >> Doxyfile
	echo "# extracted and appear in the documentation as a namespace called" >> Doxyfile
	echo "# \'anonymous_namespace{file}\', where file will be replaced with the base" >> Doxyfile
	echo "# name of the file that contains the anonymous namespace. By default" >> Doxyfile
	echo "# anonymous namespaces are hidden." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRACT_ANON_NSPACES   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HIDE_UNDOC_MEMBERS tag is set to YES, Doxygen will hide all" >> Doxyfile
	echo "# undocumented members of documented classes, files or namespaces." >> Doxyfile
	echo "# If set to NO (the default) these members will be included in the" >> Doxyfile
	echo "# various overviews, but no documentation section is generated." >> Doxyfile
	echo "# This option has no effect if EXTRACT_ALL is enabled." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_UNDOC_MEMBERS     = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HIDE_UNDOC_CLASSES tag is set to YES, Doxygen will hide all" >> Doxyfile
	echo "# undocumented classes that are normally visible in the class hierarchy." >> Doxyfile
	echo "# If set to NO (the default) these classes will be included in the various" >> Doxyfile
	echo "# overviews. This option has no effect if EXTRACT_ALL is enabled." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_UNDOC_CLASSES     = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HIDE_FRIEND_COMPOUNDS tag is set to YES, Doxygen will hide all" >> Doxyfile
	echo "# friend (class|struct|union) declarations." >> Doxyfile
	echo "# If set to NO (the default) these declarations will be included in the" >> Doxyfile
	echo "# documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_FRIEND_COMPOUNDS  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HIDE_IN_BODY_DOCS tag is set to YES, Doxygen will hide any" >> Doxyfile
	echo "# documentation blocks found inside the body of a function." >> Doxyfile
	echo "# If set to NO (the default) these blocks will be appended to the" >> Doxyfile
	echo "# function\'s detailed documentation block." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_IN_BODY_DOCS      = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The INTERNAL_DOCS tag determines if documentation" >> Doxyfile
	echo "# that is typed after a \\internal command is included. If the tag is set" >> Doxyfile
	echo "# to NO (the default) then the documentation will be excluded." >> Doxyfile
	echo "# Set it to YES to include the internal documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "INTERNAL_DOCS          = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CASE_SENSE_NAMES tag is set to NO then Doxygen will only generate" >> Doxyfile
	echo "# file names in lower-case letters. If set to YES upper-case letters are also" >> Doxyfile
	echo "# allowed. This is useful if you have classes or files whose names only differ" >> Doxyfile
	echo "# in case and if your file system supports case sensitive file names. Windows" >> Doxyfile
	echo "# and Mac users are advised to set this option to NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "CASE_SENSE_NAMES       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HIDE_SCOPE_NAMES tag is set to NO (the default) then Doxygen" >> Doxyfile
	echo "# will show members with their full class and namespace scopes in the" >> Doxyfile
	echo "# documentation. If set to YES the scope will be hidden." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_SCOPE_NAMES       = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SHOW_INCLUDE_FILES tag is set to YES (the default) then Doxygen" >> Doxyfile
	echo "# will put a list of the files that are included by a file in the documentation" >> Doxyfile
	echo "# of that file." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHOW_INCLUDE_FILES     = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the FORCE_LOCAL_INCLUDES tag is set to YES then Doxygen" >> Doxyfile
	echo "# will list include files with double quotes in the documentation" >> Doxyfile
	echo "# rather than with sharp brackets." >> Doxyfile
	echo "" >> Doxyfile
	echo "FORCE_LOCAL_INCLUDES   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the INLINE_INFO tag is set to YES (the default) then a tag [inline]" >> Doxyfile
	echo "# is inserted in the documentation for inline members." >> Doxyfile
	echo "" >> Doxyfile
	echo "INLINE_INFO            = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SORT_MEMBER_DOCS tag is set to YES (the default) then doxygen" >> Doxyfile
	echo "# will sort the (detailed) documentation of file and class members" >> Doxyfile
	echo "# alphabetically by member name. If set to NO the members will appear in" >> Doxyfile
	echo "# declaration order." >> Doxyfile
	echo "" >> Doxyfile
	echo "SORT_MEMBER_DOCS       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SORT_BRIEF_DOCS tag is set to YES then doxygen will sort the" >> Doxyfile
	echo "# brief documentation of file, namespace and class members alphabetically" >> Doxyfile
	echo "# by member name. If set to NO (the default) the members will appear in" >> Doxyfile
	echo "# declaration order." >> Doxyfile
	echo "" >> Doxyfile
	echo "SORT_BRIEF_DOCS        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SORT_MEMBERS_CTORS_1ST tag is set to YES then doxygen" >> Doxyfile
	echo "# will sort the (brief and detailed) documentation of class members so that" >> Doxyfile
	echo "# constructors and destructors are listed first. If set to NO (the default)" >> Doxyfile
	echo "# the constructors will appear in the respective orders defined by" >> Doxyfile
	echo "# SORT_MEMBER_DOCS and SORT_BRIEF_DOCS." >> Doxyfile
	echo "# This tag will be ignored for brief docs if SORT_BRIEF_DOCS is set to NO" >> Doxyfile
	echo "# and ignored for detailed docs if SORT_MEMBER_DOCS is set to NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "SORT_MEMBERS_CTORS_1ST = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SORT_GROUP_NAMES tag is set to YES then doxygen will sort the" >> Doxyfile
	echo "# hierarchy of group names into alphabetical order. If set to NO (the default)" >> Doxyfile
	echo "# the group names will appear in their defined order." >> Doxyfile
	echo "" >> Doxyfile
	echo "SORT_GROUP_NAMES       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SORT_BY_SCOPE_NAME tag is set to YES, the class list will be" >> Doxyfile
	echo "# sorted by fully-qualified names, including namespaces. If set to" >> Doxyfile
	echo "# NO (the default), the class list will be sorted only by class name," >> Doxyfile
	echo "# not including the namespace part." >> Doxyfile
	echo "# Note: This option is not very useful if HIDE_SCOPE_NAMES is set to YES." >> Doxyfile
	echo "# Note: This option applies only to the class list, not to the" >> Doxyfile
	echo "# alphabetical list." >> Doxyfile
	echo "" >> Doxyfile
	echo "SORT_BY_SCOPE_NAME     = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the STRICT_PROTO_MATCHING option is enabled and doxygen fails to do proper type resolution of all parameters of a function it will reject a" >> Doxyfile
	echo "# match between the prototype and the implementation of a member function even if there is only one candidate or it is obvious which candidate to choose by doing a simple string match. By disabling STRICT_PROTO_MATCHING doxygen" >> Doxyfile
	echo "# will still accept a match between prototype and implementation in such cases." >> Doxyfile
	echo "" >> Doxyfile
	echo "STRICT_PROTO_MATCHING  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_TODOLIST tag can be used to enable (YES) or" >> Doxyfile
	echo "# disable (NO) the todo list. This list is created by putting \\todo" >> Doxyfile
	echo "# commands in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_TODOLIST      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_TESTLIST tag can be used to enable (YES) or" >> Doxyfile
	echo "# disable (NO) the test list. This list is created by putting \\test" >> Doxyfile
	echo "# commands in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_TESTLIST      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_BUGLIST tag can be used to enable (YES) or" >> Doxyfile
	echo "# disable (NO) the bug list. This list is created by putting \\bug" >> Doxyfile
	echo "# commands in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_BUGLIST       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_DEPRECATEDLIST tag can be used to enable (YES) or" >> Doxyfile
	echo "# disable (NO) the deprecated list. This list is created by putting" >> Doxyfile
	echo "# \\deprecated commands in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_DEPRECATEDLIST= YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The ENABLED_SECTIONS tag can be used to enable conditional" >> Doxyfile
	echo "# documentation sections, marked by \\if sectionname ... \\endif." >> Doxyfile
	echo "" >> Doxyfile
	echo "ENABLED_SECTIONS       =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MAX_INITIALIZER_LINES tag determines the maximum number of lines" >> Doxyfile
	echo "# the initial value of a variable or macro consists of for it to appear in" >> Doxyfile
	echo "# the documentation. If the initializer consists of more lines than specified" >> Doxyfile
	echo "# here it will be hidden. Use a value of 0 to hide initializers completely." >> Doxyfile
	echo "# The appearance of the initializer of individual variables and macros in the" >> Doxyfile
	echo "# documentation can be controlled using \\showinitializer or \\hideinitializer" >> Doxyfile
	echo "# command in the documentation regardless of this setting." >> Doxyfile
	echo "" >> Doxyfile
	echo "MAX_INITIALIZER_LINES  = 30" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the SHOW_USED_FILES tag to NO to disable the list of files generated" >> Doxyfile
	echo "# at the bottom of the documentation of classes and structs. If set to YES the" >> Doxyfile
	echo "# list will mention the files that were used to generate the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHOW_USED_FILES        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the sources in your project are distributed over multiple directories" >> Doxyfile
	echo "# then setting the SHOW_DIRECTORIES tag to YES will show the directory hierarchy" >> Doxyfile
	echo "# in the documentation. The default is NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHOW_DIRECTORIES       = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the SHOW_FILES tag to NO to disable the generation of the Files page." >> Doxyfile
	echo "# This will remove the Files entry from the Quick Index and from the" >> Doxyfile
	echo "# Folder Tree View (if specified). The default is YES." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHOW_FILES             = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the SHOW_NAMESPACES tag to NO to disable the generation of the" >> Doxyfile
	echo "# Namespaces page." >> Doxyfile
	echo "# This will remove the Namespaces entry from the Quick Index" >> Doxyfile
	echo "# and from the Folder Tree View (if specified). The default is YES." >> Doxyfile
	echo "" >> Doxyfile
	echo "SHOW_NAMESPACES        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The FILE_VERSION_FILTER tag can be used to specify a program or script that" >> Doxyfile
	echo "# doxygen should invoke to get the current version for each file (typically from" >> Doxyfile
	echo "# the version control system). Doxygen will invoke the program by executing (via" >> Doxyfile
	echo "# popen()) the command <command> <input-file>, where <command> is the value of" >> Doxyfile
	echo "# the FILE_VERSION_FILTER tag, and <input-file> is the name of an input file" >> Doxyfile
	echo "# provided by doxygen. Whatever the program writes to standard output" >> Doxyfile
	echo "# is used as the file version. See the manual for examples." >> Doxyfile
	echo "" >> Doxyfile
	echo "FILE_VERSION_FILTER    =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The LAYOUT_FILE tag can be used to specify a layout file which will be parsed" >> Doxyfile
	echo "# by doxygen. The layout file controls the global structure of the generated" >> Doxyfile
	echo "# output files in an output format independent way. The create the layout file" >> Doxyfile
	echo "# that represents doxygen\'s defaults, run doxygen with the -l option." >> Doxyfile
	echo "# You can optionally specify a file name after the option, if omitted" >> Doxyfile
	echo "# DoxygenLayout.xml will be used as the name of the layout file." >> Doxyfile
	echo "" >> Doxyfile
	echo "LAYOUT_FILE            =" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to warning and progress messages" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The QUIET tag can be used to turn on/off the messages that are generated" >> Doxyfile
	echo "# by doxygen. Possible values are YES and NO. If left blank NO is used." >> Doxyfile
	echo "" >> Doxyfile
	echo "QUIET                  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The WARNINGS tag can be used to turn on/off the warning messages that are" >> Doxyfile
	echo "# generated by doxygen. Possible values are YES and NO. If left blank" >> Doxyfile
	echo "# NO is used." >> Doxyfile
	echo "" >> Doxyfile
	echo "WARNINGS               = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If WARN_IF_UNDOCUMENTED is set to YES, then doxygen will generate warnings" >> Doxyfile
	echo "# for undocumented members. If EXTRACT_ALL is set to YES then this flag will" >> Doxyfile
	echo "# automatically be disabled." >> Doxyfile
	echo "" >> Doxyfile
	echo "WARN_IF_UNDOCUMENTED   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If WARN_IF_DOC_ERROR is set to YES, doxygen will generate warnings for" >> Doxyfile
	echo "# potential errors in the documentation, such as not documenting some" >> Doxyfile
	echo "# parameters in a documented function, or documenting parameters that" >> Doxyfile
	echo "# don\'t exist or using markup commands wrongly." >> Doxyfile
	echo "" >> Doxyfile
	echo "WARN_IF_DOC_ERROR      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The WARN_NO_PARAMDOC option can be enabled to get warnings for" >> Doxyfile
	echo "# functions that are documented, but have no documentation for their parameters" >> Doxyfile
	echo "# or return value. If set to NO (the default) doxygen will only warn about" >> Doxyfile
	echo "# wrong or incomplete parameter documentation, but not about the absence of" >> Doxyfile
	echo "# documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "WARN_NO_PARAMDOC       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The WARN_FORMAT tag determines the format of the warning messages that" >> Doxyfile
	echo "# doxygen can produce. The string should contain the $file, $line, and $text" >> Doxyfile
	echo "# tags, which will be replaced by the file and line number from which the" >> Doxyfile
	echo "# warning originated and the warning text. Optionally the format may contain" >> Doxyfile
	echo "# $version, which will be replaced by the version of the file (if it could" >> Doxyfile
	echo "# be obtained via FILE_VERSION_FILTER)" >> Doxyfile
	echo "" >> Doxyfile
	echo "WARN_FORMAT            = \"$file:$line: $text\"" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The WARN_LOGFILE tag can be used to specify a file to which warning" >> Doxyfile
	echo "# and error messages should be written. If left blank the output is written" >> Doxyfile
	echo "# to stderr." >> Doxyfile
	echo "" >> Doxyfile
	echo "WARN_LOGFILE           = doxygen.log" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the input files" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The INPUT tag can be used to specify the files and/or directories that contain" >> Doxyfile
	echo "# documented source files. You may enter file names like \"myfile.cpp\" or" >> Doxyfile
	echo "# directories like \"/usr/src/myproject\". Separate the files or directories" >> Doxyfile
	echo "# with spaces." >> Doxyfile
	echo "" >> Doxyfile
	echo "INPUT                  = src/ include/ mainpage" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This tag can be used to specify the character encoding of the source files" >> Doxyfile
	echo "# that doxygen parses. Internally doxygen uses the UTF-8 encoding, which is" >> Doxyfile
	echo "# also the default input encoding. Doxygen uses libiconv (or the iconv built" >> Doxyfile
	echo "# into libc) for the transcoding. See http://www.gnu.org/software/libiconv for" >> Doxyfile
	echo "# the list of possible encodings." >> Doxyfile
	echo "" >> Doxyfile
	echo "INPUT_ENCODING         = UTF-8" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the value of the INPUT tag contains directories, you can use the" >> Doxyfile
	echo "# FILE_PATTERNS tag to specify one or more wildcard pattern (like *.cpp" >> Doxyfile
	echo "# and *.h) to filter out the source-files in the directories. If left" >> Doxyfile
	echo "# blank the following patterns are tested:" >> Doxyfile
	echo "# *.c *.cc *.cxx *.cpp *.c++ *.d *.java *.ii *.ixx *.ipp *.i++ *.inl *.h *.hh" >> Doxyfile
	echo "# *.hxx *.hpp *.h++ *.idl *.odl *.cs *.php *.php3 *.inc *.m *.mm *.dox *.py" >> Doxyfile
	echo "# *.f90 *.f *.for *.vhd *.vhdl" >> Doxyfile
	echo "" >> Doxyfile
	echo "FILE_PATTERNS          = *.${SOURCEFILEEXTENSION} *.${HEADERFILEEXTENSION}" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The RECURSIVE tag can be used to turn specify whether or not subdirectories" >> Doxyfile
	echo "# should be searched for input files as well. Possible values are YES and NO." >> Doxyfile
	echo "# If left blank NO is used." >> Doxyfile
	echo "" >> Doxyfile
	echo "RECURSIVE              = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The EXCLUDE tag can be used to specify files and/or directories that should" >> Doxyfile
	echo "# excluded from the INPUT source files. This way you can easily exclude a" >> Doxyfile
	echo "# subdirectory from a directory tree whose root is specified with the INPUT tag." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXCLUDE                =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The EXCLUDE_SYMLINKS tag can be used select whether or not files or" >> Doxyfile
	echo "# directories that are symbolic links (a Unix file system feature) are excluded" >> Doxyfile
	echo "# from the input." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXCLUDE_SYMLINKS       = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the value of the INPUT tag contains directories, you can use the" >> Doxyfile
	echo "# EXCLUDE_PATTERNS tag to specify one or more wildcard patterns to exclude" >> Doxyfile
	echo "# certain files from those directories. Note that the wildcards are matched" >> Doxyfile
	echo "# against the file with absolute path, so to exclude all test directories" >> Doxyfile
	echo "# for example use the pattern */test/*" >> Doxyfile
	echo "" >> Doxyfile
	echo "EXCLUDE_PATTERNS       =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The EXCLUDE_SYMBOLS tag can be used to specify one or more symbol names" >> Doxyfile
	echo "# (namespaces, classes, functions, etc.) that should be excluded from the" >> Doxyfile
	echo "# output. The symbol name can be a fully qualified name, a word, or if the" >> Doxyfile
	echo "# wildcard * is used, a substring. Examples: ANamespace, AClass," >> Doxyfile
	echo "# AClass::ANamespace, ANamespace::*Test" >> Doxyfile
	echo "" >> Doxyfile
	echo "EXCLUDE_SYMBOLS        =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The EXAMPLE_PATH tag can be used to specify one or more files or" >> Doxyfile
	echo "# directories that contain example code fragments that are included (see" >> Doxyfile
	echo "# the \\include command)." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXAMPLE_PATH           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the value of the EXAMPLE_PATH tag contains directories, you can use the" >> Doxyfile
	echo "# EXAMPLE_PATTERNS tag to specify one or more wildcard pattern (like *.cpp" >> Doxyfile
	echo "# and *.h) to filter out the source-files in the directories. If left" >> Doxyfile
	echo "# blank all files are included." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXAMPLE_PATTERNS       =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXAMPLE_RECURSIVE tag is set to YES then subdirectories will be" >> Doxyfile
	echo "# searched for input files to be used with the \\include or \\dontinclude" >> Doxyfile
	echo "# commands irrespective of the value of the RECURSIVE tag." >> Doxyfile
	echo "# Possible values are YES and NO. If left blank NO is used." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXAMPLE_RECURSIVE      = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The IMAGE_PATH tag can be used to specify one or more files or" >> Doxyfile
	echo "# directories that contain image that are included in the documentation (see" >> Doxyfile
	echo "# the \\image command)." >> Doxyfile
	echo "" >> Doxyfile
	echo "IMAGE_PATH             =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The INPUT_FILTER tag can be used to specify a program that doxygen should" >> Doxyfile
	echo "# invoke to filter for each input file. Doxygen will invoke the filter program" >> Doxyfile
	echo "# by executing (via popen()) the command <filter> <input-file>, where <filter>" >> Doxyfile
	echo "# is the value of the INPUT_FILTER tag, and <input-file> is the name of an" >> Doxyfile
	echo "# input file. Doxygen will then use the output that the filter program writes" >> Doxyfile
	echo "# to standard output." >> Doxyfile
	echo "# If FILTER_PATTERNS is specified, this tag will be" >> Doxyfile
	echo "# ignored." >> Doxyfile
	echo "" >> Doxyfile
	echo "INPUT_FILTER           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The FILTER_PATTERNS tag can be used to specify filters on a per file pattern" >> Doxyfile
	echo "# basis." >> Doxyfile
	echo "# Doxygen will compare the file name with each pattern and apply the" >> Doxyfile
	echo "# filter if there is a match." >> Doxyfile
	echo "# The filters are a list of the form:" >> Doxyfile
	echo "# pattern=filter (like *.cpp=my_cpp_filter). See INPUT_FILTER for further" >> Doxyfile
	echo "# info on how filters are used. If FILTER_PATTERNS is empty or if" >> Doxyfile
	echo "# non of the patterns match the file name, INPUT_FILTER is applied." >> Doxyfile
	echo "" >> Doxyfile
	echo "FILTER_PATTERNS        =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the FILTER_SOURCE_FILES tag is set to YES, the input filter (if set using" >> Doxyfile
	echo "# INPUT_FILTER) will be used to filter the input files when producing source" >> Doxyfile
	echo "# files to browse (i.e. when SOURCE_BROWSER is set to YES)." >> Doxyfile
	echo "" >> Doxyfile
	echo "FILTER_SOURCE_FILES    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The FILTER_SOURCE_PATTERNS tag can be used to specify source filters per file" >> Doxyfile
	echo "# pattern. A pattern will override the setting for FILTER_PATTERN (if any)" >> Doxyfile
	echo "# and it is also possible to disable source filtering for a specific pattern" >> Doxyfile
	echo "# using *.ext= (so without naming a filter). This option only has effect when" >> Doxyfile
	echo "# FILTER_SOURCE_FILES is enabled." >> Doxyfile
	echo "" >> Doxyfile
	echo "FILTER_SOURCE_PATTERNS =" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to source browsing" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SOURCE_BROWSER tag is set to YES then a list of source files will" >> Doxyfile
	echo "# be generated. Documented entities will be cross-referenced with these sources." >> Doxyfile
	echo "# Note: To get rid of all source code in the generated output, make sure also" >> Doxyfile
	echo "# VERBATIM_HEADERS is set to NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "SOURCE_BROWSER         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Setting the INLINE_SOURCES tag to YES will include the body" >> Doxyfile
	echo "# of functions and classes directly in the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "INLINE_SOURCES         = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Setting the STRIP_CODE_COMMENTS tag to YES (the default) will instruct" >> Doxyfile
	echo "# doxygen to hide any special comment blocks from generated source code" >> Doxyfile
	echo "# fragments. Normal C and C++ comments will always remain visible." >> Doxyfile
	echo "" >> Doxyfile
	echo "STRIP_CODE_COMMENTS    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the REFERENCED_BY_RELATION tag is set to YES" >> Doxyfile
	echo "# then for each documented function all documented" >> Doxyfile
	echo "# functions referencing it will be listed." >> Doxyfile
	echo "" >> Doxyfile
	echo "REFERENCED_BY_RELATION = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the REFERENCES_RELATION tag is set to YES" >> Doxyfile
	echo "# then for each documented function all documented entities" >> Doxyfile
	echo "# called/used by that function will be listed." >> Doxyfile
	echo "" >> Doxyfile
	echo "REFERENCES_RELATION    = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the REFERENCES_LINK_SOURCE tag is set to YES (the default)" >> Doxyfile
	echo "# and SOURCE_BROWSER tag is set to YES, then the hyperlinks from" >> Doxyfile
	echo "# functions in REFERENCES_RELATION and REFERENCED_BY_RELATION lists will" >> Doxyfile
	echo "# link to the source code." >> Doxyfile
	echo "# Otherwise they will link to the documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "REFERENCES_LINK_SOURCE = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the USE_HTAGS tag is set to YES then the references to source code" >> Doxyfile
	echo "# will point to the HTML generated by the htags(1) tool instead of doxygen" >> Doxyfile
	echo "# built-in source browser. The htags tool is part of GNU\'s global source" >> Doxyfile
	echo "# tagging system (see http://www.gnu.org/software/global/global.html). You" >> Doxyfile
	echo "# will need version 4.8.6 or higher." >> Doxyfile
	echo "" >> Doxyfile
	echo "USE_HTAGS              = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the VERBATIM_HEADERS tag is set to YES (the default) then Doxygen" >> Doxyfile
	echo "# will generate a verbatim copy of the header file for each class for" >> Doxyfile
	echo "# which an include is specified. Set to NO to disable this." >> Doxyfile
	echo "" >> Doxyfile
	echo "VERBATIM_HEADERS       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the alphabetical class index" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ALPHABETICAL_INDEX tag is set to YES, an alphabetical index" >> Doxyfile
	echo "# of all compounds will be generated. Enable this if the project" >> Doxyfile
	echo "# contains a lot of classes, structs, unions or interfaces." >> Doxyfile
	echo "" >> Doxyfile
	echo "ALPHABETICAL_INDEX     = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the alphabetical index is enabled (see ALPHABETICAL_INDEX) then" >> Doxyfile
	echo "# the COLS_IN_ALPHA_INDEX tag can be used to specify the number of columns" >> Doxyfile
	echo "# in which this list will be split (can be a number in the range [1..20])" >> Doxyfile
	echo "" >> Doxyfile
	echo "COLS_IN_ALPHA_INDEX    = 5" >> Doxyfile
	echo "" >> Doxyfile
	echo "# In case all classes in a project start with a common prefix, all" >> Doxyfile
	echo "# classes will be put under the same header in the alphabetical index." >> Doxyfile
	echo "# The IGNORE_PREFIX tag can be used to specify one or more prefixes that" >> Doxyfile
	echo "# should be ignored while generating the index headers." >> Doxyfile
	echo "" >> Doxyfile
	echo "IGNORE_PREFIX          =" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the HTML output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTML tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# generate HTML output." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_HTML          = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_OUTPUT tag is used to specify where the HTML docs will be put." >> Doxyfile
	echo "# If a relative path is entered the value of OUTPUT_DIRECTORY will be" >> Doxyfile
	echo "# put in front of it. If left blank \'html\' will be used as the default path." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_OUTPUT            = html" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_FILE_EXTENSION tag can be used to specify the file extension for" >> Doxyfile
	echo "# each generated HTML page (for example: .htm,.php,.asp). If it is left blank" >> Doxyfile
	echo "# doxygen will generate files with .html extension." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_FILE_EXTENSION    = .html" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_HEADER tag can be used to specify a personal HTML header for" >> Doxyfile
	echo "# each generated HTML page. If it is left blank doxygen will generate a" >> Doxyfile
	echo "# standard header." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_HEADER            =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_FOOTER tag can be used to specify a personal HTML footer for" >> Doxyfile
	echo "# each generated HTML page. If it is left blank doxygen will generate a" >> Doxyfile
	echo "# standard footer." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_FOOTER            =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_STYLESHEET tag can be used to specify a user-defined cascading" >> Doxyfile
	echo "# style sheet that is used by each HTML page. It can be used to" >> Doxyfile
	echo "# fine-tune the look of the HTML output. If the tag is left blank doxygen" >> Doxyfile
	echo "# will generate a default style sheet. Note that doxygen will try to copy" >> Doxyfile
	echo "# the style sheet file to the HTML output directory, so don\'t put your own" >> Doxyfile
	echo "# stylesheet in the HTML output directory as well, or it will be erased!" >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_STYLESHEET        =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_COLORSTYLE_HUE tag controls the color of the HTML output." >> Doxyfile
	echo "# Doxygen will adjust the colors in the stylesheet and background images" >> Doxyfile
	echo "# according to this color. Hue is specified as an angle on a colorwheel," >> Doxyfile
	echo "# see http://en.wikipedia.org/wiki/Hue for more information." >> Doxyfile
	echo "# For instance the value 0 represents red, 60 is yellow, 120 is green," >> Doxyfile
	echo "# 180 is cyan, 240 is blue, 300 purple, and 360 is red again." >> Doxyfile
	echo "# The allowed range is 0 to 359." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_COLORSTYLE_HUE    = 220" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_COLORSTYLE_SAT tag controls the purity (or saturation) of" >> Doxyfile
	echo "# the colors in the HTML output. For a value of 0 the output will use" >> Doxyfile
	echo "# grayscales only. A value of 255 will produce the most vivid colors." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_COLORSTYLE_SAT    = 100" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The HTML_COLORSTYLE_GAMMA tag controls the gamma correction applied to" >> Doxyfile
	echo "# the luminance component of the colors in the HTML output. Values below" >> Doxyfile
	echo "# 100 gradually make the output lighter, whereas values above 100 make" >> Doxyfile
	echo "# the output darker. The value divided by 100 is the actual gamma applied," >> Doxyfile
	echo "# so 80 represents a gamma of 0.8, The value 220 represents a gamma of 2.2," >> Doxyfile
	echo "# and 100 does not change the gamma." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_COLORSTYLE_GAMMA  = 80" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HTML_TIMESTAMP tag is set to YES then the footer of each generated HTML" >> Doxyfile
	echo "# page will contain the date and time when the page was generated. Setting" >> Doxyfile
	echo "# this to NO can help when comparing the output of multiple runs." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_TIMESTAMP         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HTML_ALIGN_MEMBERS tag is set to YES, the members of classes," >> Doxyfile
	echo "# files or namespaces will be aligned in HTML using tables. If set to" >> Doxyfile
	echo "# NO a bullet list will be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_ALIGN_MEMBERS     = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the HTML_DYNAMIC_SECTIONS tag is set to YES then the generated HTML" >> Doxyfile
	echo "# documentation will contain sections that can be hidden and shown after the" >> Doxyfile
	echo "# page has loaded. For this to work a browser that supports" >> Doxyfile
	echo "# JavaScript and DHTML is required (for instance Mozilla 1.0+, Firefox" >> Doxyfile
	echo "# Netscape 6.0+, Internet explorer 5.0+, Konqueror, or Safari)." >> Doxyfile
	echo "" >> Doxyfile
	echo "HTML_DYNAMIC_SECTIONS  = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_DOCSET tag is set to YES, additional index files" >> Doxyfile
	echo "# will be generated that can be used as input for Apple\'s Xcode 3" >> Doxyfile
	echo "# integrated development environment, introduced with OSX 10.5 (Leopard)." >> Doxyfile
	echo "# To create a documentation set, doxygen will generate a Makefile in the" >> Doxyfile
	echo "# HTML output directory. Running make will produce the docset in that" >> Doxyfile
	echo "# directory and running \"make install\" will install the docset in" >> Doxyfile
	echo "# ~/Library/Developer/Shared/Documentation/DocSets so that Xcode will find" >> Doxyfile
	echo "# it at startup." >> Doxyfile
	echo "# See http://developer.apple.com/tools/creatingdocsetswithdoxygen.html" >> Doxyfile
	echo "# for more information." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_DOCSET        = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When GENERATE_DOCSET tag is set to YES, this tag determines the name of the" >> Doxyfile
	echo "# feed. A documentation feed provides an umbrella under which multiple" >> Doxyfile
	echo "# documentation sets from a single provider (such as a company or product suite)" >> Doxyfile
	echo "# can be grouped." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOCSET_FEEDNAME        = \"Doxygen generated docs\"" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When GENERATE_DOCSET tag is set to YES, this tag specifies a string that" >> Doxyfile
	echo "# should uniquely identify the documentation set bundle. This should be a" >> Doxyfile
	echo "# reverse domain-name style string, e.g. com.mycompany.MyDocSet. Doxygen" >> Doxyfile
	echo "# will append .docset to the name." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOCSET_BUNDLE_ID       = org.doxygen.Project" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When GENERATE_PUBLISHER_ID tag specifies a string that should uniquely identify" >> Doxyfile
	echo "# the documentation publisher. This should be a reverse domain-name style" >> Doxyfile
	echo "# string, e.g. com.mycompany.MyDocSet.documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOCSET_PUBLISHER_ID    = org.doxygen.Publisher" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_PUBLISHER_NAME tag identifies the documentation publisher." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOCSET_PUBLISHER_NAME  = Publisher" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, additional index files" >> Doxyfile
	echo "# will be generated that can be used as input for tools like the" >> Doxyfile
	echo "# Microsoft HTML help workshop to generate a compiled HTML help file (.chm)" >> Doxyfile
	echo "# of the generated HTML documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_HTMLHELP      = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, the CHM_FILE tag can" >> Doxyfile
	echo "# be used to specify the file name of the resulting .chm file. You" >> Doxyfile
	echo "# can add a path in front of the file if the result should not be" >> Doxyfile
	echo "# written to the html output directory." >> Doxyfile
	echo "" >> Doxyfile
	echo "CHM_FILE               =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, the HHC_LOCATION tag can" >> Doxyfile
	echo "# be used to specify the location (absolute path including file name) of" >> Doxyfile
	echo "# the HTML help compiler (hhc.exe). If non-empty doxygen will try to run" >> Doxyfile
	echo "# the HTML help compiler on the generated index.hhp." >> Doxyfile
	echo "" >> Doxyfile
	echo "HHC_LOCATION           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, the GENERATE_CHI flag" >> Doxyfile
	echo "# controls if a separate .chi index file is generated (YES) or that" >> Doxyfile
	echo "# it should be included in the master .chm file (NO)." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_CHI           = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, the CHM_INDEX_ENCODING" >> Doxyfile
	echo "# is used to encode HtmlHelp index (hhk), content (hhc) and project file" >> Doxyfile
	echo "# content." >> Doxyfile
	echo "" >> Doxyfile
	echo "CHM_INDEX_ENCODING     =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_HTMLHELP tag is set to YES, the BINARY_TOC flag" >> Doxyfile
	echo "# controls whether a binary table of contents is generated (YES) or a" >> Doxyfile
	echo "# normal table of contents (NO) in the .chm file." >> Doxyfile
	echo "" >> Doxyfile
	echo "BINARY_TOC             = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The TOC_EXPAND flag can be set to YES to add extra items for group members" >> Doxyfile
	echo "# to the contents of the HTML help documentation and to the tree view." >> Doxyfile
	echo "" >> Doxyfile
	echo "TOC_EXPAND             = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_QHP tag is set to YES and both QHP_NAMESPACE and" >> Doxyfile
	echo "# QHP_VIRTUAL_FOLDER are set, an additional index file will be generated" >> Doxyfile
	echo "# that can be used as input for Qt\'s qhelpgenerator to generate a" >> Doxyfile
	echo "# Qt Compressed Help (.qch) of the generated HTML documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_QHP           = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the QHG_LOCATION tag is specified, the QCH_FILE tag can" >> Doxyfile
	echo "# be used to specify the file name of the resulting .qch file." >> Doxyfile
	echo "# The path specified is relative to the HTML output folder." >> Doxyfile
	echo "" >> Doxyfile
	echo "QCH_FILE               =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The QHP_NAMESPACE tag specifies the namespace to use when generating" >> Doxyfile
	echo "# Qt Help Project output. For more information please see" >> Doxyfile
	echo "# http://doc.trolltech.com/qthelpproject.html#namespace" >> Doxyfile
	echo "" >> Doxyfile
	echo "QHP_NAMESPACE          = org.doxygen.Project" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The QHP_VIRTUAL_FOLDER tag specifies the namespace to use when generating" >> Doxyfile
	echo "# Qt Help Project output. For more information please see" >> Doxyfile
	echo "# http://doc.trolltech.com/qthelpproject.html#virtual-folders" >> Doxyfile
	echo "" >> Doxyfile
	echo "QHP_VIRTUAL_FOLDER     = doc" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If QHP_CUST_FILTER_NAME is set, it specifies the name of a custom filter to" >> Doxyfile
	echo "# add. For more information please see" >> Doxyfile
	echo "# http://doc.trolltech.com/qthelpproject.html#custom-filters" >> Doxyfile
	echo "" >> Doxyfile
	echo "QHP_CUST_FILTER_NAME   =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The QHP_CUST_FILT_ATTRS tag specifies the list of the attributes of the" >> Doxyfile
	echo "# custom filter to add. For more information please see" >> Doxyfile
	echo "# <a href=\"http://doc.trolltech.com/qthelpproject.html#custom-filters\">" >> Doxyfile
	echo "# Qt Help Project / Custom Filters</a>." >> Doxyfile
	echo "" >> Doxyfile
	echo "QHP_CUST_FILTER_ATTRS  =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The QHP_SECT_FILTER_ATTRS tag specifies the list of the attributes this" >> Doxyfile
	echo "# project\'s" >> Doxyfile
	echo "# filter section matches." >> Doxyfile
	echo "# <a href=\"http://doc.trolltech.com/qthelpproject.html#filter-attributes\">" >> Doxyfile
	echo "# Qt Help Project / Filter Attributes</a>." >> Doxyfile
	echo "" >> Doxyfile
	echo "QHP_SECT_FILTER_ATTRS  =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_QHP tag is set to YES, the QHG_LOCATION tag can" >> Doxyfile
	echo "# be used to specify the location of Qt\'s qhelpgenerator." >> Doxyfile
	echo "# If non-empty doxygen will try to run qhelpgenerator on the generated" >> Doxyfile
	echo "# .qhp file." >> Doxyfile
	echo "" >> Doxyfile
	echo "QHG_LOCATION           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_ECLIPSEHELP tag is set to YES, additional index files" >> Doxyfile
	echo "#  will be generated, which together with the HTML files, form an Eclipse help" >> Doxyfile
	echo "# plugin. To install this plugin and make it available under the help contents" >> Doxyfile
	echo "# menu in Eclipse, the contents of the directory containing the HTML and XML" >> Doxyfile
	echo "# files needs to be copied into the plugins directory of eclipse. The name of" >> Doxyfile
	echo "# the directory within the plugins directory should be the same as" >> Doxyfile
	echo "# the ECLIPSE_DOC_ID value. After copying Eclipse needs to be restarted before" >> Doxyfile
	echo "# the help appears." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_ECLIPSEHELP   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# A unique identifier for the eclipse help plugin. When installing the plugin" >> Doxyfile
	echo "# the directory name containing the HTML and XML files should also have" >> Doxyfile
	echo "# this name." >> Doxyfile
	echo "" >> Doxyfile
	echo "ECLIPSE_DOC_ID         = org.doxygen.Project" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DISABLE_INDEX tag can be used to turn on/off the condensed index at" >> Doxyfile
	echo "# top of each HTML page. The value NO (the default) enables the index and" >> Doxyfile
	echo "# the value YES disables it." >> Doxyfile
	echo "" >> Doxyfile
	echo "DISABLE_INDEX          = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# This tag can be used to set the number of enum values (range [0,1..20])" >> Doxyfile
	echo "# that doxygen will group on one line in the generated HTML documentation." >> Doxyfile
	echo "# Note that a value of 0 will completely suppress the enum values from appearing in the overview section." >> Doxyfile
	echo "" >> Doxyfile
	echo "ENUM_VALUES_PER_LINE   = 1" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The GENERATE_TREEVIEW tag is used to specify whether a tree-like index" >> Doxyfile
	echo "# structure should be generated to display hierarchical information." >> Doxyfile
	echo "# If the tag value is set to YES, a side panel will be generated" >> Doxyfile
	echo "# containing a tree-like index structure (just like the one that" >> Doxyfile
	echo "# is generated for HTML Help). For this to work a browser that supports" >> Doxyfile
	echo "# JavaScript, DHTML, CSS and frames is required (i.e. any modern browser)." >> Doxyfile
	echo "# Windows users are probably better off using the HTML help feature." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_TREEVIEW      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# By enabling USE_INLINE_TREES, doxygen will generate the Groups, Directories," >> Doxyfile
	echo "# and Class Hierarchy pages using a tree view instead of an ordered list." >> Doxyfile
	echo "" >> Doxyfile
	echo "USE_INLINE_TREES       = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the treeview is enabled (see GENERATE_TREEVIEW) then this tag can be" >> Doxyfile
	echo "# used to set the initial width (in pixels) of the frame in which the tree" >> Doxyfile
	echo "# is shown." >> Doxyfile
	echo "" >> Doxyfile
	echo "TREEVIEW_WIDTH         = 250" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When the EXT_LINKS_IN_WINDOW option is set to YES doxygen will open" >> Doxyfile
	echo "# links to external symbols imported via tag files in a separate window." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXT_LINKS_IN_WINDOW    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Use this tag to change the font size of Latex formulas included" >> Doxyfile
	echo "# as images in the HTML documentation. The default is 10. Note that" >> Doxyfile
	echo "# when you change the font size after a successful doxygen run you need" >> Doxyfile
	echo "# to manually remove any form_*.png images from the HTML output directory" >> Doxyfile
	echo "# to force them to be regenerated." >> Doxyfile
	echo "" >> Doxyfile
	echo "FORMULA_FONTSIZE       = 10" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Use the FORMULA_TRANPARENT tag to determine whether or not the images" >> Doxyfile
	echo "# generated for formulas are transparent PNGs. Transparent PNGs are" >> Doxyfile
	echo "# not supported properly for IE 6.0, but are supported on all modern browsers." >> Doxyfile
	echo "# Note that when changing this option you need to delete any form_*.png files" >> Doxyfile
	echo "# in the HTML output before the changes have effect." >> Doxyfile
	echo "" >> Doxyfile
	echo "FORMULA_TRANSPARENT    = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Enable the USE_MATHJAX option to render LaTeX formulas using MathJax" >> Doxyfile
	echo "# (see http://www.mathjax.org) which uses client side Javascript for the" >> Doxyfile
	echo "# rendering instead of using prerendered bitmaps. Use this if you do not" >> Doxyfile
	echo "# have LaTeX installed or if you want to formulas look prettier in the HTML" >> Doxyfile
	echo "# output. When enabled you also need to install MathJax separately and" >> Doxyfile
	echo "# configure the path to it using the MATHJAX_RELPATH option." >> Doxyfile
	echo "" >> Doxyfile
	echo "USE_MATHJAX            = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When MathJax is enabled you need to specify the location relative to the" >> Doxyfile
	echo "# HTML output directory using the MATHJAX_RELPATH option. The destination" >> Doxyfile
	echo "# directory should contain the MathJax.js script. For instance, if the mathjax" >> Doxyfile
	echo "# directory is located at the same level as the HTML output directory, then" >> Doxyfile
	echo "# MATHJAX_RELPATH should be ../mathjax. The default value points to the mathjax.org site, so you can quickly see the result without installing" >> Doxyfile
	echo "# MathJax, but it is strongly recommended to install a local copy of MathJax" >> Doxyfile
	echo "# before deployment." >> Doxyfile
	echo "" >> Doxyfile
	echo "MATHJAX_RELPATH        = http://www.mathjax.org/mathjax" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When the SEARCHENGINE tag is enabled doxygen will generate a search box" >> Doxyfile
	echo "# for the HTML output. The underlying search engine uses javascript" >> Doxyfile
	echo "# and DHTML and should work on any modern browser. Note that when using" >> Doxyfile
	echo "# HTML help (GENERATE_HTMLHELP), Qt help (GENERATE_QHP), or docsets" >> Doxyfile
	echo "# (GENERATE_DOCSET) there is already a search function so this one should" >> Doxyfile
	echo "# typically be disabled. For large projects the javascript based search engine" >> Doxyfile
	echo "# can be slow, then enabling SERVER_BASED_SEARCH may provide a better solution." >> Doxyfile
	echo "" >> Doxyfile
	echo "SEARCHENGINE           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When the SERVER_BASED_SEARCH tag is enabled the search engine will be" >> Doxyfile
	echo "# implemented using a PHP enabled web server instead of at the web client" >> Doxyfile
	echo "# using Javascript. Doxygen will generate the search PHP script and index" >> Doxyfile
	echo "# file to put on the web server. The advantage of the server" >> Doxyfile
	echo "# based approach is that it scales better to large projects and allows" >> Doxyfile
	echo "# full text search. The disadvantages are that it is more difficult to setup" >> Doxyfile
	echo "# and does not have live searching capabilities." >> Doxyfile
	echo "" >> Doxyfile
	echo "SERVER_BASED_SEARCH    = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the LaTeX output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_LATEX tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# generate Latex output." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_LATEX         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The LATEX_OUTPUT tag is used to specify where the LaTeX docs will be put." >> Doxyfile
	echo "# If a relative path is entered the value of OUTPUT_DIRECTORY will be" >> Doxyfile
	echo "# put in front of it. If left blank \'latex\' will be used as the default path." >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_OUTPUT           = latex" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The LATEX_CMD_NAME tag can be used to specify the LaTeX command name to be" >> Doxyfile
	echo "# invoked. If left blank \'latex\' will be used as the default command name." >> Doxyfile
	echo "# Note that when enabling USE_PDFLATEX this option is only used for" >> Doxyfile
	echo "# generating bitmaps for formulas in the HTML output, but not in the" >> Doxyfile
	echo "# Makefile that is written to the output directory." >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_CMD_NAME         = latex" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MAKEINDEX_CMD_NAME tag can be used to specify the command name to" >> Doxyfile
	echo "# generate index for LaTeX. If left blank \'makeindex\' will be used as the" >> Doxyfile
	echo "# default command name." >> Doxyfile
	echo "" >> Doxyfile
	echo "MAKEINDEX_CMD_NAME     = makeindex" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the COMPACT_LATEX tag is set to YES Doxygen generates more compact" >> Doxyfile
	echo "# LaTeX documents. This may be useful for small projects and may help to" >> Doxyfile
	echo "# save some trees in general." >> Doxyfile
	echo "" >> Doxyfile
	echo "COMPACT_LATEX          = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The PAPER_TYPE tag can be used to set the paper type that is used" >> Doxyfile
	echo "# by the printer. Possible values are: a4, letter, legal and" >> Doxyfile
	echo "# executive. If left blank a4wide will be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "PAPER_TYPE             = a4" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The EXTRA_PACKAGES tag can be to specify one or more names of LaTeX" >> Doxyfile
	echo "# packages that should be included in the LaTeX output." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTRA_PACKAGES         =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The LATEX_HEADER tag can be used to specify a personal LaTeX header for" >> Doxyfile
	echo "# the generated latex document. The header should contain everything until" >> Doxyfile
	echo "# the first chapter. If it is left blank doxygen will generate a" >> Doxyfile
	echo "# standard header. Notice: only use this tag if you know what you are doing!" >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_HEADER           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the PDF_HYPERLINKS tag is set to YES, the LaTeX that is generated" >> Doxyfile
	echo "# is prepared for conversion to pdf (using ps2pdf). The pdf file will" >> Doxyfile
	echo "# contain links (just like the HTML output) instead of page references" >> Doxyfile
	echo "# This makes the output suitable for online browsing using a pdf viewer." >> Doxyfile
	echo "" >> Doxyfile
	echo "PDF_HYPERLINKS         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the USE_PDFLATEX tag is set to YES, pdflatex will be used instead of" >> Doxyfile
	echo "# plain latex in the generated Makefile. Set this option to YES to get a" >> Doxyfile
	echo "# higher quality PDF documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "USE_PDFLATEX           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the LATEX_BATCHMODE tag is set to YES, doxygen will add the \\\\batchmode." >> Doxyfile
	echo "# command to the generated LaTeX files. This will instruct LaTeX to keep" >> Doxyfile
	echo "# running if errors occur, instead of asking the user for help." >> Doxyfile
	echo "# This option is also used when generating formulas in HTML." >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_BATCHMODE        = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If LATEX_HIDE_INDICES is set to YES then doxygen will not" >> Doxyfile
	echo "# include the index chapters (such as File Index, Compound Index, etc.)" >> Doxyfile
	echo "# in the output." >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_HIDE_INDICES     = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If LATEX_SOURCE_CODE is set to YES then doxygen will include" >> Doxyfile
	echo "# source code with syntax highlighting in the LaTeX output." >> Doxyfile
	echo "# Note that which sources are shown also depends on other settings" >> Doxyfile
	echo "# such as SOURCE_BROWSER." >> Doxyfile
	echo "" >> Doxyfile
	echo "LATEX_SOURCE_CODE      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the RTF output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_RTF tag is set to YES Doxygen will generate RTF output" >> Doxyfile
	echo "# The RTF output is optimized for Word 97 and may not look very pretty with" >> Doxyfile
	echo "# other RTF readers or editors." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_RTF           = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The RTF_OUTPUT tag is used to specify where the RTF docs will be put." >> Doxyfile
	echo "# If a relative path is entered the value of OUTPUT_DIRECTORY will be" >> Doxyfile
	echo "# put in front of it. If left blank \'rtf\' will be used as the default path." >> Doxyfile
	echo "" >> Doxyfile
	echo "RTF_OUTPUT             = rtf" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the COMPACT_RTF tag is set to YES Doxygen generates more compact" >> Doxyfile
	echo "# RTF documents. This may be useful for small projects and may help to" >> Doxyfile
	echo "# save some trees in general." >> Doxyfile
	echo "" >> Doxyfile
	echo "COMPACT_RTF            = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the RTF_HYPERLINKS tag is set to YES, the RTF that is generated" >> Doxyfile
	echo "# will contain hyperlink fields. The RTF file will" >> Doxyfile
	echo "# contain links (just like the HTML output) instead of page references." >> Doxyfile
	echo "# This makes the output suitable for online browsing using WORD or other" >> Doxyfile
	echo "# programs which support those fields." >> Doxyfile
	echo "# Note: wordpad (write) and others do not support links." >> Doxyfile
	echo "" >> Doxyfile
	echo "RTF_HYPERLINKS         = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Load stylesheet definitions from file. Syntax is similar to doxygen\'s" >> Doxyfile
	echo "# config file, i.e. a series of assignments. You only have to provide" >> Doxyfile
	echo "# replacements, missing definitions are set to their default value." >> Doxyfile
	echo "" >> Doxyfile
	echo "RTF_STYLESHEET_FILE    =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set optional variables used in the generation of an rtf document." >> Doxyfile
	echo "# Syntax is similar to doxygen\'s config file." >> Doxyfile
	echo "" >> Doxyfile
	echo "RTF_EXTENSIONS_FILE    =" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the man page output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_MAN tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# generate man pages" >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_MAN           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MAN_OUTPUT tag is used to specify where the man pages will be put." >> Doxyfile
	echo "# If a relative path is entered the value of OUTPUT_DIRECTORY will be" >> Doxyfile
	echo "# put in front of it. If left blank \'man\' will be used as the default path." >> Doxyfile
	echo "" >> Doxyfile
	echo "MAN_OUTPUT             = man" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MAN_EXTENSION tag determines the extension that is added to" >> Doxyfile
	echo "# the generated man pages (default is the subroutine\'s section .3)" >> Doxyfile
	echo "" >> Doxyfile
	echo "MAN_EXTENSION          = .3" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the MAN_LINKS tag is set to YES and Doxygen generates man output," >> Doxyfile
	echo "# then it will generate one additional man file for each entity" >> Doxyfile
	echo "# documented in the real man page(s). These additional files" >> Doxyfile
	echo "# only source the real man page, but without them the man command" >> Doxyfile
	echo "# would be unable to find the correct page. The default is NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "MAN_LINKS              = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the XML output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_XML tag is set to YES Doxygen will" >> Doxyfile
	echo "# generate an XML file that captures the structure of" >> Doxyfile
	echo "# the code including all documentation." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_XML           = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The XML_OUTPUT tag is used to specify where the XML pages will be put." >> Doxyfile
	echo "# If a relative path is entered the value of OUTPUT_DIRECTORY will be" >> Doxyfile
	echo "# put in front of it. If left blank \'xml\' will be used as the default path." >> Doxyfile
	echo "" >> Doxyfile
	echo "XML_OUTPUT             = xml" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The XML_SCHEMA tag can be used to specify an XML schema," >> Doxyfile
	echo "# which can be used by a validating XML parser to check the" >> Doxyfile
	echo "# syntax of the XML files." >> Doxyfile
	echo "" >> Doxyfile
	echo "XML_SCHEMA             =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The XML_DTD tag can be used to specify an XML DTD," >> Doxyfile
	echo "# which can be used by a validating XML parser to check the" >> Doxyfile
	echo "# syntax of the XML files." >> Doxyfile
	echo "" >> Doxyfile
	echo "XML_DTD                =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the XML_PROGRAMLISTING tag is set to YES Doxygen will" >> Doxyfile
	echo "# dump the program listings (including syntax highlighting" >> Doxyfile
	echo "# and cross-referencing information) to the XML output. Note that" >> Doxyfile
	echo "# enabling this will significantly increase the size of the XML output." >> Doxyfile
	echo "" >> Doxyfile
	echo "XML_PROGRAMLISTING     = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options for the AutoGen Definitions output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_AUTOGEN_DEF tag is set to YES Doxygen will" >> Doxyfile
	echo "# generate an AutoGen Definitions (see autogen.sf.net) file" >> Doxyfile
	echo "# that captures the structure of the code including all" >> Doxyfile
	echo "# documentation. Note that this feature is still experimental" >> Doxyfile
	echo "# and incomplete at the moment." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_AUTOGEN_DEF   = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# configuration options related to the Perl module output" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_PERLMOD tag is set to YES Doxygen will" >> Doxyfile
	echo "# generate a Perl module file that captures the structure of" >> Doxyfile
	echo "# the code including all documentation. Note that this" >> Doxyfile
	echo "# feature is still experimental and incomplete at the" >> Doxyfile
	echo "# moment." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_PERLMOD       = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the PERLMOD_LATEX tag is set to YES Doxygen will generate" >> Doxyfile
	echo "# the necessary Makefile rules, Perl scripts and LaTeX code to be able" >> Doxyfile
	echo "# to generate PDF and DVI output from the Perl module output." >> Doxyfile
	echo "" >> Doxyfile
	echo "PERLMOD_LATEX          = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the PERLMOD_PRETTY tag is set to YES the Perl module output will be" >> Doxyfile
	echo "# nicely formatted so it can be parsed by a human reader." >> Doxyfile
	echo "# This is useful" >> Doxyfile
	echo "# if you want to understand what is going on." >> Doxyfile
	echo "# On the other hand, if this" >> Doxyfile
	echo "# tag is set to NO the size of the Perl module output will be much smaller" >> Doxyfile
	echo "# and Perl will parse it just the same." >> Doxyfile
	echo "" >> Doxyfile
	echo "PERLMOD_PRETTY         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The names of the make variables in the generated doxyrules.make file" >> Doxyfile
	echo "# are prefixed with the string contained in PERLMOD_MAKEVAR_PREFIX." >> Doxyfile
	echo "# This is useful so different doxyrules.make files included by the same" >> Doxyfile
	echo "# Makefile don\'t overwrite each other\'s variables." >> Doxyfile
	echo "" >> Doxyfile
	echo "PERLMOD_MAKEVAR_PREFIX =" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# Configuration options related to the preprocessor" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ENABLE_PREPROCESSING tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# evaluate all C-preprocessor directives found in the sources and include" >> Doxyfile
	echo "# files." >> Doxyfile
	echo "" >> Doxyfile
	echo "ENABLE_PREPROCESSING   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the MACRO_EXPANSION tag is set to YES Doxygen will expand all macro" >> Doxyfile
	echo "# names in the source code. If set to NO (the default) only conditional" >> Doxyfile
	echo "# compilation will be performed. Macro expansion can be done in a controlled" >> Doxyfile
	echo "# way by setting EXPAND_ONLY_PREDEF to YES." >> Doxyfile
	echo "" >> Doxyfile
	echo "MACRO_EXPANSION        = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXPAND_ONLY_PREDEF and MACRO_EXPANSION tags are both set to YES" >> Doxyfile
	echo "# then the macro expansion is limited to the macros specified with the" >> Doxyfile
	echo "# PREDEFINED and EXPAND_AS_DEFINED tags." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXPAND_ONLY_PREDEF     = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SEARCH_INCLUDES tag is set to YES (the default) the includes files" >> Doxyfile
	echo "# in the INCLUDE_PATH (see below) will be search if a #include is found." >> Doxyfile
	echo "" >> Doxyfile
	echo "SEARCH_INCLUDES        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The INCLUDE_PATH tag can be used to specify one or more directories that" >> Doxyfile
	echo "# contain include files that are not input files but should be processed by" >> Doxyfile
	echo "# the preprocessor." >> Doxyfile
	echo "" >> Doxyfile
	echo "INCLUDE_PATH           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# You can use the INCLUDE_FILE_PATTERNS tag to specify one or more wildcard" >> Doxyfile
	echo "# patterns (like *.h and *.hpp) to filter out the header-files in the" >> Doxyfile
	echo "# directories. If left blank, the patterns specified with FILE_PATTERNS will" >> Doxyfile
	echo "# be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "INCLUDE_FILE_PATTERNS  =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The PREDEFINED tag can be used to specify one or more macro names that" >> Doxyfile
	echo "# are defined before the preprocessor is started (similar to the -D option of" >> Doxyfile
	echo "# gcc). The argument of the tag is a list of macros of the form: name" >> Doxyfile
	echo "# or name=definition (no spaces). If the definition and the = are" >> Doxyfile
	echo "# omitted =1 is assumed. To prevent a macro definition from being" >> Doxyfile
	echo "# undefined via #undef or recursively expanded use the := operator" >> Doxyfile
	echo "# instead of the = operator." >> Doxyfile
	echo "" >> Doxyfile
	echo "PREDEFINED             =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the MACRO_EXPANSION and EXPAND_ONLY_PREDEF tags are set to YES then" >> Doxyfile
	echo "# this tag can be used to specify a list of macro names that should be expanded." >> Doxyfile
	echo "# The macro definition that is found in the sources will be used." >> Doxyfile
	echo "# Use the PREDEFINED tag if you want to use a different macro definition that overrules the definition found in the source code." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXPAND_AS_DEFINED      =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the SKIP_FUNCTION_MACROS tag is set to YES (the default) then" >> Doxyfile
	echo "# doxygen\'s preprocessor will remove all references to function-like macros" >> Doxyfile
	echo "# that are alone on a line, have an all uppercase name, and do not end with a" >> Doxyfile
	echo "# semicolon, because these will confuse the parser if not removed." >> Doxyfile
	echo "" >> Doxyfile
	echo "SKIP_FUNCTION_MACROS   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# Configuration::additions related to external references" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The TAGFILES option can be used to specify one or more tagfiles." >> Doxyfile
	echo "# Optionally an initial location of the external documentation" >> Doxyfile
	echo "# can be added for each tagfile. The format of a tag file without" >> Doxyfile
	echo "# this location is as follows:" >> Doxyfile
	echo "#" >> Doxyfile
	echo "# TAGFILES = file1 file2 ..." >> Doxyfile
	echo "# Adding location for the tag files is done as follows:" >> Doxyfile
	echo "#" >> Doxyfile
	echo "# TAGFILES = file1=loc1 \"file2 = loc2\" ..." >> Doxyfile
	echo "# where \"loc1\" and \"loc2\" can be relative or absolute paths or" >> Doxyfile
	echo "# URLs. If a location is present for each tag, the installdox tool" >> Doxyfile
	echo "# does not have to be run to correct the links." >> Doxyfile
	echo "# Note that each tag file must have a unique name" >> Doxyfile
	echo "# (where the name does NOT include the path)" >> Doxyfile
	echo "# If a tag file is not located in the directory in which doxygen" >> Doxyfile
	echo "# is run, you must also specify the path to the tagfile here." >> Doxyfile
	echo "" >> Doxyfile
	echo "TAGFILES               =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# When a file name is specified after GENERATE_TAGFILE, doxygen will create" >> Doxyfile
	echo "# a tag file that is based on the input files it reads." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_TAGFILE       =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ALLEXTERNALS tag is set to YES all external classes will be listed" >> Doxyfile
	echo "# in the class index. If set to NO only the inherited external classes" >> Doxyfile
	echo "# will be listed." >> Doxyfile
	echo "" >> Doxyfile
	echo "ALLEXTERNALS           = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the EXTERNAL_GROUPS tag is set to YES all external groups will be listed" >> Doxyfile
	echo "# in the modules index. If set to NO, only the current project\'s groups will" >> Doxyfile
	echo "# be listed." >> Doxyfile
	echo "" >> Doxyfile
	echo "EXTERNAL_GROUPS        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The PERL_PATH should be the absolute path and name of the perl script" >> Doxyfile
	echo "# interpreter (i.e. the result of \'which perl\')." >> Doxyfile
	echo "" >> Doxyfile
	echo "PERL_PATH              = /usr/bin/perl" >> Doxyfile
	echo "" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "# Configuration options related to the dot tool" >> Doxyfile
	echo "#---------------------------------------------------------------------------" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CLASS_DIAGRAMS tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# generate a inheritance diagram (in HTML, RTF and LaTeX) for classes with base" >> Doxyfile
	echo "# or super classes. Setting the tag to NO turns the diagrams off. Note that" >> Doxyfile
	echo "# this option also works with HAVE_DOT disabled, but it is recommended to" >> Doxyfile
	echo "# install and use dot, since it yields more powerful graphs." >> Doxyfile
	echo "" >> Doxyfile
	echo "CLASS_DIAGRAMS         = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# You can define message sequence charts within doxygen comments using the \\msc" >> Doxyfile
	echo "# command. Doxygen will then run the mscgen tool (see" >> Doxyfile
	echo "# http://www.mcternan.me.uk/mscgen/) to produce the chart and insert it in the" >> Doxyfile
	echo "# documentation. The MSCGEN_PATH tag allows you to specify the directory where" >> Doxyfile
	echo "# the mscgen tool resides. If left empty the tool is assumed to be found in the" >> Doxyfile
	echo "# default search path." >> Doxyfile
	echo "" >> Doxyfile
	echo "MSCGEN_PATH            =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If set to YES, the inheritance and collaboration graphs will hide" >> Doxyfile
	echo "# inheritance and usage relations if the target is undocumented" >> Doxyfile
	echo "# or is not a class." >> Doxyfile
	echo "" >> Doxyfile
	echo "HIDE_UNDOC_RELATIONS   = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If you set the HAVE_DOT tag to YES then doxygen will assume the dot tool is" >> Doxyfile
	echo "# available from the path. This tool is part of Graphviz, a graph visualization" >> Doxyfile
	echo "# toolkit from AT&T and Lucent Bell Labs. The other options in this section" >> Doxyfile
	echo "# have no effect if this option is set to NO (the default)" >> Doxyfile
	echo "" >> Doxyfile
	echo "HAVE_DOT               = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DOT_NUM_THREADS specifies the number of dot invocations doxygen is" >> Doxyfile
	echo "# allowed to run in parallel. When set to 0 (the default) doxygen will" >> Doxyfile
	echo "# base this on the number of processors available in the system. You can set it" >> Doxyfile
	echo "# explicitly to a value larger than 0 to get control over the balance" >> Doxyfile
	echo "# between CPU load and processing speed." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_NUM_THREADS        = 16" >> Doxyfile
	echo "" >> Doxyfile
	echo "# By default doxygen will write a font called Helvetica to the output" >> Doxyfile
	echo "# directory and reference it in all dot files that doxygen generates." >> Doxyfile
	echo "# When you want a differently looking font you can specify the font name" >> Doxyfile
	echo "# using DOT_FONTNAME. You need to make sure dot is able to find the font," >> Doxyfile
	echo "# which can be done by putting it in a standard location or by setting the" >> Doxyfile
	echo "# DOTFONTPATH environment variable or by setting DOT_FONTPATH to the directory" >> Doxyfile
	echo "# containing the font." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_FONTNAME           = Helvetica" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DOT_FONTSIZE tag can be used to set the size of the font of dot graphs." >> Doxyfile
	echo "# The default size is 10pt." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_FONTSIZE           = 10" >> Doxyfile
	echo "" >> Doxyfile
	echo "# By default doxygen will tell dot to use the output directory to look for the" >> Doxyfile
	echo "# FreeSans.ttf font (which doxygen will put there itself). If you specify a" >> Doxyfile
	echo "# different font using DOT_FONTNAME you can set the path where dot" >> Doxyfile
	echo "# can find it using this tag." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_FONTPATH           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CLASS_GRAPH and HAVE_DOT tags are set to YES then doxygen" >> Doxyfile
	echo "# will generate a graph for each documented class showing the direct and" >> Doxyfile
	echo "# indirect inheritance relations. Setting this tag to YES will force the" >> Doxyfile
	echo "# the CLASS_DIAGRAMS tag to NO." >> Doxyfile
	echo "" >> Doxyfile
	echo "CLASS_GRAPH            = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the COLLABORATION_GRAPH and HAVE_DOT tags are set to YES then doxygen" >> Doxyfile
	echo "# will generate a graph for each documented class showing the direct and" >> Doxyfile
	echo "# indirect implementation dependencies (inheritance, containment, and" >> Doxyfile
	echo "# class references variables) of the class with other documented classes." >> Doxyfile
	echo "" >> Doxyfile
	echo "COLLABORATION_GRAPH    = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GROUP_GRAPHS and HAVE_DOT tags are set to YES then doxygen" >> Doxyfile
	echo "# will generate a graph for groups, showing the direct groups dependencies" >> Doxyfile
	echo "" >> Doxyfile
	echo "GROUP_GRAPHS           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the UML_LOOK tag is set to YES doxygen will generate inheritance and" >> Doxyfile
	echo "# collaboration diagrams in a style similar to the OMG\'s Unified Modeling" >> Doxyfile
	echo "# Language." >> Doxyfile
	echo "" >> Doxyfile
	echo "UML_LOOK               = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If set to YES, the inheritance and collaboration graphs will show the" >> Doxyfile
	echo "# relations between templates and their instances." >> Doxyfile
	echo "" >> Doxyfile
	echo "TEMPLATE_RELATIONS     = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ENABLE_PREPROCESSING, SEARCH_INCLUDES, INCLUDE_GRAPH, and HAVE_DOT" >> Doxyfile
	echo "# tags are set to YES then doxygen will generate a graph for each documented" >> Doxyfile
	echo "# file showing the direct and indirect include dependencies of the file with" >> Doxyfile
	echo "# other documented files." >> Doxyfile
	echo "" >> Doxyfile
	echo "INCLUDE_GRAPH          = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the ENABLE_PREPROCESSING, SEARCH_INCLUDES, INCLUDED_BY_GRAPH, and" >> Doxyfile
	echo "# HAVE_DOT tags are set to YES then doxygen will generate a graph for each" >> Doxyfile
	echo "# documented header file showing the documented files that directly or" >> Doxyfile
	echo "# indirectly include this file." >> Doxyfile
	echo "" >> Doxyfile
	echo "INCLUDED_BY_GRAPH      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CALL_GRAPH and HAVE_DOT options are set to YES then" >> Doxyfile
	echo "# doxygen will generate a call dependency graph for every global function" >> Doxyfile
	echo "# or class method. Note that enabling this option will significantly increase" >> Doxyfile
	echo "# the time of a run. So in most cases it will be better to enable call graphs" >> Doxyfile
	echo "# for selected functions only using the \\callgraph command." >> Doxyfile
	echo "" >> Doxyfile
	echo "CALL_GRAPH             = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the CALLER_GRAPH and HAVE_DOT tags are set to YES then" >> Doxyfile
	echo "# doxygen will generate a caller dependency graph for every global function" >> Doxyfile
	echo "# or class method. Note that enabling this option will significantly increase" >> Doxyfile
	echo "# the time of a run. So in most cases it will be better to enable caller" >> Doxyfile
	echo "# graphs for selected functions only using the \\callergraph command." >> Doxyfile
	echo "" >> Doxyfile
	echo "CALLER_GRAPH           = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GRAPHICAL_HIERARCHY and HAVE_DOT tags are set to YES then doxygen" >> Doxyfile
	echo "# will generate a graphical hierarchy of all classes instead of a textual one." >> Doxyfile
	echo "" >> Doxyfile
	echo "GRAPHICAL_HIERARCHY    = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the DIRECTORY_GRAPH, SHOW_DIRECTORIES and HAVE_DOT tags are set to YES" >> Doxyfile
	echo "# then doxygen will show the dependencies a directory has on other directories" >> Doxyfile
	echo "# in a graphical way. The dependency relations are determined by the #include" >> Doxyfile
	echo "# relations between the files in the directories." >> Doxyfile
	echo "" >> Doxyfile
	echo "DIRECTORY_GRAPH        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DOT_IMAGE_FORMAT tag can be used to set the image format of the images" >> Doxyfile
	echo "# generated by dot. Possible values are png, svg, gif or svg." >> Doxyfile
	echo "# If left blank png will be used." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_IMAGE_FORMAT       = png" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The tag DOT_PATH can be used to specify the path where the dot tool can be" >> Doxyfile
	echo "# found. If left blank, it is assumed the dot tool can be found in the path." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_PATH               =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DOTFILE_DIRS tag can be used to specify one or more directories that" >> Doxyfile
	echo "# contain dot files that are included in the documentation (see the" >> Doxyfile
	echo "# \\dotfile command)." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOTFILE_DIRS           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MSCFILE_DIRS tag can be used to specify one or more directories that" >> Doxyfile
	echo "# contain msc files that are included in the documentation (see the" >> Doxyfile
	echo "# \\mscfile command)." >> Doxyfile
	echo "" >> Doxyfile
	echo "MSCFILE_DIRS           =" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The DOT_GRAPH_MAX_NODES tag can be used to set the maximum number of" >> Doxyfile
	echo "# nodes that will be shown in the graph. If the number of nodes in a graph" >> Doxyfile
	echo "# becomes larger than this value, doxygen will truncate the graph, which is" >> Doxyfile
	echo "# visualized by representing a node as a red box. Note that doxygen if the" >> Doxyfile
	echo "# number of direct children of the root node in a graph is already larger than" >> Doxyfile
	echo "# DOT_GRAPH_MAX_NODES then the graph will not be shown at all. Also note" >> Doxyfile
	echo "# that the size of a graph can be further restricted by MAX_DOT_GRAPH_DEPTH." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_GRAPH_MAX_NODES    = 50" >> Doxyfile
	echo "" >> Doxyfile
	echo "# The MAX_DOT_GRAPH_DEPTH tag can be used to set the maximum depth of the" >> Doxyfile
	echo "# graphs generated by dot. A depth value of 3 means that only nodes reachable" >> Doxyfile
	echo "# from the root by following a path via at most 3 edges will be shown. Nodes" >> Doxyfile
	echo "# that lay further from the root node will be omitted. Note that setting this" >> Doxyfile
	echo "# option to 1 or 2 may greatly reduce the computation time needed for large" >> Doxyfile
	echo "# code bases. Also note that the size of a graph can be further restricted by" >> Doxyfile
	echo "# DOT_GRAPH_MAX_NODES. Using a depth of 0 means no depth restriction." >> Doxyfile
	echo "" >> Doxyfile
	echo "MAX_DOT_GRAPH_DEPTH    = 0" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the DOT_TRANSPARENT tag to YES to generate images with a transparent" >> Doxyfile
	echo "# background. This is disabled by default, because dot on Windows does not" >> Doxyfile
	echo "# seem to support this out of the box. Warning: Depending on the platform used," >> Doxyfile
	echo "# enabling this option may lead to badly anti-aliased labels on the edges of" >> Doxyfile
	echo "# a graph (i.e. they become hard to read)." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_TRANSPARENT        = NO" >> Doxyfile
	echo "" >> Doxyfile
	echo "# Set the DOT_MULTI_TARGETS tag to YES allow dot to generate multiple output" >> Doxyfile
	echo "# files in one run (i.e. multiple -o and -T options on the command line). This" >> Doxyfile
	echo "# makes dot run faster, but since only newer versions of dot (>1.8.10)" >> Doxyfile
	echo "# support this, this feature is disabled by default." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_MULTI_TARGETS      = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the GENERATE_LEGEND tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# generate a legend page explaining the meaning of the various boxes and" >> Doxyfile
	echo "# arrows in the dot generated graphs." >> Doxyfile
	echo "" >> Doxyfile
	echo "GENERATE_LEGEND        = YES" >> Doxyfile
	echo "" >> Doxyfile
	echo "# If the DOT_CLEANUP tag is set to YES (the default) Doxygen will" >> Doxyfile
	echo "# remove the intermediate dot files that are used to generate" >> Doxyfile
	echo "# the various graphs." >> Doxyfile
	echo "" >> Doxyfile
	echo "DOT_CLEANUP            = YES" >> Doxyfile
	echo "created Doxyfile"
fi

git init
git config user.name "${DEVELOPER}"
git config user.email ${CONTACT}
git config core.editor vim
git config merge.tool vimdiff
git add .gitignore
git add README.md
git add LICENSE.txt
git add COPYRIGHT.txt
git add INSTALL.md
git add Makefile
git add Doxyfile
git add src/${NAME}.${SOURCEFILEEXTENSION}
git add include/version.${HEADERFILEEXTENSION}
git add mainpage
git add *.png
git add *.jpg
git add *.gif
git add script/v.py
git commit -am "initial commit"
git tag -a v0.0.0 -m "setup"
echo "created tags:"
git tag
git config core.editor vim
git config merge.tool vimdiff
git branch release
git branch development
git branch topic
git branch experimental
echo "created branches:"
git branch
git checkout topic

mkdir -pv ./.trac
echo -e "${NAME}\n\n" | trac-admin ./.trac initenv
trac-admin ./.trac permission add admin TRAC_ADMIN
trac-admin ./.trac permission add anonymous admin
trac-admin ./.trac ticket_type remove defect
trac-admin ./.trac ticket_type remove enhancement
trac-admin ./.trac ticket_type add bug
trac-admin ./.trac ticket_type add featurerequest
trac-admin ./.trac ticket_type add meeting
trac-admin ./.trac component add ui somebody
trac-admin ./.trac component add core somebody
trac-admin ./.trac component remove component1
trac-admin ./.trac component remove component2
trac-admin ./.trac permission add developer anonymous
trac-admin ./.trac permission add developer authenticated
trac-admin ./.trac permission add developer EMAIL_VIEW
trac-admin ./.trac permission add manager developer
trac-admin ./.trac permission add manager MILESTONE_ADMIN
trac-admin ./.trac permission add manager ROADMAP_ADMIN
trac-admin ./.trac version remove 2.0
trac-admin ./.trac version remove 1.0
trac-admin ./.trac version add 0.0.0
echo -e "[components]\ntracopt.versioncontrol.git.* = enabled\ntracext.git.* = enabled\n" >> ./.trac/conf/trac.ini
echo -e "[git]\ncached_repository = true\npersistent_cache = true\nshortrev_len = 6\ngit_bin = /usr/bin/git\n" >> ./.trac/conf/trac.ini
trac-admin ./.trac repository add ${NAME} ./.git git
trac-admin ./.trac config set header_logo width 100
trac-admin ./.trac config set header_logo height 100
trac-admin ./.trac config set header_logo alt Logo
trac-admin ./.trac config set header_logo src site/tux.gif
cp /etc/gp/images/tux.gif ./.trac/htdocs/
