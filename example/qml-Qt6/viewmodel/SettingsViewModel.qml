import QtQuick
import FluentUI

FluViewModel{

    objectName: "SettingsViewModel"
    scope: FluViewModelType.Application
    property int displayMode

    onInitData: {
        displayMode = FluNavigationViewType.Auto
    }

}
