#pragma once

#include "baseplot.h"

#include <QElapsedTimer>

class QTimer;

namespace QmlQCustomPlot
{

/*
 * @class TimePlot
 * @brief A class for dynamically updating the x-axis and curves with the current time in milliseconds.
 *
 * This class extends the BasePlot and provides functionalities to dynamically update 
 * a plot with time values. It allows adding time values either individually or in bulk.
 * The x-axis is based on the current time of the day, displaying values within a specified time range.
 */
class TimePlot : public BasePlot
{
    Q_OBJECT
    QML_ELEMENT
    QML_READ_WRITE_NOTIFY_PROPERTY(int, plotTimeRangeInMilliseconds) // Property to hold the time range for the plot display in milliseconds.
public:
    /*
     * @brief Constructor for the TimePlot class.
     * 
     * This constructor initializes the TimePlot object, setting the parent QQuickItem and 
     * initializing the internal timer and elapsed time tracker.
     * 
     * @param parent The parent QQuickItem, default is nullptr.
     */
    explicit TimePlot(QQuickItem *parent = nullptr);

    ~TimePlot() override;

    /*
     * @brief Sets the time range for the plot display in milliseconds.
     * 
     * This function allows the user to specify the range of time (in milliseconds) that the 
     * plot should display on the x-axis. For example, setting this to 60000 will display the 
     * last 60 seconds of data on the plot.
     * Default is 60 seconds
     * 
     * @param value The time range in milliseconds.
     */
    void set_plotTimeRangeInMilliseconds(int value) noexcept;

    /*
     * @brief Sets the time format for the x-axis labels.
     * 
     * This function allows the user to specify the format of the time labels on the x-axis. 
     * The format should be a valid QDateTime format string, such as "hh:mm:ss" or "hh:mm:ss.zzz".
     * Default is "hh:mm:ss".
     * 
     * @param format The format string for the time labels.
     */
    Q_INVOKABLE void setTimeFormat(const QString &format) noexcept;

    /*
     * @brief Adds a current time value to the plot.
     * 
     * This function adds a single data point to the plot. The x-axis value is the current 
     * elapsed time in milliseconds since the timer started, and the y-axis value is provided 
     * by the user. The data point is associated with a specific series name (curve name).
     * 
     * @param name The name of the data series (curve name).
     * @param value The value to be added to the plot.
     */
    Q_INVOKABLE void addCurrentTimeValue(const QString& name, double value) noexcept;

    /*
     * @brief Adds multiple current time values to the plot.
     * 
     * This function allows adding multiple data points to the plot at once. The values are 
     * provided as a QVariantMap, where each key is the name of a data series (curve name) 
     * and the corresponding value is the data point to be added. The x-axis value for all 
     * data points is the current elapsed time in milliseconds.
     * 
     * @param values A map of series names (curve names) and their corresponding values to be added to the plot.
     */
    Q_INVOKABLE void addCurrentTimeValues(QVariantMap values) noexcept;

protected:
    /*
     * @brief Function called when the timer times out.
     * 
     * This function is intended to be overridden by subclasses to define custom behavior 
     * when the timer expires. By default, it does nothing, but it can be used to update 
     * the plot or perform other actions at regular intervals.
     */
    virtual void onTimeOut() noexcept;

public slots:
    void updatePlot() override;

private:
    QTimer *m_timer = nullptr;   ///< Pointer to the QTimer object used to trigger regular updates.
    double m_currentTimeKey = 0; ///< Current time key (x-axis value) in seconds.
    // double m_lastAddedTime = 0;  ///< Time (in milliseconds) of the last added data point.
    double m_lastClearTime = 0;  ///< Time (in milliseconds) of the last clear operation.
};

} // namespace QmlQCustomPlot
