import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 88
    height: parent ? parent.height : 600

    signal navigate(int index)

    property int currentIndex: 1

    readonly property var items: [
        { idx: 0, label: "Home", icon: "../assets/icons/home_dark.svg" },
        { idx: 1, label: "Training", icon: "../assets/icons/training_dark.svg" },
        { idx: 2, label: "Progress", icon: "../assets/icons/progress_dark.svg" }
    ]

    Column {
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 64
        spacing: 14

        Repeater {
            model: root.items

            delegate: Item {
                width: 56
                height: 56

                property bool active: root.currentIndex === modelData.idx

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: active ? Qt.rgba(0.08, 0.08, 0.10, 0.06) : Qt.rgba(1, 1, 1, 0.0)
                    border.width: 1
                    border.color: active ? Qt.rgba(0.08, 0.08, 0.10, 0.08) : "transparent"
                    Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.InOutQuad } }
                    Behavior on border.color { ColorAnimation { duration: 180; easing.type: Easing.InOutQuad } }
                }

                Image {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    opacity: active ? 1.0 : 0.72
                    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
                }

                Rectangle {
                    id: tooltip
                    anchors.left: parent.right
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    height: 32
                    width: tooltipText.implicitWidth + 20
                    radius: 10
                    color: Qt.rgba(0.08, 0.08, 0.10, 0.06)
                    border.width: 1
                    border.color: Qt.rgba(0.08, 0.08, 0.10, 0.10)
                    visible: false
                    opacity: 0.0

                    Text {
                        id: tooltipText
                        anchors.centerIn: parent
                        text: modelData.label
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        color: "#141419"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        tooltip.visible = true
                        tooltip.opacity = 1.0
                    }
                    onExited: {
                        tooltip.opacity = 0.0
                        tooltip.visible = false
                    }
                    onClicked: {
                        root.currentIndex = modelData.idx
                        root.navigate(modelData.idx)
                    }
                }
            }
        }
    }
}
