#pragma once

#include <QObject>
#include <QtQml/qqml.h>

namespace FluSheetType {
    Q_NAMESPACE
    enum Position {
        Left = 0x0000,
        Top = 0x0001,
        Right = 0x0002,
        Bottom = 0x0004,
    };

    Q_ENUM_NS(Position)

    QML_NAMED_ELEMENT(FluSheetType)
}

namespace FluThemeType {
    Q_NAMESPACE
    enum DarkMode {
        System = 0x0000,
        Light = 0x0001,
        Dark = 0x0002,
    };

    Q_ENUM_NS(DarkMode)

    QML_NAMED_ELEMENT(FluThemeType)
}

namespace FluTimelineType {
    Q_NAMESPACE
    enum Mode {
        Left = 0x0000,
        Right = 0x0001,
        Alternate = 0x0002,
    };

    Q_ENUM_NS(Mode)

    QML_NAMED_ELEMENT(FluTimelineType)
}

namespace FluPageType {
    Q_NAMESPACE
    enum LaunchMode {
        Standard = 0x0000,
        SingleTask = 0x0001,
        SingleTop = 0x0002,
        SingleInstance = 0x0004
    };

    Q_ENUM_NS(LaunchMode)

    QML_NAMED_ELEMENT(FluPageType)
}

namespace FluWindowType {
    Q_NAMESPACE
    enum LaunchMode {
        Standard = 0x0000,
        SingleTask = 0x0001,
        SingleInstance = 0x0002
    };

    Q_ENUM_NS(LaunchMode)

    QML_NAMED_ELEMENT(FluWindowType)
}

namespace FluTreeViewType {
    Q_NAMESPACE
    enum SelectionMode {
        None = 0x0000,
        Single = 0x0001,
        Multiple = 0x0002
    };

    Q_ENUM_NS(SelectionMode)

    QML_NAMED_ELEMENT(FluTreeViewType)
}

namespace FluStatusLayoutType {
    Q_NAMESPACE
    enum StatusMode {
        Loading = 0x0000,
        Empty = 0x0001,
        Error = 0x0002,
        Success = 0x0004
    };

    Q_ENUM_NS(StatusMode)

    QML_NAMED_ELEMENT(FluStatusLayoutType)
}

namespace FluContentDialogType {
    Q_NAMESPACE
    enum ButtonFlag {
        NeutralButton = 0x0001,
        NegativeButton = 0x0002,
        PositiveButton = 0x0004
    };

    Q_ENUM_NS(ButtonFlag)

    QML_NAMED_ELEMENT(FluContentDialogType)
}

namespace FluTimePickerType {
    Q_NAMESPACE
    enum HourFormat {
        H = 0x0000,
        HH = 0x0001
    };

    Q_ENUM_NS(HourFormat)

    QML_NAMED_ELEMENT(FluTimePickerType)
}

namespace FluCalendarViewType {
    Q_NAMESPACE
    enum DisplayMode {
        Month = 0x0000,
        Year = 0x0001,
        Decade = 0x0002
    };

    Q_ENUM_NS(DisplayMode)

    QML_NAMED_ELEMENT(FluCalendarViewType)
}

namespace FluTabViewType {
    Q_NAMESPACE
    enum TabWidthBehavior {
        Equal = 0x0000,
        SizeToContent = 0x0001,
        Compact = 0x0002
    };

    Q_ENUM_NS(TabWidthBehavior)

    enum CloseButtonVisibility {
        Never = 0x0000,
        Always = 0x0001,
        OnHover = 0x0002
    };

    Q_ENUM_NS(CloseButtonVisibility)

    QML_NAMED_ELEMENT(FluTabViewType)
}

namespace FluNavigationViewType {
    Q_NAMESPACE
    enum DisplayMode {
        Open = 0x0000,
        Compact = 0x0001,
        Minimal = 0x0002,
        Auto = 0x0004
    };

    Q_ENUM_NS(DisplayMode)

    enum PageMode {
        Stack = 0x0000,
        NoStack = 0x0001
    };

    Q_ENUM_NS(PageMode)

    QML_NAMED_ELEMENT(FluNavigationViewType)
}
