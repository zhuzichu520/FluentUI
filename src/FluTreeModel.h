#ifndef FLUTREEMODEL_H
#define FLUTREEMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QtQml/qqml.h>

class FluTreeModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluTreeModel)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    explicit FluTreeModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void removeRows(int row,int count);
    Q_INVOKABLE void insertRows(int row,QList<QObject*> data);
    Q_INVOKABLE QObject* getRow(int row);
    Q_INVOKABLE void setData(QList<QObject*> data);
private:
    QList<QObject*> _rows;
};

#endif // FLUTREEMODEL_H
