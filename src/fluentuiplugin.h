#pragma once

#include <QQmlExtensionPlugin>

/**
 * @brief The FluentUIPlugin class
 */
class FluentUIPlugin : public QQmlExtensionPlugin {
    Q_OBJECT

    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    FluentUIPlugin();

    void registerTypes(const char *uri) Q_DECL_OVERRIDE;

    void initializeEngine(QQmlEngine *engine, const char *uri) Q_DECL_OVERRIDE;
};
