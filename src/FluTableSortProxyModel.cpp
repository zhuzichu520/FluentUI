#include "FluTableSortProxyModel.h"

#include <QJSValueList>

FluTableSortProxyModel::FluTableSortProxyModel(QSortFilterProxyModel *parent)
    : QSortFilterProxyModel {parent}
{
    _model = nullptr;
    connect(this,&FluTableSortProxyModel::modelChanged,this,[=]{
        setSourceModel(this->model());
        sort(0,Qt::AscendingOrder);
    });
}

bool FluTableSortProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const{
    return true;
}

bool FluTableSortProxyModel::filterAcceptsColumn(int source_column, const QModelIndex &source_parent) const{
    return true;
}

bool FluTableSortProxyModel::lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const{
    QJSValue comparator = _comparator;
    if(comparator.isNull()){
        return true;
    }
    QJSValueList data;
    data<<source_left.row();
    data<<source_right.row();
    bool flag = comparator.call(data).toBool();
    if(sortOrder()==Qt::AscendingOrder){
        return !flag;
    }else{
        return flag;
    }
}

void FluTableSortProxyModel::setSortComparator(QJSValue comparator){
    this->_comparator = comparator;
    if(sortOrder()==Qt::AscendingOrder){
        sort(0,Qt::DescendingOrder);
    }else{
        sort(0,Qt::AscendingOrder);
    }
}
QVariant FluTableSortProxyModel::getRow(int rowIndex){
    QVariant result;
    QMetaObject::invokeMethod(_model, "getRow",Q_RETURN_ARG(QVariant, result),Q_ARG(int, mapToSource(index(rowIndex,0)).row()));
    return result;
}

void FluTableSortProxyModel::setRow(int rowIndex,QVariant val){
    QMetaObject::invokeMethod(_model, "setRow",Q_ARG(int, mapToSource(index(rowIndex,0)).row()),Q_ARG(QVariant,val));
}

void FluTableSortProxyModel::removeRow(int rowIndex,int rows){
    QMetaObject::invokeMethod(_model, "removeRow",Q_ARG(int, mapToSource(index(rowIndex,0)).row()),Q_ARG(int,rows));
}

