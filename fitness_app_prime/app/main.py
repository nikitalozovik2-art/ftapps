import os
os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")

import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qml = Path(__file__).resolve().parent / "ui" / "Main.qml"
    engine.load(qml.as_uri())

    if not engine.rootObjects():
        raise SystemExit("QML failed to load")

    sys.exit(app.exec())

if __name__ == "__main__":
    main()