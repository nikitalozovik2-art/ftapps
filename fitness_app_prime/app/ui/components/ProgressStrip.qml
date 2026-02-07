import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
  id: root
  property real value: 0.08 // 0..1

  implicitHeight: 22

  Glass {
    anchors.fill: parent
    radius: 999
    glassOpacity: 0.10
  }

  // subtle border highlight (premium)
  Rectangle {
    anchors.fill: parent
    radius: 999
    color: "transparent"
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.28)
  }

  Rectangle {
    id: bar
    height: 12
    radius: 999
    anchors.left: parent.left
    anchors.leftMargin: 6
    anchors.verticalCenter: parent.verticalCenter

    // clamp
    width: Math.max(18, (parent.width - 12) * Math.max(0, Math.min(1, root.value)))

    gradient: Gradient {
      GradientStop { position: 0.0; color: "#FF5C7A" }
      GradientStop { position: 0.6; color: "#FF8FB3" }
      GradientStop { position: 1.0; color: "#7AA7FF" }
    }

    Rectangle {
      anchors.fill: parent
      radius: 999
      color: "#FFFFFF"
      opacity: 0.10
    }
  }
}
