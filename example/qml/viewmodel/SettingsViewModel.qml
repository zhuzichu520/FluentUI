import QtQuick 2.15
import FluentUI 1.0

FluViewModel{

    objectName: "SettingsViewModel"
    scope: FluViewModelType.Application
    property int displayMode

    onInitData: {
        displayMode = FluNavigationViewType.Auto
    }

}
