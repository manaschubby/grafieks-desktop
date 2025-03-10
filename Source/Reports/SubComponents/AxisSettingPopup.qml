import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents";
import "./MiniSubComponents";

Popup {

    id: popup
    width: parent.width * 0.5
    height: 670
    anchors.centerIn: parent

    visible: false
    modal: true
    padding: 0
    closePolicy: Popup.NoAutoClose

    background: Rectangle{
        color: Constants.whiteColor
    }

    ListModel{
        id: multipleAxisList
    }




    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onCancelClicked(){
        popup.visible = false
    }


    function toggleAxisSettings(){
        borderMultipleAxis.visible =  false
        borderAxis.visible =  true
        multipleAxisSettings.visible = false
        axisSettings.visible = true
    }

    function toggleMultipleAxissSettings(){
        borderMultipleAxis.visible =  true
        borderAxis.visible =  false
        multipleAxisSettings.visible = true
        axisSettings.visible = false
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts





    // Popup Header Starts

    Rectangle{

        id: header
        color: Constants.themeColor
        height: 40
        width: parent.width 

        anchors.top: parent.top
        anchors.left: parent.left


        Text{
            text: Constants.axisSettingText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: onCancelClicked()
            }
        }

    }

    // Popup Header Ends

    Rectangle{
        anchors.top: header.bottom
        height: parent.height - header.height
        width: parent.width


        // Left menu starts
        Rectangle{
            id: leftMenu
            width: 200
            height: parent.height

            Column{
                anchors.top: parent.top
                anchors.topMargin: 10
                width: parent.width
                height: parent.height - 10
                spacing: 5

                Rectangle{
                    id: axisMenubutton
                    height: 40
                    width: parent.width

                    Rectangle{
                        id: axisMenuRectangle
                        height: 38
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.themeColor

                        Text {
                            id: axisMenuText
                            text: Messages.re_sub_yasp_filter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            font.pixelSize:  Constants.fontCategoryHeader
                        }

                    }

                    Rectangle{
                        id: borderAxis
                        anchors.bottom: axisMenubutton.bottom
                        height: 2
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.grafieksGreenColor
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: axisMenuRectangle.color =  Constants.darkThemeColor
                        onExited: axisMenuRectangle.color =  Constants.themeColor
                        onClicked: toggleAxisSettings()
                    }
                }

                /*
                Rectangle{
                    id: multipleAxisMenubutton
                    height: 40
                    width: parent.width
                    visible: false

                    Rectangle{
                        id: multipleAxisMenuRectangle
                        height: 38
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.themeColor

                        Text {
                            id: multipleAxisMenuText
                            text: qsTr("Multiple Axis Chart")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            font.pixelSize:  Constants.fontCategoryHeader
                        }

                    }

                    Rectangle{
                        id: borderMultipleAxis
                        anchors.bottom: multipleAxisMenubutton.bottom
                        height: 2
                        width: parent.width - 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: Constants.grafieksGreenColor
                        visible: false
                    }

                    MouseArea{
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: toggleMultipleAxissSettings()
                        onEntered: multipleAxisMenuRectangle.color =  Constants.darkThemeColor
                        onExited: multipleAxisMenuRectangle.color =  Constants.themeColor
                    }
                }

                */

            }

        }

        // Left menu ends

        ToolSeparator{
            id: menuContentSeparator
            anchors.left: leftMenu.right
            orientation: Qt.Vertical
            height: parent.height
            width: 1
            background: Rectangle{
                color: Constants.darkThemeColor
            }
        }

        // Content Starts



        AxisSettings{
            id: axisSettings
            visible: true
        }

        MultipleAxisSettings{
            id: multipleAxisSettings
            visible: false
        }

        // Content Ends

    }

    // Page Design Ends
    /***********************************************************************************************************************/



}
