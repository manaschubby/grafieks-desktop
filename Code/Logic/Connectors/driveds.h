#ifndef DRIVEDS_H
#define DRIVEDS_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow>
#include <QUrl>
#include <QUrlQuery>
#include <QOAuthHttpServerReplyHandler>
#include <QDesktopServices>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QtDebug>
#include <QDir>
#include <QFileInfo>

#include <QFile>
#include <QCoreApplication>
#include <QDataStream>

#include "drive.h"
#include "../../secrets.h"
#include "../../statics.h"
#include "../../constants.h"

/*!
 * \brief Fetches data records from Google Drive API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://developers.google.com/drive/api/v3/reference/files">https://developers.google.com/drive/api/v3/reference/files</a>
 * \ingroup ConnectorScreen
 */

class DriveDS : public QObject
{
    Q_OBJECT
public:
    explicit DriveDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void homeBut();
    Q_INVOKABLE void fetchFileData(QString gFileId, QString fileName, QString extension);

    void addDataSource(Drive * drive);
    Q_INVOKABLE void addDataSource(const QString & id,const QString & name,const QString & kind,const QString & modifiedTime,const QString & extension);

    QList<Drive *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();
    void getDriveUsername(QString username);
    void showBusyIndicator(bool status);
    void fileDownloaded(QString filePath, QString fileType);

private slots:
    void dataReadyRead();
    void dataReadFinished();
    void dataSearchFinished();
    void userReadFinished();
    void fileDownloadFinished();

public slots:
    void resetDatasource();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QOAuth2AuthorizationCodeFlow * google;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Drive*> m_drive;

    QString username;
    QString gFileId;
    QString newFileName;
    QString extension;

};

#endif // DRIVEDS_H
