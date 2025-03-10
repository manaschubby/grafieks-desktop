#ifndef PUBLISHDATASOURCEMODEL_H
#define PUBLISHDATASOURCEMODEL_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QFile>
#include <QFileInfo>
#include <QProcess>
#include <QObject>
#include <QDebug>

#include "../../statics.h"
#include "../../secrets.h"
#include "../../constants.h"


class PublishDatasourceModel : public QObject
{
    Q_OBJECT
public:
    explicit PublishDatasourceModel(QObject *parent = nullptr);
    Q_INVOKABLE void publishDatasource(QString dsName, QString description, QString uploadImage, QString sourceType,  int schedulerId = 0, bool isFullExtract = false, QString extractColumnName = "", int dsSize = 0);
    Q_INVOKABLE void checkIfDSExists(QString dsName);
    Q_INVOKABLE void publishNowAfterDSCheck();

private slots:
    void reading();
    void readComplete();
    void readDSComplete();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();

signals:
    void publishDSStatus(QVariantMap status);
    void dsUploadPercentage(int percentage);
    void dsUploadFinished();
    void dsExists(QVariantMap status);
    void publishDSNow();
    void sessionExpired();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QFile *dataFile;
    QString inFilePath;

    QString outputFileName;

    void uploadFile();
};

#endif // PUBLISHDATASOURCEMODEL_H
