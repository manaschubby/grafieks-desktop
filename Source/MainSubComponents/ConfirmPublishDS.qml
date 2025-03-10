import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Popup {
    id: confirmPublishDs
    width: 600
    height: 300
    modal: true
    visible: false
    x: (parent.width - popup.width) / 2
    y: 100
    padding: 0

    closePolicy: Popup.NoAutoClose

    function closePopup(){
        confirmPublishDs.visible = false
        errorMsg.text = ""
    }

    function publishDS(){
        closePopup()
        PublishDatasourceModel.publishNowAfterDSCheck()
    }

    // Popup Header starts

    Rectangle{
        id: header_popup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        // anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1
        anchors.horizontalCenter: confirmPublishDs.horizontalCenter

        Text{
            text: Messages.msc_cpd_header
            anchors.verticalCenter: parent.verticalCenter
            // anchors.left : parent.left
            anchors.leftMargin: 10
            anchors.horizontalCenter: confirmPublishDs.horizontalCenter
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

    // Row : Data Source name exists starts

    Row{

        id: datasourceErrorMsg
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        // anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.horizontalCenter: confirmPublishDs.horizontalCenter

        Rectangle{

            id: label1
            width:label_col
            height: 40
            anchors.leftMargin: 30

            Text{
                id : dsNameLabel
                text: Messages.msc_cpd_mainText
                // anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: confirmPublishDs.horizontalCenter
            }
        }

    }

    // Row : Data Source name exists ends

    // Row : Data Source name exists starts

    Row{

        id: datasourceErrorHandlingButtons
        anchors.top: datasourceErrorMsg.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        padding: 10

        Button{
            id: confirm
            text: Messages.confirmBtnTxt
            onClicked: publishDS()
        }

        Button{
            id: reject
            text: Messages.cancelBtnTxt
            onClicked: closePopup()
        }

    }

    // Row : Data Source name exists ends

}
