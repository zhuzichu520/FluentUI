#ifndef FLUTABLESORTPROXYMODEL_H
#define FLUTABLESORTPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QAbstractTableModel>
#include <QtQml/qqml.h>
#include <QJSValue>
#include "stdafx.h"

class FluTableSortProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QAbstractTableModel*,model)
    QML_NAMED_ELEMENT(FluTableSortProxyModel)
public:
    explicit FluTableSortProxyModel(QSortFilterProxyModel *parent = nullptr);
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool filterAcceptsColumn(int sourceColumn, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const override;
    Q_INVOKABLE QVariant getRow(int rowIndex);
    Q_INVOKABLE void setRow(int rowIndex,QVariant val);
    Q_INVOKABLE void removeRow(int rowIndex,int rows);
    Q_INVOKABLE void setComparator(QJSValue comparator);
    Q_INVOKABLE void setFilter(QJSValue filter);
private:
    QJSValue _filter;
    QJSValue _comparator;
};

#endif // FLUTABLESORTPROXYMODEL_H
