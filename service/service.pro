TARGET = dalvik-timezone-updater-service
target.path = /usr/bin

QT += dbus

dbus.files = dbus/org.coderus.dalviktimezoneupdater.service
dbus.path = /usr/share/dbus-1/services

tzdata.files = tzdata
tzdata.path = /usr/share/dalvik-timezone-updater

INSTALLS = target dbus tzdata

SOURCES += \
    src/dbuslistener.cpp \
    src/main.cpp

HEADERS += \
    src/dbuslistener.h
    
