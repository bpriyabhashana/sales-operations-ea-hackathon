
function getSummaryPerBUPerMonth(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {

    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];
    int periodNo = 0;

    map<json> dateRange = {};

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

        dateRange[periodStr] = period.startDate + " " + period.endDate;
        // dateRange[periodStr] = {startDate: period.startDate, endDate: period.endDate};

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

    return {DateRange: dateRange, Revenue: revenueRows, CostOfSales: cosRows, GrossProfit: gpRows, GrossMargin: gmRows};

}


function getSummaryPerBUDateRange(DatePeriodWithBURecord payload) returns [json[], json[], json[], json[]]|error {

    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];

    decimal costOfSalesTotalBU = 0.00;
    decimal cosCloudTotalBU = 0.00;
    decimal cosRecurringTotalBU = 0.00;
    decimal cosNonRecurringTotalBU = 0.00;

    decimal revenueTotalBU = 0.00;
    decimal revenueCloudTotalBU = 0.00;
    decimal revenueRecurringTotalBU = 0.00;
    decimal revenueNonRecurringTotalBU = 0.00;

    json|error costOfSales = getExpenseRecords(payload.period);

    if (costOfSales is json) {
        foreach var item in <json[]>costOfSales {
            IncomeExpenseSummaryRecord summaryObject = check item.cloneWithType(IncomeExpenseSummaryRecord);

            if (payload.businessUnit == BU_INTEGRATION_SW) {
                if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                    if (summaryObject.AccountCategory == COS_RECURRING_REVENUE) {
                        cosRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_NON_RECURRING_REVENUE) {
                        cosNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_CLOUD) {
                        cosCloudTotalBU += summaryObject.Amount;
                    }
                }
            } else if (payload.businessUnit == BU_ALL_WSO2) {
                if (summaryObject.AccountCategory == COS_RECURRING_REVENUE) {
                    cosRecurringTotalBU += summaryObject.Amount;
                } else if (summaryObject.AccountCategory == COS_NON_RECURRING_REVENUE) {
                    cosNonRecurringTotalBU += summaryObject.Amount;
                } else if (summaryObject.AccountCategory == COS_CLOUD) {
                    cosCloudTotalBU += summaryObject.Amount;
                }
            } else {
                if (summaryObject.BusinessUnit == payload.businessUnit) {
                    if (summaryObject.AccountCategory == COS_RECURRING_REVENUE) {
                        cosRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_NON_RECURRING_REVENUE) {
                        cosNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_CLOUD) {
                        cosCloudTotalBU += summaryObject.Amount;
                    }
                }
            }
        }
        costOfSalesTotalBU = cosRecurringTotalBU + cosNonRecurringTotalBU + cosCloudTotalBU;

        cosRows.push(
        {
            id: "1",
            title: COS_HEADING_TITLE,
            value: costOfSalesTotalBU
        },
        {
            id: "2",
            title: COS_RECURRING_TITLE,
            value: cosRecurringTotalBU
        },
        {
            id: "3",
            title: COS_NON_RECURRING_TITLE,
            value: cosNonRecurringTotalBU
        },
        {
            id: "4",
            title: COS_PUBLIC_CLOUD_TITLE,
            value: cosCloudTotalBU
        }
    );

    } 

    json|error revenue = getIncomeRecords(payload.period);

    if (revenue is json) {

        foreach var item in <json[]>revenue {
            IncomeExpenseSummaryRecord summaryObject = check item.cloneWithType(IncomeExpenseSummaryRecord);

            if (payload.businessUnit == BU_INTEGRATION_SW) {
                if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                    if (summaryObject.AccountCategory == REVENUE_RECURRING) {
                        revenueRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_NON_RECURRING) {
                        revenueNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_CLOUD) {
                        revenueCloudTotalBU += summaryObject.Amount;
                    }
                }
            } else if (payload.businessUnit == BU_ALL_WSO2) {
                if (summaryObject.AccountCategory == REVENUE_RECURRING) {
                    revenueRecurringTotalBU += summaryObject.Amount;
                } else if (summaryObject.AccountCategory == REVENUE_NON_RECURRING) {
                    revenueNonRecurringTotalBU += summaryObject.Amount;
                } else if (summaryObject.AccountCategory == REVENUE_CLOUD) {
                    revenueCloudTotalBU += summaryObject.Amount;
                }
            } else {

                if (summaryObject.BusinessUnit == payload.businessUnit) {
                    if (summaryObject.AccountCategory == REVENUE_RECURRING) {
                        revenueRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_NON_RECURRING) {
                        revenueNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_CLOUD) {
                        revenueCloudTotalBU += summaryObject.Amount;
                    }
                }
            }

        }

        revenueTotalBU = revenueRecurringTotalBU + revenueNonRecurringTotalBU + revenueCloudTotalBU;

        revenueRows.push(
        {
            id: "1",
            title: REVENUE_HEADING_TITLE,
            value: revenueTotalBU
        },
        {
            id: "2",
            title: REVENUE_RECURRING_TITLE,
            value: revenueRecurringTotalBU
        },
        {
            id: "3",
            title: REVENUE_NON_RECURRING_TITLE,
            value: revenueNonRecurringTotalBU
        },
        {
            id: "4",
            title: REVENUE_CLOUD_TITLE,
            value: revenueCloudTotalBU
        }
    );

        // Gross Profit calculations -> Revenue - Cost of Sales
        gpRows.push(
        {
            id: "1",
            title: GP_HEADING_TITLE,
            value: revenueTotalBU - costOfSalesTotalBU
        },
        {
            id: "2",
            title: GP_RECURRING_TITLE,
            value: revenueRecurringTotalBU - cosRecurringTotalBU
        },
        {
            id: "3",
            title: GP_NON_RECURRING_TITLE,
            value: revenueNonRecurringTotalBU - cosNonRecurringTotalBU
        },
        {
            id: "4",
            title: GP_PUBLIC_CLOUD_TITLE,
            value: revenueCloudTotalBU - cosCloudTotalBU
        }
    );

        // Gross Margin calculations -> Gross Profit / Revenue
        gmRows.push(
        {
            id: "1",
            title: GM_HEADING_TITLE,
            value: calculateGrossMargin(revenueTotalBU, costOfSalesTotalBU)
        },
        {
            id: "2",
            title: GM_RECURRING_TITLE,
            value: calculateGrossMargin(revenueRecurringTotalBU, cosRecurringTotalBU)
        },
        {
            id: "3",
            title: GM_NON_RECURRING_TITLE,
            value: calculateGrossMargin(revenueNonRecurringTotalBU, cosNonRecurringTotalBU)
        },
        {
            id: "4",
            title: GM_PUBLIC_CLOUD_TITLE,
            value: calculateGrossMargin(revenueCloudTotalBU, cosCloudTotalBU)
        }
    );

    }

    
    return [revenueRows, cosRows, gpRows, gmRows];
}
