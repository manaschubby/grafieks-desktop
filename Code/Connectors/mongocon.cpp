#include "mongocon.h"

MongoCon::MongoCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MongoCon::MongoInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    Q_UNUSED(host);
    Q_UNUSED(db);
    Q_UNUSED(port);
    Q_UNUSED(username);
    Q_UNUSED(password);

    QVariantMap outputStatus;
    return outputStatus;
}

QVariantMap MongoCon::MongoOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Sample Connection for MongoDB
//         dbOdbc.setDatabaseName("DRIVER={MongoDB ODBC 1.4.2 ANSI Driver};Server={cluster0.bdrhj.mongodb.net};Port=3707;Database=mongo_test");


        QString dbString = "DRIVER={"+ driver +"};Server="+ host +";Port="+ QString::number(port) +";Database="+ db;

        QSqlDatabase dbMongoOdbc = QSqlDatabase::addDatabase("QODBC", Constants::mongoOdbcStrType);
        dbMongoOdbc.setHostName(host);
        dbMongoOdbc.setPort(port);
        dbMongoOdbc.setUserName(username);
        dbMongoOdbc.setPassword(password);

        dbMongoOdbc.setDatabaseName(dbString);
        dbMongoOdbc.open();

        if(!dbMongoOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbMongoOdbc.lastError().text());
            qDebug() << dbMongoOdbc.lastError();

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::mongoHost = host;
            Statics::mongoDb = dbString;
            Statics::mongoPort = port;
            Statics::mongoUsername = username;
            Statics::mongoPassword = password;
            Statics::mongoRealDbName = db;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another MongoDB Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbMongoOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::mongoOdbcStrQueryType);

            dbMongoOdbc2.setDatabaseName(dbString);
            dbMongoOdbc2.setHostName(host);
            dbMongoOdbc2.setPort(port);
            dbMongoOdbc2.setUserName(username);
            dbMongoOdbc2.setPassword(password);

            dbMongoOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

void MongoCon::closeConnection()
{
    QSqlDatabase dbMongoOdbc = QSqlDatabase::database(Constants::mongoOdbcStrType);
    QSqlDatabase dbMongoOdbc2 = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);

    if(dbMongoOdbc.isOpen()) {
        dbMongoOdbc.removeDatabase(Constants::mongoOdbcStrType);
        dbMongoOdbc.close();
    }
    if(dbMongoOdbc2.isOpen()) {
        dbMongoOdbc2.removeDatabase(Constants::mongoOdbcStrQueryType);
        dbMongoOdbc2.close();
    }

    Statics::mongoHost = "";
    Statics::mongoDb = "";
    Statics::mongoPort = 0;
    Statics::mongoUsername = "";
    Statics::mongoPassword = "";
    Statics::mongoRealDbName = "";

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

MongoCon::~MongoCon()
{

}
