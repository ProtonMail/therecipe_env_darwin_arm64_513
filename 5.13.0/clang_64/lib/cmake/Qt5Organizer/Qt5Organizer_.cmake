
add_library(Qt5:: MODULE IMPORTED)

_populate_Organizer_plugin_properties( RELEASE "organizer/libqtorganizer_memory.dylib")

list(APPEND Qt5Organizer_PLUGINS Qt5::)
