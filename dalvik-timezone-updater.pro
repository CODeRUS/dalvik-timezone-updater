TEMPLATE = subdirs
SUBDIRS = \
    service \
    gui \
    $${NULL}

gui.depends = service

OTHER_FILES = \
    rpm/dalvik-timezone-updater.spec \
    $${NULL}
