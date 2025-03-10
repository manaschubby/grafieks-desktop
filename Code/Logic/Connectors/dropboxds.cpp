#include "dropboxds.h"


/*!
 * \brief Constructor function to initialize connection with Dropbox API
 * \details Initiates OAuth connection. Once OAuth token is obtained, it calls relevant methods to fetch the data from
 * the API
 * \param parent
 */
DropboxDS::DropboxDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    emit showBusyIndicator(true);

    this->dropbox = new QOAuth2AuthorizationCodeFlow(this);

    // Set Scope or Permissions required from dropbox
    // List can be obtained from https://www.dropbox.com/lp/developers/reference/oauth-guide

    this->dropbox->setScope("files.content.read account_info.read files.metadata.read");

    connect(this->dropbox, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);
        QByteArray postData;

        query.addQueryItem("force_reapprove", "true"); // Param required to get data everytime
        query.addQueryItem("token_access_type", "offline"); // Needed for Refresh Token (as AccessToken expires shortly)
        query.addQueryItem("response_type", "code");


        postData = query.toString(QUrl::FullyEncoded).toUtf8();

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });
    // Here the parameters from dropbox JSON are filled up
    // Attached screenshot of JSON file and dropbox Console

    this->dropbox->setAuthorizationUrl(QUrl("https://www.dropbox.com/oauth2/authorize"));
    this->dropbox->setClientIdentifier(Secret::dropBoxClient);
    this->dropbox->setAccessTokenUrl(QUrl("https://api.dropboxapi.com/oauth2/token"));
    this->dropbox->setClientIdentifierSharedKey(Secret::dropBoxSecret);



    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in dropbox Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(Secret::dropBoxPort, this);
    this->dropbox->setReplyHandler(replyHandler);
    //    connect(this->dropbox,&QOAuth2AuthorizationCodeFlow::granted,this,&DropboxDS::folderNav);

    connect(this->dropbox, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        const QUrl API_ENDPOINT("https://api.dropboxapi.com/2/files/list_folder");
        QJsonObject obj;
        obj.insert("limit", 1000);
        obj.insert("path","");
        obj.insert("recursive",true);
        obj.insert("include_deleted",false);
        obj.insert("include_has_explicit_shared_members",false);
        obj.insert("include_mounted_folders",true);
        obj.insert("include_non_downloadable_files",true);

        QJsonDocument doc(obj);
        QString strJson(doc.toJson(QJsonDocument::Compact));

        //api link - https://www.dropbox.com/developers/documentation/http/documentation#files-list_folder


        QNetworkRequest m_networkRequest;
        m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/files/list_folder"));

        m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
        m_networkRequest.setRawHeader("Authorization", "Bearer " + this->dropbox->token().toUtf8());
        token = this->dropbox->token();

        m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());
        connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
        connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataReadFinished);

    });

}

/*!
 * \brief Calls to authorize the user using Qt's OAuth class
 */
void DropboxDS::fetchDatasources()
{
    this->dropbox->grant();

}

/*!
 * \brief Back navigation path
 * \param path (string identifier parameter: Dropbox)
 * \param name (folder name)
 * \return QString
 */
QString DropboxDS::goingBack(QString path,QString name)
{
    emit showBusyIndicator(true);

    int len = name.length();
    QString p = path;
    p.chop(len);

    if(p=="Dropbox" || p.length() == 1 || name == "Folder name")
        p="";

    folderNav(p);

    return p;

}


/*!
 * \brief List contents of a folder
 * \param path (Folder path)
 */
void DropboxDS::folderNav(QString path)
{
    emit showBusyIndicator(true);

    QJsonObject obj;
    obj.insert("limit", 1000);
    obj.insert("path",path);
    obj.insert("recursive",false);
    obj.insert("include_media_info",false);
    obj.insert("include_deleted",false);
    obj.insert("include_has_explicit_shared_members",false);
    obj.insert("include_mounted_folders",true);
    obj.insert("include_non_downloadable_files",true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    QNetworkRequest m_networkRequest;
    m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/files/list_folder"));

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());
    connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataReadFinished);
}

/*!
 * \brief Search the Box API
 * \details Documentation reference https://www.dropbox.com/developers/documentation/http/documentation#files-search
 * \param path (File name)
 */
void DropboxDS::searchQuer(QString path)
{
    emit showBusyIndicator(true);

    QJsonObject obj;
    obj.insert("query",path);
    obj.insert("include_highlights",false);
    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    QNetworkRequest m_networkRequest;

    m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/files/search_v2"));
    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    m_networkReply = m_networkAccessManager->post(m_networkRequest,strJson.toUtf8());
    connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataSearchedFinished);

}


void DropboxDS::fetchFileData(QString fileId, QString fileName, QString extension)
{

    emit showBusyIndicator(true);

    this->dropBoxFileId = fileId;
    this->dropBoxFileName = fileName;
    this->extension = extension;

    QJsonObject obj;
    obj.insert("path",fileId);
    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));


    QNetworkRequest m_networkRequest;
    m_networkRequest.setUrl(QUrl("https://content.dropboxapi.com/2/files/download"));
//    m_networkRequest.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);
    m_networkRequest.setMaximumRedirectsAllowed(5);

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/octet-stream; charset=utf-8");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    m_networkRequest.setRawHeader("Dropbox-API-Arg", strJson.toUtf8());

    QByteArray b;
    b.clear();
    m_networkReply = m_networkAccessManager->post(m_networkRequest, b);
    //    connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::saveFile);
}

/*!
 * \brief Notify model after adding new record in QList<Dropbox *>
 * \param box (Dropbox *)
 */
void DropboxDS::addDataSource(Dropbox *dropbox)
{
    emit preItemAdded();
    m_dropbox.append(dropbox);
    emit postItemAdded();
}

/*!
 * \brief Add new data to QList<Dropbox *>
 * \param id (File id)
 * \param tag (File tag)
 * \param name (File name)
 * \param pathLower (path in lower case)
 * \param clientModified (Modified date)
 * \param extension (File extension)
 */
void DropboxDS::addDataSource(const QString & id, const QString & tag, const QString & name, const QString & pathLower, const QString & clientModified,const QString & extension)
{
    Dropbox *dropbox = new Dropbox(id,tag,name,pathLower,clientModified,extension);

    addDataSource(dropbox);
}

/*!
 * \brief List the values in QList<Dropbox *>
 * \return QList<Dropbox *>
 */
QList<Dropbox *> DropboxDS::dataItems()
{
    return m_dropbox;
}

/*!
 * \brief Clear all the values in QList<Dropbox*> & notify model
 */
void DropboxDS::resetDatasource()
{
    emit preReset();
    m_dropbox.clear();
    emit postReset();
}

/*!
 * \brief Reads incoming data from the API & store to buffer
 */
void DropboxDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

/*!
 * \brief Processes the data buffer
 * \details Process the data buffer and append new values to QList<Dropbox*>
 */

void DropboxDS::dataReadFinished()
{

    if(m_networkReply->error()){
        qDebug() <<"There was some error : "<< m_networkReply->errorString() << m_networkReply->readAll();
    }
    else{

        Statics::onlineStorageType = Constants::dropboxIntType;

        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json";

        this->resetDatasource();

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["entries"].toArray();

        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString DropboxID = dataObj["id"].toString();
            QString DropboxTag = dataObj[".tag"].toString();
            QString DropboxName = dataObj["name"].toString();
            QStringList extensionList;
            QString DropboxExtension;
            QString DropboxPathLower = dataObj["path_lower"].toString();
            QString DropboxClientModi;
            if(DropboxTag  == "file"){
                DropboxClientModi = QDateTime::fromString(dataObj["client_modified"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
                extensionList = DropboxName.split('.');
                DropboxExtension = "." + extensionList.last();
            }
            else{
                DropboxClientModi = "--";
                DropboxExtension = "--";

            }
            if(requiredExtensions.indexOf(DropboxExtension) >= 0 || DropboxExtension == "--"){
                this->addDataSource(DropboxID,DropboxTag,DropboxName,DropboxPathLower,DropboxClientModi,DropboxExtension);
            }
        }

        //        Get user email
        QByteArray blankPostReq;

        QNetworkRequest m_networkRequest;
        m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());
        m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/users/get_current_account"));

        m_networkReply = m_networkAccessManager->post(m_networkRequest, blankPostReq);
        connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::userReadFinished);

    }
    m_dataBuffer->clear();
    emit showBusyIndicator(false);
}

/*!
 * \brief Process data search in Dropbox
 */
void DropboxDS::dataSearchedFinished()
{

    if(m_networkReply->error()){
        qDebug()<< "There was some error :" << m_networkReply->errorString();
    }else{
        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonArray dataArray = resultObj["matches"].toArray();

        for(int i=0;i<dataArray.size();i++){
            QJsonObject dataObj = dataArray.at(i).toObject();
            QJsonObject dataObj2 = dataObj["metadata"].toObject();
            QJsonObject dataObj3 = dataObj2["metadata"].toObject();

            QString DropboxID = dataObj3["id"].toString();
            QString DropboxTag = dataObj3[".tag"].toString();
            QString DropboxName = dataObj3["name"].toString();

            QStringList extensionList;
            QString DropboxExtension;
            QString DropboxPathLower = dataObj3["path_lower"].toString();
            QString DropboxClientModi;

            if(DropboxTag  == "file"){
                DropboxClientModi = QDateTime::fromString(dataObj["client_modified"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
                extensionList = DropboxName.split('.');
                DropboxExtension = "." + extensionList.last();
            }
            else{
                DropboxClientModi = "--";
                DropboxExtension = "--";

            }

            if(requiredExtensions.indexOf(DropboxExtension) >= 0 || DropboxExtension == "--"){
                this->addDataSource(DropboxID,DropboxTag,DropboxName,DropboxPathLower,DropboxClientModi,DropboxExtension);
            }

        }

    }
    m_dataBuffer->clear();
    emit showBusyIndicator(false);
}

void DropboxDS::userReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());
    int statusCode = m_networkReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        emit getDropboxUsername(resultObj.value("email").toString());
    }


    m_dataBuffer->clear();
    emit showBusyIndicator(false);
}

void DropboxDS::saveFile()
{

    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QString fileName = QDir::temp().tempPath() +"/" + this->dropBoxFileId.remove(0,3) + this->extension;
        QFile file(fileName);
        file.open(QIODevice::WriteOnly);
        file.write(m_networkReply->readAll());
        file.close();

        if(this->extension.contains("xls") || this->extension.contains("xlsx")){
            emit fileDownloaded(fileName, "excel");

        } else if(this->extension.contains("csv")){
            emit fileDownloaded(fileName,"csv");

        } else if(this->extension.contains("json")){
            emit fileDownloaded(fileName, "json");
        }
    }

    // emit showBusyIndicator(false);
}

void DropboxDS::addDatasourceHelper(QJsonDocument &doc)
{

}
