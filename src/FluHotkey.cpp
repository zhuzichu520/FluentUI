#include "FluHotkey.h"
#include "QGuiApplication"
#ifdef QHOTKEY_AVAILABLE
#include "qhotkey/qhotkey.h"
#endif


FluHotkey::FluHotkey(QObject *parent) : QObject{parent} {
    _sequence = "";
    _isRegistered = false;
#ifdef QHOTKEY_AVAILABLE
    connect(this, &FluHotkey::sequenceChanged, this, [=] {
        if (_hotkey) {
            delete _hotkey;
            _hotkey = nullptr;
        }
        _hotkey = new QHotkey(QKeySequence(_sequence), true, qApp);
        this->isRegistered(_hotkey->isRegistered());
        QObject::connect(_hotkey, &QHotkey::activated, qApp, [=]() { Q_EMIT this->activated(); });
        QObject::connect(_hotkey, &QHotkey::registeredChanged, qApp,
                         [=]() { this->isRegistered(_hotkey->isRegistered()); });
    });
#else
    connect(this, &FluHotkey::sequenceChanged, this, [=] {
        this->isRegistered(false);
    });
#endif
}

FluHotkey::~FluHotkey() {
#ifdef QHOTKEY_AVAILABLE
    if (_hotkey) {
        delete _hotkey;
        _hotkey = nullptr;
    }
#endif
}
