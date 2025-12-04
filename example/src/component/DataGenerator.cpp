//
// Created by rookie on 2025/12/3.
//

#include "DataGenerator.h"


QVector<double> DataGenerator::xData() const {
    QReadLocker locker(&m_lock);
    return m_xData;
}

QVector<double> DataGenerator::yData() const {
    QReadLocker locker(&m_lock);
    return m_yData;
}

bool DataGenerator::isRunning() const {
    return m_timer->isActive();
}

Q_INVOKABLE void DataGenerator::start() {
    if (!m_timer->isActive()) {
      m_timer->start();
      emit runningChanged(true);
      generateData();
    }
}

Q_INVOKABLE void DataGenerator::stop() {
    if (m_timer->isActive()) {
      m_timer->stop();
      emit runningChanged(false);
    }
}

Q_INVOKABLE void DataGenerator::setParameters(double sineFreq, double sineAmp, double noiseAmp) {
    QWriteLocker locker(&m_lock);
    m_sineFrequency = sineFreq;
    m_sineAmplitude = sineAmp;
    m_noiseAmplitude = noiseAmp;
}

void DataGenerator::generateData() {
    QWriteLocker locker(&m_lock);

    m_xData.clear();
    m_yData.clear();

    double dt = 1.0 / m_sampleRate;

    for (int i = 0; i < m_sampleRate; ++i) {
        double t = i * dt;

        double sineValue = m_sineAmplitude * std::sin(2 * M_PI * m_sineFrequency * t);

        double randomValue = (QRandomGenerator::global()->generateDouble() - 0.5) * 2.0;
        double noiseValue = m_noiseAmplitude * randomValue;//-0.03~0.03

        m_xData.append(t);
        m_yData.append(sineValue + noiseValue);
    }

    emit dataUpdated();
}