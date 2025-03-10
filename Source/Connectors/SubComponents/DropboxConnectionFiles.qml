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
import QtQuick.Layouts 1.3


import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"

Popup {
    id: popup
    width: parent.width * 0.75
    height: parent.height * 0.75
    modal: true
    visible: false
    x: parent.width * 0.125
    y: parent.height * 0.125
    padding: 0
    closePolicy: Popup.NoAutoClose
    property int label_col : 135
    property var pathFolder: "Dropbox"
    property var folderName: "Folder name"

    property var fileId: ""
    property var fileName: ""
    property var fileExtension: ""
    property var fileTag: ""
    property var filePathFolder: ""
    property var filePathLower: ""

    property var generalObjectName : ""
    property var navigationPaths: []

    property var startTime: 0

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

    Connections{
        target: DropboxDS

        function onGetDropboxUsername(username){
            connectedById.text = Messages.cn_sub_common_connectedTo + username
        }

        function onShowBusyIndicator(status){
            if(status === true){
                busyindicator.running = true

                startTime = new Date().getTime().toString()
                busyindicator.running = true
                mainTimer.running = true
                mainTimer.start()
                displayTime.text = ""

            } else{
                busyindicator.running = false

                mainTimer.stop()
                mainTimer.running = false
                busyindicator.running = false
                displayTime.text = ""
            }
        }

        function onFileDownloaded(filePath, fileType){

            if(fileType === "csv"){
                ConnectorsLoginModel.csvLogin(filePath, true, ",")
            } else if(fileType === "excel"){
                var drivers = ODBCDriversModel.fetchOdbcDrivers(Constants.excelType)
                ConnectorsLoginModel.excelLogin(drivers, filePath)
            } else if(fileType === "json"){
                ConnectorsLoginModel.jsonLogin(filePath, true)
            }
        }
    }

    Connections{
        target: ConnectorsLoginModel

        function onExcelLoginStatus(status, directLogin){

            if(directLogin === true){
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

                mainTimer.stop()
                mainTimer.running = false
                busyindicator.running = false
                displayTime.text = ""
            }
        }

        function onCsvLoginStatus(status, directLogin){

            if(directLogin === true){
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

                mainTimer.stop()
                mainTimer.running = false
                busyindicator.running = false
                displayTime.text = ""
            }
        }

        function onJsonLoginStatus(status, directLogin){

            if(directLogin === true){
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

                mainTimer.stop()
                mainTimer.running = false
                busyindicator.running = false
                displayTime.text = ""
            }
        }

    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function closePopup(){
        popup.visible = false
    }

    function updatePath(text){
        path.text=text;
    }

    function onFileClicked(id, name, extension, tag, pathLower,extension, modifiedTime){

        fileSelected.visible = true
        fileNotSelectedMsg.visible = false

        if(tag === "folder"){
            pathFolder = pathLower;
            folderName = name;
        }

        if(tag === "file")
        {
            path.text = name
            detailNameDisplay.text = name;
            documentTypeDisplay.text = extension;
            modifiedTimeDisplay.text = modifiedTime;

            updatePath(pathLower)
        }

        fileId = id
        fileName = name
        fileExtension = extension
        fileTag = tag
        filePathFolder = pathLower
        filePathLower = pathLower

    }

    function onFileDoubleClicked(id, name, tag, pathFolder, pathLower){

        if(fileTag === "folder"){
            DropboxDS.folderNav(filePathFolder)
            navigationPaths.push({"path": filePathFolder, "name": name})
        } else{
            DropboxDS.fetchFileData(fileId, fileName, fileExtension)
        }

        updatePath(pathLower)
    }

    function onHomeClicked(){
        DropboxDS.folderNav("")
        //refer function folderNav of dropboxds.cpp
        updatePath(pathFolder)
    }


    function searchFiles(){
        DropboxDS.searchQuer(server_files.text)
    }


    function onBackPressed(){
        let lastElement = navigationPaths.length - 1
        let navPaths = navigationPaths[lastElement]
        navigationPaths.pop()
        updatePath(DropboxDS.goingBack(navPaths.path, navPaths.name));
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
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            id : text1
            text: "Connect to Dropbox"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontReading
            anchors.leftMargin: 20
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
                    closePopup();
                    updatePath("Dropbox")
                }
            }
        }

    }

    // Popup Header ends

    // Modal Content Starts


    Column{
        id: dropboxModalContent
        anchors.top: header_popup.bottom
        anchors.margins: 20
        anchors.left: parent.left

        // Row  User Details Starts

        Rectangle{
            id: userDetails

            Text {
                id: connectedById
                text: qsTr("Not Connected")
            }
        }



        // Row  User Details Ends

        // Row  File Search Starts

        Row{
            id: searchFileRow
            anchors.top: userDetails.bottom
            anchors.topMargin: 20

            TextField{
                id: server_files
                placeholderText: "file name"
                selectByMouse: true
                width: popup.width * 0.6
                height: 40
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 5
                    width: popup.width * 0.6
                }
                onTextChanged: searchFiles()
            }
        }

        // Row  File Search Ends

        // Row  File List Table Starts

        Row{
            id: dropboxFilesList
            anchors.top : searchFileRow.bottom

            anchors.topMargin: 20

            Row{
                width: popup.width * 0.6

                Rectangle{
                    height: popup.height * 0.75 - 100
                    width: popup.width * 0.6
                    border.color: Constants.themeColor



                    ListView{
                        id: fileList
                        model:DropboxModel
                        clip: true
                        height: parent.height
                        width: popup.width * 0.6
                        ScrollBar.vertical: ScrollBar {}
                        headerPositioning: ListView.OverlayHeader

                        header: Row{

                            width: popup.width * 0.6
                            z: 10
                            Column{
                                width: 20
                                Rectangle{
                                    color: Constants.themeColor
                                    height:30
                                    width:fileList.width / 2

                                }
                            }


                            Column{
                                width: parent.width / 2
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: fileList.width / 2

                                    Text{
                                        text: "Name"
                                        anchors.verticalCenter: parent.verticalCenter
                                        leftPadding: 20
                                    }
                                }
                            }
                            Column{
                                width: parent.width / 4
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: fileList.width / 2

                                    Text{
                                        text: qsTr("Kind")
                                        leftPadding: 20
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                            Column{
                                width: parent.width / 4
                                Rectangle {
                                    color: Constants.themeColor
                                    height: 30
                                    width: parent.width

                                    Text{
                                        text: qsTr("Last Modified")
                                        leftPadding: 20
                                        anchors.verticalCenter: parent.verticalCenter

                                    }
                                }
                            }

                        }

                        delegate: dropboxDelegate

                    }
                }

            }
            Row{
                id:fileDetails
                width: popup.width * 0.4  - 40

                Rectangle{
                    id: fileNotSelected
                    height: popup.height * 0.75 - 100
                    width: popup.width * 0.4 - 40
                    border.color: Constants.themeColor

                    Rectangle{
                        id: detailsHeading
                        height: 30
                        width: parent.width
                        border.color: Constants.themeColor

                        Text {
                            text: qsTr("Details")
                            anchors.topMargin: 5
                            font.pixelSize: Constants.fontCategoryHeader
                            anchors.top: detailsHeading.top
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                    }

                    HorizontalLineTpl{
                        width: parent.width
                        anchors.top: detailsHeading.bottom
                        line_color: Constants.themeColor
                    }

                    Image {
                        id: dropBoxImage
                        source: "/Images/icons/dropbox-2.png"
                        anchors.topMargin: 50
                        anchors.top: detailsHeading.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: fileNotSelectedMsg
                        anchors.topMargin: 20
                        anchors.top: dropBoxImage.bottom
                        text: qsTr("Select a file from the list that you want to connect to")
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle{
                        id: fileSelected
                        visible: false
                        width: parent.width
                        anchors.top: dropBoxImage.bottom
                        anchors.topMargin: 20

                        Column{
                            id: fileHeadingColumn
                            width: parent.width/2 - 5

                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Name")
                            }
                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Kind")
                            }
                            Text {
                                anchors.right: parent.right
                                padding: 5
                                text: qsTr("Last Modified")
                            }

                        }

                        Column{
                            id:fileDetailsColumn
                            anchors.left: fileHeadingColumn.right
                            width: parent.width/2 + 5

                            Text {
                                id: detailNameDisplay
                                padding: 5
                            }
                            Text {
                                id: documentTypeDisplay
                                padding: 5
                            }
                            Text {
                                id: modifiedTimeDisplay
                                padding: 5
                            }
                        }

                    }
                }

            }


        }

        // Row  File List Table Ends



        Row{
            anchors.top: dropboxFilesList.bottom

            anchors.topMargin: 20

            Row{
                id: breadcrumb
                width: popup.width * 0.6
                Rectangle{
                    height: 40
                    width: popup.width * 0.6
                    border.color: Constants.borderBlueColor
                    anchors.verticalCenter: parent

                    Text {
                        id: path
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 10
                        text: qsTr(pathFolder)
                    }
                }
            }


            Rectangle{
                width: popup.width * 0.4
                anchors.left:breadcrumb.right
                anchors.leftMargin: popup.width * 0.4  - 250

                Text{
                    id: displayTime
                    anchors.right: busyindicator.left
                    anchors.rightMargin: 10

                    Timer {
                        id: mainTimer
                        interval: 1000;
                        running: false;
                        repeat: true
//                        onTriggered: displayTime.text = Math.round((new Date().getTime() - startTime) / 1000) + " s"
                    }
                }

                BusyIndicatorTpl {
                    id: busyindicator
                    running: true
                    anchors.right: homeBtn.left
                    anchors.rightMargin: 10
                }

                CustomButton{

                    id: homeBtn
                    height: 40
                    width: 100
                    textValue: "Home"
                    anchors.right: cancelBtn.left
                    anchors.rightMargin: 10

                    onClicked: onHomeClicked()

                }

                CustomButton{

                    id: cancelBtn
                    height: 40
                    width: 100
                    textValue: "Back"
                    anchors.leftMargin: 10

                    onClicked: onBackPressed()

                }

                CustomButton{

                    id: nextBtn
                    height: 40
                    width: 100
                    textValue: "Next"
                    anchors.left: cancelBtn.right
                    anchors.leftMargin: 10

                    onClicked: onFileDoubleClicked(fileId, fileName, fileExtension, fileTag, filePathFolder, filePathLower)
                }

            }
        }
    }

    // Modal Content ends




    // Page Design Ends
    /***********************************************************************************************************************/

    Component{
        id: dropboxDelegate
        DropboxDelegate{}
    }

}
