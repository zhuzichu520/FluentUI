import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Window {
    id:app
    color: "#00000000"
    Component.onCompleted: {
        FluApp.init(app,properties)
        console.debug(properties.installHelper.applicationFilePath())
        FluApp.isDark = false
        FluApp.routes = {
            "/":"qrc:/MainPage.qml",
            "/Setting":"qrc:/SettingPage.qml",
            "/About":"qrc:/AboutPage.qml",
            "/Installer":"qrc:/Installer.qml",
            "/Uninstall":"qrc:/Uninstall.qml"
        }
        if(installHelper.isNavigateUninstall()){
            FluApp.initialRoute = "/Uninstall"
        }else{
            if(installHelper.isNavigateInstall()){
                FluApp.initialRoute = "/Installer"
            }else{
                FluApp.initialRoute = "/"
            }
        }
        FluApp.run()
    }

}
