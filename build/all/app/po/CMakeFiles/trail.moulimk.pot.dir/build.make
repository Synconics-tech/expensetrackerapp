# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/cmake/bin/cmake

# The command to remove a file.
RM = /opt/cmake/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/vboxuser/Desktop/trail

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/vboxuser/Desktop/trail/build/all/app

# Utility rule file for trail.moulimk.pot.

# Include any custom commands dependencies for this target.
include po/CMakeFiles/trail.moulimk.pot.dir/compiler_depend.make

# Include the progress variables for this target.
include po/CMakeFiles/trail.moulimk.pot.dir/progress.make

po/CMakeFiles/trail.moulimk.pot:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/vboxuser/Desktop/trail/build/all/app/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating translation template"
	cd /home/vboxuser/Desktop/trail/build/all/app/po && /usr/bin/intltool-extract --update --type=gettext/ini --srcdir=/home/vboxuser/Desktop/trail trail.desktop.in
	cd /home/vboxuser/Desktop/trail/build/all/app/po && /usr/bin/xgettext -o trail.moulimk.pot -D /home/vboxuser/Desktop/trail/po -D /home/vboxuser/Desktop/trail/build/all/app/po --from-code=UTF-8 --c++ --qt --language=javascript --add-comments=TRANSLATORS --keyword=tr --keyword=tr:1,2 --keyword=ctr:1c,2 --keyword=dctr:2c,3 --keyword=N_ --keyword=_ --keyword=dtr:2 --keyword=dtr:2,3 --keyword=tag --keyword=tag:1c,2 --package-name='trail.moulimk' --sort-by-file ../qml/ItemTablePage.qml ../qml/Main.qml trail.desktop.in.h
	cd /home/vboxuser/Desktop/trail/build/all/app/po && /opt/cmake/bin/cmake -E copy trail.moulimk.pot /home/vboxuser/Desktop/trail/po

trail.moulimk.pot: po/CMakeFiles/trail.moulimk.pot
trail.moulimk.pot: po/CMakeFiles/trail.moulimk.pot.dir/build.make
.PHONY : trail.moulimk.pot

# Rule to build all files generated by this target.
po/CMakeFiles/trail.moulimk.pot.dir/build: trail.moulimk.pot
.PHONY : po/CMakeFiles/trail.moulimk.pot.dir/build

po/CMakeFiles/trail.moulimk.pot.dir/clean:
	cd /home/vboxuser/Desktop/trail/build/all/app/po && $(CMAKE_COMMAND) -P CMakeFiles/trail.moulimk.pot.dir/cmake_clean.cmake
.PHONY : po/CMakeFiles/trail.moulimk.pot.dir/clean

po/CMakeFiles/trail.moulimk.pot.dir/depend:
	cd /home/vboxuser/Desktop/trail/build/all/app && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/vboxuser/Desktop/trail /home/vboxuser/Desktop/trail/po /home/vboxuser/Desktop/trail/build/all/app /home/vboxuser/Desktop/trail/build/all/app/po /home/vboxuser/Desktop/trail/build/all/app/po/CMakeFiles/trail.moulimk.pot.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : po/CMakeFiles/trail.moulimk.pot.dir/depend

