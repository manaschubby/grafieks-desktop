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

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    //property string selectOption: "Select numerical"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:60
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    property int counter: 0
    property var acceptedValues:["Equal", "Not Equal To", "Smaller Than", "Greater Than", "Equal or Smaller Than", "Equal or Greater Than", "Between"]



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: listModel
        ListElement{
            menuItem:"Equal"
        }
        ListElement{
            menuItem:"Not Equal To"
        }
        ListElement{
            menuItem:"Smaller Than"
        }
        ListElement{
            menuItem:"Greater Than"
        }
        ListElement{
            menuItem:"Equal or Smaller Than"
        }
        ListElement{
            menuItem:"Equal or Greater Than"
        }
        ListElement{
            menuItem:"Between"
        }
    }



    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DSParamsModel

        function onResetInput(){
            textField.text =""
            textField2nd.text =""
            selectOption.textValue ="Equal"
            DSParamsModel.setIncludeNullMap(counter, true)
            DSParamsModel.setExcludeMap(counter, false)
        }

        function onInternalCounterChanged(){
            if(DSParamsModel.section === Constants.numericalTab){
                counter = DSParamsModel.internalCounter
            }
        }

        function onFilterIndexChanged(){
            counter = DSParamsModel.filterIndex
        }
    }

    Connections{
        target: CSVJsonDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ExcelDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: ForwardOnlyDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    Connections{
        target: QueryDataModel

        function onColumnListModelDataChanged(values){
            updateData(values)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function slotDataCleared(){

    }

    function slotEditModeNumerical(relation, slug, value){

        topContent.visible = true
        if( slug === "Between"){
            var valueList = value.split(" And ")
            textField.text = valueList[0]
            textField2nd.text = valueList[1]
            selectOption.textValue = slug
        }
        else{
            textField.text = value
            selectOption.textValue = slug
        }
    }

    function updateData(options){

        var jsonOptions = JSON.parse(options)

        if(DSParamsModel.section === Constants.numericalTab){

            if(jsonOptions.slug === Constants.slugBetweenRelation){

                var splitValues = jsonOptions.values.split(" And ")
                textField.text = splitValues[0]
                textField2nd.text = splitValues[1]
            } else{
                textField.text = jsonOptions.values
            }

            selectOption.textValue = jsonOptions.slug

        }
    }

    function getNewRelation(tmpRelation){

        let newRelation = ""

        switch(tmpRelation){

        case acceptedValues[0]:
            newRelation = Constants.equalRelation
            break

        case acceptedValues[1]:
            newRelation = Constants.notEqualRelation
            break

        case acceptedValues[2]:
            newRelation = Constants.smallerThanRelation
            break

        case acceptedValues[3]:
            newRelation = Constants.greaterThanRelation
            break

        case acceptedValues[4]:
            newRelation = Constants.smallerThanEqualRelation
            break

        case acceptedValues[5]:
            newRelation = Constants.greaterThanEqualRelation
            break

        case acceptedValues[6]:

            newRelation = Constants.betweenRelation
            break
        }
        return newRelation
    }

    function onNumericalInput(value1, value2, tmpRelation){

        var newValue = value1
        if(tmpRelation === "Between"){
            newValue = value1 + " And " + value2
        }

        let relation = getNewRelation(tmpRelation)
        DSParamsModel.addToJoinValue(counter, newValue)
        DSParamsModel.addToJoinRelation(counter, relation)
        DSParamsModel.addToJoinRelationSlug(counter, tmpRelation)

    }



    function onIncludeCheckStateChanged(checked){
        DSParamsModel.setIncludeNullMap(counter, checked)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        id: numericalHeading

        height: 40
        width: parent.width

        color: "transparent"

        /******************* DO NOT DELETE *********************
        Column{

            id: addnumerical
            anchors.top: parent.top
            anchors.topMargin: 10

            anchors.left: parent.left
            leftPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBoxTpl {
                id: checkedIncludeNull
                checked: DSParamsModel.getIncludeNullMap(counter)[counter] === "1" ? true : false
                parent_dimension: Constants.defaultCheckBoxDimension
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    onIncludeCheckStateChanged(checked)
                }
            }


        }


        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {

                    onExludeCheckStateChanged(checked)
                }
            }


        }
        ************************************************************/
    }

    Rectangle{
        id: conditionRow

        height: 30
        width: parent.width
        color: "transparent"

        anchors.top: numericalHeading.bottom
        anchors.topMargin: 5

        Text {
            id: name
            text: Messages.filterConditionText
            leftPadding: 20
        }



    }

    Rectangle{
        anchors.top: conditionRow.bottom
        width: parent.width
        height: 30
        color: "transparent"

        Rectangle{
            id: numericalOptionRow
            anchors.left: parent.left
            width: parent.width / 3
            height: 30
            color: "transparent"


            SelectDropdown{
                id: selectOption
                textValue:"Equal"
                list: listModel
                height: listModel.count * 30
                anchors.left: parent.left
                anchors.leftMargin: 20
                onTextValueChanged: {
                    if(selectOption.textValue === "Between"){
                        numericalTextBox2nd.visible = true
                    }
                    else{
                        numericalTextBox2nd.visible = false
                    }
                    onNumericalInput(textField.text, textField2nd.text, selectOption.textValue)
                }
            }

            Rectangle{
                id: numericalTextBox
                width : 200
                height : 30
                anchors {
                    left : selectOption.right
                    leftMargin: 100
                }

                TextField{
                    id : textField
                    selectByMouse: true
                    height : parent.height
                    width : parent.width
                    placeholderText: Messages.mo_mini_cfwc_enterValue
                    onActiveFocusChanged: {
                        numericalTextBox.border.color = "blue"
                    }
                    onTextChanged: onNumericalInput(textField.text, textField2nd.text, selectOption.textValue)

                }

            }

            Rectangle{
                id: numericalTextBox2nd
                width : 200
                height : 30
                visible : false
                anchors {
                    left : numericalTextBox.right
                    leftMargin: 15
                }

                TextField{
                    id : textField2nd
                    selectByMouse: true
                    height : parent.height
                    width : parent.width
                    placeholderText: Messages.mo_mini_cfwc_enterValue
                    onActiveFocusChanged: {
                        numericalTextBox.border.color = "blue"
                    }
                    onTextChanged: onNumericalInput(textField.text, textField2nd.text, selectOption.textValue)
                }
            }
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}

