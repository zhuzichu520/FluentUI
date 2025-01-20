#pragma once

#include <QObject>
#include <QQmlApplicationEngine>

#include "singleton.h"
#include "stdafx.h"

class AppInfo : public QObject {
  Q_OBJECT
  Q_PROPERTY_AUTO(QString, version)
 private:
  explicit AppInfo(QObject *parent = nullptr);

 public:
  EXAMPLESINGLETON(AppInfo)
  [[maybe_unused]] Q_INVOKABLE void testCrash();
};
