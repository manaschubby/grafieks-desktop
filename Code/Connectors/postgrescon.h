#ifndef POSTGRESCON_H
#define POSTGRESCON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QtDebug>
#include <QObject>

#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

/*!
 * \brief Handles the connection with Postgres database across the application
 * \ingroup Connectors
 */

class PostgresCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString DRIVER = "QPSQL";
    const QString ODBCDRIVER = "QODBC";

public:
    explicit PostgresCon(QObject *parent = nullptr);
    QVariantMap PostgresInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    QVariantMap PostgresOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~PostgresCon();

signals:

};

#endif // POSTGRESCON_H
