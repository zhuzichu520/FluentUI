import QtQuick
import FluentUI
import "qrc:///example/qml/component"

FluViewModel{

    objectName: "SettingsViewModel"
    property int displayMode

    onInitData: {
        displayMode = FluNavigationViewType.Auto
    }

}
