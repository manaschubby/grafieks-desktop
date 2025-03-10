/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0


import "../MainSubComponents"
import "./SubComponents"
import "./SubComponents/MiniSubComponents"


Page {

    id: queryModellerPage
    height: parent.height
        background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }



    property int menu_width: 60
    property bool dataModellerSelected: true
    property int statusIndex: 1
    property bool collapsed: false
    property bool open: true
    property int dataPreviewNo: 6
    property bool tableShowToggle: true
    property Page page: queryModellerPage
    property LeftMenuBar leftMenuBar : left_menubar
    property int droppedCount: 0
    property var flatFiles: [Constants.excelType, Constants.csvType, Constants.jsonType]

    property int timeElapsed : 0


    // Dont delete this
    ListModel{
        id: otherSqlTableList
    }

    /***********************************************************************************************************************/
    // Connection Starts


    Connections{
        target: ConnectorsLoginModel


        // Rest fetch data model from datasources

        function onMysqlLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onPostgresLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onMssqlLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onAccessLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                radio_live.visible = false
                radio_memory.checked = true
            }
        }

        function onLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                queryModellerTab.visible = true
            }
        }
        function onSqliteLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = false
                radio_memory.checked = true
            }
        }
        function onMongoLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = NewTableListModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onSnowflakeLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = ForwardOnlyDataModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onRedshiftLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = ForwardOnlyDataModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }

        function onTeradataLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = ForwardOnlyDataModel.getTableList()
                queryModellerTab.visible = true
                radio_live.visible = true
                radio_live.checked = true
            }
        }
        function onExcelLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = ExcelDataModel.getTableList()
                queryModellerTab.visible = false
                
                radio_live.visible = false
                radio_memory.checked = true
            }
        }

        function onExcelLoginOdbcStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = ExcelDataModel.getTableList()
                queryModellerTab.visible = false
                tabbutton_querymodeller.width=100
                radio_live.visible = false
                radio_memory.checked = true
            }
        }

        function onCsvLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = CSVJsonDataModel.getTableList()
                queryModellerTab.visible = false
                radio_live.visible = false
                radio_memory.checked = true
            }
        }

        function onJsonLoginStatus(status){
            if(status.status === true){
                // Call functions
                tableslist.model = CSVJsonDataModel.getTableList()
                queryModellerTab.visible = false
                radio_live.visible = false
                radio_memory.checked = true
            }
        }
    }

    Connections{
        target: FilterCategoricalListModel

        function onRowCountChanged(){
            filterNumber.text = FilterCategoricalListModel.rowCount() + FilterDateListModel.rowCount() + FilterNumericalListModel.rowCount()
        }
    }

    Connections{
        target: FilterDateListModel

        function onRowCountChanged(){
            filterNumber.text = FilterCategoricalListModel.rowCount() + FilterDateListModel.rowCount() + FilterNumericalListModel.rowCount()
        }
    }

    Connections{
        target: FilterNumericalListModel

        function onRowCountChanged(){
            filterNumber.text = FilterCategoricalListModel.rowCount() + FilterDateListModel.rowCount() + FilterNumericalListModel.rowCount()
        }
    }

    Connections{
        target: QueryModel

        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(false)
        }

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onExtractCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }

        function onLiveFileSaved(ifPublish){
            saveLiveLimit(ifPublish)
        }

        function onLiveCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }
    }

    Connections{
        target: ForwardOnlyQueryModel

        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(false)
        }

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onExtractCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }

        function onLiveFileSaved(ifPublish){
            saveLiveLimit(ifPublish)
        }

        function onLiveCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }
    }

    Connections{
        target: ExcelQueryModel

        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(false)

        }

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onExtractCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }
    }

    Connections{
        target: CSVJsonQueryModel

        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(false)
        }

        function onExtractFileExceededLimit(freeLimit, ifPublish){
            saveExtractLimit(freeLimit, ifPublish)
        }

        function onExtractCreationError(errorMessage){
            extractCreationError.text = errorMessage
            extractCreationError.open()
            saveExtractPopupFunction(false)
        }
    }

    Connections{
        target: ExtractsLiveQueryModel

        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(false)
        }
    }


    Connections{
        target: GeneralParamsModel

        // Prompt the popup to show the timer and throbber
        // when extract is saved
        function onShowSaveExtractWaitPopup(){
            saveExtractPopupFunction(true)
        }
    }

    Connections{
        target: DSParamsModel

        function onDestroyLocalObjectsAndMaps(){
            searchTextBox.text = ""
            ds_name.text = ""
        }

        function onDisconnectAll(){
            disconnectDS();
            ReportParamsModel.resetReportIdsCounter();
            DashboardParamsModel.clearAllMapValuesAfterDisconnect();
            // Here are all the instances, Let's Remove the charts
            // console.logo('Removing all the charts');
            // let allReportInstances = ReportParamsModel.getAllDashboardReportInstances();
            // for (var reportIdValue in allReportInstances) {
            //     // Redrawing charts one by one;
            //     var instance = allReportInstances[reportIdValue];
            //     instance.remove();
            // }
        }
    }



    // Connection  Ends
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTIONS STARTS



    function onDataModellerClicked(){

        if(!dataModellerSelected){
            dataModellerSelected = !dataModellerSelected
            datamodeller_querymodeller_background.color = Constants.leftDarkColor;
            queryModellerTab_background.color = queryModellerTab_background.hovered ? Constants.leftDarkColor : Constants.themeColor
            datamodeller_querymodeller_text.color = Constants.blackColor

            // Prompt dialog to warn user of data deletion
            // If accepted, the clear data
            // and push to another stackview screen
            // MessageDialog defined at the bottom
            dataRemovalWarningDataModel.open()

            // Finally set a parameter in DSParamsModel
            DSParamsModel.setCurrentTab(Constants.dataModellerTab)

            // Enable filter button
            filter_btn.visible = true
        }
    }

    function onDataModellerHovered(){
        if(!dataModellerSelected){
            datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.grafieksGreenColor : Constants.themeColor
            datamodeller_querymodeller_text.color = datamodeller_querymodeller.hovered ? Constants.whiteColor : Constants.blackColor

        }
    }

    function onQueryModellerHovered(){
        if(dataModellerSelected){
            queryModellerTab_background.color = queryModellerTab.hovered ? Constants.grafieksGreenColor : Constants.themeColor
            queryModellerTab_text.color = queryModellerTab.hovered ? Constants.whiteColor : Constants.blackColor
            datamodeller_querymodeller_text.color = Constants.blackColor
        }
    }

    function onDragRightPanel(mouse){

        //        if(infoTableResizingFixed){
        //            if(mouse.y > 0){
        //                dataQueryModellerStackview.height += mouse.y
        //                if(dataQueryModellerStackview.height > 200){
        //                    infoTableResizingFixed = false
        //                }
        //            }
        //        }

        //        if(dataQueryModellerStackview.height > 200){

        //            if(dataQueryModellerStackview.height + mouse.y < 200){
        //                dataQueryModellerStackview.height = 200
        //            }else{
        //                dataQueryModellerStackview.height += mouse.y
        //            }

        //        }else{
        //            infoTableResizingFixed = true;
        //        }

        //        infodata_table.height = Qt.binding(function(){
        //            return queryModellerPage.height - submenu.height - dataQueryModellerStackview.height
        //        })

        if(column_querymodeller.width-mouse.x > 160 && column_querymodeller.width-mouse.x < 450 ){
            column_querymodeller.width = column_querymodeller.width - mouse.x
        }
        //        if( column_querymodeller.width-mouse.x < 450){
        //              column_querymodeller.width = column_querymodeller.width - mouse.x
        //        }


    }


    function onQueryModellerClicked(){

        if(dataModellerSelected){
            dataModellerSelected = !dataModellerSelected

            queryModellerTab_background.color = Constants.leftDarkColor
            datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.leftDarkColor : Constants.themeColor
            queryModellerTab_text.color = Constants.blackColor

            // Prompt dialog to warn user of data deletion
            // If accepted, the clear data
            // and push to another stackview screen
            // MessageDialog defined at the bottom
            dataRemovalWarningQueryModel.open()

            // Finally set a parameter in DSParamsModel
            DSParamsModel.setCurrentTab(Constants.queryModellerTab)

            // Disable filter options
            filter_btn.visible = false
        }

    }

    function showInMemoryPopup(){
        inMemory.visible = true
    }

    function onRefreshBtnClicked(){

        // If already logged in, dont prompt
        if (typeof settings.value("user/sessionToken") == "undefined"){
            connectGrafieks1.visible = true
        } else{
            showInMemoryPopup()
        }
    }

    function onInMemorySelected(){

        // Also set the C++ class
        // extract == in memory
        DSParamsModel.setDsType(Constants.extractDS)
        DSParamsModel.setFileExtension(Constants.extractFileExt)
        GeneralParamsModel.setFromLiveQuery(false)
    }

    function openDataFilters(){
        TableSchemaModel.showSchema(DSParamsModel.tmpSql)
        datafilters.visible = true
    }

    function onLiveSelected(){

        // Also set the C++ class
        DSParamsModel.setDsType(Constants.liveDS)
        DSParamsModel.setFileExtension(Constants.liveFileExt)
        GeneralParamsModel.setFromLiveQuery(true)
    }

    function onCreateDashboardClicked(){

        console.log("QQQ", DSParamsModel.tmpSql);

        QueryModel.setIfPublish(false)
        ForwardOnlyQueryModel.setIfPublish(false)
        ExcelQueryModel.setIfPublish(false)
        CSVJsonQueryModel.setIfPublish(false)

        if(DSParamsModel.dsName !== ""){
            saveFilePrompt.open()
        } else {
            datasourceNameWarningModal.open();
        }
    }


    function onPublishDataSourceClicked(){

        // If already logged in, dont prompt
        if (typeof settings.value("user/sessionToken") == "undefined"){
            connectGrafieks1.visible = true
        } else{

            // See if the DS Name is not blank
            if(DSParamsModel.dsName !== ""){
                publishDatasource.visible = true

                QueryStatsModel.setProfiling(false)
                QueryStatsModel.setProfileStatus(false)

            } else {
                datasourceNameWarningModal.open();
            }

        }
    }

    function searchTable(text){
        if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){
            tableslist.model = NewTableListModel.filterTableList(text)
        } else if(GeneralParamsModel.getDbClassification() === Constants.csvType || GeneralParamsModel.getDbClassification() === Constants.jsonType ){
            tableslist.model = CSVJsonDataModel.filterTableList(text)
        } else if(GeneralParamsModel.getDbClassification() === Constants.excelType){
            tableslist.model = ExcelDataModel.filterTableList(text)
        } else{
            tableslist.model = ForwardOnlyDataModel.filterTableList(text)
        }
    }

    function collapseTables(){

        if(collapsed === true){
            drop_icon.source = "/Images/icons/Down_20.png"
            collapsed = false
            tableslist.visible = true
        }
        else{
            drop_icon.source = "/Images/icons/Right_20.png"
            collapsed = true
            tableslist.visible = false
        }
    }


    function setDataSourceName(){
        DSParamsModel.setDsName(ds_name.text)
    }

    function focusDataSourceNameField(){
        ds_name.readOnly= false
        ds_name.focus = true;
    }


    function clearERDiagram(){
        DSParamsModel.resetDataModel()
        clearModelQueryData()
    }

    function clearQueryData(){
        DSParamsModel.resetFilter()
        DSParamsModel.setTmpSql("")
        clearModelQueryData()
    }

    function clearModelQueryData(){

        //        if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){
        //            QueryModel.removeTmpChartData()
        //        } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
        //            DuckQueryModel.removeTmpChartData()
        //        } else{
        //            ForwardOnlyQueryModel.removeTmpChartData()
        //        }

        NewTableColumnsModel.clearColumns();
    }

    function onTableToggle(){
        NewTableColumnsModel.getColumnsForTable(modelData, "TableColumns")

        toggleTableIcon.source = tablecolumnListView.visible === false ?  "/Images/icons/Down_20.png" : "/Images/icons/Right_20.png"
        if(tablecolumnListView.visible === true){
            tablecolumnListView.visible = false
            dragRect.height -= tablecolumnListView.height
        } else{
            tablecolumnListView.visible = true
            dragRect.height += tablecolumnListView.height
        }

    }

    function showTableIcon(){
        //        DashboardParamsModel.setCurrentReport(newItem.objectName)
        tableShowToggle = true


    }
    function hideTableIcon(){
        //        DashboardParamsModel.setCurrentReport(newItem.objectName)
        tableShowToggle = false

    }

    function disconnectDS(){
        if(GeneralParamsModel.getDbClassification() === Constants.sqlType || GeneralParamsModel.getDbClassification() === Constants.accessType){
            NewTableListModel.clearData()
        } else {
            ForwardOnlyDataModel.clearData()
        }

        ConnectorsLoginModel.sqlLogout()

        DSParamsModel.resetDataModel();
        DSParamsModel.resetFilter()
        DSParamsModel.setTmpSql("")
        DSParamsModel.setDsName("")

        // Clear filters
        FilterCategoricalListModel.clearFilters()
        FilterNumericalListModel.clearFilters()
        FilterDateListModel.clearFilters()
        TableSchemaModel.clearSchema()

        resetOnlineStorageType()

        // Destroy dashboards
        DashboardParamsModel.destroyDashboard(0, true)
        DashboardParamsModel.clearFilters();
        TableColumnsModel.deleteDashboard(0, true)
        TableColumnsModel.clearFilters()

        // Destroy reports
        ReportParamsModel.deleteReport(0, true)
        ReportsDataModel.deleteReportData(0, true)
        ReportsDataModel.removeTmpChartData()

        // GeneralParamsModel
        GeneralParamsModel.resetGeneralParams();

        // ChartsThread
        ChartsThread.clearCache();

        // Take back to select connection screen
        stacklayout_home.currentIndex = 3
    }

    function resetOnlineStorageType(){

        let onlineStorageType = GeneralParamsModel.getOnlineStorageType()

        switch(onlineStorageType){
        case Constants.driveType:
            DriveDS.resetDatasource()
            break;

        case Constants.sheetType:
            SheetDS.resetDatasource()
            break;

        case Constants.boxType:
            BoxDS.resetDatasource()
            break;

        case Constants.dropBoxType:
            DropboxDS.resetDatasource()
            break;

        case Constants.githubType:
            GithubDS.resetDatasource()
            break;

        }
    }


    function saveExtractPopupFunction(signalType){

        queryModellerPage.timeElapsed = 0
        waitTimer.start()

        if(signalType === true){
            saveExtractPopup.visible = true
            saveExtractPopup.open()
        } else {
            saveExtractPopup.visible = false
            saveExtractPopup.close()
        }
    }

    function saveExtractLimit(freeLimit, ifPublish){

        queryModellerPage.timeElapsed = 0
        waitTimer.stop()

        if(freeLimit){
            freeLimitExtractWarning.open()
        } else {

            if(!ifPublish){
                GeneralParamsModel.setCurrentScreen(Constants.dashboardScreen)
                stacklayout_home.currentIndex = Constants.dashboardDesignerIndex

                let currentDashboard = DashboardParamsModel.currentDashboard
            }

        }
    }

    function saveLiveLimit(ifPublish){

        queryModellerPage.timeElapsed = 0
        waitTimer.stop()

        if(!ifPublish){
            GeneralParamsModel.setCurrentScreen(Constants.dashboardScreen)
            stacklayout_home.currentIndex = Constants.dashboardDesignerIndex

            let currentDashboard = DashboardParamsModel.currentDashboard
        }
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/






    /***********************************************************************************************************************/
    // SubComponents Starts



    DataFilters{
        id: datafilters
    }

    PublishDatasource{
        id: publishDatasource
    }

    InMemory{
        id: inMemory
    }


    Component{
        id:tablelistDelegate


        Rectangle {
            id: dragRect
            width: item_querymodeller.width-10
            height: 30



            property bool caught: false

            Image {
                id: tableImg
                height: 16
                width: 16
                source: "/Images/icons/table_32.png"
                anchors.left: parent.left
                anchors.leftMargin: 35

            }

            Text {
                id: contactInfo
                text: modelData
                anchors.left: tableImg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: tableImg.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderMedium
            }

            Image {
                id: toggleTableIcon
                height: 10
                width: 10
                source : "/Images/icons/Right_20.png"
                anchors.left: parent.left
                anchors.leftMargin:  15
                anchors.verticalCenter: tableImg.verticalCenter
                visible: tableShowToggle

                //                MouseArea{
                //                    anchors.fill: parent
                //                    onClicked: menuOptions.open()

                //                }
            }






            TableColumns{
                id: tablecolumnListView
                anchors.top: tableImg.bottom
                anchors.left: parent.left
                anchors.leftMargin: 50
                visible: false
                objectName: modelData
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: dragRect
                drag.minimumX: -(  page.width - parent.width - leftMenuBar.width)
                drag.maximumX: 0
                hoverEnabled: true


                onEntered: showTableIcon();
                onExited: hideTableIcon();

                drag.onActiveChanged: {
                    if (mouseArea.drag.active) {
                        tableslist.dragItemIndex = index;
                        tableslist.tableName = modelData
                    }
                    dragRect.Drag.drop();
                }



                onClicked: {

                    NewTableColumnsModel.getColumnsForTable(modelData, "TableColumns")

                    if(tablecolumnListView.visible === true){
                        toggleTableIcon.source ="/Images/icons/Right_20.png"
                        tablecolumnListView.visible = false
                        dragRect.height -= tablecolumnListView.height
                    } else{
                        toggleTableIcon.source ="/Images/icons/Down_20.png"
                        tablecolumnListView.visible = true
                        dragRect.height += tablecolumnListView.height
                    }
                }

            }

            states: [
                State {
                    when: dragRect.Drag.active
                    ParentChange {
                        target: dragRect
                        parent: tableslist
                    }

                    AnchorChanges {
                        target: dragRect
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                }
            ]

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: dragRect.width / 2
            Drag.hotSpot.y: dragRect.height / 2

        }


    }

    MessageDialog{
        id: dataRemovalWarningDataModel
        title: Messages.warningTitle
        text: Messages.mo_dqm_warningQueryLoss
//        icon: StandardIcon.Critical

        onAccepted: {

            clearQueryData()
            dataQueryModellerStackview.pop()
            dataQueryModellerStackview.push("./SubComponents/DataModeller.qml")
        }
    }

    MessageDialog{
        id: datasourceNameWarningModal
        title: Messages.warningTitle
        text: Messages.mo_dqm_mandatoryDSName
//        icon: StandardIcon.Critical
    }

    MessageDialog{
        id: dataRemovalWarningQueryModel
        title: Messages.warningTitle
        text: Messages.mo_dqm_warningModelLoss
//        icon: StandardIcon.Critical

        onAccepted: {

            clearERDiagram()
            dataQueryModellerStackview.pop()
            dataQueryModellerStackview.push("./SubComponents/QueryModeller.qml")
        }

    }

    MessageDialog{
        id: freeLimitExtractWarning
        title: Messages.warningTitle
        text: Messages.mo_dqm_freeExtractSizeLimit
//        icon: StandardIcon.Critical

    }

    MessageDialog{
        id: extractCreationError
        title: Messages.mo_dqm_extractCreateErr
//        icon: StandardIcon.Critical
    }


    // This is a component because it uses Qt.labs.Platform
    // and this conflicts with the current file
    SaveExtract{
        id: saveFilePrompt
    }

    Timer {
        id: waitTimer
        objectName: "Timer"
        interval: 1000;
        repeat: true
        onTriggered: {
            queryModellerPage.timeElapsed++
            saveExtractPopup.timerText = Messages.mo_dqm_timeElapsed + queryModellerPage.timeElapsed + " seconds"
        }
    }

    // Throbber or loading
    // While the extract is being saved to a local file
    Popup{
        id: saveExtractPopup
        width: 600
        height: 400
        modal: true
        visible: false
        x: parent.width/2 - 300
        y: parent.height/2 - 300
        closePolicy: Popup.NoAutoClose

        property alias timerText: timeText.text

        BusyIndicatorTpl{
            id: busyIndicator
            anchors.centerIn: parent
        }

        Text{
            id: waitText
            text: Messages.mo_dqm_waitCreateExtract
            anchors.top: busyIndicator.bottom
            anchors.horizontalCenter: busyIndicator.horizontalCenter
        }

        Text{
            id: timeText
            text: Messages.mo_dqm_timeElapsed +  "0 seconds"
            anchors.top: waitText.bottom
            anchors.horizontalCenter: waitText.horizontalCenter
        }
    }

    ButtonGroup{
        id: memoryType
    }



    // SubComponents ends
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Page Design Starts

    // Left menubar starts

    LeftMenuBar{
        id: left_menubar
    }

    // Left menubar ends


    // Top toolbar starts - Sub menu -> Data modeller and Query Modeller Tabs + Filter Btns

    Rectangle{
        id: submenu
        height: 25
        width: parent.width - menu_width - column_querymodeller.width
        x: menu_width - 11
        // color:"red"


        TabBar{

            id: tabbutton_querymodeller
            contentHeight :parent.height+1
            width:202


            // Data Modeller Button starts

            TabButton{
                id: datamodeller_querymodeller
                text: Messages.mo_dqm_dataTabName
                width:100
                height: parent.height
                

                onClicked: onDataModellerClicked()
                onHoveredChanged: onDataModellerHovered()

                background: Rectangle {
                    id: datamodeller_querymodeller_background
                    color: {
                        datamodeller_querymodeller.hovered ? Constants.grafieksGreenColor : Constants.themeColor
                    }
                }

                contentItem: Text{
                    id: datamodeller_querymodeller_text
                    text: datamodeller_querymodeller.text
                    color:  datamodeller_querymodeller.hovered ? Constants.whiteColor : Constants.blackColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Component.onCompleted: {
                    datamodeller_querymodeller_background.color = Constants.leftDarkColor
                    datamodeller_querymodeller_text.color = Constants.blackColor
                }

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_dataTabDesc

            }

            // Data Modeller Button ends



            // Query Modeller Button starts

            TabButton{
                id: queryModellerTab
                text: Messages.mo_dqm_queryTabName
                width:100
                height: parent.height


                onClicked: onQueryModellerClicked()
                onHoveredChanged: onQueryModellerHovered()

                background: Rectangle {
                    id: queryModellerTab_background
                    color:  queryModellerTab.hovered ? Constants.grafieksGreenColor : Constants.themeColor

                }

                contentItem: Text{
                    id: queryModellerTab_text
                    text: queryModellerTab.text
                    color:  queryModellerTab.hovered ? Constants.whiteColor : Constants.blackColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_queryTabDesc

            }

            //    TabButton {
            //         id: tabPublishDashboarda
            //        text: qsTr("Home")
            //    }
            //    TabButton {
            //        text: qsTr("Discover")
            //    }

            // Query Modeller button ends



        }

        Row{
            id: toptool_querymodeller
            anchors.right: submenu.right
            anchors.rightMargin: 10

            // Disconnect Button starts

            //            Button{
            //                id: disconnect_btn
            //                width: disconnect_text.text.length * 8
            //                height: 28

            //                Text{
            //                    id: disconnect_text
            //                    text: "Disconnect " + ConnectorsLoginModel.connectedDB
            //                    anchors.centerIn: parent
            //                }

            //                onClicked: disconnectDS()
            //            }

            // Disconnect Button ends

            // Refresh button starts

            Button{
                id:refresh_querymodeller
                height: 28
                width: 30
                visible: radio_live.radio_checked === false ? true: false

                Image{

                    source: "/Images/icons/Refresh_30.png"
                    anchors.topMargin: 4
                    anchors.left: refresh_querymodeller.left
                    anchors.top: refresh_querymodeller.top
                    anchors.leftMargin: 5
                    height: 20
                    width: 20

                }


                background: Rectangle{
                    color: refresh_querymodeller.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: onRefreshBtnClicked()

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_inmemoryDesc

            }

            // Refresh button ends




            // Filter button starts

            Button{
                id: filter_btn
                width: 100
                height: 28
                anchors.leftMargin: 10

                Image{
                    id: filter_querymodeller
                    source: "/Images/icons/Plus_32.png"
                    anchors.topMargin: 4
                    anchors.leftMargin: 10
                    anchors.left: filter_btn.left
                    anchors.top: filter_btn.top
                    height: 20
                    width: 20

                }

                Text{
                    id: filterText
                    text: Messages.mo_dqm_filterName
                    anchors.top: filter_btn.top
                    anchors.left: filter_querymodeller.right
                    anchors.topMargin: 6
                    anchors.leftMargin: 5
                }

                Text {
                    id: filterLeftSquareBracket
                    anchors.left: filterText.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    anchors.leftMargin: 2
                    text: qsTr("[")
                    color: Constants.grafieksGreen
                }
                Text {
                    id: filterNumber
                    anchors.left: filterLeftSquareBracket.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    text: qsTr("0")
                }
                Text {
                    id: filterRightSquareBracket
                    anchors.left: filterNumber.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    text: qsTr("]")
                    color: Constants.grafieksGreen
                }

                background: Rectangle{
                    color: filter_btn.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: openDataFilters()

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_filterDesc
            }

            // Filter button ends

            // In memory radio button starts

            CustomRadioButton{
                id: radio_memory
                radio_text: Messages.mo_dqm_extractName
                parent_dimension: 16

                ButtonGroup.group: memoryType
                onCheckedChanged: onInMemorySelected()

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_extractDesc
            }

            // In memory radio button ends

            // Live radio button starts


            CustomRadioButton{
                id: radio_live
                radio_text: Messages.mo_dqm_liveName
                enabled: true
                parent_dimension: 16
                ButtonGroup.group: memoryType
                onCheckedChanged: onLiveSelected()

                ToolTip.delay:Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipHideTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.mo_dqm_liveDesc
            }

            // Live radio button ends
        }

    }

    /***********************************************************************************************************************/


    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width - 80
        anchors.top: submenu.bottom
        leftPadding: left_menubar.width
        anchors.topMargin:-5
        anchors.horizontalCenter: submenu.horizontalCenter

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

    }

    // Top toolbar ends





    /***********************************************************************************************************************/
    // Center Panel starts

    StackView{
        id: dataQueryModellerStackview

        anchors.top: toolsep1.bottom
        //        anchors.topMargin: 2
        anchors.left:left_menubar.right
        height:queryModellerPage.height - 300
        width: queryModellerPage.width - menu_width - column_querymodeller.width
        rightPadding: 10
        leftPadding: 10

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 1
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 1
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 1
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 1
            }
        }

        initialItem: DataModeller{}

    }


    // Center Panel Ends
    /***********************************************************************************************************************/



    // Data table and other info at bottom Starts

    InfoTable{

        id: infodata_table
        anchors.top: dataQueryModellerStackview.bottom
        anchors.left: left_menubar.right
        width: parent.width
        visible: true

    }

    // Info table Ends


    //    ToolSeparator{
    //        id: toolsep2
    //        height:parent.height
    //        anchors.right:parent.right
    //        anchors.top: parent.top
    //        anchors.rightMargin: 194
    //        anchors.topMargin: -5
    //    }

    JoinPopup{
        id: joinPopup
    }


    // Righthand Panel starts


    Column{
        id: column_querymodeller

        height:parent.height
        width: 205
        anchors.right:parent.right
        spacing: 50



        Rectangle{
            id: rectangle_querymodeller_right_col
            color:Constants.themeColor
            width:column_querymodeller.width
            height:column_querymodeller.height
            border.color: Constants.darkThemeColor
            



            ToolSeparator{
                id: toolsep2
                height:parent.height
                anchors.left:parent.left
                anchors.top: parent.top
                anchors.leftMargin:  -7
                anchors.topMargin: -5



                MouseArea{
                    id: rightPanelDragMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.SizeHorCursor
                    width: parent.width
                    height: parent.height

                    onPositionChanged: {

                        onDragRightPanel(mouse)

                    }

                }

            }


            // Tab button starts

            TabBar{
                id: tabbar_querymodeller

                width:rectangle_querymodeller_right_col.width
                contentHeight :25
                z: 20

                background: Rectangle {
                    color: "transparent"
                }
                // Next button starts

                TabButton{
                    id: tabPublishDashboard
                    width:rectangle_querymodeller_right_col.width / 2
                    height: parent.height
                    z: 20

                    Image {
                        id: publishIcon
                        source: "/Images/icons/publish_20.png"
                        height: 20
                        width: 20
                        anchors.centerIn: parent
                    }

                    onClicked: onPublishDataSourceClicked()

                    background: Rectangle{
                        width: parent.width-2
                        color: Constants.grafieksLightGreenColor
                        opacity: tabPublishDashboard.hovered ? 0.42 : 1
                    }

                    ToolTip.delay:Constants.tooltipShowTime
                    ToolTip.timeout: Constants.tooltipHideTime
                    ToolTip.visible: hovered
                    ToolTip.text: Messages.mo_dqm_publishDs

                }


                TabButton{
                    id: tabCreateDashboard
                    width:rectangle_querymodeller_right_col.width / 2+1
                    height: parent.height
                    z: 20

                    Image {
                        id: dashboardIcon
                        source: "/Images/icons/create_dashboard_20.png"
                        height: 20
                        width: 20
                        anchors.centerIn: parent
                    }

                    contentItem: Text{
                        id:tabCreateDashboard_text
                    }
                    background: Rectangle {
                        width: parent.width
                        color: Constants.grafieksLightGreenColor
                        opacity: tabCreateDashboard.hovered ? 0.42 : 1
                    }

                    onClicked: onCreateDashboardClicked()

                    ToolTip.delay:Constants.tooltipShowTime
                    ToolTip.timeout: Constants.tooltipHideTime
                    ToolTip.visible: hovered
                    ToolTip.text: Messages.mo_dqm_createDashboard

                }

                // Next button ends
            }

            // Tab button ends



            // Right item 1 starts

            Rectangle{
                id: rectangle_querymodeller_right_col1

                anchors.top: tabbar_querymodeller.bottom
                anchors.topMargin: 2

                height:30
                width: rectangle_querymodeller_right_col.width
                z: 20



                TextField{
                    id: ds_name
                    placeholderText: Messages.mo_dqm_dsNamePlaceholder
                    anchors.verticalCenter: rectangle_querymodeller_right_col1.verticalCenter
                    anchors.left: rectangle_querymodeller_right_col1.left
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    readOnly: false
                    selectByMouse: true
                    width:250
                    height: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    font.pixelSize: 14
                    verticalAlignment:TextEdit.AlignVCente

                    // Set the text
                    onTextChanged: setDataSourceName()
                    background: Rectangle{
                        color: "transparent"
                        border.color: "transparent"
                    }
                    Keys.onReturnPressed: ds_name.focus = false

                }


                //                Image {
                //                    id: dataSourceNameEditIcon
                //                    source: "/Images/icons/edit-32.png"
                //                    height: 20
                //                    width: 20
                //                    anchors.right: parent.right
                //                    anchors.rightMargin: 17
                //                    anchors.verticalCenter: parent.verticalCenter

                //                    ToolTip.delay:Constants.tooltipShowTime
                //                    ToolTip.timeout: Constants.tooltipHideTime
                //                    ToolTip.text: qsTr("Edit datasource name")
                //                    ToolTip.visible:  mouseAreaEditDS.containsMouse? true : false

                //                    MouseArea{
                //                        id: mouseAreaEditDS
                //                        anchors.fill: parent
                //                        onClicked: focusDataSourceNameField()
                //                        hoverEnabled: true

                //                    }

                //                }


            }

            // Right item 1 ends

            // Right item 2 starts

            Rectangle{
                id: rectangle_querymodeller_right_col2

                anchors.top: rectangle_querymodeller_right_col1.bottom
                anchors.topMargin: 2
                height:30
                width: rectangle_querymodeller_right_col.width
                color:Constants.themeColor
                z: 20

                Text{
                    id: connected_to
                    text: Messages.mo_dqm_connectedTo
                    anchors.verticalCenter: rectangle_querymodeller_right_col2.verticalCenter
                    anchors.left: rectangle_querymodeller_right_col2.left
                    anchors.leftMargin: 10

                }
            }

            // Right item 2 ends

            // Right item 3 starts

            Rectangle{
                id: rectangle_querymodeller_right_col3

                anchors.top: rectangle_querymodeller_right_col2.bottom
                anchors.topMargin: 2
                height:40
                width: rectangle_querymodeller_right_col.width
                z: 20

                Row{

                    id: row_querymodeller_right_col
                    width: parent.width-10
                    height: 30

                    TextField{
                        id:searchTextBox
                        placeholderText: Messages.search
                        selectByMouse: true
                        width: parent.width -8
                        height:30
                        cursorVisible: true
                        anchors.top: row_querymodeller_right_col.top
                        anchors.topMargin: 5
                        anchors.leftMargin: 5
                        anchors.horizontalCenter: row_querymodeller_right_col.horizontalCenter

                        background: Rectangle{
                            border.width: 0
                        }

                        onTextChanged: searchTable(searchTextBox.text)

                    }
                }

                ToolSeparator{
                    id: toolsep3
                    orientation: Qt.Horizontal
                    width: rectangle_querymodeller_right_col3.width - 20
                    anchors.top: row_querymodeller_right_col.bottom
                    anchors.horizontalCenter: row_querymodeller_right_col.horizontalCenter
                    // anchors.topMargin: 1
                }
            }

            // Right item 3 ends

            // Right item 4 starts

            Item{
                id: item_querymodeller
                width: rectangle_querymodeller_right_col3.width - 10
                anchors.top: rectangle_querymodeller_right_col3.bottom
                anchors.topMargin: 2




                Rectangle{

                    height: column_querymodeller.height - 180
                    width:column_querymodeller.width
                    

                    Rectangle {
                        id: categoryItem
                        height: 40
                        width: column_querymodeller.width

                        z: 20


                        Rectangle{
                            id:dateRect
                            height: 30
                            width: parent.width+1
                            color: Constants.themeColor
                            //            anchors.top: parent.top
                            x:-1

                            border.color: Constants.darkThemeColor

                            Image {
                                id: database
                                height: 20
                                width: 18
                                source: "/Images/icons/database_32x36.png"
                                anchors.left: drop_icon.right
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                id:database_name
                                anchors.left: database.right
                                anchors.leftMargin: 10
                                width: categoryItem.width-100
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: Constants.fontCategoryHeaderMedium
                                text: ConnectorsLoginModel.connectedDB
                                elide: Text.ElideRight


                                ToolTip.delay:Constants.tooltipShowTime
                                ToolTip.timeout: Constants.tooltipHideTime
                                ToolTip.text: qsTr(Messages.mo_dqm_connectedDb + ConnectorsLoginModel.connectedDB + " ")
                                ToolTip.visible: mouseAreaCurrentDB.containsMouse? true: false

                                MouseArea{
                                    id: mouseAreaCurrentDB
                                    anchors.fill: parent
                                    hoverEnabled: true

                                }
                            }

                            Image {
                                id: power_icon
                                source: "/Images/icons/PowerOff.png"
                                width: 18
                                height: 18
                                anchors.left: database_name.right
                                anchors.leftMargin:  13
                                anchors.verticalCenter: parent.verticalCenter
                                visible: true

                                ToolTip.delay:Constants.tooltipShowTime
                                ToolTip.timeout: Constants.tooltipHideTime
                                ToolTip.text: Messages.mo_dqm_disconnect
                                ToolTip.visible: mousePowerIcon.containsMouse ? true: false

                                MouseArea{
                                    id:mousePowerIcon
                                    anchors.fill: parent
                                    onClicked: disconnectDS()
                                    hoverEnabled: true
                                }




                            }

                            Image {
                                id: drop_icon
                                source: "/Images/icons/Down_20.png"
                                width: 10
                                height: 10
                                anchors.left: parent.left
                                anchors.leftMargin:  5
                                anchors.verticalCenter: parent.verticalCenter
                                visible: true

                                ToolTip.delay:Constants.tooltipShowTime
                                ToolTip.timeout: Constants.tooltipHideTime
                                ToolTip.text: Messages.mo_dqm_showHideTables
                                ToolTip.visible: mouseAreaShowHide.containsMouse ? true: false

                                MouseArea {
                                    id: mouseAreaShowHide
                                    anchors.fill: parent
                                    onClicked: collapseTables()
                                    hoverEnabled: true
                                }

                            }
                        }
                    }

                    ListView {
                        id: tableslist
                        spacing: 0
                        anchors.top: categoryItem.bottom
                        height : parent.height-categoryItem.height
                        width: item_querymodeller.width+10
                        delegate: tablelistDelegate
                        visible: true

                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        ScrollBar.vertical: ScrollBar {}


                        property int dragItemIndex: -1
                        property string tableName : ""
                    }

                }
            }

        }
    }

    // Righthand Panel ends


    //Page Design Ends
    /***********************************************************************************************************************/


}
