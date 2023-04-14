#include "WindowHelper.h"

#include "FluRegister.h"
#include "FluApp.h"
#include "FluTheme.h"

#ifdef Q_OS_WIN
#include <dwmapi.h>
#include <Windows.h>
#include <windowsx.h>
enum class Style : DWORD
{
    windowed = (WS_OVERLAPPEDWINDOW | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_THICKFRAME | WS_CLIPCHILDREN),
    aero_borderless = (WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_THICKFRAME | WS_CLIPCHILDREN)
};
#endif

WindowHelper::WindowHelper(QObject *parent)
    : QObject{parent}
{

}

void WindowHelper::initWindow(QQuickWindow* window){
    this->window = window;
}

void WindowHelper::firstUpdate(){
    if(isFisrt){
#ifdef Q_OS_WIN
        if(FluTheme::getInstance()->frameless()){
            HWND wnd = (HWND)window->winId();
            SetWindowLongPtr(wnd, GWL_STYLE, static_cast<LONG>(Style::aero_borderless));
            const MARGINS shadow_on = { 1, 1, 1, 1 };
            DwmExtendFrameIntoClientArea(wnd, &shadow_on);
            SetWindowPos(wnd, Q_NULLPTR, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE);
            ShowWindow(wnd, SW_SHOW);
            window->setFlag(Qt::FramelessWindowHint,false);
        }
#endif
        isFisrt = false;
    }

}

QVariant WindowHelper::createRegister(const QString& path){
    FluRegister *p = new FluRegister(this->window);
    p->from(this->window);
    p->path(path);
    return  QVariant::fromValue(p);
}

void WindowHelper::destoryWindow(){
    if(this->window){
        FluApp::getInstance()->wnds.remove(this->window->winId());
        this->window->deleteLater();
    }
}
