#ifndef DROPBOXDS_H
#define DROPBOXDS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QOAuth2AuthorizationCodeFlow>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QUrl>
#include <QUrlQuery>
#include <QFile>
#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <QtDebug>
#include <QByteArray>
#include <QDir>


#include "dropbox.h"
#include "../../secrets.h"
#include "../../statics.h"
#include "../../constants.h"


/*!
 * \brief Fetches data records from Dropbox API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://www.dropbox.com/developers/documentation/http/documentation">https://www.dropbox.com/developers/documentation/http/documentation</a>
 * \ingroup ConnectorScreen
 */

class DropboxDS : public QObject
{
    Q_OBJECT
public:
    explicit DropboxDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE QString goingBack(QString path,QString name);
    Q_INVOKABLE void folderNav(QString path);
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void fetchFileData(QString fileId, QString fileName, QString extension);

    void addDataSource(Dropbox * dropbox);

    Q_INVOKABLE void addDataSource(const QString & id,const QString & tag,const QString & name,const QString & pathLower,const QString & clientModified,const QString & extension);
    QList<Dropbox *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();
    void getDropboxUsername(QString username);
    void showBusyIndicator(bool status);
    void fileDownloaded(QString filePath, QString fileType);

private slots:
    void dataReadyRead();
    void dataReadFinished();
    void dataSearchedFinished();
    void userReadFinished();
    void saveFile();

public slots:
    void resetDatasource();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Dropbox*> m_dropbox;
    QOAuth2AuthorizationCodeFlow * dropbox;
    QString token;
    QString username;

    QString dropBoxFileId;
    QString dropBoxFileName;
    QString extension;

    void addDatasourceHelper(QJsonDocument &doc);
};

#endif // DROPBOXDS_H
