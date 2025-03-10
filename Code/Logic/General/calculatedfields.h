#ifndef CALCULATEDFIELDS_H
#define CALCULATEDFIELDS_H

#include <QObject>
#include <QMap>

#include "jsoncons/json.hpp"
#include "../../constants.h"
#include "../../statics.h"
#include "datatype.h"
#include "calculatedfieldsyntax.h"

#include "../../duckdb.hpp"

class CalculatedFields : public QObject
{
    Q_OBJECT
    QString columnName;
    QString columnType;
    QVariantMap calculatedFields;


public:
    explicit CalculatedFields(QObject *parent = nullptr);

    CalculatedFieldSyntax calculatedFieldSyntax;

    // Query = actual query for calculated field
    // Source = dashboard/report
    // mode = single result/multiple result (reduce/map)

    Q_INVOKABLE bool addCalculatedField(QString name, QString query, QString source, QString mode);
    Q_INVOKABLE void fetchCalculatedFields();
    Q_INVOKABLE void setCalculatedFieldName(QString columnName);
    Q_INVOKABLE void setCalculatedFieldType(QString columnType);

public slots:
    void dispatchCalculatedField(duckdb::Connection *con);
    void dispatchCalculatedFieldsWithoutConnection();


private:
    QString getSqlQuery(QString stdQuery);
    bool saveCalculatedFields(QString name, QString colName, QString colType, QString query, QString source, QString mode, QString datasourceType);
    bool fetchExtractCalculatedValues(QString masterCalculatedFieldsTable);
    bool fetchLiveCalculatedValues(QString calculatedFieldQuery);
    QStringList fetchLiveWhereJoinConditions();
    void listCalculatedFields();

signals:
    void signalCalculatedFields(QVariantMap calculatedFields);

};

#endif // CALCULATEDFIELDS_H
