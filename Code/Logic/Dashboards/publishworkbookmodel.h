#ifndef PUBLISHWORKBOOKMODEL_H
#define PUBLISHWORKBOOKMODEL_H

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

class PublishWorkbookModel : public QObject
{
    Q_OBJECT
public:
    explicit PublishWorkbookModel(QObject *parent = nullptr);
    Q_INVOKABLE void publishWorkbook(int projectId, QString wbName, QString description, QString uploadImage,  int dashboardCount = 0, QString dashboardDetails = "");
    Q_INVOKABLE void workbookFile(QString workbookFilePath);

private slots:
    void reading();
    void readComplete();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();

signals:
    void publishWbStatus(QVariantMap status);
    void wbUploadPercentage(int percentage);
    void wbUploadFinished();
    void sessionExpired();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

    QString outputFileName;
    QString workbookFilePath;

    void uploadFile();

};

#endif // PUBLISHWORKBOOKMODEL_H
