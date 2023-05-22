#ifndef FLUTOOLS_H
#define FLUTOOLS_H

#include <QObject>
#include <QFile>
#include <QtQml/qqml.h>

/**
 * @brief The FluTools class
 */
class FluTools : public QObject
{
    Q_OBJECT

    QML_NAMED_ELEMENT(FluTools)
    QML_SINGLETON
private:
    explicit FluTools(QObject *parent = nullptr);
    static FluTools* m_instance;
public:
    static FluTools *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        return getInstance();
    }
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

    /**
     * @brief readFile 读取文件内容
     * @param fileName
     * @return
     */
    Q_INVOKABLE QString readFile(const QString &fileName);

    Q_INVOKABLE bool isMacos();

    Q_INVOKABLE bool isLinux();

    Q_INVOKABLE bool isWin();

};

#endif // FLUTOOLS_H
