This script is made to make it comfortable to create new projects.
It is designed for one man offline usage.
It fits for c and c++ projects.
Feel free to edit and share it.

FOLDERSTRUCTURE:
All your source files shall be stored in src.
All your header files shall be stored in include.
Generated .o files will be stored in obj.
Generated executable files will be stored in bin.
All your libraries you use shall be stored in extlib.
Generated libraries will be stored in lib.
Generated documentation will appear in doc.
Check what "make clean" does before executing it! It deletes generated folders!!! Do not store data in generated folders!!!

GIT:
The script generates four branches:
release
development
topic
experimental
The working branch shall be topic. If a feature is working you can merge it into the development branch by make minor. If your project has a few new feature and is ready to use and also tested you can merge the changes into the release branch by make major. Experimental shall be used if you implement new features that you might nor want to include in the project. It is just for testing. After each successfull build of your project the script commits automatically all changes and taggs it. If you want you are free to commit on your own between builds with make commit. The master branch is unused by the script. make sure you only work in the topic branch. Otherwise there could happen things that are not wanted! This shall guarantee that you have everytime a working version of your project. And if that is not the case you have the possibillity to make a (temporarry) roleback to any successful build you want.
You can add push/pull mechanics to make the makefile multyuser-friendly. It is strongly unrecommended to manually switch branches and work on other branches than on topic-branch. experimental-branch have to be merged on your own and is itself still experimental...

DOXYGEN:
Comment your code in doxygen conform style. If you do so make doc generates automatically the whole documentation in html documents and a few more formats. This makes it a lot easier to read the documentation. Doxygen is similar to javadoc. http://www.stack.nl/~dimitri/doxygen/manual/commands.html

MAKE:
The Makefile provides a lot options to automatically do things you might want to do. So instead of compiling all files on your own and link them together a single make all does the whole stuff for you.

TRAC:
The script also uses a lightweight projectmanagement/bugtracking system with a web frontend that is based on a sqlite db.

The script uses content from:
http://opensource.org
http://creativecommons.org
http://www.gnu.org
http://www.isc.tamu.edu/~lewing/linux/sit3-shine.7.gif
http://www.doxygen.org