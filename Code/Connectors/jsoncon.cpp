#include "jsoncon.h"

JsonCon::JsonCon(QObject *parent) : QObject(parent)
{

}

void JsonCon::closeConnection()
{

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

JsonCon::~JsonCon()
{

}

QVariantMap JsonCon::JsonInstance(const QString &filepath)
{
    QVariantMap outputStatus;
    QFile file(filepath);

    if (!file.open(QIODevice::ReadOnly)) {

            outputStatus.insert("status", false);
            outputStatus.insert("msg", file.errorString());

            file.close();
    }
    else{

        outputStatus.insert("status", true);
        outputStatus.insert("msg", Messages::GeneralSuccessMsg);
    }

    return outputStatus;

}

void JsonCon::convertJsonToCsv()
{
    QString jsonPath = Statics::currentDbName;
    QFile jsonFile;
    jsonFile.setFileName(jsonPath);
    jsonFile.open(QIODevice::ReadOnly | QIODevice::Text);


    QJsonDocument jsonResponse = QJsonDocument::fromJson(jsonFile.readAll());
    ojson j = ojson::parse(jsonResponse.toJson());
    std::string output;
    csv::encode_csv(j, output);


    QFile csvFile;
    QFileInfo fi(jsonPath);

    QString outPath = QDir::tempPath() + "/" + fi.completeBaseName();
    csvFile.setFileName(outPath);
    if( csvFile.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream stream(&csvFile);
        stream << output.c_str();

        csvFile.close();
    }

    jsonFile.close();
    emit convertedJsonPaths(outPath);
}
