import QtQuick 2.15
import QtGraphicalEffects 1.15

DropShadow {
    radius: 5
    samples: 4
    color: FluApp.isDark ? "#80FFFFFF" : "#40000000"
}
