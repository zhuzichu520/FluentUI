#include "FluTreeModel.h"

#include <QMetaEnum>

Node::Node(QObject *parent): QObject{parent}{
}

FluTreeModel::FluTreeModel(QObject *parent): QAbstractItemModel{parent}{
    dataSourceSize(0);
}

QModelIndex FluTreeModel::parent(const QModelIndex &child) const{
    return QModelIndex();
}

QModelIndex FluTreeModel::index(int row, int column,const QModelIndex &parent) const{
    if (!hasIndex(row, column, parent) || parent.isValid())
        return QModelIndex();
    return createIndex(row, column, _rows.at(row));
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
    return { {Qt::DisplayRole, "modelData"} };
};

void FluTreeModel::setData(QList<Node*> data){
    beginResetModel();
    _rows = data;
    endResetModel();
}

void FluTreeModel::removeRows(int row,int count){
    if (row < 0 || row + count > _rows.size() || count==0)
        return;
    beginRemoveRows(QModelIndex(),row, row + count - 1);
    QList<Node*> firstPart = _rows.mid(0,row);
    QList<Node*> secondPart = _rows.mid(row + count);
    _rows.clear();
    _rows.append(firstPart);
    _rows.append(secondPart);
    endRemoveRows();
}

void FluTreeModel::insertRows(int row,QList<Node*> data){
    if (row < 0 || row > _rows.size() || data.size() == 0)
        return;;
    beginInsertRows(QModelIndex(), row, row + data.size() - 1);
    QList<Node*> firstPart = _rows.mid(0, row);
    QList<Node*> secondPart = _rows.mid(row);
    _rows.clear();
    _rows.append(firstPart);
    _rows.append(data);
    _rows.append(secondPart);
    endInsertRows();
}

QObject* FluTreeModel::getRow(int row){
    return _rows.at(row);
}

void FluTreeModel::checkRow(int row,bool chekced){
    auto itemData = _rows.at(row);
    if(itemData->hasChildren()){
        QList<Node*> stack = itemData->_children;
        std::reverse(stack.begin(), stack.end());
        while (stack.count() > 0) {
            auto item = stack.at(stack.count()-1);
            stack.pop_back();
            if(!item->hasChildren()){
                item->_checked = chekced;
            }
            QList<Node*> children = item->_children;
            if(!children.isEmpty()){
                std::reverse(children.begin(), children.end());
                foreach (auto c, children) {
                    stack.append(c);
                }
            }
        }
    }else{
        if(itemData->_checked == chekced){
            return;
        }
        itemData->_checked = chekced;
    }
    Q_EMIT layoutChanged(QList<QPersistentModelIndex>(),QAbstractItemModel::VerticalSortHint);
    QList<Node*> data;
    foreach (auto item, _dataSource) {
        if(!item->hasChildren()){
            if(item->_checked){
                data.append(item);
            }
        }
    }
    selectionModel(data);
}

void FluTreeModel::setDataSource(QList<QMap<QString,QVariant>> data){
    _dataSource.clear();
    if(_root){
        delete _root;
        _root = nullptr;
    }
    _root = new Node(this);
    std::reverse(data.begin(), data.end());
    while (data.count() > 0) {
        auto item = data.at(data.count()-1);
        data.pop_back();
        Node* node = new Node(this);
        node->_title = item.value("title").toString();
        node->_key = item.value("key").toString();
        node->_depth = item.value("__depth").toInt();
        node->_parent = item.value("__parent").value<Node*>();
        node->_isExpanded = true;
        if(node->_parent){
            node->_parent->_children.append(node);
        }else{
            node->_parent = _root;
            _root->_children.append(node);
        }
        _dataSource.append(node);
        if (item.contains("children")) {
            QList<QVariant> children = item.value("children").toList();
            if(!children.isEmpty()){
                std::reverse(children.begin(), children.end());
                for (int i = 0; i < children.count(); ++i) {
                    auto child = children.at(i).toMap();
                    child.insert("__depth",item.value("__depth").toInt(0)+1);
                    child.insert("__parent",QVariant::fromValue(node));
                    data.append(child);
                }
            }
        }
    }
    beginResetModel();
    _rows = _dataSource;
    endResetModel();
    dataSourceSize(_dataSource.size());
}

void FluTreeModel::collapse(int row){
    if(!_rows.at(row)->_isExpanded){
        return;
    }
    _rows.at(row)->_isExpanded = false;
    Q_EMIT dataChanged(index(row,0),index(row,0));
    auto modelData = _rows.at(row);
    int removeCount = 0;
    for(int i=row+1;i<_rows.count();i++){
        auto obj = _rows[i];
        if(obj->_depth<=modelData->_depth){
            break;
        }
        removeCount = removeCount + 1;
    }
    removeRows(row+1,removeCount);
}

void FluTreeModel::expand(int row){
    if(_rows.at(row)->_isExpanded){
        return;
    }
    _rows.at(row)->_isExpanded = true;
    Q_EMIT dataChanged(index(row,0),index(row,0));
    auto modelData = _rows.at(row);
    QList<Node*> insertData;
    QList<Node*> stack = modelData->_children;
    std::reverse(stack.begin(), stack.end());
    while (stack.count() > 0) {
        auto item = stack.at(stack.count()-1);
        stack.pop_back();
        if(item->isShown()){
            insertData.append(item);
        }
        QList<Node*> children = item->_children;
        if(!children.isEmpty()){
            std::reverse(children.begin(), children.end());
            foreach (auto c, children) {
                stack.append(c);
            }
        }
    }
    insertRows(row+1,insertData);
}

void FluTreeModel::dragAnddrop(int dragIndex,int dropIndex,bool isDropTopArea){
    if(dropIndex>_rows.count() || dropIndex<0){
        return;
    }
    auto dragItem = _rows[dragIndex];
    auto dropItem = _rows[dropIndex];
    int targetIndex;
    if(dropIndex > dragIndex){
        if(isDropTopArea){
            targetIndex = dropIndex;
        }else{
            targetIndex = dropIndex+1;
        }
    }else{
        if(isDropTopArea){
            targetIndex = dropIndex;
        }else{
            targetIndex = dropIndex+1;
        }
    }
    if (!beginMoveRows(QModelIndex(), dragIndex, dragIndex, QModelIndex(), targetIndex)) {
        return;
    }
    if(dropIndex > dragIndex){
        if(isDropTopArea){
            targetIndex = dropIndex-1;
        }else{
            targetIndex = dropIndex;
        }
    }else{
        if(isDropTopArea){
            targetIndex = dropIndex;
        }else{
            targetIndex = dropIndex+1;
        }
    }
    _rows.move(dragIndex,targetIndex);
    endMoveRows();

    Q_EMIT layoutAboutToBeChanged();
    if(dragItem->_parent == dropItem->_parent){
        QList<Node*>* children = &(dragItem->_parent->_children);
        int srcIndex = children->indexOf(dragItem);
        int destIndex = children->indexOf(dropItem);
        if(dropIndex > dragIndex){
            if(isDropTopArea){
                targetIndex = destIndex-1;
            }else{
                targetIndex = destIndex;
            }
        }else{
            if(isDropTopArea){
                targetIndex = destIndex;
            }else{
                targetIndex = destIndex+1;
            }
        }
        children->move(srcIndex,targetIndex);
    }else{
        QList<Node*>* srcChildren = &(dragItem->_parent->_children);
        QList<Node*>* destChildren = &(dropItem->_parent->_children);
        int srcIndex = srcChildren->indexOf(dragItem);
        int destIndex = destChildren->indexOf(dropItem);
        dragItem->_depth = dropItem->_depth;
        dragItem->_parent = dropItem->_parent;
        if(dragItem->hasChildren()){
            QList<Node*> stack = dragItem->_children;
            foreach (auto node, stack) {
                node->_depth = dragItem->_depth+1;
            }
            std::reverse(stack.begin(), stack.end());
            while (stack.count() > 0) {
                auto item = stack.at(stack.count()-1);
                stack.pop_back();
                QList<Node*> children = item->_children;
                if(!children.isEmpty()){
                    std::reverse(children.begin(), children.end());
                    foreach (auto c, children) {
                        c->_depth = item->_depth+1;
                        stack.append(c);
                    }
                }
            }
        }
        srcChildren->removeAt(srcIndex);
        if(dropIndex > dragIndex){
            if(isDropTopArea){
                targetIndex = destIndex;
            }else{
                targetIndex = destIndex + 1;
            }
        }else{
            if(isDropTopArea){
                targetIndex = destIndex;
            }else{
                targetIndex = destIndex + 1;
            }
        }
        destChildren->insert(targetIndex,dragItem);
    }
    changePersistentIndex(index(qMin(dragIndex,dropIndex),0),index(qMax(dragIndex,dropIndex),0));
    Q_EMIT layoutChanged(QList<QPersistentModelIndex>(),QAbstractItemModel::VerticalSortHint);

}

bool FluTreeModel::hitHasChildrenExpanded(int row){
    auto itemData = _rows.at(row);
    if(itemData->hasChildren() && itemData->_isExpanded){
        return true;
    }
    return false;
}

void FluTreeModel::refreshNode(int row){
    Q_EMIT dataChanged(index(row,0),index(row,0));
};

Node* FluTreeModel::getNode(int row){
    return _rows.at(row);
}

void FluTreeModel::allExpand(){
    beginResetModel();
    QList<Node*> data;
    QList<Node*> stack = _root->_children;
    std::reverse(stack.begin(), stack.end());
    while (stack.count() > 0) {
        auto item = stack.at(stack.count()-1);
        stack.pop_back();
        if(item->hasChildren()){
            item->_isExpanded = true;
        }
        data.append(item);
        QList<Node*> children = item->_children;
        if(!children.isEmpty()){
            std::reverse(children.begin(), children.end());
            foreach (auto c, children) {
                stack.append(c);
            }
        }
    }
    _rows = data;
    endResetModel();
}
void FluTreeModel::allCollapse(){
    beginResetModel();
    QList<Node*> stack = _root->_children;
    std::reverse(stack.begin(), stack.end());
    while (stack.count() > 0) {
        auto item = stack.at(stack.count()-1);
        stack.pop_back();
        if(item->hasChildren()){
            item->_isExpanded = false;
        }
        QList<Node*> children = item->_children;
        if(!children.isEmpty()){
            std::reverse(children.begin(), children.end());
            foreach (auto c, children) {
                stack.append(c);
            }
        }
    }
    _rows = _root->_children;
    endResetModel();
}
