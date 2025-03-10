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

import "../SubComponents"
import "../../MainSubComponents"

Popup {
    id: popup
    width: 800
    height: 500
    modal: true
    visible: false
    x: parent.width/2 - 400
    y: parent.height/2 - 250
    padding: 0
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    closePolicy: Popup.NoAutoClose
    property int label_col : 135

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS


    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    // LIVE CONNECTION not possible
    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onAllowBtnClicked(){
        popup.visible = false;
        driveListPopup.visible = true;
        DriveDS.fetchDatasources();
        //driveds.cpp for more info

    }

    function closePopup(){
        popup.visible = false
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

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
            text: Messages.cn_sub_drive_header
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
                onClicked: closePopup()
            }
        }

    }

    // Popup Header ends

    // Row : To allow user to login to drive

    Row{
        id: driveConnectionModal
        anchors.top: header_popup.bottom
        anchors.topMargin: 70
        width: parent.width

        Rectangle{

            id:driveConnectionAllow
            width: parent.width

            Text {
                id: allowMsg
                anchors.top: parent.top
                anchors.rightMargin: 10

                text: qsTr(GeneralParamsModel.getAppInfo().APP_NAME + Messages.cn_sub_drive_allowReqMsg)
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Constants.fontHeader
            }





            CustomButton{

                id: allowBtn
                textValue: Messages.cn_sub_common_allow
                anchors.top: allowMsg.bottom
                anchors.topMargin: 60
                width: 100
                height:50
                fontPixelSize: Constants.fontHeader
                anchors.horizontalCenter: parent.horizontalCenter


                onClicked: onAllowBtnClicked()

            }


            Text {
                id: infoMsg
                anchors.top: allowBtn.bottom

                anchors.topMargin: 80

                text: Messages.cn_sub_drive_allowAuthMsg
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Text {
                id: infoMsg2
                anchors.top: infoMsg.bottom

                text: Messages.cn_sub_common_afterAuthMsg
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}

