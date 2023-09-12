import QtQuick
import FluentUI

FluViewModel{

    objectName: "SettingsViewModel"
    property int displayMode

    onInitData: {
        displayMode = FluNavigationViewType.Auto
    }

}
