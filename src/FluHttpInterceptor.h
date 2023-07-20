#ifndef FLUHTTPINTERCEPTOR_H
#define FLUHTTPINTERCEPTOR_H

#include <QObject>
#include <QtQml/qqml.h>

class FluHttpInterceptor : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluHttpInterceptor)
public:
    explicit FluHttpInterceptor(QObject *parent = nullptr);

signals:

};

#endif // FLUHTTPINTERCEPTOR_H
