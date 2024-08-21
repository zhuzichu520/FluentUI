#pragma once

#include <QObject>
#include <QQuickItem>
#include <QAbstractNativeEventFilter>
#include <QQmlProperty>
#include "stdafx.h"

#ifdef Q_OS_WIN

#pragma comment (lib, "user32.lib")
#pragma comment (lib, "dwmapi.lib")

#include <windows.h>
#include <windowsx.h>
#include <dwmapi.h>
enum _DWM_SYSTEMBACKDROP_TYPE {
    _DWMSBT_AUTO, // [Default] Let DWM automatically decide the system-drawn backdrop for this
    // window.
    _DWMSBT_NONE, // [Disable] Do not draw any system backdrop.
    _DWMSBT_MAINWINDOW,      // [Mica] Draw the backdrop material effect corresponding to a
    // long-lived window.
    _DWMSBT_TRANSIENTWINDOW, // [Acrylic] Draw the backdrop material effect corresponding to a
    // transient window.
    _DWMSBT_TABBEDWINDOW,    // [Mica Alt] Draw the backdrop material effect corresponding to a
    // window with a tabbed title bar.
};
enum WINDOWCOMPOSITIONATTRIB {
    WCA_UNDEFINED = 0,
    WCA_NCRENDERING_ENABLED = 1,
    WCA_NCRENDERING_POLICY = 2,
    WCA_TRANSITIONS_FORCEDISABLED = 3,
    WCA_ALLOW_NCPAINT = 4,
    WCA_CAPTION_BUTTON_BOUNDS = 5,
    WCA_NONCLIENT_RTL_LAYOUT = 6,
    WCA_FORCE_ICONIC_REPRESENTATION = 7,
    WCA_EXTENDED_FRAME_BOUNDS = 8,
    WCA_HAS_ICONIC_BITMAP = 9,
    WCA_THEME_ATTRIBUTES = 10,
    WCA_NCRENDERING_EXILED = 11,
    WCA_NCADORNMENTINFO = 12,
    WCA_EXCLUDED_FROM_LIVEPREVIEW = 13,
    WCA_VIDEO_OVERLAY_ACTIVE = 14,
    WCA_FORCE_ACTIVEWINDOW_APPEARANCE = 15,
    WCA_DISALLOW_PEEK = 16,
    WCA_CLOAK = 17,
    WCA_CLOAKED = 18,
    WCA_ACCENT_POLICY = 19,
    WCA_FREEZE_REPRESENTATION = 20,
    WCA_EVER_UNCLOAKED = 21,
    WCA_VISUAL_OWNER = 22,
    WCA_HOLOGRAPHIC = 23,
    WCA_EXCLUDED_FROM_DDA = 24,
    WCA_PASSIVEUPDATEMODE = 25,
    WCA_USEDARKMODECOLORS = 26,
    WCA_CORNER_STYLE = 27,
    WCA_PART_COLOR = 28,
    WCA_DISABLE_MOVESIZE_FEEDBACK = 29,
    WCA_LAST = 30
};

enum ACCENT_STATE {
    ACCENT_DISABLED = 0,
    ACCENT_ENABLE_GRADIENT = 1,
    ACCENT_ENABLE_TRANSPARENTGRADIENT = 2,
    ACCENT_ENABLE_BLURBEHIND = 3,        // Traditional DWM blur
    ACCENT_ENABLE_ACRYLICBLURBEHIND = 4, // RS4 1803
    ACCENT_ENABLE_HOST_BACKDROP = 5,     // RS5 1809
    ACCENT_INVALID_STATE = 6             // Using this value will remove the window background
};

enum ACCENT_FLAG {
    ACCENT_NONE = 0,
    ACCENT_ENABLE_ACRYLIC = 1,
    ACCENT_ENABLE_ACRYLIC_WITH_LUMINOSITY = 482
};

struct ACCENT_POLICY {
    DWORD dwAccentState;
    DWORD dwAccentFlags;
    DWORD dwGradientColor; // #AABBGGRR
    DWORD dwAnimationId;
};
using PACCENT_POLICY = ACCENT_POLICY *;
struct WINDOWCOMPOSITIONATTRIBDATA {
    WINDOWCOMPOSITIONATTRIB Attrib;
    PVOID pvData;
    SIZE_T cbData;
};
using PWINDOWCOMPOSITIONATTRIBDATA = WINDOWCOMPOSITIONATTRIBDATA *;

typedef HRESULT (WINAPI *DwmSetWindowAttributeFunc)(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
typedef HRESULT (WINAPI *DwmExtendFrameIntoClientAreaFunc)(HWND hwnd, const MARGINS *pMarInset);
typedef HRESULT (WINAPI *DwmIsCompositionEnabledFunc)(BOOL *pfEnabled);
typedef HRESULT (WINAPI *DwmEnableBlurBehindWindowFunc)(HWND hWnd, const DWM_BLURBEHIND *pBlurBehind);
typedef BOOL (WINAPI *SetWindowCompositionAttributeFunc)(HWND hwnd, const WINDOWCOMPOSITIONATTRIBDATA *);

#endif

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
using QT_NATIVE_EVENT_RESULT_TYPE = qintptr;
using QT_ENTER_EVENT_TYPE = QEnterEvent;
#else
using QT_NATIVE_EVENT_RESULT_TYPE = long;
using QT_ENTER_EVENT_TYPE = QEvent;
#endif

class FluFrameless : public QQuickItem, QAbstractNativeEventFilter {
    Q_OBJECT
    Q_PROPERTY_AUTO_P(QQuickItem *, appbar)
    Q_PROPERTY_AUTO_P(QQuickItem *, maximizeButton)
    Q_PROPERTY_AUTO_P(QQuickItem *, minimizedButton)
    Q_PROPERTY_AUTO_P(QQuickItem *, closeButton)
    Q_PROPERTY_AUTO(bool, topmost)
    Q_PROPERTY_AUTO(bool, disabled)
    Q_PROPERTY_AUTO(bool, fixSize)
    Q_PROPERTY_AUTO(QString, effect)
    Q_PROPERTY_READONLY_AUTO(bool, effective)
    Q_PROPERTY_READONLY_AUTO(QStringList, availableEffects)
    QML_NAMED_ELEMENT(FluFrameless)
public:
    explicit FluFrameless(QQuickItem *parent = nullptr);

    ~FluFrameless() override;

    void componentComplete() override;

    [[maybe_unused]] bool nativeEventFilter(const QByteArray &eventType, void *message,
                                            QT_NATIVE_EVENT_RESULT_TYPE *result) override;

    [[maybe_unused]] Q_INVOKABLE void showFullScreen();

    Q_INVOKABLE void showMaximized();

    [[maybe_unused]] Q_INVOKABLE void showMinimized();

    Q_INVOKABLE void showNormal();

    Q_INVOKABLE void setHitTestVisible(QQuickItem *);

    [[maybe_unused]] Q_INVOKABLE void onDestruction();

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    bool _isFullScreen();

    bool _isMaximized();

    void _updateCursor(int edges);

    void _setWindowTopmost(bool topmost);

    void _showSystemMenu(QPoint point);

    bool _hitAppBar();

    bool _hitMaximizeButton();

    void _setMaximizePressed(bool val);

    void _setMaximizeHovered(bool val);

private:
    quint64 _current = 0;
    int _edges = 0;
    int _margins = 8;
    quint64 _clickTimer = 0;
    bool _isWindows11OrGreater = false;
    QList<QPointer<QQuickItem>> _hitTestList;
    QString _currentEffect;
};
