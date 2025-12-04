//
// Created by rookie on 2025/12/3.
//

#ifndef DATAGENERATOR_H
#define DATAGENERATOR_H


#include <QObject>
#include <QVector>
#include <QTimer>
#include <QRandomGenerator>
#include <QReadWriteLock>
#include <cmath>
#include <QDateTime>

class DataGenerator : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVector<double> xData READ xData NOTIFY dataUpdated)
    Q_PROPERTY(QVector<double> yData READ yData NOTIFY dataUpdated)
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)

public:
    explicit DataGenerator(QObject *parent = nullptr)
        : QObject(parent), m_timer(new QTimer(this)) {

        m_timer->setInterval(50);
        connect(m_timer, &QTimer::timeout, this, &DataGenerator::generateData);

        m_sampleRate = 20000.0;
        m_sineFrequency = 2.0; //Hz
        m_sineAmplitude = 1.5;
        m_noiseAmplitude = 0.03;

        m_xData.reserve(m_sampleRate);
        m_yData.reserve(m_sampleRate);
    }

    ~DataGenerator() override {
        stop();
    }
    QVector<double> xData() const;
    QVector<double> yData() const;
    bool isRunning() const;


public slots:
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void setParameters(double sineFreq, double sineAmp, double noiseAmp);

signals:
    void dataUpdated();
    void runningChanged(bool running);

private slots:
    void generateData();

private:
    double m_sampleRate;
    double m_sineFrequency;
    double m_sineAmplitude;
    double m_noiseAmplitude;

    QVector<double> m_xData;
    QVector<double> m_yData;

    QTimer *m_timer;
    mutable QReadWriteLock m_lock;
};


#endif //DATAGENERATOR_H