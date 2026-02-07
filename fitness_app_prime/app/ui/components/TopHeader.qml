import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
  id: root
  property string title: "Training Upper Body"
  property string subtitle: ""
  property real progressValue: 0.0
  signal resetDay()

  implicitHeight: 92

  Glass {
    anchors.fill: parent
    radius: 28
    glassOpacity: 0.20
  }

  RowLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 14

    // Avatar
    Rectangle {
      Layout.preferredWidth: 44
      Layout.preferredHeight: 44
      Layout.maximumHeight: 44
      Layout.alignment: Qt.AlignVCenter

      radius: 16
      color: "#ffffff"
      border.width: 1
      border.color: Qt.rgba(1,1,1,0.35)

      Text {
        anchors.centerIn: parent
        text: "NI"
        font.pixelSize: 14
        font.weight: Font.DemiBold
        color: "#0b1520"
      }
    }

    // Title / subtitle
    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: 4

      Text {
        text: root.title
        font.pixelSize: 18
        font.weight: Font.DemiBold
        color: "#0b1520"
        elide: Text.ElideRight
        Layout.fillWidth: true
      }

      Text {
        text: root.subtitle
        font.pixelSize: 12
        color: Qt.rgba(0.15,0.25,0.35,0.65)
        elide: Text.ElideRight
        visible: root.subtitle.length > 0
        Layout.fillWidth: true
      }
    }

    // Right block: compact progress + button
    RowLayout {
      Layout.alignment: Qt.AlignVCenter
      spacing: 12

      // ✅ Compact progress pill (фиксируем Layout-ом)
      Glass {
        radius: 16
        glassOpacity: 0.16

        Layout.preferredWidth: 120
        Layout.preferredHeight: 44
        Layout.maximumHeight: 44
        Layout.alignment: Qt.AlignVCenter

        Row {
          anchors.centerIn: parent
          spacing: 8

          Rectangle {
            width: 18
            height: 18
            radius: 9
            color: Qt.rgba(0.6,0.6,0.7,0.35)
          }

          Column {
            spacing: 2
            Text {
              text: "Progress"
              font.pixelSize: 10
              color: Qt.rgba(0.15,0.25,0.35,0.65)
            }
            Text {
              text: Math.round(Math.max(0, Math.min(1, root.progressValue)) * 100) + "%"
              font.pixelSize: 12
              font.weight: Font.DemiBold
              color: "#0b1520"
            }
          }
        }
      }

      // Button (тоже фиксируем Layout-ом)
      SoftButton {
        text: "Сброс дня"
        Layout.preferredWidth: 120
        Layout.preferredHeight: 44
        Layout.maximumHeight: 44
        Layout.alignment: Qt.AlignVCenter
        onClicked: root.resetDay()
      }
    }
  }
}
