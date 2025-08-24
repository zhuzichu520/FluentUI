#include "FluCountTimer.h"

FluCountTimer::FluCountTimer(QObject *parent)
    : QObject(parent)
      , _countType(CountType::Countdown)
      , _value(0)
      , _interval(1000)
      , _running(false)
      , _format("hh:mm:ss")
      , _hour(0)
      , _minute(0)
      , _second(0)
      , _millisecond(0)
      , _timer(new QTimer(this)) {
    _timer->setInterval(_interval);
    connect(_timer, &QTimer::timeout, this, &FluCountTimer::onTimeout);
    connect(this, &FluCountTimer::intervalChanged, this, [this] { _timer->setInterval(_interval); });
    connect(this, &FluCountTimer::valueChanged, this, [this] { updateTime(); });
    connect(this, &FluCountTimer::runningChanged, this, &FluCountTimer::onRunningChanged);
    updateTime();
}

void FluCountTimer::start() {
    if ((_countType == CountType::Countdown && _value > 0) || _countType == CountType::Countup) {
        running(true);
    }
}

void FluCountTimer::stop() {
    running(false);
}

void FluCountTimer::reset(int baseValue) {
    stop();
    value(baseValue);
}

void FluCountTimer::onTimeout() {
    if (_countType == CountType::Countdown) {
        qint64 newValue = _value - _interval;
        if (newValue < 0) {
            newValue = 0;
        }
        value(newValue);
        if (newValue == 0) {
            stop();
            Q_EMIT finished();
        }
    } else {
        value(_value + _interval);
    }
}

void FluCountTimer::onRunningChanged() {
    if (_running) {
        _timer->start();
    } else {
        _timer->stop();
    }
}

void FluCountTimer::updateTime() {
    hour(_value / 3600000);
    minute((_value % 3600000) / 60000);
    second((_value % 60000) / 1000);
    millisecond(_value % 1000);
    time(formatTime());
}

QString FluCountTimer::formatTime() const {
    QString timeStr = _format;
    timeStr.replace("hh", QString::number(_hour).rightJustified(2, '0'));
    timeStr.replace("h", QString::number(_hour));
    timeStr.replace("mm", QString::number(_minute).rightJustified(2, '0'));
    timeStr.replace("m", QString::number(_minute));
    timeStr.replace("ss", QString::number(_second).rightJustified(2, '0'));
    timeStr.replace("s", QString::number(_second));
    timeStr.replace("zzz", QString::number(_millisecond).rightJustified(3, '0'));
    timeStr.replace("z", QString::number(_millisecond));
    return timeStr;
}
