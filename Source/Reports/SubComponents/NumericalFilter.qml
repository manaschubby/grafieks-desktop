import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"
import "../SubComponents/MiniSubComponents"

Popup {
    id: numericalFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose
    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    property int filterIndex: 0
    property int counter: 0



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: checkListModel

        ListElement{
            textValue:"All"
        }

        ListElement{
            textValue:"All 1"
        }

        ListElement{
            textValue:"All 2"
        }

        ListElement{
            textValue:"All 3"
        }
    }



    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal clearData()
    signal signalNumericalEditData(string relation, string sug, string value)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections{
        target: ReportParamsModel

        function onInternalCounterChanged(){
            counter = ReportParamsModel.internalCounter
        }

        function onFilterIndexChanged(){
            counter = ReportParamsModel.filterIndex
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        numericalFilterPopup.signalNumericalEditData.connect(topContent.slotEditModeNumerical)

        numericalFilterPopup.clearData.connect(topContent.slotDataCleared)
    }
    // SLOT function
    function slotEditMode(section, category, subCategory, relation, slug, value){

        if(section === Constants.numericalTab){

            topContent.visible = true
            numericalFilterPopup.signalNumericalEditData(relation, slug, value)
        }
    }


    function closePopup(){
        numericalFilterPopup.visible = false
        ReportParamsModel.clearFilter()
    }

    function onCancelClicked(){
        closePopup()
        ReportParamsModel.clearFilter();
    }

    function onApplyClicked(){

        numericalFilterPopup.visible = false

        var filterIndex = ReportParamsModel.filterIndex
        var section = ReportParamsModel.section
        var category = ReportParamsModel.category
        var subCategory = ReportParamsModel.subCategory
        var tableName = ReportParamsModel.tableName
        var columnName = ReportParamsModel.colName

        ReportParamsModel.addToFilterSectionMap(counter, section)
        ReportParamsModel.addToFilterCategoryMap(counter, category)
        ReportParamsModel.addToFilterSubCategoryMap(counter, subCategory)
        ReportParamsModel.addToFilterColumnMap(counter, columnName, tableName)
        ReportParamsModel.addToNumericalFilters(counter)

        manageFilters(ReportParamsModel.mode, counter, ReportParamsModel.filterModelIndex)

        // Reset all DSParams
        ReportParamsModel.clearFilter();

        // Clear tabs individual temp data
        dateFilterPopup.clearData()

        // Call the function to apply all the filters in reports
        // This will emit a signal from ReportParamsModel.fetchMasterReportFilters to the slot in ChartsModel.updateFilterData
        ReportParamsModel.fetchMasterReportFilters(ReportParamsModel.reportId)

    }

    function manageFilters(mode, counter = 0, filterId = 0){

        console.log("INSERT INTO NUMERICAL FILTERS  - INSERT REPORT ID", mode, counter, filterId)
        ReportParamsModel.addToMasterReportFilters(ReportParamsModel.reportId);

    }



    function onResetClicked(){
        closePopup()
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
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1


        Text{
            id : text1
            text: Messages.re_sub_common_header
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

                    closePopup()

                }
            }
        }

    }

    // Popup Header ends

    //    Top Menu Contents

    NumericalFilterInnerPopup{
        id: topContent
    }

    // Footer starts

    Rectangle{
        id: footerContent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 20

        height: 30
        width: parent.width

        color: "transparent"

        CustomButton{
            id: resetBtn
            textValue:  Messages.resetBtnTxt

            anchors.left: parent.left
            anchors.leftMargin: 20

            onClicked: {

                onResetClicked()
            }
        }



        CustomButton{
            id: apply_btn1
            textValue:  Messages.applyBtnTxt

            anchors.right: parent.right
            anchors.rightMargin: 20


            onClicked: {

                onApplyClicked()

            }
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            textValue: Messages.cancelBtnTxt
            onClicked: {
                onCancelClicked()
            }


        }


    }

    // Footer ends

    // Page Design Ends
    /***********************************************************************************************************************/


}
