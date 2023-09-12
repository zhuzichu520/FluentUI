import QtQuick 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"

FluViewModel{

    objectName: "SettingsViewModel"
    property int displayMode

    onInitData: {
        displayMode = FluNavigationViewType.Auto
    }

}
