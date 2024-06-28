#pragma once

#define Q_PROPERTY_AUTO_P(TYPE, M)                                                                 \
    Q_PROPERTY(TYPE M MEMBER _##M NOTIFY M##Changed)                                               \
public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(TYPE in_##M) {                                                                          \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
    }                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
    }                                                                                              \
                                                                                                   \
private:                                                                                           \
    TYPE _##M;

#define Q_PROPERTY_AUTO(TYPE, M)                                                                   \
    Q_PROPERTY(TYPE M MEMBER _##M NOTIFY M##Changed)                                               \
public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(const TYPE &in_##M) {                                                                   \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
    }                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
    }                                                                                              \
                                                                                                   \
private:                                                                                           \
    TYPE _##M;


#define Q_PROPERTY_READONLY_AUTO(TYPE, M)                                                          \
    Q_PROPERTY(TYPE M READ M NOTIFY M##Changed FINAL)                                              \
public:                                                                                            \
    Q_SIGNAL void M##Changed();                                                                    \
    void M(const TYPE &in_##M) {                                                                   \
        _##M = in_##M;                                                                             \
        Q_EMIT M##Changed();                                                                       \
    }                                                                                              \
    TYPE M() {                                                                                     \
        return _##M;                                                                               \
    }                                                                                              \
                                                                                                   \
private:                                                                                           \
    TYPE _##M;
