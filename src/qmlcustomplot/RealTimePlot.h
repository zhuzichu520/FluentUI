//
// Created by rookie on 2025/11/8.
//

#ifndef REALTIMEPLOT_H
#define REALTIMEPLOT_H

#pragma once

#include <QQuickPaintedItem>
#include <QVariant>
#include "qcustomplot.h"
#include <QMutex>
#include <QMutexLocker>
#include <atomic>
#include "macros.h"
#include "axis.h"
#include "baseplot.h"

namespace QmlQCustomPlot
{
    class Axis;
    class RealTimePlot : public BasePlot {
        Q_OBJECT
        QML_ELEMENT

    public:
        explicit RealTimePlot(QQuickItem *parent = nullptr);
        ~RealTimePlot() override;

    private:
        void recvMaxBufferPoints(int n);

    public slots:
        Q_INVOKABLE void appendBatch(const QVector<double> &x, const QVector<double> &y) override;
        void updatePlot() override;

    private:
        // 双缓冲以减少锁竞争：写入后备缓冲，在绘制线程（GUI）中与前台缓冲交换
        QVector<double> m_frontX;
        QVector<double> m_frontY;
        QVector<double> m_backX;
        QVector<double> m_backY;
        QMutex m_bufLock;
        std::atomic<bool> m_hasNewBatch{false};
    };
}
#endif //REALTIMEPLOT_H