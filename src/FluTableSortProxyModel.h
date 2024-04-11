#pragma once

#include <QSortFilterProxyModel>
#include <QAbstractTableModel>
#include <QtQml/qqml.h>
#include <QJSValue>
#include "stdafx.h"

class FluTableSortProxyModel : public QSortFilterProxyModel {
Q_OBJECT
Q_PROPERTY_AUTO_P(QAbstractTableModel*, model)
    QML_NAMED_ELEMENT(FluTableSortProxyModel)
public:
    explicit FluTableSortProxyModel(QSortFilterProxyModel *parent = nullptr);

    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

    bool filterAcceptsColumn(int sourceColumn, const QModelIndex &sourceParent) const override;

    bool lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const override;

    Q_INVOKABLE [[maybe_unused]] QVariant getRow(int rowIndex);

    Q_INVOKABLE [[maybe_unused]] void setRow(int rowIndex, const QVariant &val);

    Q_INVOKABLE [[maybe_unused]] void removeRow(int rowIndex, int rows);

    Q_INVOKABLE [[maybe_unused]] [[maybe_unused]] void setComparator(const QJSValue &comparator);

    Q_INVOKABLE [[maybe_unused]] void setFilter(const QJSValue &filter);

private:
    QJSValue _filter;
    QJSValue _comparator;
};