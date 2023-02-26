#include "FluentUI.h"

#include "Fluent.h"

void FluentUI::create(QQmlEngine *engine)
{
    Fluent::getInstance()->registerTypes(URI_STR);
    Fluent::getInstance()->initializeEngine(engine,URI_STR);
    engine->addImportPath("/");
}

QString FluentUI::version()
{
    return Fluent::getInstance()->version();
}
