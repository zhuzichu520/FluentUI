#include "FluentUI.h"

#include "Fluent.h"

void FluentUI::create(QQmlEngine *engine)
{
    engine->addImportPath("/");
    Fluent::getInstance()->initializeEngine(engine,URI_STR);
    Fluent::getInstance()->registerTypes(URI_STR);
}

QString FluentUI::version()
{
    return Fluent::getInstance()->version();
}
