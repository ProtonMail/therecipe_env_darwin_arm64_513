
if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 ScriptTools module requires at least CMake version 3.1.0")
endif()

get_filename_component(_qt5ScriptTools_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

# For backwards compatibility only. Use Qt5ScriptTools_VERSION instead.
set(Qt5ScriptTools_VERSION_STRING 5.13.0)

set(Qt5ScriptTools_LIBRARIES Qt5::ScriptTools)

macro(_qt5_ScriptTools_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::ScriptTools\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
endmacro()


macro(_populate_ScriptTools_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION)
    set_property(TARGET Qt5::ScriptTools APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5ScriptTools_install_prefix}/lib/${LIB_LOCATION}")
    _qt5_ScriptTools_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5ScriptTools_LIB_DEPENDENCIES}
    )
    set_target_properties(Qt5::ScriptTools PROPERTIES
        "INTERFACE_LINK_LIBRARIES" "${_deps}"
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps}"
    )

endmacro()

if (NOT TARGET Qt5::ScriptTools)

    set(_Qt5ScriptTools_OWN_INCLUDE_DIRS
      "${_qt5ScriptTools_install_prefix}/lib/QtScriptTools.framework"
      "${_qt5ScriptTools_install_prefix}/lib/QtScriptTools.framework/Headers"
    )
    set(Qt5ScriptTools_PRIVATE_INCLUDE_DIRS
        "${_qt5ScriptTools_install_prefix}/lib/QtScriptTools.framework/Versions/5/Headers/5.13.0/"
        "${_qt5ScriptTools_install_prefix}/lib/QtScriptTools.framework/Versions/5/Headers/5.13.0/QtScriptTools"
    )

    foreach(_dir ${_Qt5ScriptTools_OWN_INCLUDE_DIRS})
        _qt5_ScriptTools_check_file_exists(${_dir})
    endforeach()


    set(Qt5ScriptTools_INCLUDE_DIRS ${_Qt5ScriptTools_OWN_INCLUDE_DIRS})

    set(Qt5ScriptTools_DEFINITIONS -DQT_SCRIPTTOOLS_LIB)
    set(Qt5ScriptTools_COMPILE_DEFINITIONS QT_SCRIPTTOOLS_LIB)
    set(_Qt5ScriptTools_MODULE_DEPENDENCIES "Core")


    set(Qt5ScriptTools_OWN_PRIVATE_INCLUDE_DIRS ${Qt5ScriptTools_PRIVATE_INCLUDE_DIRS})

    set(_Qt5ScriptTools_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5ScriptTools_FIND_REQUIRED)
        set(_Qt5ScriptTools_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5ScriptTools_FIND_DEPENDENCIES_QUIET)
    if (Qt5ScriptTools_FIND_QUIETLY)
        set(_Qt5ScriptTools_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5ScriptTools_FIND_VERSION_EXACT)
    if (Qt5ScriptTools_FIND_VERSION_EXACT)
        set(_Qt5ScriptTools_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5ScriptTools_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5ScriptTools_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                5.13.0 ${_Qt5ScriptTools_FIND_VERSION_EXACT}
                ${_Qt5ScriptTools_DEPENDENCIES_FIND_QUIET}
                ${_Qt5ScriptTools_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5ScriptTools_FOUND False)
            return()
        endif()

        list(APPEND Qt5ScriptTools_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5ScriptTools_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5ScriptTools_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5ScriptTools_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5ScriptTools_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5ScriptTools_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5ScriptTools_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5ScriptTools_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5ScriptTools_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5ScriptTools_EXECUTABLE_COMPILE_FLAGS)

    set(_Qt5ScriptTools_LIB_DEPENDENCIES "Qt5::Core")


    add_library(Qt5::ScriptTools SHARED IMPORTED)
    set_property(TARGET Qt5::ScriptTools PROPERTY FRAMEWORK 1)

    set_property(TARGET Qt5::ScriptTools PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5ScriptTools_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::ScriptTools PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_SCRIPTTOOLS_LIB)

    set_property(TARGET Qt5::ScriptTools PROPERTY INTERFACE_QT_ENABLED_FEATURES )
    set_property(TARGET Qt5::ScriptTools PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    set(_Qt5ScriptTools_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5ScriptTools_PRIVATE_DIR ${Qt5ScriptTools_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5ScriptTools_PRIVATE_DIR})
            set(_Qt5ScriptTools_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5ScriptTools_PRIVATE_DIRS_EXIST)
        add_library(Qt5::ScriptToolsPrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::ScriptToolsPrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5ScriptTools_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5ScriptTools_PRIVATEDEPS)
        foreach(dep ${_Qt5ScriptTools_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5ScriptTools_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::ScriptToolsPrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::ScriptTools ${_Qt5ScriptTools_PRIVATEDEPS}
        )
    endif()

    _populate_ScriptTools_target_properties(RELEASE "QtScriptTools.framework/QtScriptTools" "" )




    file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5ScriptTools_*Plugin.cmake")

    macro(_populate_ScriptTools_plugin_properties Plugin Configuration PLUGIN_LOCATION)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5ScriptTools_install_prefix}/plugins/${PLUGIN_LOCATION}")
        _qt5_ScriptTools_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )
    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()




_qt5_ScriptTools_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5ScriptToolsConfigVersion.cmake")

endif()
