#include "dsparamsmodel.h"

DSParamsModel::DSParamsModel(QObject *parent) : QObject(parent),counter(1)
{

    m_section = Constants::defaultTabSection;
    m_category = Constants::defaultCategory;
    m_subCategory = Constants::defaultSubCategory;
    m_mode = Constants::defaultMode;
    //    m_exclude = Constants::defaultExclude;
    //    m_includeNull = Constants::defaultIncludeNull;
    //    m_selectAll = Constants::defaultSelectAll;
    m_internalCounter = 0;
    m_filterIndex = 0;
}

void DSParamsModel::closeModel()
{

    this->resetDataModel();


    this->joinOrder.clear();
    this->joinRelation.clear();
    this->joinValue.clear();
    this->joinRelationSlug.clear();
    this->dateFormatMap.clear();
    this->actualDateValues.clear();
}

DSParamsModel::~DSParamsModel()
{

}

void DSParamsModel::executeModelerQuery()
{
    emit processQuery();
}

void DSParamsModel::disconnectDS()
{
    emit disconnectAll();
}

void DSParamsModel::resetDataModel()
{

    // First emit the signals to destroy the visual objects in qml
    emit destroyLocalObjectsAndMaps();

    this->hideColumns.clear();
    this->joinBoxTableMap.clear();
    this->joinTypeMap.clear();
    this->joinIconMap.clear();
    this->joinMapList.clear();
    this->primaryJoinTable.clear();
    this->querySelectParamsList.clear();
    this->joinOrder.clear();
    this->existingTables.clear();
    this->rectangles.clear();
    this->frontRectangleCoordinates.clear();
    this->rearRectangleCoordinates.clear();
    this->newConnectingLine.clear();
    this->frontLineMap.clear();
    this->rearLineMap.clear();
    this->newJoinBox.clear();

}



QVariantList DSParamsModel::readDatasource(QString filename)
{

    QVariantList fileReadStatus;

    QString dbDriver = "",
            typeOfConnection = "",
            tmpSql = "",
            section = "",
            category = "",
            subCategory = "",
            tableName = "",
            colName = "",
            mode = "",
            dsName = "",
            dsType = "",
            extractColName = "",
            dbDriverCredential = "",
            dbHostCredential = "",
            dbFileNameCredential = "",
            dbPortCredential = "",
            dbUsernameCredential = "";

    int modellerType = 0,
            internalCounter = 0,
            filterIndex = 0,
            joinId = 0,
            displayRowsCount = 0,
            schedulerId = 0;

    QVariantMap joinRelation, joinValue, joinRelationSlug;
    QStringList hideColumns;
    QMap<int, QStringList> joinBoxTableMap;
    QMap<int, QString> joinTypeMap;
    QMap<int, QString> joinIconMap;
    QMap<int, QMap<int, QStringList>> joinMapList;
    QMap<int, QString> primaryJoinTable;
    QStringList querySelectParamsList;
    QVariantList joinOrder;

    bool exclude = false,
            includeNull = false,
            selectAll = false,
            isFullExtract = false;

    // Filename resource uri to filepath
    QFile file(QUrl(filename).toLocalFile());

    // Check if file readable
    if (!file.open(QFile::ReadOnly))
    {
        return fileReadStatus << Messages::FILE_READ_ERROR << Messages::fileReadError;
    }

    QDataStream in(&file); // read the data serialized from the file

    // Read and check the header
    quint32 magic;
    in >> magic;
    if (magic != 0x785AA164)
        return fileReadStatus << Messages::FILE_FORMAT_ERROR << Messages::fileFormatInvalid;

    // Read the version
    qint32 version;
    in >> version;

    if (version <= 100)
        return fileReadStatus << Messages::FILE_TOO_OLD << Messages::fileTooOld;

    if (version > 100)
        in.setVersion(QDataStream::Qt_5_15);

    in >> dbDriver;
    in >> typeOfConnection;
    in >> modellerType;

    if (modellerType == 1)
    {

        // 4. For Query Modeller
        in >> tmpSql;
        in >> joinRelation;
        in >> joinValue;
        in >> joinRelationSlug;
        in >> internalCounter;
        in >> section;
        in >> category;
        in >> subCategory;
        in >> tableName;
        in >> colName;
        in >> exclude;
        in >> includeNull;
        in >> selectAll;
        in >> filterIndex;
        in >> mode;
    }
    else
    {

        in >> hideColumns;
        in >> joinBoxTableMap;
        in >> joinTypeMap;
        in >> joinIconMap;
        in >> joinMapList;
        in >> primaryJoinTable;
        in >> querySelectParamsList;
        in >> joinOrder;
        in >> joinId;
    }

    in >> dsName;
    in >> dsType;
    in >> displayRowsCount;

    // 7. InMemory config parameters
    in >> schedulerId;
    in >> isFullExtract;
    in >> extractColName;

    // 8. For Live - Login credentials (sans password). For Extract - Data

    if (dsType == "live")
    {

        in >> dbDriverCredential;
        in >> dbHostCredential;
        in >> dbFileNameCredential;
        in >> dbPortCredential;
        in >> dbUsernameCredential;
    }
    else
    {
    }


    return fileReadStatus << Messages::FILE_READ_SUCCESS << Messages::fileReadSuccess;
}

void DSParamsModel::resetFilter()
{
    // Q_PROPERTY clear
    this->setInternalCounter(0);
    this->setSection(Constants::defaultTabSection);
    this->setCategory(Constants::defaultCategory);
    this->setSubCategory(Constants::defaultSubCategory);
    this->setTableName("");
    this->setColName("");
    this->setFilterIndex(0);
    this->setFilterModelIndex(0);
    this->setMode(Constants::defaultMode);

    // Variables clear
    this->removeJoinRelation(0, true);
    this->removeJoinValue(0, true);
    this->removeJoinRelationSlug(0, true);
    this->removeIncludeNullMap(0, true);
    this->removeIncludeNullMap(0, true);
    this->removeSelectAllMap(0, true);
    this->removeTmpSelectedValues(0, true);
    this->removeTmpFilterIndex(0, true);
    this->removeDateFormatMap(0, true);
    this->removeActualDateValues(0, true);
}

void DSParamsModel::clearFilter()
{
    // Q_PROPERTY
//    this->setSection(Constants::defaultTabSection);
//    this->setCategory(Constants::defaultCategory);
//    this->setSubCategory(Constants::defaultSubCategory);

    // variable change
    this->removeTmpSelectedValues(0, true);
    this->removeTmpFilterIndex(0, true);

}

void DSParamsModel::addToHideColumns(QString colName)
{
    this->hideColumns.append(colName);
    emit hideColumnsChanged(this->hideColumns);
}

void DSParamsModel::removeFromHideColumns(QString colName, bool removeAll)
{
    if (removeAll == true)
    {
        this->hideColumns.clear();
    }
    else
    {
        this->hideColumns.removeOne(colName);
    }
    emit hideColumnsChanged(this->hideColumns);
}

QStringList DSParamsModel::fetchHideColumns(QString searchKeyword)
{
    return this->hideColumns.filter(searchKeyword);
}

void DSParamsModel::addToJoinBoxTableMap(int refObjId, QString firstTable, QString secondTable)
{
    QStringList joinedTables;
    joinedTables << firstTable << secondTable;

    this->joinBoxTableMap.insert(refObjId, joinedTables);
}

void DSParamsModel::removeJoinBoxTableMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinBoxTableMap.clear();
    }
    else
    {
        this->joinBoxTableMap.remove(refObjId);
    }
}

QVariantList DSParamsModel::fetchJoinBoxTableMap(int refObjId)
{
    QVariantList returnObj;
    returnObj << refObjId << this->joinBoxTableMap.value(refObjId).at(0) << this->joinBoxTableMap.value(refObjId).at(1);
    return returnObj;
}

void DSParamsModel::addToJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap.insert(refObjId, joinType);
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::updateJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap[refObjId] = joinType;
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::removeJoinTypeMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinTypeMap.clear();
    }
    else
    {
        this->joinTypeMap.remove(refObjId);
    }
}

QString DSParamsModel::fetchJoinTypeMap(int refObjId)
{
    return this->joinTypeMap.value(refObjId);
}

void DSParamsModel::addToJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap.insert(refObjId, iconLink);
    emit joinIconMapChanged(outData);
}

void DSParamsModel::updateJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap[refObjId] = iconLink;
    emit joinIconMapChanged(outData);
}

void DSParamsModel::removeJoinIconMap(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->joinIconMap.clear();
    }
    else
    {
        this->joinIconMap.remove(refObjId);
    }
}

void DSParamsModel::addToJoinMapList(int refObjId, int internalCounter, QString leftParam, QString rightParam)
{
    QMap<int, QStringList> joinParamMap;
    QStringList params;

    params << leftParam << rightParam;

    if (!this->joinMapList[refObjId].isEmpty())
        joinParamMap = this->joinMapList[refObjId];

    joinParamMap[internalCounter] = params;
    this->joinMapList[refObjId] = joinParamMap;
}

void DSParamsModel::removeJoinMapList(int refObjId, int internalCounter, bool deleteMainMap)
{

    if (refObjId > 0 || internalCounter > 0)
    {

        if (deleteMainMap == false)
        {
            QMap<int, QStringList> joinParamMap;

            joinParamMap = this->joinMapList.value(refObjId);
            joinParamMap.remove(internalCounter);

            this->joinMapList[refObjId] = joinParamMap;
        }
        else
        {
            this->joinMapList.remove(refObjId);
        }
    }
}

QVariantMap DSParamsModel::fetchJoinMapList(int refObjId)
{
    QStringList params;
    QVariantMap output;

    QString leftParam, rightParam;

    for (auto key : this->joinMapList.value(refObjId).keys())
    {

        leftParam = this->joinMapList.value(refObjId).value(key).value(0);
        rightParam = this->joinMapList.value(refObjId).value(key).value(1);

        params << leftParam << rightParam;

        output[QString::number(key)] = params;
        params.clear();
    }

    return output;
}

void DSParamsModel::addToPrimaryJoinTable(int refObjId, QString tableName)
{
    this->primaryJoinTable[refObjId] = tableName;
}

void DSParamsModel::removePrimaryJoinTable(int refObjId, bool removeAll)
{
    if (removeAll == true)
    {
        this->primaryJoinTable.clear();
    }
    else
    {
        this->primaryJoinTable.remove(refObjId);
    }
}

QString DSParamsModel::fetchPrimaryJoinTable(int refObjId)
{
    return this->primaryJoinTable.value(refObjId);
}

void DSParamsModel::addToQuerySelectParamsList(QString selectParam)
{
    QStringList filteredData = this->querySelectParamsList.filter(selectParam);

    if(filteredData.empty()){
        this->querySelectParamsList.append(selectParam);
    }
}

void DSParamsModel::removeQuerySelectParamsList(QString refObjName, bool deleteAllMatching)
{

    if (refObjName != "")
        this->querySelectParamsList.removeOne(refObjName);

    if(deleteAllMatching == true){
        const auto toRemove = this->querySelectParamsList.filter(refObjName);
        for(const auto &item : toRemove)
            this->querySelectParamsList.removeAll(item);
    }
}

QStringList DSParamsModel::fetchQuerySelectParamsList()
{

    return this->querySelectParamsList;
}

void DSParamsModel::addToJoinOrder(int joinOrderId)
{
    this->joinOrder.append(joinOrderId);
}

void DSParamsModel::addToExistingTables(int refObjId, QString tableName)
{
    this->existingTables.insert(refObjId, tableName);
}

void DSParamsModel::removeExistingTables(int refObjId)
{
    this->existingTables.remove(refObjId);
}

QVariant DSParamsModel::fetchExistingTables(int refObjId)
{
    return this->existingTables.value(refObjId);
}

int DSParamsModel::existingTablesSize()
{
    return this->existingTables.size();
}

void DSParamsModel::addToRectangles(int refObjId, const QVariant &rectangleObject)
{
    this->rectangles.insert(refObjId, rectangleObject);
}

void DSParamsModel::removeRectangles(int refObjId)
{
    this->rectangles.remove(refObjId);
}

QVariant DSParamsModel::fetchRectangles(int refObjId)
{
    return this->rectangles.value(refObjId);
}

QVariantMap DSParamsModel::fetchAllRectangles()
{
    QVariantMap output;
    QMap<int, QVariant>::const_iterator i = this->rectangles.constBegin();
    while (i != this->rectangles.constEnd()) {
        output.insert(QString::number(i.key()), i.value());
        ++i;
    }

    return output;
}

QVector<int> DSParamsModel::fetchAllRectangleKeys()
{
    QVector<int> output;
    QMap<int, QVariant>::const_iterator i = this->rectangles.constBegin();
    while (i != this->rectangles.constEnd()) {
        output.append(i.key());
        ++i;
    }

    return output;
}

int DSParamsModel::rectanglesSize()
{
    return this->rectangles.size();
}

void DSParamsModel::addToFrontRectangleCoordinates(int refObjId, QVariant rectangleCoordinates)
{
    this->frontRectangleCoordinates.insert(refObjId, rectangleCoordinates);
}

void DSParamsModel::removeFrontRectangleCoordinates(int refObjId)
{
    this->frontRectangleCoordinates.remove(refObjId);
}

QVariant DSParamsModel::fetchFrontRectangleCoordinates(int refObjId)
{
    return this->frontRectangleCoordinates.value(refObjId);
}

void DSParamsModel::addToRearRectangleCoordinates(int refObjId, QVariant rectangleCoordinates)
{
    this->rearRectangleCoordinates.insert(refObjId, rectangleCoordinates);
}

void DSParamsModel::removeRearRectangleCoordinates(int refObjId)
{
    this->rearRectangleCoordinates.remove(refObjId);
}

QVariant DSParamsModel::fetchRearRectangleCoordinates(int refObjId)
{
    return this->rearRectangleCoordinates.value(refObjId);
}

QVariantMap DSParamsModel::fetchAllRearRectangleCoordinates()
{
    QVariantMap output;
    QMap<int, QVariant>::const_iterator i = this->rearRectangleCoordinates.constBegin();
    while (i != this->rearRectangleCoordinates.constEnd()) {
        output.insert(QString::number(i.key()), i.value());
        ++i;
    }

    return output;
}

void DSParamsModel::addToNewConnectingLine(int refObjId, const QVariant &lineObject)
{
    this->newConnectingLine.insert(refObjId, lineObject);
}

void DSParamsModel::removeNewConnectingLine(int refObjId)
{
    this->newConnectingLine.remove(refObjId);
}

QVariant DSParamsModel::fetchNewConnectingLine(int refObjId)
{
    return this->newConnectingLine.value(refObjId);
}

QVector<int> DSParamsModel::fetchAllLineKeys()
{
    QVector<int> output;
    QMap<int, QVariant>::const_iterator i = this->newConnectingLine.constBegin();
    while (i != this->newConnectingLine.constEnd()) {
        output.append(i.key());
        ++i;
    }

    return output;
}

int DSParamsModel::linesSize()
{
    return this->newConnectingLine.size();
}

void DSParamsModel::addToFrontLineMap(int refObjId, QVariant lineObject)
{
    this->frontLineMap.insert(refObjId, lineObject);
}

void DSParamsModel::removeFrontLineMap(int refObjId)
{
    this->frontLineMap.remove(refObjId);
}

QVariant DSParamsModel::fetchFrontLineMap(int refObjId)
{
    return this->frontLineMap.value(refObjId);
}

void DSParamsModel::addToRearLineMap(int refObjId, QVariant lineObject)
{
    this->rearLineMap.insert(refObjId, lineObject);
}

void DSParamsModel::removeRearLineMap(int refObjId)
{
    this->rearLineMap.remove(refObjId);
}

QVariant DSParamsModel::fetchRearLineMap(int refObjId)
{
    return this->rearLineMap.value(refObjId);
}

void DSParamsModel::addToNewJoinBox(int refObjId, const QVariant &joinBoxObject)
{
    this->newJoinBox.insert(refObjId, joinBoxObject);
}

void DSParamsModel::removeNewJoinBox(int refObjId)
{
    this->newJoinBox.remove(refObjId);
}

QVariant DSParamsModel::fetchNewJoinBox(int refObjId)
{
    return this->newJoinBox.value(refObjId);
}

int DSParamsModel::fetchTotalJoins()
{
    return this->newJoinBox.count();
}

void DSParamsModel::addToJoinRelation(int refObjId, QString relation)
{
    this->joinRelation.insert(QString::number(refObjId), relation);
}

void DSParamsModel::removeJoinRelation(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinRelation.clear();
    }
    else
    {
        this->joinRelation.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinRelation(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinRelation.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinRelation;
    }

    return output;
}

void DSParamsModel::addToJoinValue(int refObjId, QString value)
{
    this->joinValue.insert(QString::number(refObjId), value);
}

void DSParamsModel::removeJoinValue(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinValue.clear();
    }
    else
    {
        this->joinValue.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinValue(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinValue.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinValue;
    }

    return output;
}

void DSParamsModel::addToJoinRelationSlug(int refObjId, QString value)
{
    this->joinRelationSlug.insert(QString::number(refObjId), value);
}

void DSParamsModel::removeJoinRelationSlug(int refObjId, bool removeAll)
{

    if (removeAll == true)
    {
        this->joinRelationSlug.clear();
    }
    else
    {
        this->joinRelationSlug.remove(QString::number(refObjId));
    }
}

QVariantMap DSParamsModel::fetchJoinRelationSlug(int refObjId, bool fetchAll)
{

    QVariantMap output;

    if (fetchAll == false)
    {
        QVariant val;

        val = this->joinRelationSlug.value(QString::number(refObjId));
        output.insert(QString::number(refObjId), val);
    }
    else
    {
        output = this->joinRelationSlug;
    }
    return output;
}

void DSParamsModel::setDateFormatMap(int refObjId, int formatId)
{
    this->dateFormatMap.insert(refObjId, formatId);
}

void DSParamsModel::removeDateFormatMap(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->dateFormatMap.remove(refObjId);
    } else{
        this->dateFormatMap.clear();
    }
}

int DSParamsModel::getDateFormatMap(int refObjId)
{
    return this->dateFormatMap.value(refObjId);
}

void DSParamsModel::setActualDateValues(int refObjId, QString value1, QString value2)
{
    QStringList input;

    input << value1;
    if(value2 != ""){
        input << value2;
    }
    this->actualDateValues.insert(refObjId, input);
}

void DSParamsModel::removeActualDateValues(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->actualDateValues.remove(refObjId);
    } else{
        this->actualDateValues.clear();
    }
}

QStringList DSParamsModel::getActualDateValues(int refObjId)
{
    QStringList output;
    output = this->actualDateValues.value(refObjId);
    return output;
}

void DSParamsModel::setExcludeMap(int refObjId, bool value)
{
    this->excludeMap.insert(refObjId, value);
}

void DSParamsModel::removeExcludeMap(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->excludeMap.remove(refObjId);
    } else{
        this->excludeMap.clear();
    }
}

QVariantMap DSParamsModel::getExcludeMap(int refObjId, bool fetchAll)
{
    QVariantMap output;

    if(fetchAll == false){
        output.insert(QString::number(refObjId), QString::number(this->excludeMap.value(refObjId)));

    } else{

        QMapIterator<int, bool> iterator(this->excludeMap);

        while(iterator.hasNext()) {
            iterator.next();
            output.insert(QString::number(iterator.key()), QString::number(iterator.value()));
        }
    }

    return output;
}

void DSParamsModel::setIncludeNullMap(int refObjId, bool value)
{
    this->includeNullMap.insert(refObjId, value);
}

void DSParamsModel::removeIncludeNullMap(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->includeNullMap.remove(refObjId);
    } else{
        this->includeNullMap.clear();
    }
}

QVariantMap DSParamsModel::getIncludeNullMap(int refObjId, bool fetchAll)
{
    QVariantMap output;

    if(fetchAll == false){
        output.insert(QString::number(refObjId), QString::number(this->includeNullMap.value(refObjId)));

    } else{

        QMapIterator<int, bool> iterator(this->includeNullMap);

        while(iterator.hasNext()) {
            iterator.next();
            output.insert(QString::number(iterator.key()), QString::number(iterator.value()));
        }
    }

    return output;
}

void DSParamsModel::setSelectAllMap(bool refObjId, bool value)
{
    this->selectAllMap.insert(refObjId, value);
}

void DSParamsModel::removeSelectAllMap(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->selectAllMap.remove(refObjId);
    } else{
        this->selectAllMap.clear();
    }
}

QVariantMap DSParamsModel::getSelectAllMap(int refObjId, bool fetchAll)
{
    QVariantMap output;

    if(fetchAll == false){
        output.insert(QString::number(refObjId), QString::number(this->selectAllMap.value(refObjId)));

    } else{

        QMapIterator<int, bool> iterator(this->selectAllMap);

        while(iterator.hasNext()) {
            iterator.next();
            output.insert(QString::number(iterator.key()), QString::number(iterator.value()));
        }
    }

    return output;
}

void DSParamsModel::setTmpSelectedValues(QString value)
{
    if(this->tmpSelectedValues.indexOf(value) < 0){
        this->tmpSelectedValues.append(value);

        emit tmpSelectedValuesChanged(this->tmpSelectedValues);
    }
}

void DSParamsModel::removeTmpSelectedValues(int refObjId, bool removeAll)
{
    if(removeAll == true){
        this->tmpSelectedValues.clear();
    } else{
        this->tmpSelectedValues.removeAt(refObjId);
    }
}

QStringList DSParamsModel::getTmpSelectedValues(int refObjId, bool fetchAll)
{
    QStringList output;

    if(fetchAll == false){
        output.append(this->tmpSelectedValues.value(refObjId));
    } else{
        output = this->tmpSelectedValues;
    }

    return output;
}

int DSParamsModel::searchTmpSelectedValues(QString keyword)
{
    return this->tmpSelectedValues.indexOf(keyword);
}

void DSParamsModel::setTmpFilterIndex(int value)
{
    this->tmpFilterIndex.append(value);
}

void DSParamsModel::removeTmpFilterIndex(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->tmpFilterIndex.remove(refObjId);
    } else{
        this->tmpFilterIndex.clear();
    }
}

QVector<int> DSParamsModel::getTmpFilterIndex(int refObjId, bool fetchAll)
{
    QVector<int> output;

    if(fetchAll == false){
        output.append(this->tmpFilterIndex.value(refObjId));
    } else{
        output = this->tmpFilterIndex;
    }

    return output;
}

void DSParamsModel::resetInputFields()
{
    emit resetInput();
}

int DSParamsModel::currentTab() const
{
    return m_currentTab;
}

QString DSParamsModel::fileExtension() const
{
    return m_fileExtension;
}

bool DSParamsModel::runCalled() const
{
    return m_runCalled;
}

QString DSParamsModel::dsName() const
{
    return m_dsName;
}

QString DSParamsModel::dsType() const
{
    return m_dsType;
}

bool DSParamsModel::isFullExtract() const
{
    return m_isFullExtract;
}

QString DSParamsModel::extractColName() const
{
    return m_extractColName;
}

int DSParamsModel::schedulerId() const
{
    return m_schedulerId;
}

int DSParamsModel::displayRowsCount() const
{
    return m_displayRowsCount;
}

int DSParamsModel::joinId() const
{
    return m_joinId;
}

QString DSParamsModel::queryJoiner() const
{
    return m_queryJoiner;
}

QString DSParamsModel::tmpSql() const
{
    return m_tmpSql;
}

int DSParamsModel::internalCounter() const
{
    return m_internalCounter;
}

QString DSParamsModel::section() const
{
    return m_section;
}

QString DSParamsModel::colName() const
{
    return m_colName;
}

QString DSParamsModel::tableName() const
{
    return m_tableName;
}


int DSParamsModel::filterIndex() const
{
    return m_filterIndex;
}

QString DSParamsModel::mode() const
{
    return m_mode;
}

int DSParamsModel::filterModelIndex() const
{
    return m_filterModelIndex;
}

void DSParamsModel::setCurrentTab(int currentTab)
{
    if (m_currentTab == currentTab)
        return;

    m_currentTab = currentTab;
    emit currentTabChanged(m_currentTab);
}

void DSParamsModel::setFileExtension(QString fileExtension)
{
    if (m_fileExtension == fileExtension)
        return;

    m_fileExtension = fileExtension;
    emit fileExtensionChanged(m_fileExtension);
}

void DSParamsModel::setRunCalled(bool runCalled)
{
    if (m_runCalled == runCalled)
        return;

    m_runCalled = runCalled;
    emit runCalledChanged(m_runCalled);
}

QString DSParamsModel::category() const
{
    return m_category;
}

QString DSParamsModel::subCategory() const
{
    return m_subCategory;
}

void DSParamsModel::setDsName(QString dsName)
{
    if (m_dsName == dsName)
        return;

    m_dsName = dsName;
    emit dsNameChanged(m_dsName);
}

void DSParamsModel::setDsType(QString dsType)
{
    if (m_dsType == dsType)
        return;

    Statics::dsType = dsType;
    m_dsType = dsType;
    emit dsTypeChanged(m_dsType);
}

void DSParamsModel::setIsFullExtract(bool isFullExtract)
{
    if (m_isFullExtract == isFullExtract)
        return;

    m_isFullExtract = isFullExtract;
    emit isFullExtractChanged(m_isFullExtract);
}

void DSParamsModel::setExtractColName(QString extractColName)
{
    if (m_extractColName == extractColName)
        return;

    m_extractColName = extractColName;
    emit extractColNameChanged(m_extractColName);
}

void DSParamsModel::setSchedulerId(int schedulerId)
{
    if (m_schedulerId == schedulerId)
        return;

    m_schedulerId = schedulerId;
    emit schedulerIdChanged(m_schedulerId);
}

void DSParamsModel::setDisplayRowsCount(int displayRowsCount)
{
    if (m_displayRowsCount == displayRowsCount)
        return;

    m_displayRowsCount = displayRowsCount;
    emit displayRowsCountChanged(m_displayRowsCount);
}

void DSParamsModel::setJoinId(int joinId)
{
    if (m_joinId == joinId)
        return;

    m_joinId = joinId;
    emit joinIdChanged(m_joinId);
}

void DSParamsModel::setQueryJoiner(QString queryJoiner)
{
    if (m_queryJoiner == queryJoiner)
        return;

    m_queryJoiner = queryJoiner;
    emit queryJoinerChanged(m_queryJoiner);
}

void DSParamsModel::setTmpSql(QString tmpSql)
{
    // Only select queries to be accepted
    bool isSqlSelect = tmpSql.toUpper().startsWith("SELECT");

    if (m_tmpSql == tmpSql && !isSqlSelect)
        return;

    m_tmpSql = tmpSql;
    emit tmpSqlChanged(m_tmpSql);
}

void DSParamsModel::setInternalCounter(int internalCounter)
{
    if (m_internalCounter == internalCounter)
        return;

    m_internalCounter = internalCounter;
    emit internalCounterChanged(m_internalCounter);
}

void DSParamsModel::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}

void DSParamsModel::setColName(QString colName)
{
    if (m_colName == colName)
        return;

    m_colName = colName;
    emit colNameChanged(m_colName);
}

void DSParamsModel::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void DSParamsModel::setFilterIndex(int filterIndex)
{
    if (m_filterIndex == filterIndex)
        return;

    m_filterIndex = filterIndex;
    emit filterIndexChanged(m_filterIndex);
}


void DSParamsModel::setMode(QString mode)
{
    if (m_mode == mode)
        return;

    m_mode = mode;
    emit modeChanged(m_mode);
}

void DSParamsModel::setFilterModelIndex(int filterModelIndex)
{
    if (m_filterModelIndex == filterModelIndex)
        return;

    m_filterModelIndex = filterModelIndex;
    emit filterModelIndexChanged(m_filterModelIndex);
}

QMap<QString, QString> DSParamsModel::datasourceCredentials()
{
    QMap<QString, QString> credentials;

    switch (Statics::currentDbIntType)
    {

    case Constants::mysqlIntType:

        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", Statics::myHost);
        credentials.insert("fileDB", Statics::myDb);
        credentials.insert("port", QString::number(Statics::myPort));
        credentials.insert("username", Statics::myUsername);
        credentials.insert("password", Statics::myPassword);
        break;

    case Constants::sqliteIntType:
        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", "");
        credentials.insert("fileDB", Statics::sqliteFile);
        credentials.insert("port", "");
        credentials.insert("username", Statics::sqliteUsername);
        credentials.insert("password", Statics::sqlitePassword);
        break;

    case Constants::postgresIntType:
        credentials.insert("type", Statics::currentDbStrType);
        credentials.insert("host", Statics::postgresHost);
        credentials.insert("fileDB", Statics::postgresDb);
        credentials.insert("port", QString::number(Statics::postgresPort));
        credentials.insert("username", Statics::postgresUsername);
        credentials.insert("password", Statics::postgresPassword);
        break;
    }

    return credentials;
}

void DSParamsModel::insertOne()
{
}

void DSParamsModel::updateOne()
{
}

void DSParamsModel::deleteOne()
{
}

void DSParamsModel::fetchOne()
{
}

void DSParamsModel::insertMany()
{
}

void DSParamsModel::updateMany()
{
}

void DSParamsModel::deleteMany()
{
}

void DSParamsModel::fetchMany()
{
}

void DSParamsModel::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void DSParamsModel::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}
