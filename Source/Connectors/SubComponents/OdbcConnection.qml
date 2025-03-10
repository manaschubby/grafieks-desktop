/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Mysql Connection
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"

Popup {
    id: popup
    width: 600
    height: 400
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 300
    padding: 0
    property int label_col : 135


    /***********************************************************************************************************************/
    // Connection  Starts

    Connections{
        target: ConnectorsLoginModel

        function onMysqlLoginStatus(status){

             if(status.status === true){

                 popup.visible = false
                 GeneralParamsModel.setCurrentScreen(Constants.modelerScreen)
                 stacklayout_home.currentIndex = 5
             }
             else{
                 popup.visible = true
                 msg_dialog.open()
                 msg_dialog.text = status.msg
             }
        }
    }

    // Connection  Ends
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function hidePopup(){
        popup.visible = false
    }

    function connectToMySQL(){
//        ConnectorsLoginModel.mysqlLogin(server.text, database.text, port.text, username.text, password.text)
//        ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_my", 3306, "root", "123@312QQl")
//        ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_dummy", 3306, "root", "")
//        ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_my", 3308, "root", "root")
        ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_my", 3306, "root", "")

    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // SubComponents Starts


    MessageDialog{
        id: msg_dialog
        title: "Mysql Connection"
        text: ""
//        icon: StandardIcon.Critical
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            id : text1
            text: "Sign In to MySQL"
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
                onClicked: hidePopup()
            }
        }

    }

    // Popup Header ends

    // Row1: Enter Server address starts

    Row{

        id: row1
        anchors.top: headerPopup.bottom
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.rightMargin: 40

        Rectangle{

            id: label1
            width:label_col
            height: 40

            Text{
                text: "Driver"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader

                anchors.verticalCenter: parent.verticalCenter
            }
        }


        ComboBox {
            id: control
            model: ["First", "Second", "Third","fourth"]


            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: modelData
                    color: "black"
                    font: control.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: control.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }

            contentItem: Text {
                leftPadding: 10
                rightPadding: control.indicator.width + control.spacing

                text: control.displayText
                font: control.font
                color: control.pressed ? "black" : "black"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 400
                implicitHeight: 40
                border.color: Constants.borderBlueColor
                border.width: control.visualFocus ? 2 : 1
                radius: 5
            }

            popup: Popup {
                y: control.height - 1
                width: control.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: control.popup.visible ? control.delegateModel : null
                    currentIndex: control.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 10
                }
            }
        }

    }

    // Row1: Enter server address ends

    // Row2: Enter database name starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label3
            width:label_col
            height: 40
            Text{
                text: "Serversss"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: server
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: 200

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 200
            }
        }
        Rectangle{

            id: labelPort
            width: 40
            height: 40

            Text{
                text: "Port"
                leftPadding: 10
                anchors.left: server.right
                anchors.rightMargin: 20
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        TextField{
            id: port
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            //width: 130
            height: 40
            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 160

            }
        }

    }

    // Row2: Enter database name ends

    // Row3: Enter port number starts


    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: "Database"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: database
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }


    // Row3: Enter port number ends

    // Row 4: Enter user name starts

    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label4
            width:label_col
            height: 40

            Text{
                text: "Username"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }

    // Row 4: Enter user name ends

    // Row 5: Enter password starts

    Row{

        id: row5
        anchors.top: row4.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label5
            width:label_col
            height: 40

            Text{
                text: "Password"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password
            maximumLength: 250
            selectByMouse: true
            echoMode: "Password"
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }

    // Row 5: Enter password ends

    // Row 6: Action Button starts

    Row{

        id: row6
        // anchors.top: row5.bottom
        // anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin:15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        //        anchors.rightMargin: label_col*2 + 47
        spacing: 10

        CustomButton{

            id: btn_signin
            textValue: Messages.signInText
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: connectToMySQL()
        }

    }
    // Row 6: Action Button ends



    // Page Design Ends
    /***********************************************************************************************************************/



}
