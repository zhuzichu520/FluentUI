#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
#pragma ide diagnostic ignored "google-default-arguments"
#pragma once

#include <QObject>
#include <QAbstractTableModel>
#include <QJsonArray>
#include <QVariant>
#include <QtQml/qqml.h>
#include "stdafx.h"

/**
 * @brief The FluTreeNode class
 */
class FluTreeNode : public QObject {
Q_OBJECT
    Q_PROPERTY(QVariantMap data READ data CONSTANT)
    Q_PROPERTY(int depth READ depth CONSTANT)
    Q_PROPERTY(bool isExpanded READ isExpanded CONSTANT)
    Q_PROPERTY(bool checked READ checked CONSTANT)
public:
    explicit FluTreeNode(QObject *parent = nullptr);

    Q_INVOKABLE [[nodiscard]] int depth() const { return _depth; };
    Q_INVOKABLE [[nodiscard]] bool isExpanded() const { return _isExpanded; };
    Q_INVOKABLE [[nodiscard]] QVariantMap data() const { return _data; };
    Q_INVOKABLE [[nodiscard]] bool hasChildren() const { return !_children.isEmpty(); };
    Q_INVOKABLE bool hasNextNodeByIndex(int index) {
        FluTreeNode *p = this;
        for (int i = 0; i <= _depth - index - 1; i++) {
            p = p->_parent;
        }
        if (p->_parent->_children.indexOf(p) == p->_parent->_children.count() - 1) {
            return false;
        }
        return true;
    }

    Q_INVOKABLE [[nodiscard]] bool checked() const {
        if (!hasChildren()) {
            return _checked;
        }
        for (int i = 0; i <= _children.size() - 1; ++i) {
            auto item = _children.at(i);
            if (!item->checked()) {
                return false;
            }
        }
        return true;
    };
    Q_INVOKABLE bool hideLineFooter() {
        if (_parent) {
            auto childIndex = _parent->_children.indexOf(this);
            if (childIndex == _parent->_children.count() - 1) {
                return true;
            }
            if (_parent->_children.at(childIndex + 1)->hasChildren()) {
                return true;
            }
            return false;
        }
        return false;
    };

    [[nodiscard]] bool isShown() const {
        auto p = _parent;
        while (p) {
            if (!p->_isExpanded) {
                return false;
            }
            p = p->_parent;
        }
        return true;
    }

public:
    QString _title = "";
    int _depth = 0;
    bool _checked = false;
    bool _isExpanded = true;
    QVariantMap _data;
    QList<FluTreeNode *> _children;
    FluTreeNode *_parent = nullptr;
};

class FluTreeModel : public QAbstractItemModel {
Q_OBJECT
Q_PROPERTY_AUTO(int, dataSourceSize)
Q_PROPERTY_AUTO(QList<FluTreeNode *>, selectionModel)
Q_PROPERTY_AUTO(QList<QVariantMap>, columnSource)
    QML_NAMED_ELEMENT(FluTreeModel)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum TreeModelRoles {
        RowModel = 0x0101,
        ColumnModel = 0x0102
    };

    explicit FluTreeModel(QObject *parent = nullptr);

    [[nodiscard]] int rowCount(const QModelIndex &parent = {}) const override;

    [[nodiscard]] int columnCount(const QModelIndex &parent = {}) const override;

    [[nodiscard]] QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    [[nodiscard]] QModelIndex parent(const QModelIndex &child) const override;

    [[nodiscard]] QModelIndex index(int row, int column, const QModelIndex &parent = {}) const override;

    Q_INVOKABLE void removeRows(int row, int count);

    Q_INVOKABLE void insertRows(int row, const QList<FluTreeNode *> &data);

    Q_INVOKABLE QObject *getRow(int row);

    Q_INVOKABLE void setRow(int row, QVariantMap data);

    Q_INVOKABLE void setData(QList<FluTreeNode *> data);

    Q_INVOKABLE void setDataSource(QList<QMap<QString, QVariant>> data);

    Q_INVOKABLE void collapse(int row);

    Q_INVOKABLE void expand(int row);

    Q_INVOKABLE FluTreeNode *getNode(int row);

    Q_INVOKABLE void refreshNode(int row);

    Q_INVOKABLE void checkRow(int row, bool checked);

    Q_INVOKABLE bool hitHasChildrenExpanded(int row);

    Q_INVOKABLE void allExpand();

    Q_INVOKABLE void allCollapse();

private:
    QList<FluTreeNode *> _rows;
    QList<FluTreeNode *> _dataSource;
    FluTreeNode *_root = nullptr;
};

#pragma clang diagnostic pop