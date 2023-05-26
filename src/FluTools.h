#ifndef FLUTOOLS_H
#define FLUTOOLS_H

#include <QObject>
#include <QFile>
#include <QQmlEngine>
#include <QtQml/qqml.h>

/**
 * @brief The FluTools class
 */
class FluTools : public QObject
{
    Q_OBJECT

private:
    explicit FluTools(QObject *parent = nullptr);
    static FluTools* m_instance;
public:
    static FluTools *getInstance();
    /**
     * @brief clipText 将字符串添加到剪切板
     * @param text
     */
    Q_INVOKABLE void clipText(const QString& text);

    /**
     * @brief uuid 获取uuid
     * @return
     */
    Q_INVOKABLE QString uuid();

    Q_INVOKABLE bool isMacos();

    Q_INVOKABLE bool isLinux();

    Q_INVOKABLE bool isWin();

};

#endif // FLUTOOLS_H
