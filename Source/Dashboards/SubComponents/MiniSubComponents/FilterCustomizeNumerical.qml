import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"
import "../MiniSubComponents"

Item {

    id: filterCustomizeNumerical
    height: parent.height
//    width: parent.width

    ButtonGroup{
        id:buttonGroupFilterTypeNumerical
    }


    Connections{

        target: DashboardParamsModel

        function onCurrentSelectedColumnChanged(currentSelectedColumn){

            if(DashboardParamsModel.currentColumnType === Constants.numericalTab){
                var currentDashboard = DashboardParamsModel.currentDashboard
                var currentColumn = DashboardParamsModel.currentSelectedColumn
                var columnFilter = DashboardParamsModel.fetchColumnFilterType(currentDashboard, currentColumn)

                // filterNumericalTypes: ["dataRange","dataEqual","datanotEqual","dataSmaller","dataGreater","dataEqualOrSmaller","dataEqualOrGreater","dataBetween"]

                switch(columnFilter){
                case Constants.filterNumericalTypes[0]:
                    rangeText.checked = true
                    break;

                case Constants.filterNumericalTypes[1]:
                    control5.checked = true
                    break;

                case Constants.filterNumericalTypes[2]:
                    control6.checked = true
                    break;

                case Constants.filterNumericalTypes[3]:
                    control7.checked = true
                    break;

                case Constants.filterNumericalTypes[4]:
                    control8.checked = true
                    break;

                case Constants.filterNumericalTypes[5]:
                    control9.checked = true
                    break;

                case Constants.filterNumericalTypes[6]:
                    control10.checked = true
                    break;
                case Constants.filterNumericalTypes[7]:
                    control11.checked = true
                    break;

                default:
                    rangeText.checked = true
                    break;
                }
            }
        }
    }

    function setFilterType(newFilter){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentSelectedCol = DashboardParamsModel.currentSelectedColumn
        console.log("NEW FILTER", newFilter)
        DashboardParamsModel.setColumnFilterType(currentDashboardId, currentSelectedCol, newFilter)
    }


    //                    Range Filter
    RadioButton {
        id: rangeText
        ButtonGroup.group: buttonGroupFilterTypeNumerical
        x:5

        anchors.margins: 10
        onCheckedChanged: setFilterType(Constants.filterNumericalTypes[0])
        indicator: Rectangle {
            implicitWidth: 16
            implicitHeight: 16
            x: 208
            y: parent.height / 2 - height / 2
            radius: 13
            color: "transparent"
            border.color: "black"

            Rectangle {
                width: 16/2
                height: width
                radius: width/2
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "black"
                visible: rangeText.checked
            }

        }

        contentItem: Text {
            rightPadding: rangeText.indicator.width + rangeText.spacing+100
            text: Messages.da_sub_fcn_rangeText

            elide: Text.ElideRight
            font.pixelSize: 17
            verticalAlignment: Text.AlignVCenter
        }



    }

    Text {
        id: conditionText
        text: Messages.da_sub_fcn_conditionText
        font.pixelSize: 17
        anchors.top: rangeText.bottom
        anchors.margins: 15
        anchors.horizontalCenter:  parent.horizontalCenter
        horizontalAlignment: Text.horizontalAlignment
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    ColumnLayout {
        id: rangeRadio
        anchors.top: conditionText.bottom
        x:15
        anchors.margins: 15
        spacing: 15
        RadioButton {
            id: control5
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[1])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control5.checked
                }

            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_equal
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }



        }
        RadioButton {
            id: control6
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[2])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control6.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_notequal
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control7
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[3])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control7.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_smaller
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control8
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[4])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control8.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_greater
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control9
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[5])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control9.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_equalorsmaller
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control10
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[6])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control10.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_equalorgreater
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }
        RadioButton {
            id: control11
            ButtonGroup.group: buttonGroupFilterTypeNumerical
            onCheckedChanged: setFilterType(Constants.filterNumericalTypes[7])
            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                x: 200
                y: parent.height / 2 - height / 2
                radius: 13
                color: "transparent"
                border.color: "black"

                Rectangle {
                    width: 16/2
                    height: width
                    radius: width/2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    visible: control11.checked
                }
            }

            contentItem: Text {
                rightPadding: 200
                text: Messages.da_sub_fcn_between
                elide: Text.ElideRight
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
            }
        }

    }

}
