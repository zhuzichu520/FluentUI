#pragma once

#include <QQmlExtensionPlugin>
#include <FluentUI.h>

class FluentUIQmlPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;

    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};
