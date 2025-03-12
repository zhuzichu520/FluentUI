#pragma once

#include <QObject>
#include <QQmlEngine>

/**
 * @brief The FluentUI class
 */
class FluentUI{

public:

   static Q_DECL_EXPORT void registerTypes(QQmlEngine *engine);

   static void registerTypes(const char *uri);

   static void initializeEngine(QQmlEngine *engine, [[maybe_unused]] const char *uri);

private:
   static const int _major = 1;
   static const int _minor = 0;
   static const char *_uri;
};
