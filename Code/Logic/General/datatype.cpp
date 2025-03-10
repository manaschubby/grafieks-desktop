#include "datatype.h"

DataType::DataType(QObject *parent) : QObject(parent)
{

}


/*!
 * \brief Returns custom datatype of the queried column name
 * \param parameter (table column type)
 * \return QString
 */
QString DataType::dataType(QString parameter)
{

    QString output;
    QStringList categorical, numerical, dateformat;


    categorical << "varchar" << "char" << "text" << "tinytext" << "mediumtext" << "longtext" << "boolean" <<"character varying" << "nvarchar" << "character"
                << "varying character" << "nchar" << "native character" << "clob" << "ntext" << "varchar2" << "nvarchar2" << "nclob"
                << "urowid" << "rowid" << "string" << "symbol" << "bpchar"
                << "memo" << "yes/no" << "hyperlink" << "short text" << "long text"
                << "QString" << "CF" << "CV" << "uchar" << "enum" << "json";

    numerical   << "int" << "tinyint" << "smallint" << "mediumint" << "bigint" << "decimal" << "float" << "double" << "real" << "integer" << "serial" << "bigserial"
                << "double precision" << "numeric" << "smallserial" << "unsigned big int" << "int2" << "dec" << "bit" << "smallmoney" << "money"
                << "binary_float" << "binary_double" << "int1" << "int2" << "short" << "float4" << "int4" << "signed" << "float8" << "long" << "int8"
                << "large number" << "autonumber" << "number"
                << "I8" << "I1" << "D" << "F" << "I" << "N" << "D" << "I2" << "I4"
                << "uint" << "ushort" << "ulong" << "qulonglong";

    dateformat << "date" << "datetime" << "timestamp" << "time" << "year"
               << "timestamp without time zone" << "timestamp with time zone"
               << "time without time zone" << "time with time zone" << "interval"
               << "datetimeoffset" << "smalldatetime" << "datetime2" << "timestamp with time zone" << "timestamp with local timezone" << "TIMESTAMPTZ" << "TIMETZ"
               << "interval year" << "interval day"
               << "date/time" << "date/time extended"
               << "DA" << "DY" << "DH" << "DM" << "DS" << "HR" << "HM" << "HS" << "MI" << "MS" << "MO" << "SC" << "YR" << "YM" << "PD" << "PZ" << "PT" << "PS" << "PM" << "AT" << "TS" << "TZ" << "SZ"
               << "QDateTime" << "QDate";

    // Match the incoming parameter and determine filter type

    if(categorical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::categoricalType;
    } else if(numerical.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::numericalType;
    } else if(dateformat.contains(parameter, Qt::CaseInsensitive)){
        output =  Constants::dateType;
    } else{
        output =  Constants::otherType;
    }

    return output;

}



bool DataType::checkNumberType(QString inputVariable)
{
    bool isNumber = false;
    inputVariable.toDouble(&isNumber);
    return isNumber;
}

QVariantList DataType::checkDateTimeType(QString inputVariable)
{
    QVariantList output;
    QStringList validDateFormats;
    bool isDate = false;
    QString matchedFormat;
    // Formats refered from https://help.talend.com/r/6K8Ti_j8LkR03kjthAW6fg/~wDyssNBFPIG2jgx3fux3Q

    validDateFormats << "d.M.yy" << "d.M.yy H.mm" << "d.M.yyyy H.mm.ss"
                    << "d.M.yyyy H:mm:ss"
                    << "dd-MM-yy" << "dd-MM-yy HH:mm" << "dd-MM-yyyy HH:mm:ss" << "dd-MM-yyyy"
                    << "dd.MM.yy" << "d. MMMM yyyy" << "ddd, d. MMMM yyyy" << "dd.MM.yyyy" << "dd.MM.yy HH:mm" << "d. MMMM yyyy HH:mm:ss z" << "dd.MM.yyyy HH:mm:ss" << "dd.MM.yy HH:mm:ss" << "dd.MM.yyyy HH:mm"
                    << "d-MMM-yyyy" << "dd/MM/yy h:mm A" << "d-MMM-yyyy h:mm:ss A"
                    << "dd MMMM yyyy" << "dddd, d MMMM yyyy" << "dd-MMM-yyyy" << "dd MMMM yyyy HH:mm:ss z" << "dd-MMM-yyyy HH:mm:ss"
                    << "M/d/yy" << "MM/dd/yy" << "MM-dd-yy" << "M-d-yy" << "MMM d, yyyy" << "MMMM d, yyyy" << "dddd, MMMM d, yyyy" << "MMM d yyyy" << "MMMM d yyyy" << "MM-dd-yyyy" << "M-d-yyyy" << "dd/MM/yyyy" << "d/M/yyyy" << "MM/dd/yyyy" << "M/d/yyyy" << "yyyy/M/d" << "M/d/yy h:mm A" << "MM/dd/yy h:mm A" << "MM-dd-yy h:mm A" << "M-d-yy h:mm A" << "MMM d, yyyy h:mm:ss A" << "M-d-yyyy h:mm:ss A" << "yyyy-MM-dd h:mm:ss A" << "yyyy-MM-dd h:mm:ss" << "yyyy-M-d h:mm:ss a" << "dd/MM/yyyy h:mm:ss a" << "d/M/yyyy h:mm:ss a" << "MM/dd/yyyy h:mm:ss a" << "M/d/yyyy h:mm:ss a" << "MM/dd/yy h:mm:ss a" << "MM/dd/yy H:mm:ss" << "M/d/yy H:mm:ss" << "dd/MM/yyyy h:mm a" << "d/M/yyyy h:mm a" << "MM/dd/yyyy h:mm a" << "M/d/yyyy h:mm a" << "MM-dd-yy h:mm:ss a" << "M-d-yy h:mm:ss a" << "MM-dd-yyyy h:mm a" << "M-d-yyyy h:mm a" <<  "yyyy-MM-dd h:mm a" << "yyyy-M-d h:mm a" << "MMM.dd.yyyy" << "d/MMM/yyyy H:mm:ss zzz" << "dd/MMM/yy h:mm a"
                    << "d/MM/yy" << "d/MM/yy H:mm" << "d.M.yy H:mm"
                    << "yy/MM/dd HH:mm"
                    << "yyyy.MM.dd" << "yyyy.MM.dd HH:mm:ss" << "yyyy.MM.dd HH:mm"
                    << "yyyy.MM.dd." << "yyyy.MM.dd. H:mm:ss" << "yyyy.MM.dd. H:mm"
                    << "d.M.yyyy HH:mm:ss" << "d.M.yyyy HH:mm"
                    << "yy/MM/dd" << "yyyy/MM/dd" << "yy/MM/dd H:mm" << "MM/dd/yy H:mm"
                    << "yyyy-MM-dd";

    validDateFormats.removeDuplicates();
    foreach(QString format, validDateFormats){
        QDateTime convertedDateTime = QDateTime::fromString(inputVariable, format);
        if(convertedDateTime.isValid()){
            isDate = true;
            matchedFormat = format;
            break;
        }
    }

    output.append(isDate);
    output.append(matchedFormat);
    return output;
}

QStringList DataType::variableType(QString inputVariable)
{
    QString variableType = Constants::categoricalType;
    bool containsDigit = false;
    QString matchedFormat;
    QStringList output;

    // Check if the string has a digit
    foreach(QChar stringChar, inputVariable){
        if(stringChar.isDigit()){
            containsDigit =  true;
            break;
        }
    }

    // Check data type
    if(containsDigit){
        if(checkNumberType(inputVariable) == true){
            variableType = Constants::numericalType;
            matchedFormat = "";
        } else if(checkDateTimeType(inputVariable).at(0).toBool() == true){
            variableType = Constants::dateType;
            matchedFormat = checkDateTimeType(inputVariable).at(1).toString();
        } else {
            variableType = Constants::categoricalType;
            matchedFormat = "";
        }
    }

    output.append(variableType);
    output.append(matchedFormat);

    return output;
}

QString DataType::qVariantType(QString inputVariable)
{
    QString output;

    QStringList intType;
    QStringList bigIntType;
    QStringList boolType;
    QStringList dateType;
    QStringList dateTimeType;
    QStringList floatType;
    QStringList doubleType;
    QStringList blobType;

    intType << "int" << "uint";
    bigIntType << "qulonglong" << "qlonglong";
    boolType << "bool";
    dateType << "qdate";
    dateTimeType << "qtime" << "qdatetime";
    floatType << "float";
    doubleType << "double";
    blobType << "qdatastream";

    inputVariable = inputVariable.toLower();

    if(intType.contains(inputVariable)){
        output = "INTEGER";
    } else if(bigIntType.contains(inputVariable)) {
        output = "BIGINT";
    } else if(boolType.contains(inputVariable)) {
        output = "BOOLEAN";
    } else if(dateType.contains(inputVariable)) {
        output = "DATE";
    } else if(dateTimeType.contains(inputVariable)) {
        output = "TIMESTAMP";
    } else if(floatType.contains(inputVariable)) {
        output = "FLOAT";
    } else if(doubleType.contains(inputVariable)) {
        output = "DOUBLE";
    } else if(blobType.contains(inputVariable)) {
       output = "BLOB";
    } else {
       output = "VARCHAR";
    }

    return output;
}
