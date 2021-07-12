

## Build config:

../qt5/configure -release -opensource -confirm-license -skip qtconnectivity -platform macx-clang QMAKE_APPLE_DEVICE_ARCHS=arm64 -nomake examples -nomake tests -skip qt3d -prefix /Users/proton/Projects/Qt5-ARM64

## QT Patches
### System tray icon

```
diff --git a/src/plugins/platforms/cocoa/qcocoasystemtrayicon.mm b/src/plugins/platforms/cocoa/qcocoasystemtrayicon.mm
index 4982f5ee05..3ae1e4fca3 100644
--- a/src/plugins/platforms/cocoa/qcocoasystemtrayicon.mm
+++ b/src/plugins/platforms/cocoa/qcocoasystemtrayicon.mm
@@ -224,6 +224,7 @@ void QCocoaSystemTrayIcon::updateIcon(const QIcon &icon)
	 r.moveCenter(fullHeightPixmap.rect().center());
	 p.drawPixmap(r, pixmap);
     }
+    fullHeightPixmap.setDevicePixelRatio(devicePixelRatio);
 
     NSImage *nsimage = static_cast<NSImage *>(qt_mac_create_nsimage(fullHeightPixmap));
     [nsimage setTemplate:icon.isMask()];
```

### New linker flags

```
diff --git a/mkspecs/features/mac/default_post.prf b/mkspecs/features/mac/default_post.prf
index 993f4d5..d052808 100644
--- a/mkspecs/features/mac/default_post.prf
+++ b/mkspecs/features/mac/default_post.prf
@@ -197,7 +197,7 @@
                 -isysroot$$xcodeSDKInfo(Path, $$sdk)
             QMAKE_XARCH_LFLAGS_$${arch} = $$version_min_flags \
                 -Xarch_$${arch} \
-                -Wl,-syslibroot,$$xcodeSDKInfo(Path, $$sdk)
+                -isysroot$$xcodeSDKInfo(Path, $$sdk)
 
             QMAKE_XARCH_CFLAGS += $(EXPORT_QMAKE_XARCH_CFLAGS_$${arch})
             QMAKE_XARCH_LFLAGS += $(EXPORT_QMAKE_XARCH_LFLAGS_$${arch})
@@ -218,7 +218,7 @@
         version_min_flag = -m$${version_identifier}-version-min=$$deployment_target
         QMAKE_CFLAGS += -isysroot $$QMAKE_MAC_SDK_PATH $$version_min_flag
         QMAKE_CXXFLAGS += -isysroot $$QMAKE_MAC_SDK_PATH $$version_min_flag
-        QMAKE_LFLAGS += -Wl,-syslibroot,$$QMAKE_MAC_SDK_PATH $$version_min_flag
+        QMAKE_LFLAGS += -isysroot $$QMAKE_MAC_SDK_PATH $$version_min_flag
     }
 
     # Enable precompiled headers for multiple architectures
```
