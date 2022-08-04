
function getSummaryPerBUPerMonth(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {

    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];
    int periodNo = 0;

    map<json> cosTotal = {id: "1", title: COS_HEADING_TITLE};
    map<json> cosRecurring = {id: "2", title: COS_RECURRING_TITLE};
    map<json> cosNonRecurring = {id: "3", title: COS_NON_RECURRING_TITLE};
    map<json> cosPublicCloud = {id: "4", title: COS_PUBLIC_CLOUD_TITLE};

    map<json> revenueTotal = {id: "1", title: REVENUE_HEADING_TITLE};
    map<json> revenueRecurring = {id: "2", title: REVENUE_RECURRING_TITLE};
    map<json> revenueNonRecurring = {id: "3", title: REVENUE_NON_RECURRING_TITLE};
    map<json> revenueCloud = {id: "4", title: REVENUE_CLOUD_TITLE};

    map<json> gpTotal = {id: "1", title: GP_HEADING_TITLE};
    map<json> gpRecurring = {id: "2", title: GP_RECURRING_TITLE};
    map<json> gpNonRecurring = {id: "3", title: GP_NON_RECURRING_TITLE};
    map<json> gpPublicCloud = {id: "4", title: GP_PUBLIC_CLOUD_TITLE};

    map<json> gmTotal = {id: "1", title: GM_HEADING_TITLE};
    map<json> gmRecurring = {id: "2", title: GM_RECURRING_TITLE};
    map<json> gmNonRecurring = {id: "3", title: GM_NON_RECURRING_TITLE};
    map<json> gmPublicCloud = {id: "4", title: GM_PUBLIC_CLOUD_TITLE};

    foreach var period in payload.dateRange {

        json[] revenueRowsPeriod = [];
        json[] cosRowsPeriod = [];
        json[] gpRowsPeriod = [];
        json[] gmRowsPeriod = [];

        periodNo += 1;
        var periodStr = "period" + periodNo.toString();

        DatePeriodWithBURecord datePeriodWithBURecord = {
            businessUnit: payload.businessUnit,
            period: {
                startDate: period.startDate,
                endDate: period.endDate
            }
        };

        [revenueRowsPeriod, cosRowsPeriod, gpRowsPeriod, gmRowsPeriod] = check getSummaryPerBUDateRange(datePeriodWithBURecord);

        cosTotal[periodStr] = check cosRowsPeriod[0].value;
        cosRecurring[periodStr] = check cosRowsPeriod[1].value;
        cosNonRecurring[periodStr] = check cosRowsPeriod[2].value;
        cosPublicCloud[periodStr] = check cosRowsPeriod[3].value;

        revenueTotal[periodStr] = check revenueRowsPeriod[0].value;
        revenueRecurring[periodStr] = check revenueRowsPeriod[1].value;
        revenueNonRecurring[periodStr] = check revenueRowsPeriod[2].value;
        revenueCloud[periodStr] = check revenueRowsPeriod[3].value;

        gpTotal[periodStr] = check gpRowsPeriod[0].value;
        gpRecurring[periodStr] = check gpRowsPeriod[1].value;
        gpNonRecurring[periodStr] = check gpRowsPeriod[2].value;
        gpPublicCloud[periodStr] = check gpRowsPeriod[3].value;

        gmTotal[periodStr] = check gmRowsPeriod[0].value;
        gmRecurring[periodStr] = check gmRowsPeriod[1].value;
        gmNonRecurring[periodStr] = check gmRowsPeriod[2].value;
        gmPublicCloud[periodStr] = check gmRowsPeriod[3].value;

    }
    cosRows = [cosTotal, cosRecurring, cosNonRecurring, cosPublicCloud];
    revenueRows = [revenueTotal, revenueRecurring, revenueNonRecurring, revenueCloud];
    gpRows = [gpTotal, gpRecurring, gpNonRecurring, gpPublicCloud];
    gmRows = [gmTotal, gmRecurring, gmNonRecurring, gmPublicCloud];

    return {Revenue: revenueRows, CostOfSales: cosRows, GrossProfit: gpRows, GrossMargin: gmRows};

}
