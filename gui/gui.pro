TARGET = dalvik-timezone-updater

CONFIG += sailfishapp

SOURCES += \
    src/main.cpp

OTHER_FILES += \
    qml/pattern.png \
    qml/main.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    dalvik-timezone-updater.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256
