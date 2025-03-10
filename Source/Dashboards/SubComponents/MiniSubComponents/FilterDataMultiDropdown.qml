import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {

    id: filterDataMultiItem
    height: comboBox.height + columnName.height
    width: parent.width-25
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataMultiItem.objectName
    property var modelContent: []
    property bool master: false

    ListModel{
        id: listModel
        dynamicRoles: true
    }

    onComponentNameChanged: {

        idPlesaeWaitThorbber.visible = true
        idPlesaeWaitText.visible = true

        if(GeneralParamsModel.getAPISwitch()) {
            // This part is taken care in DashboardFiltersAdd addNewFilterColumns()
        } else if(GeneralParamsModel.getFromLiveFile() || GeneralParamsModel.getFromLiveQuery()){
            modelContent = TableColumnsModel.fetchColumnDataLive(componentName)
            processDataList(modelContent)
        } else {
            modelContent = TableColumnsModel.fetchColumnData(componentName)
            processDataList(modelContent)
        }


    }

    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    Connections {
        target: TableColumnsModel

        function onColumnDataChanged(columnData, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard)
                processDataList(columnData)
        }
    }

    function processDataList(modelContent){
        modelContent.unshift("Select All")

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        var i = 0;
        listModel.clear()

        if(previousCheckValues.length > 0){
            modelContent.forEach(item => {
                                     var checkedStatus = previousCheckValues.includes(item) ? true : false;
                                     listModel.append({"name": item, "checked": checkedStatus, "index": i})
                                     i++
                                 })
        } else {
            modelContent.forEach(item => {
                                     listModel.append({"name": item, "checked": true, "index": i})
                                     i++
                                 })
        }


        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)

        // for the first time, select all values
        master = true

        idPlesaeWaitThorbber.visible = false
        idPlesaeWaitText.visible = false
    }

    function onMultiSelectCheckboxSelected(modelData,checked, index){

        if(checked === true){

            // Start pushing the individual checked item in the array
            DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

        } else{
            // Remove item if unchecked
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)
        }

    }

    function filterClicked(){

        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }

    function selectAll(checkedState){
        DashboardParamsModel.setSelectAll(checkedState, componentName, DashboardParamsModel.currentDashboard)

        if(checkedState === true){
            modelContent.forEach(item => {
                                     DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, item)
                                 })

        } else {
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        }
    }

    ButtonGroup {
        id: childGroup
        exclusive: false
    }


    Rectangle{
        height: parent.height
        width: parent.width
        color: "white"
        border.color: Constants.darkThemeColor
        Rectangle{
            id:columnName
            width:parent.width
            height:25


            color: Constants.themeColor

            border.color: Constants.darkThemeColor
            Row{

                spacing: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15


                Text {
                    id: componentTitle
                    width:123
                    elide: Text.ElideRight
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    verticalAlignment: Text.AlignVCenter
                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        source: "/Images/icons/customize.png"
                        width: 16
                        height: 16
                        MouseArea{
                            anchors.fill: parent
                            onClicked: filterClicked()
                        }
                    }
                }
            }
        }

        BusyIndicatorTpl{
            id: idPlesaeWaitThorbber
            anchors.centerIn: parent
        }

        Text {
            id: idPlesaeWaitText
            text: Messages.loadingPleaseWait
            anchors.top: idPlesaeWaitThorbber.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ComboBox {
            id: comboBox
            width: parent.width
            model: listModel
            anchors.top : columnName.bottom

            indicator: Canvas {
                id: canvasMultiselect
                x: comboBox.width - width - comboBox.rightPadding
                y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: comboBox
                    function onPressedChanged(){
                        canvas.requestPaint()
                    }
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = comboBox.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }

            // ComboBox closes the popup when its items (anything AbstractButton derivative) are
            //  activated. Wrapping the delegate into a plain Item prevents that.
            delegate: Item {
                width: parent.width
                height: checkDelegate.height

                function toggle() {
                    checkDelegate.toggle()
                }

                CheckDelegate {
                    id: checkDelegate
                    checked:  model.checked
                    highlighted: comboBox.highlightedIndex === model.index
                    anchors.fill: parent
                    objectName: model.index

                    indicator: Rectangle {
                        id: parent_border
                        implicitHeight: 16
                        implicitWidth: 16
                        x:  checkDelegate.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: "black"


                        Rectangle {
                            id: child_border
                            width: 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: checkDelegate.down ?  Constants.darkThemeColor : "black"
                            visible: checkDelegate.checked
                        }
                    }
                    contentItem: Text {
                        text: model.name
                        elide: Text.ElideLeft
                        leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
                    }

                    Component.onCompleted: {
                        if(index > 0){
                            ButtonGroup.group = childGroup
                        }
                    }

                    onCheckedChanged: {

                        if(index === 0){
                            childGroup.checkState = checkDelegate.checkState
                            for(var i =0; i < listModel.count; ++i){
                                listModel.setProperty(i, "checked", checked)
                            }
                            if(checked === true){
                                master = true
                            } else {
                                master = false
                            }
                        } else {

                            if(master === true && checked === false){
                                master = false
                                for(var i =0; i < listModel.count; ++i){
                                    listModel.setProperty(i, "checked", false)
                                }
                            }

                            if(master === false && checked === true){
                                listModel.setProperty(model.index, "checked", true)
                            }
                            onMultiSelectCheckboxSelected(model.name, checked, index)
                        }
                    }
                }
            }
        }
    }
}
