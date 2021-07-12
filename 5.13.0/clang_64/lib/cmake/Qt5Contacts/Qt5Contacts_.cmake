
add_library(Qt5:: MODULE IMPORTED)

_populate_Contacts_plugin_properties( RELEASE "contacts/libqtcontacts_memory.dylib")

list(APPEND Qt5Contacts_PLUGINS Qt5::)
