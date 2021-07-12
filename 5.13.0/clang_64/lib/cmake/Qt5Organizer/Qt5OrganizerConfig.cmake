
if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 Organizer module requires at least CMake version 3.1.0")
endif()

get_filename_component(_qt5Organizer_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

# For backwards compatibility only. Use Qt5Organizer_VERSION instead.
set(Qt5Organizer_VERSION_STRING 0.0.0)

set(Qt5Organizer_LIBRARIES Qt5::Organizer)

macro(_qt5_Organizer_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::Organizer\" references the file
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


macro(_populate_Organizer_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION)
    set_property(TARGET Qt5::Organizer APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5Organizer_install_prefix}/lib/${LIB_LOCATION}")
    _qt5_Organizer_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5Organizer_LIB_DEPENDENCIES}
    )
    set_target_properties(Qt5::Organizer PROPERTIES
        "INTERFACE_LINK_LIBRARIES" "${_deps}"
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps}"
    )

endmacro()

if (NOT TARGET Qt5::Organizer)

    set(_Qt5Organizer_OWN_INCLUDE_DIRS
      "${_qt5Organizer_install_prefix}/lib/QtOrganizer.framework"
      "${_qt5Organizer_install_prefix}/lib/QtOrganizer.framework/Headers"
    )
    set(Qt5Organizer_PRIVATE_INCLUDE_DIRS
        "${_qt5Organizer_install_prefix}/lib/QtOrganizer.framework/Versions/0/Headers/0.0.0/"
        "${_qt5Organizer_install_prefix}/lib/QtOrganizer.framework/Versions/0/Headers/0.0.0/QtOrganizer"
    )

    foreach(_dir ${_Qt5Organizer_OWN_INCLUDE_DIRS})
        _qt5_Organizer_check_file_exists(${_dir})
    endforeach()


    set(Qt5Organizer_INCLUDE_DIRS ${_Qt5Organizer_OWN_INCLUDE_DIRS})

    set(Qt5Organizer_DEFINITIONS -DQT_ORGANIZER_LIB)
    set(Qt5Organizer_COMPILE_DEFINITIONS QT_ORGANIZER_LIB)
    set(_Qt5Organizer_MODULE_DEPENDENCIES "Core")


    set(Qt5Organizer_OWN_PRIVATE_INCLUDE_DIRS ${Qt5Organizer_PRIVATE_INCLUDE_DIRS})

    set(_Qt5Organizer_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5Organizer_FIND_REQUIRED)
        set(_Qt5Organizer_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5Organizer_FIND_DEPENDENCIES_QUIET)
    if (Qt5Organizer_FIND_QUIETLY)
        set(_Qt5Organizer_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5Organizer_FIND_VERSION_EXACT)
    if (Qt5Organizer_FIND_VERSION_EXACT)
        set(_Qt5Organizer_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5Organizer_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5Organizer_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                0.0.0 ${_Qt5Organizer_FIND_VERSION_EXACT}
                ${_Qt5Organizer_DEPENDENCIES_FIND_QUIET}
                ${_Qt5Organizer_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5Organizer_FOUND False)
            return()
        endif()

        list(APPEND Qt5Organizer_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5Organizer_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5Organizer_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5Organizer_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5Organizer_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5Organizer_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Organizer_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Organizer_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Organizer_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Organizer_EXECUTABLE_COMPILE_FLAGS)

    set(_Qt5Organizer_LIB_DEPENDENCIES "Qt5::Core")


    add_library(Qt5::Organizer SHARED IMPORTED)
    set_property(TARGET Qt5::Organizer PROPERTY FRAMEWORK 1)

    set_property(TARGET Qt5::Organizer PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5Organizer_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::Organizer PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_ORGANIZER_LIB)

    set_property(TARGET Qt5::Organizer PROPERTY INTERFACE_QT_ENABLED_FEATURES )
    set_property(TARGET Qt5::Organizer PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    set(_Qt5Organizer_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5Organizer_PRIVATE_DIR ${Qt5Organizer_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5Organizer_PRIVATE_DIR})
            set(_Qt5Organizer_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5Organizer_PRIVATE_DIRS_EXIST)
        add_library(Qt5::OrganizerPrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::OrganizerPrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5Organizer_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5Organizer_PRIVATEDEPS)
        foreach(dep ${_Qt5Organizer_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5Organizer_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::OrganizerPrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::Organizer ${_Qt5Organizer_PRIVATEDEPS}
        )
    endif()

    _populate_Organizer_target_properties(RELEASE "QtOrganizer.framework/QtOrganizer" "" )




    file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5Organizer_*Plugin.cmake")

    macro(_populate_Organizer_plugin_properties Plugin Configuration PLUGIN_LOCATION)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5Organizer_install_prefix}/plugins/${PLUGIN_LOCATION}")
        _qt5_Organizer_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )
    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()




_qt5_Organizer_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5OrganizerConfigVersion.cmake")

endif()
