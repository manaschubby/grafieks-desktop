/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Sqlite Connection
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
    height: 250
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 125
    padding: 0
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    property int label_col : 135

    property var selectedFile: ""

    // LIVE CONNECTION not possible

    Connections{
        target: ConnectorsLoginModel

        function onSqliteLoginStatus(status){

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

        function onLogout(){
            selectedFile = ""
            sqliteFileName.text = ""
        }
    }

    Component.onCompleted: {
        promptSqlitenameFilters = Messages.cn_sub_sqlite_namedFilter
    }

    function connectToSqlite(selectedFile){
        ConnectorsLoginModel.sqliteLogin(selectedFile)
    }


    // Popup Header starts

    Rectangle{
        id: header_popup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width 
        anchors.top: parent.top
        anchors.left: parent.left


        Text{
            id : text1
            text: Messages.cn_sub_sqlite_header
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
                onClicked: {
                    popup.visible = false
                }
            }
        }

    }

    // Popup Header ends




    // Row3: Enter port number starts


    Row{

        id: row3
        anchors.top: header_popup.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1
        padding: 10



        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: Messages.cn_sub_common_db
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{

            id: label4
            width:400
            height: 40
            Button{
                id : file_btn
                anchors.verticalCenter: parent.verticalCenter
                text: Messages.cn_sub_sqlite_selFile
                onClicked: promptSqlite.open();
            }

            Text{
                id: sqliteFileName
                anchors.bottom: file_btn.bottom
                text:""
            }
        }

    }


    // Row3: Enter port number ends



    // Row 6: Action Button starts

    Row{

        id: row6
        // anchors.top: row3.bottom
        // anchors.topMargin: 15
        anchors.bottom:parent.bottom
        // anchors.bottomMargin:15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 100
        spacing: 10

  
        CustomButton{

            id: btn_cancel
            anchors.bottom:parent.bottom
            anchors.bottomMargin:30
            width: 100
            anchors.right:parent.right
            textValue: Messages.openFileText
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: connectToSqlite(selectedFile)
        }
        
    }
    // Row 6: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: Messages.cn_sub_sqlite_subHeader
        text: ""
//        icon: StandardIcon.Critical
    }

    // Select SQLITE file
    FileDialog{
        id: promptSqlite
        title: Messages.cn_sub_sqlite_selFile

        onAccepted: {
            sqliteFileName.text = GeneralParamsModel.urlToFilePath(fileUrl).replace(/^.*[\\\/]/, '')
            selectedFile = fileUrl
        }
        onRejected: {
            console.log("file rejected")
        }
    }


}
