import QtQuick 2.15
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

Slider {
    id: control
    value: 0.5

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: Constants.darkThemeColor

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: Constants.grafieksGreenColor
            radius: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 10
        implicitHeight: 20
        radius: 10
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }
}
