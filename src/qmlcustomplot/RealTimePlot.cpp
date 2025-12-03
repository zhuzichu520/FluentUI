//
// Created by rookie on 2025/11/8.
//

#include "RealTimePlot.h"
#include "qcustomplot.h"
 #include <algorithm>
 #include <limits>

namespace QmlQCustomPlot
{
    RealTimePlot::RealTimePlot(QQuickItem *parent): BasePlot(parent)
    {
        connect(this, &BasePlot::maxBufferChanged, this, [this](){
            this->recvMaxBufferPoints(this->maxBufferPoints());
        });
    }
    RealTimePlot::~RealTimePlot()
    {

    }
    void RealTimePlot::recvMaxBufferPoints(int n)
    {
        m_frontX.reserve(n);
        m_frontY.reserve(n);
        m_backX.reserve(n);
        m_backY.reserve(n);
    }

    Q_INVOKABLE void RealTimePlot::appendBatch(const QVector<double> &x, const QVector<double> &y)
    {
        if (paused()) return;
        if (width() <= 0 || height() <= 0) return;
        if (x.isEmpty() || y.isEmpty()) return;

        QMutexLocker locker(&m_bufLock);
        m_backX = x;
        m_backY = y;
        m_hasNewBatch.store(true, std::memory_order_release);
    }

    void RealTimePlot::updatePlot()
    {
        QCustomPlot * m_customPlot = customPlot();
        if (!m_customPlot) return;
        if (!m_hasNewBatch.load(std::memory_order_acquire)) {
            return;
        }

        {
            QMutexLocker locker(&m_bufLock);
            if (m_hasNewBatch.load(std::memory_order_relaxed)) {
                m_frontX.swap(m_backX);
                m_frontY.swap(m_backY);
                m_hasNewBatch.store(false, std::memory_order_release);
            }
        }

        const auto &gmap = graphs();
        for (auto it = gmap.constBegin(); it != gmap.constEnd(); ++it) {
            it->value<Graph*>()->setData(m_frontX, m_frontY, true);
        }
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
}