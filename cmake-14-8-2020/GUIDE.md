How to add a new library to the CMake build system for Macaulay2
================================================================

- Read the CMake manual on ExternalProject
- Insert the scaffolding for ExternalProject_Add in `cmake/build-libraries.cmake`
  - here is a basic template, prepared:
```
# http://perso.ens-lyon.fr/nathalie.revol/software.html
ExternalProject_Add(build-mpfi
  URL               <archive download address>
  URL_HASH          SHA256=<sha256sum of the archive>
  PREFIX            libraries/mpfi
  SOURCE_DIR        libraries/mpfi/build
  DOWNLOAD_DIR      ${CMAKE_SOURCE_DIR}/BUILD/tarfiles
  BUILD_IN_SOURCE   ON
  CONFIGURE_COMMAND autoreconf -vif
            COMMAND ${CONFIGURE} --prefix=${M2_HOST_PREFIX}
  BUILD_COMMAND     ${MAKE} -j${PARALLEL_JOBS} all
  INSTALL_COMMAND   ${MAKE} -j${PARALLEL_JOBS} install
  EXCLUDE_FROM_ALL  ON
  STEP_TARGETS      install
  )
_ADD_COMPONENT_DEPENDENCY(libraries mpfi "" MPFI_FOUND)
```
  - you can also use the MPFR instructions as a template
    - this is probably better, since both of them use autotools and require GMP
	- if the library uses CMake, you could use Flint as template
  - add the scaffolding after the section for the last dependency, so after MPFR
  - first, set the download information; there are two options:
    - via compressed archive + checksum hash (this is the one available for MPFI)
    - via git repository (this one is better for submodule libraries)
  - in a build directory, run `ninja build-mpfi`
    just so the library is downloaded and extracte

- Read the build manual for the library
  - try `./configure --help`
  - look for environmental variables used (`CC, CFLAGS, CPPFLAGS, LDFLAGS`, etc.)
  - look for dependencies and how they are located (`--with-gmp=...`, etc.)
  - look for static/shared library flags 
  - try `make <TAB> <TAB>` to see all targets (only works with bash completion)
  - build the library directly as practice

- Insert the configure commands
  - you may need to add `autoreconf -vif` as the first command
    this command translates `configure.ac` to `configure`
  - use `${CONFIGURE}` instead of `./configure`
  - add the necessary configure flags
    - specify the build prefix (`--prefix=${M2_HOST_PREFIX}`)
    - static vs shared library (search for `${shared_setting}`)
    - don't enable assertions (search for `${assertions_setting}`)
    - don't build documentation (I don't think this applies here)
    - set the environmental variables
- Insert the build commands
  - use `${MAKE} -j${PARALLEL_JOBS}` instead of `make -j`
  - consider only building in certain subdirectories, e.g. with `-C src`
- Insert the install commands
  - consider using target `install-strip` if available
- Insert the `_ADD_COMPONENT_DEPENDENCY` line
  This line tells CMake the dependencies among the libraries Macaulay2 builds

- TEST TEST TEST
  - try `ninja build-mpfi -v`
  - try `ninja build-mpfi-test`
  - try in a docker environment

- Open `cmake/check-libraries.cmake`
  - add the library to `LIBRARIES_LIST` if it must be linked with M2-binary
    - the order is important: dependencies should come later in the list
  - add the library to `LIBRARY_OPTIONS` (even if it need not be linked with M2-binary)
- Add a "find_package" module `cmake/FindMPFI.cmake`
  - preferably use an existing module as template, here is a basic one:
```
find_path(MPFI_INCLUDE_DIR NAMES mpfi.h
  PATHS ${INCLUDE_INSTALL_DIR} ${CMAKE_INSTALL_PREFIX}/include)

find_library(MPFI_LIBRARIES NAMES mpfi
  PATHS ${LIB_INSTALL_DIR} ${CMAKE_INSTALL_PREFIX}/lib)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MPFI DEFAULT_MSG MPFI_INCLUDE_DIR MPFI_LIBRARIES)

mark_as_advanced(MPFI_INCLUDE_DIR MPFI_LIBRARIES)
```
  - this defines two important standard variables that will be used by CMake:
    -  `MPFI_INCLUDE_DIR`     - the MPFI include directory
    -  `MPFI_LIBRARIES`       - the MPFI library
  - add `find_package(MPFI)` to `cmake/check-libraries.cmake`
  - test that when the library is already installed, it is correctly found by cmake

- Debugging issues:
  - look under `BUILD/build/libraries/<library name>/build`
  - read `configure.ac`, if it exists
  - read `Makefile.am`, if it exists
  - look for Makefiles under subdirectories
  - look for errors in `config.log`
  - if linking conflicts are detected,
    try `cmake --debug-trycompile` and `ninja build-...` and
    look under `BUILD/build/CMakeFiles/CMakeTmp` or `CMakeError.log`

## Exercises

- Open `cmake/build-libraries.cmake`
  - Add the following under the configure commands for MPFI:
```
                      --with-gmp=${MP_ROOT}
                      --with-mpfr=${MPFR_ROOT}
```
  - look in `cmake/FindCDDLIB.cmake` to see where `CDDLIB_ROOT` is defined
  - add `MPFR_ROOT` to `cmake/FindMPFR.cmake`
- Install license information for MPFI:
  - add instructions to make a subdirectory `${M2_INSTALL_LICENSESDIR}/mpfi`
  - find the relevant license files
  - add instructions to copy the license files
- Add `build-mpfi-test` target
  - see `TEST_COMMAND` for MPFR as an example
- Open `Macaulay2/d/version.dd`
  - look around at how various library versions are embedded with M2-binary
  - add `"mpfi version"`, which should be set to `MPFI_VERSION_STRING`
  - you also need to include `mpfi.h` in an appropriate place
  - test that this works by running `ninja M2-binary` and testing `version#"mpfr version"`
- Open `Macaulay2/m2/startup.m2.in`
  - add entry for MPFI version to the `copyright` variable
  - test that this works by running `M2 --copyright`
- Open `INSTALL`
  - add information about installing MPFI on various linux distributions
- Open `INSTALL-CMake.md`
  - add entry for `build-mpfi` under "Targets for Building Libraries and Programs"
- Open `Macaulay2/packages/Macaulay2Doc/overview3.m2`
  - add documentation node for "MPFI"
  - add link to "MPFI" to the "Copyright and license" node
- Open `Macaulay2/packages/Macaulay2Doc/changes.m2`
  - mention under the "changes made for the next release" node that MPFI is added
- Open `Macaulay2/packages/Licenses.m2`
  - add information about MPFI license

Optional:
- Add version checking to `FindMPFI.cmake`
- Add Arb: http://arblib.org/setup.html#download

How to add a new program to the CMake build system for Macaulay2
================================================================

Few distinctions:
- add the scaffolding near the other programs in `build-libraries.cmake`
- no need to install, only copy the executable under `${M2_INSTALL_PROGRAMSDIR}`
- add something like `find_program(NORMALIZ	NAMES	normaliz)` to `check-libraries.cmake`
- add the program to `PROGRAM_OPTIONS`

## Exercises

Optional:
- There are three `ExternalProject_Add` instructions at the end of
  `build-libraries.cmake` for programs that Macaulay2 *can* use, but
  we don't build them. Try to build them, and if you run into any issues,
  try to debug the issue.
  - Polymake
  - PHCpack
  - Bertini
