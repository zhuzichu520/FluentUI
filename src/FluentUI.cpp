#include "FluentUI.h"
#include "Fluent.h"

void FluentUI::registerTypes(const char *uri){
    Fluent::getInstance()->registerTypes(uri);
}

void FluentUI::initializeEngine(QQmlEngine *engine, const char *uri){
    Fluent::getInstance()->initializeEngine(engine,uri);
}

void FluentUI::initialize(QQmlEngine *engine){
    Fluent::getInstance()->registerTypes(URI_STR);
    Fluent::getInstance()->initializeEngine(engine,URI_STR);
}
