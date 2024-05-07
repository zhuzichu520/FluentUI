#ifndef FLUTABLEMODEL_H
#define FLUTABLEMODEL_H

#include <QObject>
#include <QAbstractItemModel>
#include <QtQml/qqml.h>
#include "stdafx.h"

class FluTableModel : public QAbstractTableModel {
Q_OBJECT
Q_PROPERTY_AUTO(QList<QVariantMap>, columnSource)
Q_PROPERTY_AUTO(QList<QVariantMap>, rows)
    Q_PROPERTY(int rowCount READ rowCount CONSTANT)
    QML_NAMED_ELEMENT(FluTableModel)
public:
    enum TableModelRoles {
        RowModel = 0x0101,
        ColumnModel = 0x0102
    };

    explicit FluTableModel(QObject *parent = nullptr);

    [[nodiscard]] int rowCount(const QModelIndex &parent = {}) const override;

    [[nodiscard]] int columnCount(const QModelIndex &parent = {}) const override;

    [[nodiscard]] QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    [[nodiscard]] QModelIndex parent(const QModelIndex &child) const override;

    [[nodiscard]] QModelIndex index(int row, int column, const QModelIndex &parent = {}) const override;

    Q_INVOKABLE void clear();

    Q_INVOKABLE QVariant getRow(int rowIndex);

    Q_INVOKABLE void setRow(int rowIndex, QVariant row);

    Q_INVOKABLE void insertRow(int rowIndex, QVariant row);

    Q_INVOKABLE void removeRow(int rowIndex, int rows = 1);

    Q_INVOKABLE void appendRow(QVariant row);

};


#endif // FLUTABLEMODEL_H
