# ------------------------------------------------------------------------ *\
# mk/cmake/fetchcontent_provider_declare.cmake
# This file is part of RetroShare.
#
# Copyright (C) 2026      David Bears <dbear4q@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------ */

cmake_minimum_required(VERSION 3.24...4.4)

list(APPEND CMAKE_MODULE_PATH
	"${PROJECT_SOURCE_DIR}/mk/cmake/fetch_provider_packages"
)
set(FETCHCONTENT_QUIET OFF)
include(FetchContent)
include(ExternalProject)

if(CMAKE_VERSION VERSION_GREATER_EQUAL 4.2)
	function(EnvironmentModification)
	endfunction()
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL 3.25)
	function(EnvironmentModification outvar)
		list(TRANSFORM ARGN PREPEND --modify\;)
		set(${outvar} ${CMAKE_COMMAND} -E env ${ARGN} -- PARENT_SCOPE)
	endfunction(EnvironmentModification)
else()
	function(EnvironmentModification outvar)
		list(TRANSFORM ARGN REPLACE "^([^=]+)=set:(.*)\$" "\\1=\\2")
		list(TRANSFORM ARGN REPLACE "^([^=]+)=unset:(.*)\$" "--unset=\\1")
		set(${outvar} ${CMAKE_COMMAND} -E env ${ARGN} -- PARENT_SCOPE)
	endfunction(EnvironmentModification)
endif()

################################################################################
### sam3

if(NOT TARGET sam3_external)
set(sam3_external_SOURCE_DIR "sam3_external-prefix/src/sam3_external")
set(sam3_external_BINARY_DIR ${sam3_external_SOURCE_DIR})
list(APPEND sam3_external_BUILD_ENVIRONMENT
  "CC=set:${CMAKE_C_COMPILER}"
	"AR=set:${CMAKE_AR}"
)
if(WIN32)
  list(APPEND sam3_external_BUILD_ENVIRONMENT
    "LDFLAGS=set:-lmingw32 -lws2_32 -lwsock32 -mwindows"
  )
endif()
EnvironmentModification(envmod_build ${sam3_external_BUILD_ENVIRONMENT})
ExternalProject_Add(sam3_external
	GIT_REPOSITORY "https://github.com/i2p/libsam3.git"
	GIT_TAG "origin/master"
	GIT_SHALLOW TRUE
	GIT_PROGRESS TRUE
	TIMEOUT 10
	CONFIGURE_COMMAND ""
  BUILD_COMMAND ${envmod_build} make build
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE TRUE
	BUILD_ALWAYS TRUE
	EXCLUDE_FROM_ALL YES
  BUILD_BYPRODUCTS "${sam3_external_BINARY_DIR}/libsam3.a"
  BUILD_ENVIRONMENT_MODIFICATION ${sam3_external_BUILD_ENVIRONMENT}
)
endif()
