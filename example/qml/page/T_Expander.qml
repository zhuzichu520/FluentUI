import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Expander")

    FluFrame{
        Layout.fillWidth: true
        height: layout_column.height+20
        padding: 10
        Column{
            id:layout_column
            spacing: 15
            anchors{
                top:parent.top
                left:parent.left
            }

            FluExpander{
                headerText: qsTr("Open a radio box")
                Layout.topMargin: 20
                Item{
                    anchors.fill: parent
                    FluRadioButtons{
                        spacing: 8
                        anchors{
                            top: parent.top
                            left: parent.left
                            topMargin: 15
                            leftMargin: 15
                        }
                        FluRadioButton{
                            text:"Radio Button_1"
                        }
                        FluRadioButton{
                            text:"Radio Button_2"
                        }
                        FluRadioButton{
                            text:"Radio Button_3"
                        }
                    }
                }
            }

            FluExpander{
                Layout.topMargin: 20
                headerText: qsTr("Open a sliding text box")
                Item{
                    anchors.fill: parent
                    Flickable{
                        id:scrollview
                        width: parent.width
                        height: parent.height
                        contentWidth: width
                        boundsBehavior: Flickable.StopAtBounds
                        contentHeight: text_info.height
                        ScrollBar.vertical: FluScrollBar {}
                        FluText{
                            id:text_info
                            width: scrollview.width
                            wrapMode: Text.WrapAnywhere
                            padding: 14
                            text: qsTr("Permit me to observe: the late emperor was taken from us before he could finish his life`s work, the restoration of Han. Today, the empire is still divided in three, and our very survival is threatened. Yet still the officials at court and the soldiers throughout the realm remain loyal to you, your majesty. Because they remember the late emperor, all of them, and they wish to repay his kindness in service to you. This is the moment to extend your divine influence, to honour the memory of the late Emperor and strengthen the morale of your officers. It is not time to listen to bad advice, or close your ears to the suggestions of loyal men.
The court and the administration are as one. Both must be judged by one standard. Those who are loyal and good must get what they deserve, but so must the evil-doers who break the law. This will demonstrate the justice of your rule. There cannot be one law for the court and another for the administration.
Counselors and attendants like Guo Youzhi, Fei Yi, and Dong Yun are all reliable men, loyal of purpose and pure in motive. The late Emperor selected them for office so that they would serve you after his death.These are the men who should be consulted on all palace affairs. Xiang Chong has proved himself a fine general in battle, and the late Emperor believed in him. That is why the assembly has recommended him for overall command. It will keep the troops happy if he is consulted on all military matters.
Xiang Chong has proved himself a fine general in battle, and the late Emperor believed in him. That is why the assembly has recommended him for overall command. It will keep the troops happy if he is consulted on all military matters.
The emperors of the Western Han chose their courtiers wisely, and their dynasty flourished. The emperors of the Eastern Han chose poorly, and they doomed the empire to ruin. Whenever the late Emperor discussed this problem with me, he lamented the failings of Emperors Huan and Ling. Advisors like Guo Youzhi, Fei Yi, Chen Zhen, Zhang Yi, and Jiang Wan – these are all men of great integrity and devotion. I encourage you to trust them, your majesty, if the house of Han is to rise again.
I begin as a common man, farming in my fields in Nanyang, doing what I could to survive in an age of chaos. I never had any interest in making a name for myself as a noble. The late Emperor was not ashamed to visit my cottage and seek my advice. Grateful for his regard, I responded to his appeal and threw myself into his service. Now twenty-one years has passed, the late Emperor always appreciated my caution and, in his final days, entrusted me with his cause.
Since that moment, I have been tormented day and night by the fear that I might let him down. That is why I crossed the Lu river at the height of summer, and entered the wastelands beyond. Now the south has been subdued, and our forces are fully armed.I should lead our soldiers to conquer the northern heartland and attempt to remove the hateful traitors, restore the house of Han, and return it to the former capital.This the way I mean to honor my debt to the late Emperor and fulfill my duty to you. Guo Youzhi, Fei Yi, and Dong Yun are the ones who should be making policy decisions and recommendations.
My only desire is to be permitted to drive out the traitors and restore the Han. If I should let you down, punish my offense and report it to the spirit of the late Emperor. If those three advisors should fail in their duties, then they should be punished for their negligence.Your Majesty, consider your course of action carefully. Seek out good advice, and never forget the late Emperor. I depart now on a long expedition, and I will be forever grateful if you heed my advice. Blinded by my own tears, I know not what I write.")
                        }
                    }
                }
            }
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluExpander{
    headerText: qsTr("Open a radio box")
    Item{
        anchors.fill: parent
        Flickable{
            width: parent.width
            height: parent.height
            contentWidth: width
            contentHeight: text_info.height
            ScrollBar.vertical: FluScrollBar {}
            FluText{
                id:text_info
                width: scrollview.width
                wrapMode: Text.WrapAnywhere
                padding: 14
                text: qsTr("Permit me to observe: the late emperor was taken from us before he could finish his life`s work...")
            }
        }
    }
}'
    }

    FluFrame {
        Layout.fillWidth: true
        padding: 10
        Layout.topMargin: 20
        Column {
            spacing: 15
            FluExpander {
                headerHeight: 60
                contentHeight: content_layout.implicitHeight
                headerDelegate: Component {
                    Item {
                        RowLayout {
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 15
                            }
                            spacing: 15
                            FluImage {
                                width: 20
                                height: 20
                                sourceSize.width: 20
                                sourceSize.height: 20
                                source: "qrc:/example/res/image/favicon.ico"
                            }
                            ColumnLayout {
                                spacing: 0
                                FluText {
                                    text: "FluentUI"
                                }
                                FluText {
                                    text: "%1".arg(AppInfo.version)
                                    textColor: FluTheme.fontSecondaryColor
                                    font.pixelSize: 12
                                }
                            }
                        }
                        FluLoadingButton {
                            id: btn_checkupdate
                            anchors {
                                verticalCenter: parent.verticalCenter
                                right: parent.right
                                rightMargin: 15
                            }
                            text: qsTr("Check for Updates")
                            onClicked: {
                                loading = true;
                                FluEventBus.post("checkUpdate");
                            }
                        }
                        FluEvent {
                            name: "checkUpdateFinish"
                            onTriggered: {
                                btn_checkupdate.loading = false;
                            }
                        }
                    }
                }
                content: ColumnLayout {
                    id: content_layout
                    spacing: 0
                    RowLayout {
                        Layout.topMargin: 15
                        Layout.leftMargin: 15
                        spacing: 0
                        FluText {
                            text: "GitHub: "
                        }
                        FluTextButton {
                            text: "https://github.com/zhuzichu520/FluentUI"
                            onClicked: {
                                Qt.openUrlExternally(text);
                            }
                        }
                    }
                    RowLayout {
                        Layout.bottomMargin: 15
                        Layout.leftMargin: 15
                        spacing: 0
                        FluText {
                            text: "bilibili: "
                        }
                        FluTextButton {
                            text: "https://www.bilibili.com/video/BV1mg4y1M71w"
                            onClicked: {
                                Qt.openUrlExternally(text);
                            }
                        }
                    }
                }
            }

            FluExpander {
                contentHeight: 100
                headerHeight: 45
                headerDelegate: Component {
                    Item {
                        FluToggleButton {
                            anchors.centerIn: parent
                            text: qsTr("This is a ToggleButton in the header")
                        }
                    }
                }
                content: Item {
                    anchors.fill: parent
                    FluButton {
                        anchors.centerIn: parent
                        text: qsTr("This is a StandardButton in the content")
                        onClicked: {
                            showInfo(qsTr("Click StandardButton"))
                        }
                    }
                }
            }
        }
    }

    CodeExpander {
        Layout.fillWidth: true
        Layout.topMargin: -6
        code: 'FluExpander {
    contentHeight: 100
    headerHeight: 45
    headerDelegate: Component {
        Item {
            FluToggleButton {
                anchors.centerIn: parent
                text: qsTr("This is a ToggleButton in the header")
            }
        }
    }
    content: Item {
        anchors.fill: parent
        FluButton {
            anchors.centerIn: parent
            text: qsTr("This is a StandardButton in the content")
            onClicked: {
                showInfo(qsTr("Click StandardButton"))
            }
        }
    }
}'
    }
}
