#ifndef FLUHOTKEY_H
#define FLUHOTKEY_H

#include <QObject>
#include <QQuickItem>
#include "qhotkey/qhotkey.h"
#include "stdafx.h"

class FluHotkey : public QObject {

    Q_OBJECT
    Q_PROPERTY_AUTO(QString, sequence)
    Q_PROPERTY_AUTO(QString, name)
    Q_PROPERTY_READONLY_AUTO(bool, isRegistered)
    QML_NAMED_ELEMENT(FluHotkey)
public:
    explicit FluHotkey(QObject *parent = nullptr);
    ~FluHotkey();
    Q_SIGNAL void activated();

private:
    QHotkey *_hotkey = nullptr;
};

#endif // FLUHOTKEY_H
