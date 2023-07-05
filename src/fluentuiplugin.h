#ifndef FLUENTUIPLUGIN_H
#define FLUENTUIPLUGIN_H

#include <QQmlExtensionPlugin>

class FluentUIPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};

#endif // FLUENTUIPLUGIN_H
