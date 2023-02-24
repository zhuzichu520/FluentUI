TEMPLATE = subdirs

SUBDIRS += \
    src/FluentUI.pro \
    example

    example.depends = src/FluentUI.pro
