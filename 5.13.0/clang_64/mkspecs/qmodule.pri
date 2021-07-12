!host_build|!cross_compile {
    QMAKE_APPLE_DEVICE_ARCHS=arm64
}
QT_CPU_FEATURES.arm64 = neon crc32
QT.global_private.enabled_features = alloca_h alloca dbus gui network reduce_exports sql system-zlib testlib widgets xml
QT.global_private.disabled_features = sse2 alloca_malloc_h android-style-assets avx2 private_tests dbus-linked gc_binaries libudev posix_fallocate reduce_relocations release_tools stack-protector-strong zstd
QT_COORD_TYPE = double
QMAKE_LIBS_ZLIB = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.3.sdk/usr/lib/libz.tbd
QT_BUILD_PARTS += libs tools
CONFIG += compile_examples largefile neon precompile_header
QT_HOST_CFLAGS_DBUS += 
