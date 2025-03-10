#include "csvjsondatamodel.h"

CSVJsonDataModel::CSVJsonDataModel(QObject *parent) : QAbstractTableModel(parent)
{
    this->totalColCount = 1;
}


CSVJsonDataModel::~CSVJsonDataModel()
{

}

int CSVJsonDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return this->totalRowCount;
}

int CSVJsonDataModel::columnCount(const QModelIndex &) const
{
    return this->totalColCount;
}

QVariant CSVJsonDataModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        return QString(this->m_roleNames[section]);
    }
    return QVariant();
}

QVariant CSVJsonDataModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
        return this->modelOutput[index.row()];
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> CSVJsonDataModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void CSVJsonDataModel::columnData(QString col, QString tableName, QString options)
{

    emit fetchingColumnListModel();

    bool firstLine = true;
    QString delimiter = Statics::separator;

    int columnNumber = 0;
    this->masterResultData.clear();

    QJsonDocument optionsObj = QJsonDocument::fromJson(options.toUtf8());
    QJsonObject obj = optionsObj.object();


    QFile file(Statics::csvJsonPath);
    file.open(QFile::ReadOnly | QFile::Text);

    if(!file.isOpen()){
        qDebug() << "Cannot open file" << file.errorString();
    } else{

        int dataTypeCounter = 0;
        while(!file.atEnd()){
            QByteArray line = file.readLine().simplified();
            QString lineAsString = QString(line);

            if(firstLine){

                firstLine = false;
                QRegularExpression rx( delimiter + "(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
                this->headerDataFinal = lineAsString.split(rx);

//                if (this->headerDataFinal.at(0).contains("\xEF\xBB\xBF")){
//                    this->headerDataFinal[0] =  this->headerDataFinal.at(0).right(this->headerDataFinal.at(0).length() - 3);
//                }

                for(int i = 0; i < this->headerDataFinal.length(); i++){
                    this->m_roleNames.insert(i, this->headerDataFinal.at(i));
                }

                columnNumber = this->headerDataFinal.indexOf(col.toUtf8().constData());
                this->m_roleNames.insert(0, col.toUtf8());
            } else {
                QString colData = line.split(*delimiter.toStdString().c_str()).at(columnNumber);


                if(dataTypeCounter == 0 && obj.value("section").toString() == Constants::dateType){
                    DataType datatype;
                    this->dateFormat = datatype.variableType(colData).at(1);
                    dataTypeCounter++;
                }

                if(!this->masterResultData.contains(colData)){
                    this->masterResultData.append(colData);
                }
            }
        }
    }
    this->modelOutput.clear();
    this->modelOutput = this->masterResultData;
    this->totalRowCount = this->masterResultData.length();

    emit columnListModelDataChanged(options);
}

void CSVJsonDataModel::columnSearchData(QString col, QString tableName, QString searchString, QString options)
{

    this->modelOutput.clear();
    emit fetchingColumnListModel();

    QStringList output = this->masterResultData.filter(searchString, Qt::CaseInsensitive);
    this->modelOutput = output;
    this->totalRowCount = output.length();

    emit columnListModelDataChanged(options);
}

QStringList CSVJsonDataModel::getTableList()
{

    this->output.clear();
    QString db = Statics::currentDbName;
    this->fileName       = QFileInfo(db).baseName().toLower();
    this->fileName = this->fileName.remove(QRegularExpression("[^A-Za-z0-9]"));
    this->output.append(this->fileName);
    return this->output;
}

QStringList CSVJsonDataModel::filterTableList(QString keyword)
{

    return this->output.filter(keyword, Qt::CaseInsensitive);
}

QString CSVJsonDataModel::getDateFormat()
{
    return this->dateFormat;
}

QStringList CSVJsonDataModel::getDateColumnData()
{
    return this->modelOutput;
}

