import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "../components"

Item {
  id: root
  Layout.fillWidth: true
  Layout.fillHeight: true

  property string uiFont: "Segoe UI Variable Text"

  // Technique context
  property string currentExerciseTitle: ""
  property string currentExerciseMeta: ""

  // Rest context
  property string restExerciseTitle: ""
  property int restTotalSeconds: 102  // 1:42
  property int restRemainingSeconds: restTotalSeconds
  property bool restPaused: false

  function formatTime(sec) {
    var m = Math.floor(sec / 60)
    var s = sec % 60
    return m + ":" + (s < 10 ? "0" + s : s)
  }

  function openTechnique(title, meta) {
    currentExerciseTitle = title
    currentExerciseMeta = meta
    techniquePopup.open()
  }

  function openRest(title) {
    restExerciseTitle = title
    restRemainingSeconds = restTotalSeconds
    restPaused = false
    restTimer.running = true
    restPopup.open()
  }

  component UiText: Text {
    font.family: root.uiFont
    renderType: Text.NativeRendering
  }

  component PillBtn: Item {
    id: pb
    property string text: ""
    property bool active: false
    property int px: 12
    signal clicked()

    implicitHeight: 30
    implicitWidth: Math.max(92, label.implicitWidth + 26)

    Rectangle {
      anchors.fill: parent
      radius: 999
      color: pb.active ? Qt.rgba(1,1,1,0.95) : Qt.rgba(1,1,1,0.72)
      border.width: 1
      border.color: Qt.rgba(0,0,0,0.06)
    }

    UiText {
      id: label
      anchors.centerIn: parent
      text: pb.text
      font.pixelSize: pb.px
      font.weight: Font.DemiBold
      color: "#0b1520"
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: pb.clicked()
    }
  }

  // DayChip fixed: padding=0 + visually centered
  component DayChip: Item {
    id: dc
    property string text: ""
    property bool active: false
    property color accent: "#FF6B7A"
    signal clicked()

    implicitHeight: 44
    implicitWidth: Math.max(130, chipText.implicitWidth + 34)

    Glass { anchors.fill: parent; radius: 18; glassOpacity: dc.active ? 0.12 : 0.14; padding: 0 }

    Rectangle {
      anchors.fill: parent
      radius: 18
      color: dc.active ? Qt.rgba(dc.accent.r, dc.accent.g, dc.accent.b, 0.20) : Qt.rgba(0,0,0,0)
    }

    UiText {
      id: chipText
      anchors.centerIn: parent
      text: dc.text
      font.pixelSize: 13
      font.weight: Font.DemiBold
      color: "#0b1520"
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: dc.clicked()
    }
  }

  component DumbbellIcon: Item {
    id: di
    property color stroke: Qt.rgba(0.10,0.20,0.35,0.85)
    implicitWidth: 22
    implicitHeight: 22

    Canvas {
      anchors.fill: parent
      onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        ctx.lineWidth = 2.2;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";
        ctx.strokeStyle = di.stroke;

        var w = width, h = height;
        var cy = h*0.5;

        ctx.beginPath(); ctx.moveTo(w*0.30, cy); ctx.lineTo(w*0.70, cy); ctx.stroke();

        ctx.beginPath(); ctx.moveTo(w*0.22, cy-h*0.18); ctx.lineTo(w*0.22, cy+h*0.18); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(w*0.16, cy-h*0.14); ctx.lineTo(w*0.16, cy+h*0.14); ctx.stroke();

        ctx.beginPath(); ctx.moveTo(w*0.78, cy-h*0.18); ctx.lineTo(w*0.78, cy+h*0.18); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(w*0.84, cy-h*0.14); ctx.lineTo(w*0.84, cy+h*0.14); ctx.stroke();
      }
    }
  }

  // ✅ FIX: RepDot теперь хранит done у себя (QML гарантированно обновляет визуал)
  component RepDot: Glass {
    id: rd
    property int number: 1
    property bool done: false
    signal clicked()

    radius: 14
    glassOpacity: 0.12
    padding: 0
    Layout.preferredWidth: 34
    Layout.preferredHeight: 34

    Rectangle {
      anchors.fill: parent
      radius: 14
      color: rd.done ? Qt.rgba(0.10, 0.75, 0.45, 0.22) : Qt.rgba(1,1,1,0.35)
      border.width: 1
      border.color: rd.done ? Qt.rgba(0.10, 0.75, 0.45, 0.55) : Qt.rgba(0,0,0,0.06)

      Behavior on color { ColorAnimation { duration: 180 } }
      Behavior on border.color { ColorAnimation { duration: 180 } }
    }

    UiText {
      anchors.centerIn: parent
      text: rd.number
      font.pixelSize: 12
      font.weight: Font.DemiBold
      color: rd.done ? Qt.rgba(0.05,0.35,0.22,0.98) : "#0b1520"
      Behavior on color { ColorAnimation { duration: 180 } }
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: rd.clicked()
    }
  }

  ColumnLayout {
    width: parent.width
    height: parent.height
    spacing: 14

    // Days row (центрирование)
    Glass {
      Layout.fillWidth: true
      Layout.preferredHeight: 56
      radius: 28
      glassOpacity: 0.14
      padding: 0

      RowLayout {
        anchors.fill: parent
        anchors.margins: 8  // 64-20 = 44
        spacing: 12

        DayChip { text: "Day 1 Chest"; active: true; accent: "#FF6B7A"; Layout.alignment: Qt.AlignVCenter }
        DayChip { text: "Day 2 Back";  accent: "#4FC3F7"; Layout.alignment: Qt.AlignVCenter }
        DayChip { text: "Day 3 Shoulders"; accent: "#8E7BFF"; Layout.alignment: Qt.AlignVCenter }
        DayChip { text: "Day 4 Arms"; accent: "#FF7BD7"; Layout.alignment: Qt.AlignVCenter }
        DayChip { text: "Day 5 Technique"; accent: "#53D769"; Layout.alignment: Qt.AlignVCenter }

        Item { Layout.fillWidth: true }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 16

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 14

        RowLayout {
          Layout.fillWidth: true
          Layout.preferredHeight: 250
          spacing: 14

          Glass {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 28
            glassOpacity: 0.14

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: 18
              spacing: 10

              RowLayout {
                Layout.fillWidth: true
                spacing: 12

                UiText { text: "Day 1 Chest"; font.pixelSize: 26; font.weight: Font.DemiBold; color: "#0b1520"; Layout.alignment: Qt.AlignVCenter }
                Item { Layout.fillWidth: true }

                PillBtn { text: "Сила"; active: true; Layout.alignment: Qt.AlignVCenter }
                PillBtn { text: "Гипертрофия"; Layout.alignment: Qt.AlignVCenter }
                PillBtn { text: "Техника"; Layout.alignment: Qt.AlignVCenter; onClicked: root.openTechnique("Day 1 Chest — техника", "Тяжелый жим + верх груди") }
              }

              UiText { text: "Тяжелый жим + верх груди"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.65) }

              // ✅ FIX: clip для прогресса
              Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 999
                color: Qt.rgba(0.10,0.20,0.35,0.06)
                clip: true

                Rectangle {
                  height: parent.height
                  radius: 999
                  width: Math.max(22, parent.width * 0.12)
                  gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF5C7A" }
                    GradientStop { position: 1.0; color: "#7AA7FF" }
                  }
                }
              }

              UiText { text: "Выполнено: 2 / 16"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.65) }

              RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Glass { Layout.fillWidth: true; Layout.preferredHeight: 78; radius: 20; glassOpacity: 0.12
                  ColumnLayout { anchors.centerIn: parent; spacing: 6
                    UiText { text: "Total sets"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.60) }
                    UiText { text: "16"; font.pixelSize: 22; font.weight: Font.DemiBold; color: "#0b1520" }
                  }
                }

                Glass { Layout.fillWidth: true; Layout.preferredHeight: 78; radius: 20; glassOpacity: 0.12
                  ColumnLayout { anchors.centerIn: parent; spacing: 6
                    UiText { text: "Total reps"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.60) }
                    UiText { text: "160+"; font.pixelSize: 22; font.weight: Font.DemiBold; color: "#0b1520" }
                  }
                }

                Glass { Layout.fillWidth: true; Layout.preferredHeight: 78; radius: 20; glassOpacity: 0.12
                  ColumnLayout { anchors.centerIn: parent; spacing: 6
                    UiText { text: "Time"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.60) }
                    UiText { text: "40 мин"; font.pixelSize: 22; font.weight: Font.DemiBold; color: "#0b1520" }
                  }
                }
              }

              Item { Layout.fillHeight: true }
            }
          }

          ColumnLayout {
            Layout.preferredWidth: 360
            Layout.fillHeight: true
            spacing: 14

            Glass {
              Layout.fillWidth: true
              Layout.preferredHeight: 118
              radius: 24
              glassOpacity: 0.14

              RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                ColumnLayout {
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                  spacing: 6

                  UiText { text: "Серия"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.60) }

                  RowLayout { spacing: 8
                    UiText { text: "🔥"; font.pixelSize: 16; Layout.alignment: Qt.AlignVCenter }
                    UiText { text: "6 дней"; font.pixelSize: 18; font.weight: Font.DemiBold; color: "#0b1520"; Layout.alignment: Qt.AlignVCenter }
                  }

                  UiText { text: "Держи ритм это ускоряет прогресс"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.55); wrapMode: Text.WordWrap }
                }

                UiText { text: "Streak"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.55); Layout.alignment: Qt.AlignTop }
              }
            }

            Glass {
              Layout.fillWidth: true
              Layout.preferredHeight: 118
              radius: 24
              glassOpacity: 0.14

              RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                ColumnLayout {
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                  spacing: 6

                  RowLayout {
                    Layout.fillWidth: true
                    UiText { text: "Next workout"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.60) }
                    Item { Layout.fillWidth: true }
                    UiText { text: "Up next"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.55) }
                  }

                  UiText { text: "Day 2 Back"; font.pixelSize: 18; font.weight: Font.DemiBold; color: "#0b1520" }
                  UiText { text: "Тяга + широчайшие"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.55) }
                }

                Glass {
                  Layout.preferredWidth: 44
                  Layout.preferredHeight: 44
                  radius: 22
                  glassOpacity: 0.12
                  padding: 0

                  Rectangle {
                    anchors.centerIn: parent
                    width: 30; height: 30; radius: 15
                    color: Qt.rgba(0.20,0.45,1.0,0.16)
                    UiText { anchors.centerIn: parent; text: "➜"; font.pixelSize: 14; color: Qt.rgba(0.10,0.25,0.55,0.9) }
                  }
                }
              }
            }
          }
        }

        // Exercises
        Repeater {
          model: [
            { title: "Жим штанги лёжа 0", sub: "468  ·  2:30  ·  47.5 кг", tag: "Main Lift", reps: 4 },
            { title: "Жим штанги наклон 30", sub: "3610  ·  2:00", tag: "Upper Chest", reps: 3 },
            { title: "Жим гантелей лёжа (neutral)", sub: "3812  ·  1:30", tag: "Pump", reps: 4 },
            { title: "Разводка гантелей", sub: "3215  ·  1:30", tag: "Pump", reps: 4 }
          ]

          delegate: Glass {
            id: exCard
            Layout.fillWidth: true
            Layout.preferredHeight: 118
            radius: 26
            glassOpacity: 0.14

            property var exData: modelData

            RowLayout {
              anchors.fill: parent
              anchors.margins: 16
              spacing: 14

              Glass {
                Layout.preferredWidth: 52
                Layout.preferredHeight: 52
                radius: 22
                glassOpacity: 0.12
                padding: 0
                Layout.alignment: Qt.AlignVCenter

                DumbbellIcon { anchors.centerIn: parent; stroke: Qt.rgba(0.10,0.20,0.35,0.80) }
              }

              ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                RowLayout {
                  Layout.fillWidth: true
                  spacing: 10

                  UiText {
                    text: exCard.exData.title
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: "#0b1520"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                  }

                  UiText { text: exCard.exData.tag; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.55); Layout.alignment: Qt.AlignVCenter }
                }

                UiText { text: exCard.exData.sub; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.60) }

                RowLayout {
                  Layout.fillWidth: true
                  spacing: 10

                  Repeater {
                    model: exCard.exData.reps
                    delegate: RepDot {
                      number: index + 1

                      onClicked: {
                        done = !done
                        root.openRest(exCard.exData.title + " — повтор " + (index + 1))
                      }
                    }
                  }

                  Item { Layout.fillWidth: true }

                  PillBtn {
                    text: "Техника"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: root.openTechnique(exCard.exData.title, exCard.exData.sub)
                  }
                }
              }
            }
          }
        }

        Item { Layout.fillHeight: true }
      }

      // Right column
      ColumnLayout {
        Layout.preferredWidth: 460
        Layout.fillHeight: true
        spacing: 14

        Glass {
          Layout.fillWidth: true
          Layout.preferredHeight: 170
          radius: 28
          glassOpacity: 0.14

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            RowLayout {
              Layout.fillWidth: true
              UiText { text: "Weekly Progress"; font.pixelSize: 14; font.weight: Font.DemiBold; color: Qt.rgba(0.15,0.25,0.35,0.80) }
              Item { Layout.fillWidth: true }
              UiText { text: "7д"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.55) }
            }

            UiText { text: "Сила/объём по дням"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.55) }
            Rectangle { Layout.fillWidth: true; height: 2; radius: 1; color: Qt.rgba(0,0,0,0.04) }
            UiText { text: "(график подключим дальше)"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.45) }
            Item { Layout.fillHeight: true }
          }
        }

        Glass {
          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 28
          glassOpacity: 0.14

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            RowLayout {
              Layout.fillWidth: true
              spacing: 10
              UiText { text: "Rich cards"; font.pixelSize: 14; font.weight: Font.DemiBold; color: Qt.rgba(0.15,0.25,0.35,0.80) }
              PillBtn { text: "Live"; px: 12 }
              Item { Layout.fillWidth: true }
              UiText { text: "Скролл внутри"; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.45) }
            }

            UiText { text: "Скролл внутри, кликай сеты (подключим дальше)."; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.45); wrapMode: Text.WordWrap }
            Item { Layout.fillHeight: true }
          }
        }
      }
    }
  }

  // =========================
  // REST POPUP
  // =========================
  Timer {
    id: restTimer
    interval: 1000
    repeat: true
    running: false
    onTriggered: {
      if (root.restPaused) return
      if (root.restRemainingSeconds > 0) {
        root.restRemainingSeconds -= 1
      } else {
        running = false
      }
    }
  }

  Popup {
    id: restPopup
    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0

    x: root.width - width - 26
    y: root.height - height - 26

    background: Rectangle {
      radius: 22
      color: Qt.rgba(1,1,1,0.93)  // ~7% прозрачности
      border.width: 1
      border.color: Qt.rgba(0,0,0,0.08)
    }

    onClosed: restTimer.running = false

    contentItem: Item {
      implicitWidth: 340
      implicitHeight: 160

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
          Layout.fillWidth: true

          ColumnLayout {
            spacing: 2
            UiText { text: "Отдых"; font.pixelSize: 12; color: Qt.rgba(0.15,0.25,0.35,0.60) }
            UiText { text: root.restExerciseTitle; font.pixelSize: 11; color: Qt.rgba(0.15,0.25,0.35,0.45); elide: Text.ElideRight }
          }

          Item { Layout.fillWidth: true }
          SoftButton { text: "✕"; Layout.preferredWidth: 44; Layout.preferredHeight: 36; onClicked: restPopup.close() }
        }

        UiText {
          text: root.formatTime(root.restRemainingSeconds)
          font.pixelSize: 36
          font.weight: Font.DemiBold
          color: "#0b1520"
        }

        RowLayout {
          Layout.fillWidth: true
          spacing: 10

          SoftButton {
            text: root.restPaused ? "Продолжить" : "Пауза"
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            onClicked: root.restPaused = !root.restPaused
          }

          SoftButton {
            text: "Сброс"
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            onClicked: {
              root.restRemainingSeconds = root.restTotalSeconds
              root.restPaused = false
              restTimer.running = true
            }
          }
        }
      }
    }
  }

  // =========================
  // TECHNIQUE (новый дизайн как на твоём фото)
  // =========================
  component BigTab: Item {
    id: bt
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property bool active: false
    signal clicked()

    implicitHeight: 72
    implicitWidth: 250

    Rectangle {
      anchors.fill: parent
      radius: 18
      color: bt.active ? Qt.rgba(0.10,0.35,1.0,0.96) : Qt.rgba(1,1,1,0.70)
      border.width: 1
      border.color: bt.active ? Qt.rgba(0.10,0.35,1.0,0.96) : Qt.rgba(0,0,0,0.06)
    }

    RowLayout {
      anchors.fill: parent
      anchors.margins: 14
      spacing: 10

      Rectangle {
        Layout.preferredWidth: 34
        Layout.preferredHeight: 34
        radius: 12
        color: bt.active ? Qt.rgba(1,1,1,0.18) : Qt.rgba(0.10,0.20,0.35,0.06)

        UiText {
          anchors.centerIn: parent
          text: bt.icon
          font.pixelSize: 16
          color: bt.active ? Qt.rgba(1,1,1,0.95) : Qt.rgba(0.10,0.20,0.35,0.70)
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        UiText {
          text: bt.title
          font.pixelSize: 13
          font.weight: Font.DemiBold
          color: bt.active ? Qt.rgba(1,1,1,0.98) : "#0b1520"
          elide: Text.ElideRight
        }

        UiText {
          text: bt.subtitle
          font.pixelSize: 11
          color: bt.active ? Qt.rgba(1,1,1,0.78) : Qt.rgba(0.15,0.25,0.35,0.55)
          elide: Text.ElideRight
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: bt.clicked()
    }
  }

  component CheckLine: RowLayout {
    id: cl
    property string text: ""
    spacing: 10
    Layout.fillWidth: true

    Rectangle {
      Layout.preferredWidth: 22
      Layout.preferredHeight: 22
      radius: 11
      color: Qt.rgba(0.10,0.35,1.0,0.12)
      border.width: 1
      border.color: Qt.rgba(0.10,0.35,1.0,0.20)

      UiText { anchors.centerIn: parent; text: "✓"; font.pixelSize: 12; font.weight: Font.DemiBold; color: Qt.rgba(0.10,0.35,1.0,0.95) }
    }

    UiText {
      text: cl.text
      font.pixelSize: 13
      font.weight: Font.Medium
      color: Qt.rgba(0.08,0.12,0.18,0.92)
      wrapMode: Text.WordWrap
      lineHeightMode: Text.ProportionalHeight
      lineHeight: 1.18
      Layout.fillWidth: true
    }
  }

  Popup {
    id: techniquePopup
    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Справа, как у тебя в референсе
    x: Math.max(0, parent.width - width - 28)
    y: 128

    width: 520
    implicitHeight: 720

    background: Rectangle {
        radius: 26
        color: "white"
        border.color: Qt.rgba(0,0,0,0.10)
        border.width: 1
    }

    // Лёгкое затемнение под окном (вариант B)
    Overlay.modal: Rectangle { color: "transparent" }
    Overlay.modeless: Rectangle {
        color: Qt.rgba(0,0,0,0.18)
        Behavior on color { ColorAnimation { duration: 160 } }
    }

    property int activeTab: 0

    // Демо-контент (жим лёжа)
    readonly property var tabTitles: [
        { title: "Ключевые точки", sub: "Основные моменты" },
        { title: "Типичные ошибки", sub: "Чего нельзя делать" },
        { title: "Амплитуда движения", sub: "Насколько глубоко опускать" },
        { title: "Лайфхаки", sub: "Как сделать лучше" }
    ]

    readonly property var demo: ({
        key: [
            "Лопатки сведены и опущены — держи «полку».",
            "Локти под углом ~45° — не разводи в стороны.",
            "Гриф по дуге: вниз к нижней груди, вверх к плечам.",
            "Контроль внизу: пауза 0–1с без отскока."
        ],
        err: [
            "Отрыв таза/моста — теряешь стабильность.",
            "Сильный прогиб кистей — боль и потеря силы.",
            "Развод локтей 90° — риск плечам.",
            "Отскок от груди — ломает траекторию и темп."
        ],
        amp: [
            "Опускай до лёгкого касания груди (контролируемо).",
            "Если плечи дискомфортят — укороти амплитуду и проверь угол локтя.",
            "Сохраняй одинаковую точку касания каждый повтор.",
            "Вверх — до полного выпрямления, без «переброса» плеч вперёд."
        ],
        hacks: [
            "Сожми гриф «внутрь» — включаются широчайшие и стабилизация.",
            "Ноги в пол, пятки давят — стабильнее корпус.",
            "На старте подумай «гриф к себе» — траектория станет ровнее.",
            "Дыши: вдох на опускании, выдох после прохождения «мертвой точки»."
        ]
    })

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Техника"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                        color: "#0E1320"
                    }
                    Text {
                        // сюда позже подставим текущее упражнение
                        text: "Жим штанги лёжа 0"
                        font.pixelSize: 14
                        color: Qt.rgba(0.10,0.12,0.16,0.55)
                        elide: Text.ElideRight
                    }
                }

                SoftButton {
                    text: "✕"
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: 34
                    radius: 12
                    onClicked: techniquePopup.close()
                }
            }

            // Tabs
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: 4
                    delegate: BigTab {
                        Layout.fillWidth: true
                        title: techniquePopup.tabTitles[index].title
                        subtitle: techniquePopup.tabTitles[index].sub
                        active: techniquePopup.activeTab === index
                        onClicked: techniquePopup.activeTab = index
                    }
                }
            }

            // Main content
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 12
                columnSpacing: 12

                // K — основной текст техники (крупнее/читабельнее)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 18
                    color: Qt.rgba(1,1,1,0.96)
                    border.color: Qt.rgba(0,0,0,0.08)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Rectangle {
                                width: 28; height: 28; radius: 10
                                color: Qt.rgba(0.23,0.45,0.98,0.10)
                                Text { anchors.centerIn: parent; text: "👁"; font.pixelSize: 14 }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: techniquePopup.tabTitles[techniquePopup.activeTab].title
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                color: "#0E1320"
                                elide: Text.ElideRight
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: {
                                    if (techniquePopup.activeTab === 0) return techniquePopup.demo.key
                                    if (techniquePopup.activeTab === 1) return techniquePopup.demo.err
                                    if (techniquePopup.activeTab === 2) return techniquePopup.demo.amp
                                    return techniquePopup.demo.hacks
                                }
                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10

                                    Rectangle {
                                        width: 22; height: 22; radius: 11
                                        color: Qt.rgba(0.23,0.45,0.98,0.18)
                                        border.color: Qt.rgba(0.23,0.45,0.98,0.35)
                                        border.width: 1
                                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 12; color: "#2B5BFF" }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData
                                        wrapMode: Text.WordWrap
                                        font.pixelSize: 15
                                        color: Qt.rgba(0.10,0.12,0.16,0.78)
                                    }
                                }
                            }
                        }
                    }
                }

                // Z — лайфхаки (вторая колонка)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 18
                    color: Qt.rgba(1,1,1,0.96)
                    border.color: Qt.rgba(0,0,0,0.08)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Rectangle {
                                width: 28; height: 28; radius: 10
                                color: Qt.rgba(0.98,0.70,0.20,0.18)
                                border.color: Qt.rgba(0.98,0.70,0.20,0.28)
                                border.width: 1
                                Text { anchors.centerIn: parent; text: "💡"; font.pixelSize: 14 }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Лайфхаки"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                color: "#0E1320"
                                elide: Text.ElideRight
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: techniquePopup.demo.hacks
                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10

                                    Rectangle {
                                        width: 22; height: 22; radius: 11
                                        color: Qt.rgba(0.13,0.77,0.37,0.18)
                                        border.color: Qt.rgba(0.13,0.77,0.37,0.30)
                                        border.width: 1
                                        Text { anchors.centerIn: parent; text: "✓"; font.pixelSize: 12; color: "#16A34A" }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData
                                        wrapMode: Text.WordWrap
                                        font.pixelSize: 15
                                        color: Qt.rgba(0.10,0.12,0.16,0.78)
                                    }
                                }
                            }
                        }
                    }
                }

                // H — визуальная техника (низ, на всю ширину)
                Rectangle {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.preferredHeight: 170
                    radius: 18
                    color: Qt.rgba(1,1,1,0.96)
                    border.color: Qt.rgba(0,0,0,0.08)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Rectangle {
                                width: 28; height: 28; radius: 10
                                color: Qt.rgba(0.23,0.45,0.98,0.10)
                                Text { anchors.centerIn: parent; text: "🎥"; font.pixelSize: 14 }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: "Визуальная техника"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                color: "#0E1320"
                            }

                            Rectangle {
                                Layout.preferredWidth: 200
                                Layout.preferredHeight: 62
                                radius: 16
                                color: Qt.rgba(0.23,0.45,0.98,0.06)
                                border.color: Qt.rgba(0.23,0.45,0.98,0.14)
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10
                                    Text { text: "📹"; font.pixelSize: 18 }
                                    Text { text: "/"; font.pixelSize: 14; color: Qt.rgba(0,0,0,0.25) }
                                    Text { text: "🖼"; font.pixelSize: 18 }
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: "+ Хочешь — добавлю видео/гиф в чек‑лист про технику прямо тут."
                            font.pixelSize: 13
                            color: Qt.rgba(0.10,0.12,0.16,0.55)
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
}

