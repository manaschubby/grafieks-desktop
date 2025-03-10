#include "publishdatasourcemodel.h"

PublishDatasourceModel::PublishDatasourceModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray),
    dataFile(nullptr)
{

}

void PublishDatasourceModel::publishDatasource(QString dsName, QString description, QString uploadImage, QString sourceType,  int schedulerId,  bool isFullExtract, QString extractColumnName, int dsSize)
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QString base64Image;
    QString filename;

    // Extract the exact file path
    // Open file for reading
    QFile imageFile(uploadImage);

    imageFile.open(QIODevice::ReadOnly);

    if(imageFile.isOpen()){

        // Extract the filename
        QFileInfo fileInfo(imageFile.fileName());
        filename = fileInfo.fileName();

        // Convert filedata to base64
        QByteArray imageData = imageFile.readAll();
        base64Image = QString(imageData.toBase64());
    } else {
        qDebug() << Q_FUNC_INFO << __LINE__  << imageFile.errorString();
    }

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_newdatasource");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("schedulerId", schedulerId);
    obj.insert("datasourceName", dsName);
    obj.insert("description", description);
    obj.insert("image", base64Image);
    obj.insert("fileName", filename);
    obj.insert("sourceType", sourceType);
    obj.insert("columnName", extractColumnName);
    obj.insert("isFullExtract", isFullExtract);
    obj.insert("inMemory", true);
    obj.insert("dsSize", dsSize);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &PublishDatasourceModel::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &PublishDatasourceModel::readComplete, Qt::UniqueConnection);


}

void PublishDatasourceModel::checkIfDSExists(QString dsName){
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();



    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/checkdatasource");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("datasourcename", dsName);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &PublishDatasourceModel::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &PublishDatasourceModel::readDSComplete, Qt::UniqueConnection);
}

void PublishDatasourceModel::publishNowAfterDSCheck(){
    emit publishDSNow();
}

void PublishDatasourceModel::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void PublishDatasourceModel::readComplete()
{
    QVariantMap outputStatus;
    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();

        // Set the output
        outputStatus.insert("code", m_networkReply->error());
        outputStatus.insert("msg", m_networkReply->errorString());

    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();

        // Set the output
        outputStatus.insert("code", statusObj["code"].toInt());
        outputStatus.insert("msg", statusObj["msg"].toString());
        this->outputFileName = statusObj["datasource"].toString();

    }


    // If saving to database throws error, emit signal
    // else start uploading the extract file
    if(outputStatus.value("code") != 200){
        emit publishDSStatus(outputStatus);
    } else {
        uploadFile();
    }

    m_tempStorage->clear();
}

void PublishDatasourceModel::readDSComplete()
{
    QVariantMap outputStatus;
    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();

        // Set the output
        outputStatus.insert("code", m_networkReply->error());
        outputStatus.insert("msg", m_networkReply->errorString());
        outputStatus.insert("statusMsg", "");

    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();
        QString statusMsg = resultJson["data"].toString();

        // Set the output
        outputStatus.insert("code", statusObj["code"].toInt());
        outputStatus.insert("msg", statusObj["msg"].toString());
        outputStatus.insert("statusMsg", statusMsg);
    }

    m_tempStorage->clear();

    if(outputStatus.value("msg").toString() == Constants::sessionExpiredText){
        emit sessionExpired();
    } else {
        emit dsExists(outputStatus);
    }

}

void PublishDatasourceModel::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    int percentageUploaded = 100 * bytesSent/bytesTotal;
    emit dsUploadPercentage(percentageUploaded);
}

void PublishDatasourceModel::uploadFinished()
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/copyfiles");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("ProfileID", profileId);
    obj.insert("Extract", this->outputFileName);
    obj.insert("Live", "");
    obj.insert("Workbook", "");

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());
    emit dsUploadFinished();
}

void PublishDatasourceModel::uploadFile()
{
    this->inFilePath = Statics::extractPath != "" ? Statics::extractPath : Statics::livePath;

    QSettings settings;

    QString ftpAddress = Constants::defaultFTPEndpoint;
    QString siteName = settings.value("user/sitename").toString();
    QString ftpUser = settings.value("user/ftpUser").toString();
    QString ftpPass = settings.value("user/ftpPass").toString();
    QString ftpPort = settings.value("user/ftpPort").toString();

    QProcess curlProcess;
    curlProcess.start("curl", {"-p", "--insecure",  "ftp://" + ftpAddress + ":" + ftpPort + "/" + siteName + "/datasources/" + this->outputFileName, "--user", ftpUser + ":" + ftpPass, "-T", this->inFilePath, "--ftp-create-dirs"});
    if (curlProcess.waitForFinished()){
        qDebug() << "FTP DONE" << curlProcess.exitStatus();
        this->uploadFinished();
    }

}
