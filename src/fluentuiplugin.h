#ifndef FLUENTUIPLUGIN_H
#define FLUENTUIPLUGIN_H

#include <QQmlExtensionPlugin>



class FluentUIPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    FluentUIPlugin();
    void registerTypes(const char *uri) Q_DECL_OVERRIDE;
#ifdef FLUENTUI_BUILD_STATIC_LIB
    static void registerTypes();
    static FluentUIPlugin* instance();
#endif
    void initializeEngine(QQmlEngine *engine, const char *uri) Q_DECL_OVERRIDE;
};

#endif // FLUENTUIPLUGIN_H
