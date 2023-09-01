#ifndef FLUTOOLS_H
#define FLUTOOLS_H

#include <QObject>
#include <QFile>
#include <QColor>
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
     * @brief qtMajor Qt Major版本
     * @return
     */
    Q_INVOKABLE int qtMajor();

    /**
     * @brief qtMajor Qt Minor版本
     * @return
     */
    Q_INVOKABLE int qtMinor();

    /**
     * @brief isMacos 是否是Macos系统
     * @return
     */
    Q_INVOKABLE bool isMacos();

    /**
     * @brief isLinux 是否是Linux系统
     * @return
     */
    Q_INVOKABLE bool isLinux();

    /**
     * @brief isWin 是否是Windows系统
     * @return
     */
    Q_INVOKABLE bool isWin();

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
    Q_INVOKABLE QString readFile(const QString& fileName);

    /**
     * @brief setQuitOnLastWindowClosed 设置关闭最后一个窗口是否退出程序
     * @param val
     */
    Q_INVOKABLE void setQuitOnLastWindowClosed(bool val);

    /**
     * @brief setOverrideCursor 设置全局鼠标样式
     * @param shape
     */
    Q_INVOKABLE void setOverrideCursor(Qt::CursorShape shape);

    /**
     * @brief restoreOverrideCursor 还原全局鼠标样式
     */
    Q_INVOKABLE void restoreOverrideCursor();

    /**
     * @brief html2PlantText 将html转换成纯文本
     * @param html
     */
    Q_INVOKABLE QString html2PlantText(const QString& html);

    /**
     * @brief toLocalPath 获取文件路径，可以去掉windows系统下的file:///，macos下的file://
     * @param url
     * @return 返回文件路径
     */
    Q_INVOKABLE QString toLocalPath(const QUrl& url);

    /**
     * @brief deleteItem 销毁Item对象
     * @param p
     */
    Q_INVOKABLE void deleteItem(QObject *p);

    /**
     * @brief getFileNameByUrl
     * @param url
     * @return
     */
    Q_INVOKABLE QString getFileNameByUrl(const QUrl& url);

    /**
     * @brief getVirtualGeometry
     * @return
     */
    Q_INVOKABLE QRect getVirtualGeometry();

    /**
     * @brief getApplicationDirPath
     * @return
     */
    Q_INVOKABLE QString getApplicationDirPath();

    /**
     * @brief getUrlByFilePath
     * @param path
     * @return
     */
    Q_INVOKABLE QUrl getUrlByFilePath(const QString& path);

    /**
     * @brief colorAlpha
     * @param color
     * @param alpha
     * @return
     */
    Q_INVOKABLE QColor colorAlpha(const QColor&,qreal alpha);

    /**
     * @brief md5
     * @param text
     * @return
     */
    QString md5(QString text);

    /**
     * @brief toBase64
     * @param text
     * @return
     */
    QString toBase64(QString text);

    /**
     * @brief fromBase64
     * @param text
     * @return
     */
    QString fromBase64(QString text);

};

#endif // FLUTOOLS_H
