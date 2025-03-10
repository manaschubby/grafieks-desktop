#ifndef SAVEEXTRACTFORWARDONLYWORKER_H
#define SAVEEXTRACTFORWARDONLYWORKER_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>
#include <QSqlError>
#include <QDebug>
#include <QDate>

#include "../../General/datatype.h"
#include "../../General/generalparamsmodel.h"

#include "../../../statics.h"
#include "../../../constants.h"
#include "../../../duckdb.hpp"

class SaveExtractForwardOnlyWorker : public QThread
{
    Q_OBJECT
    DataType dataType;

    QString query;
    int internalColCount;
    QStringList columnStringTypes;
    QVariantMap changedColumnTypes;

    int colCount;

public:
    explicit SaveExtractForwardOnlyWorker(QString query = "", QVariantMap changedColumnTypes = QVariantMap());

protected:
    void run() override;

private:
    void appendExtractData(duckdb::Appender *appender, QSqlQuery *query);


signals:
    void saveExtractComplete(QString errorMsg);

};

#endif // SAVEEXTRACTFORWARDONLYWORKER_H
