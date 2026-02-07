import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
  id: root

  property string text: "Button"
  property bool active: false

  // ✅ ДОБАВИЛ: теперь можно писать radius: 12 / 18 / 22 снаружи
  property int radius: 18

  // (не обязательно, но удобно)
  property color textColor: "#0b1520"

  signal clicked()

  implicitWidth: 200
  implicitHeight: 44

  background: Rectangle {
    // ✅ теперь radius задаётся снаружи
    radius: root.radius
    color: root.active ? Qt.rgba(1,1,1,0.95) : Qt.rgba(1,1,1,0.55)
    border.width: 1
    border.color: root.active ? Qt.rgba(0.25,0.55,1.0,0.45) : Qt.rgba(1,1,1,0.35)
  }

  contentItem: Text {
    text: root.text
    color: root.textColor
    font.pixelSize: 14
    font.weight: Font.DemiBold
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
