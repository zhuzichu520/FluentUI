#include "FluTreeModel.h"

#include <QMetaEnum>

FluTreeModel::FluTreeModel(QObject *parent)
    : QAbstractTableModel{parent}
{

}

int FluTreeModel::rowCount(const QModelIndex &parent) const {
    return _rows.count();
};

int FluTreeModel::columnCount(const QModelIndex &parent) const {
    return 1;;
};

QVariant FluTreeModel::data(const QModelIndex &index, int role) const {
    switch (role) {
    case Qt::DisplayRole:
        return  QVariant::fromValue(_rows.at(index.row()));
    default:
        break;
    }
    return QVariant();
};

QHash<int, QByteArray> FluTreeModel::roleNames() const {
    return { {Qt::DisplayRole, "display"} };
};

void FluTreeModel::setData(QList<QObject*> data){
    beginResetModel();
    _rows = data;
    endResetModel();
}

void FluTreeModel::removeRows(int row,int count){
    if (row < 0 || row + count > _rows.size())
        return;
    beginRemoveRows(QModelIndex(),row, row + count - 1);
    for (int i = 0; i < count; ++i) {
        _rows.removeAt(row);
    }
    endRemoveRows();
}

void FluTreeModel::insertRows(int row,QList<QObject*> data){
    if (row < 0 || row > _rows.size())
        return;
    beginInsertRows(QModelIndex(), row, row + data.size() - 1);
    for (const auto& item : data) {
        _rows.insert(row++, item);
    }
    endInsertRows();
}

QObject* FluTreeModel::getRow(int row){
    return _rows.at(row);
}
