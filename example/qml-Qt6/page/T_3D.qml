import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI
import Qt3D.Core
import Qt3D.Render
import Qt3D.Input
import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Dialogs
import Qt.labs.platform
import "../component"

FluContentPage{

    id:root
    title:"3D"

    Scene3D{
        id:scene_3d
        anchors.fill: parent
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio
        Entity {
            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 22.5
                aspectRatio: scene_3d.width / scene_3d.height
                nearPlane: 1
                farPlane: 1000.0
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                position: Qt.vector3d( 0.0, 0.0, 15.0 )
            }
            FirstPersonCameraController {
                linearSpeed: 100
                lookSpeed: 50
                camera: camera
            }
            components: [
                RenderSettings{
                    activeFrameGraph: ForwardRenderer{
                        clearColor: Qt.rgba(0,0,0,0);
                        camera: camera
                    }
                },
                InputSettings{}
            ]
            Mesh {
                id: mesh
                source: "https://zhu-zichu.gitee.io/test.obj"
            }
            PhongMaterial {
                id: material
                ambient: color_picker.colorValue
            }
            Transform{
                id:transform
                scale: 1.0
                translation: Qt.vector3d(0, 0, 0)
                rotation: fromEulerAngles(0, 0, 0)
                property real hAngle:0.0
                NumberAnimation on hAngle{
                    from:0
                    to:360.0
                    duration: 5000
                    loops: Animation.Infinite
                }
                matrix:{
                    var m=Qt.matrix4x4();
                    m.rotate(hAngle,Qt.vector3d(0,1,0));
                    m.translate(Qt.vector3d(0,0,0));
                    return m;
                }
            }
            Entity {
                id: entity
                components: [mesh, material,transform]
            }
        }
    }
    ColumnLayout{
        RowLayout{
            spacing: 10
            Layout.topMargin: 20
            FluText{
                text:"tintColor:"
                Layout.alignment: Qt.AlignVCenter
            }
            FluColorPicker{
                id:color_picker
                enableAlphaChannel:false
                Component.onCompleted: {
                    setColor("gray")
                }
            }
        }

        FluButton{
            text:"选择obj资源"
            onClicked: {
                file_dialog.open()
            }
        }
    }

    FileDialog {
        id: file_dialog
        nameFilters: ["Obj files (*.obj)"]
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            var fileUrl =  file_dialog.currentFile
            mesh.source = fileUrl
        }
    }

}
