#ifndef CHARTSTHREAD_H
#define CHARTSTHREAD_H

// ----------------------
// IMPORTANT
// ----------------------
// This class will be replaced ChartsWorker class in the future

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTime>
#include <QDateTime>
#include <QRegularExpression>
#include <QElapsedTimer>
#include <QFileInfo>
#include <QSqlQuery>
#include <QSqlError>

#include "jsoncons/json.hpp"
#include "../../constants.h"
#include "../../statics.h"
#include "datatype.h"

#include "../../duckdb.hpp"

using namespace jsoncons;

class ChartsThread : public QObject
{
    Q_OBJECT
    QString reportWhereConditions;
    QString dashboardWhereConditions;
    int currentDashboardId;
    int currentReportId;

    int currentChartSource;
    QTime myTimer;
    QElapsedTimer myTimer2;
    QString masterTable;
    QString masterJoinParams;
    QString masterWhereParams;

    QString datasourceType;
    QString xAxisColumn;
    QString yAxisColumn;
    QString xSplitKey;
    QVariantList xAxisColumnList;
    QVariantList yAxisColumnList;
    QVariantList row3ColumnList;
    QString sourceColumn;
    QString destinationColumn;
    QString measureColumn;
    QString calculateColumn;
    QString greenValue;
    QString yellowValue;
    QString redValue;
    QJsonArray dateConversionOptions;
    QJsonArray xAxisObject;
    QJsonArray yAxisObject;

    QHash<int, QString> dashboardReportDataCached;
    QHash<int, QString> liveDashboardFilterParamsCached;
    QHash<int, QString> dashboardWhereConditionsCached;
    QHash<int, bool> cachedDashboardConditions;

    DataType dataType;

public:
    explicit ChartsThread(QObject *parent = nullptr);
    ~ChartsThread();

    Q_INVOKABLE void clearCache();

    void methodSelector(QString functionName = "", QString reportWhereConditions = "", QString dashboardWhereConditions = "", int chartSource = Constants::reportScreen, int reportId = 0, int dashboardId = 0, QString datasourceType = Constants::liveType, QJsonArray xAxisObject = {}, QJsonArray yAxisObject = {});
    void queryParams(QString masterTable = "", QString masterWhereParams = "", QString masterJoinParams = "");
    void setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey);
    void setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList, QVariantList &row3ColumnList);
    void setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn);
    void setGaugeKpiDetails(QString &calculateColumn, QString greenValue = "", QString yellowValue = "", QString redValue = "");
    void setTablePivotDateConversionOptions(QString dateConversionOptions);

public slots:

    void start();

    QString getAggregateType();

    void getBarChartValues();
    void getStackedBarChartValues(); // getStackedBarAreaValues
    void getGroupedBarChartValues();
    void getNewGroupedBarChartValues();
    void getAreaChartValues(); // getLineAreaWaterfallValues
    void getLineChartValues(); // getLineAreaWaterfallValues
    void getLineBarChartValues();
    void getPieChartValues();
    void getFunnelChartValues();
    void getRadarChartValues();
    void getScatterChartValues();
    void getScatterChartNumericalValues();

    void getHeatMapChartValues();

    void getSunburstChartValues(); // getTreeSunburstValues
    void getWaterfallChartValues(); // getLineAreaWaterfallValues
    void getGaugeChartValues();
    void getSankeyChartValues();

    void getTreeChartValues(); // getTreeSunburstValues
    void getTreeMapChartValues(); // getTreeSunburstValues
    void getKPIChartValues();
    void getTableChartValues();
    void getPivotChartValues();
    void getStackedAreaChartValues(); // getStackedBarAreaValues
    void getMultiLineChartValues();

    void getLineAreaWaterfallValues( QString &xAxisColumn, QString &yAxisColumn, QJsonArray &xAxisObject, QString identifier = "");
    void getTreeSunburstValues(QVariantList &xAxisColumn, QString &yAxisColumn, QString identifier = "");
    void getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QJsonArray &xAxisObject, QString identifier = "");

private:
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> queryExtractFunction(QString mainQuery);
    QSqlQuery queryLiveFunction(QString mainQuery);
    QMap<int, QHash<int, QString>> queryLiveValues(QString mainQuery, int totalCols); // QHash instead of QStringList for faster access
    QString getTableName();

signals:

    void signalBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalGroupedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalNewGroupedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalAreaChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalLineChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalLineBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalPieChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalFunnelChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalRadarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalScatterChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalScatterChartNumericalValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalHeatMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSunburstChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalWaterfallChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalGaugeChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSankeyChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalKPIChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTableChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalPivotChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedAreaChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalMultiLineChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

    void signalLineAreaWaterfallValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeSunburstValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedBarAreaValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

};

#endif // CHARTSTHREAD_H
