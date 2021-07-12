
if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 PublishSubscribe module requires at least CMake version 3.1.0")
endif()

get_filename_component(_qt5PublishSubscribe_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

# For backwards compatibility only. Use Qt5PublishSubscribe_VERSION instead.
set(Qt5PublishSubscribe_VERSION_STRING 5.4.0)

set(Qt5PublishSubscribe_LIBRARIES Qt5::PublishSubscribe)

macro(_qt5_PublishSubscribe_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::PublishSubscribe\" references the file
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


macro(_populate_PublishSubscribe_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION)
    set_property(TARGET Qt5::PublishSubscribe APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5PublishSubscribe_install_prefix}/lib/${LIB_LOCATION}")
    _qt5_PublishSubscribe_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5PublishSubscribe_LIB_DEPENDENCIES}
    )
    set_target_properties(Qt5::PublishSubscribe PROPERTIES
        "INTERFACE_LINK_LIBRARIES" "${_deps}"
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps}"
    )

endmacro()

if (NOT TARGET Qt5::PublishSubscribe)

    set(_Qt5PublishSubscribe_OWN_INCLUDE_DIRS
      "${_qt5PublishSubscribe_install_prefix}/lib/QtPublishSubscribe.framework"
      "${_qt5PublishSubscribe_install_prefix}/lib/QtPublishSubscribe.framework/Headers"
    )
    set(Qt5PublishSubscribe_PRIVATE_INCLUDE_DIRS
        "${_qt5PublishSubscribe_install_prefix}/lib/QtPublishSubscribe.framework/Versions/5/Headers/5.4.0/"
        "${_qt5PublishSubscribe_install_prefix}/lib/QtPublishSubscribe.framework/Versions/5/Headers/5.4.0/QtPublishSubscribe"
    )

    foreach(_dir ${_Qt5PublishSubscribe_OWN_INCLUDE_DIRS})
        _qt5_PublishSubscribe_check_file_exists(${_dir})
    endforeach()


    set(Qt5PublishSubscribe_INCLUDE_DIRS ${_Qt5PublishSubscribe_OWN_INCLUDE_DIRS})

    set(Qt5PublishSubscribe_DEFINITIONS -DQT_PUBLISHSUBSCRIBE_LIB)
    set(Qt5PublishSubscribe_COMPILE_DEFINITIONS QT_PUBLISHSUBSCRIBE_LIB)
    set(_Qt5PublishSubscribe_MODULE_DEPENDENCIES "Core")


    set(Qt5PublishSubscribe_OWN_PRIVATE_INCLUDE_DIRS ${Qt5PublishSubscribe_PRIVATE_INCLUDE_DIRS})

    set(_Qt5PublishSubscribe_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5PublishSubscribe_FIND_REQUIRED)
        set(_Qt5PublishSubscribe_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5PublishSubscribe_FIND_DEPENDENCIES_QUIET)
    if (Qt5PublishSubscribe_FIND_QUIETLY)
        set(_Qt5PublishSubscribe_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5PublishSubscribe_FIND_VERSION_EXACT)
    if (Qt5PublishSubscribe_FIND_VERSION_EXACT)
        set(_Qt5PublishSubscribe_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5PublishSubscribe_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5PublishSubscribe_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                5.4.0 ${_Qt5PublishSubscribe_FIND_VERSION_EXACT}
                ${_Qt5PublishSubscribe_DEPENDENCIES_FIND_QUIET}
                ${_Qt5PublishSubscribe_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5PublishSubscribe_FOUND False)
            return()
        endif()

        list(APPEND Qt5PublishSubscribe_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5PublishSubscribe_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5PublishSubscribe_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5PublishSubscribe_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5PublishSubscribe_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5PublishSubscribe_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5PublishSubscribe_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5PublishSubscribe_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5PublishSubscribe_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5PublishSubscribe_EXECUTABLE_COMPILE_FLAGS)

    set(_Qt5PublishSubscribe_LIB_DEPENDENCIES "Qt5::Core")


    add_library(Qt5::PublishSubscribe SHARED IMPORTED)
    set_property(TARGET Qt5::PublishSubscribe PROPERTY FRAMEWORK 1)

    set_property(TARGET Qt5::PublishSubscribe PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5PublishSubscribe_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::PublishSubscribe PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_PUBLISHSUBSCRIBE_LIB)

    set_property(TARGET Qt5::PublishSubscribe PROPERTY INTERFACE_QT_ENABLED_FEATURES )
    set_property(TARGET Qt5::PublishSubscribe PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    set(_Qt5PublishSubscribe_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5PublishSubscribe_PRIVATE_DIR ${Qt5PublishSubscribe_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5PublishSubscribe_PRIVATE_DIR})
            set(_Qt5PublishSubscribe_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5PublishSubscribe_PRIVATE_DIRS_EXIST)
        add_library(Qt5::PublishSubscribePrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::PublishSubscribePrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5PublishSubscribe_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5PublishSubscribe_PRIVATEDEPS)
        foreach(dep ${_Qt5PublishSubscribe_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5PublishSubscribe_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::PublishSubscribePrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::PublishSubscribe ${_Qt5PublishSubscribe_PRIVATEDEPS}
        )
    endif()

    _populate_PublishSubscribe_target_properties(RELEASE "QtPublishSubscribe.framework/QtPublishSubscribe" "" )




    file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5PublishSubscribe_*Plugin.cmake")

    macro(_populate_PublishSubscribe_plugin_properties Plugin Configuration PLUGIN_LOCATION)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5PublishSubscribe_install_prefix}/plugins/${PLUGIN_LOCATION}")
        _qt5_PublishSubscribe_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )
    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()




_qt5_PublishSubscribe_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5PublishSubscribeConfigVersion.cmake")

endif()
