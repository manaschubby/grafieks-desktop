import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

import "../../chartsWebViewHandlers.js" as ChartsWebViewHandler

Popup {

    property int shapeWidth: 20
    property int shapeHeight: 20

    width: 160
    height: 90
    x: 10
    modal: false
    visible: false

    ListModel{
        id: pivotThemeModel
        ListElement{
            themeName: "Blue"
        }
        ListElement{
            themeName: "Red"
        }
        ListElement{
            themeName: "Green"
        }
        ListElement{
            themeName: "Orange"
        }
        ListElement{
            themeName: "Flower"
        }
        ListElement{
            themeName: "White"
        }
        ListElement{
            themeName: "Black"
        }
    }

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.darkThemeColor
    }

    function onThemeChanged(curve){
        const themeValue = pivotSelectBox.currentValue;
        d3PropertyConfig.pivotTheme = pivotSelectBox.currentValue;
        ChartsWebViewHandler.updateChart(d3PropertyConfig)
    }

    Rectangle{
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 10

            Rectangle{
                height: 20
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Messages.re_mini_ptp_header
                }
            }

            Rectangle{
                height: 30
                width: parent.width
                CustomComboBox{
                    id: pivotSelectBox
                    model: pivotThemeModel
                    textRole: "themeName"
                    valueRole: "themeName"
                    width: parent.width-2*leftMargin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: leftMargin
                    anchors.top: parent.top
                    onCurrentValueChanged: onThemeChanged()
                }

            }


        }

    }
}
