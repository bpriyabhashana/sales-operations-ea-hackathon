
function getSummaryPerBUPerMonth(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {

    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];
    int periodNo = 0;

    map<json> dateRange = {};

    map<json> cosTotal = {title: COS_HEADING_TITLE};
    map<json> cosRecurring = {title: COS_RECURRING_TITLE};
    map<json> cosNonRecurring = {title: COS_NON_RECURRING_TITLE};
    map<json> cosPublicCloud = {title: COS_PUBLIC_CLOUD_TITLE};

    map<json> revenueTotal = {title: REVENUE_HEADING_TITLE};
    map<json> revenueRecurring = {title: REVENUE_RECURRING_TITLE};
    map<json> revenueNonRecurring = {title: REVENUE_NON_RECURRING_TITLE};
    map<json> revenueCloud = {title: REVENUE_CLOUD_TITLE};

    map<json> gpTotal = {title: GP_HEADING_TITLE};
    map<json> gpRecurring = {title: GP_RECURRING_TITLE};
    map<json> gpNonRecurring = {title: GP_NON_RECURRING_TITLE};
    map<json> gpPublicCloud = {title: GP_PUBLIC_CLOUD_TITLE};

    map<json> gmTotal = {title: GM_HEADING_TITLE};
    map<json> gmRecurring = {title: GM_RECURRING_TITLE};
    map<json> gmNonRecurring = {title: GM_NON_RECURRING_TITLE};
    map<json> gmPublicCloud = {title: GM_PUBLIC_CLOUD_TITLE};

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
    cosRows = check formatArray([cosTotal, cosRecurring, cosNonRecurring, cosPublicCloud]);
    revenueRows = check formatArray([revenueTotal, revenueRecurring, revenueNonRecurring, revenueCloud]);
    gpRows = check formatArray([gpTotal, gpRecurring, gpNonRecurring, gpPublicCloud]);
    gmRows = check formatArray([gmTotal, gmRecurring, gmNonRecurring, gmPublicCloud]);

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

            match payload.businessUnit {
                BU_INTEGRATION_SW => {
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
                }
                BU_ALL_WSO2 => {
                    if (summaryObject.AccountCategory == COS_RECURRING_REVENUE) {
                        cosRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_NON_RECURRING_REVENUE) {
                        cosNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == COS_CLOUD) {
                        cosCloudTotalBU += summaryObject.Amount;
                    }
                }
                _ => {
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
        }
        costOfSalesTotalBU = cosRecurringTotalBU + cosNonRecurringTotalBU + cosCloudTotalBU;

        cosRows.push(
        {
            title: COS_HEADING_TITLE,
            value: costOfSalesTotalBU
        },
        {
            title: COS_RECURRING_TITLE,
            value: cosRecurringTotalBU
        },
        {
            title: COS_NON_RECURRING_TITLE,
            value: cosNonRecurringTotalBU
        },
        {
            title: COS_PUBLIC_CLOUD_TITLE,
            value: cosCloudTotalBU
        }
    );

    }

    json|error revenue = getIncomeRecords(payload.period);

    if (revenue is json) {

        foreach var item in <json[]>revenue {
            IncomeExpenseSummaryRecord summaryObject = check item.cloneWithType(IncomeExpenseSummaryRecord);

            match payload.businessUnit {
                BU_INTEGRATION_SW => {
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
                }
                BU_ALL_WSO2 => {
                    if (summaryObject.AccountCategory == REVENUE_RECURRING) {
                        revenueRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_NON_RECURRING) {
                        revenueNonRecurringTotalBU += summaryObject.Amount;
                    } else if (summaryObject.AccountCategory == REVENUE_CLOUD) {
                        revenueCloudTotalBU += summaryObject.Amount;
                    }
                }
                _ => {
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
        }

        revenueTotalBU = revenueRecurringTotalBU + revenueNonRecurringTotalBU + revenueCloudTotalBU;

        revenueRows.push(
        {
            title: REVENUE_HEADING_TITLE,
            value: revenueTotalBU
        },
        {
            title: REVENUE_RECURRING_TITLE,
            value: revenueRecurringTotalBU
        },
        {
            title: REVENUE_NON_RECURRING_TITLE,
            value: revenueNonRecurringTotalBU
        },
        {
            title: REVENUE_CLOUD_TITLE,
            value: revenueCloudTotalBU
        }
    );

        gpRows.push(
        {
            title: GP_HEADING_TITLE,
            value: revenueTotalBU - costOfSalesTotalBU
        },
        {
            title: GP_RECURRING_TITLE,
            value: revenueRecurringTotalBU - cosRecurringTotalBU
        },
        {
            title: GP_NON_RECURRING_TITLE,
            value: revenueNonRecurringTotalBU - cosNonRecurringTotalBU
        },
        {
            title: GP_PUBLIC_CLOUD_TITLE,
            value: revenueCloudTotalBU - cosCloudTotalBU
        }
    );

        gmRows.push(
        {
            title: GM_HEADING_TITLE,
            value: calculateGrossMargin(revenueTotalBU, costOfSalesTotalBU)
        },
        {
            title: GM_RECURRING_TITLE,
            value: calculateGrossMargin(revenueRecurringTotalBU, cosRecurringTotalBU)
        },
        {
            title: GM_NON_RECURRING_TITLE,
            value: calculateGrossMargin(revenueNonRecurringTotalBU, cosNonRecurringTotalBU)
        },
        {
            title: GM_PUBLIC_CLOUD_TITLE,
            value: calculateGrossMargin(revenueCloudTotalBU, cosCloudTotalBU)
        }
    );

    }

    return [revenueRows, cosRows, gpRows, gmRows];
}
