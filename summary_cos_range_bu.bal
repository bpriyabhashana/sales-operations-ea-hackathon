function getSummaryCOSRangeBUSummary(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check calculateCosDetailsPerBUDateRange(payload,
                                                        AC_CAT_ALL,
                                                        COS_HEADING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

function getSummaryCOSRangeBURecurringSummary(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check calculateCosDetailsPerBUDateRange(payload,
                                                        COS_RECURRING_REVENUE,
                                                        COS_RECURRING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

function getSummaryCOSRangeBUNonRecurringSummary(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check calculateCosDetailsPerBUDateRange(payload,
                                                        COS_NON_RECURRING_REVENUE,
                                                        COS_NON_RECURRING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

function getSummaryCOSRangeBUCloudSummary(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check calculateCosDetailsPerBUDateRange(payload,
                                                        COS_CLOUD,
                                                        COS_PUBLIC_CLOUD_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

public isolated function calculateCosDetailsPerBUDateRange(MultipleDatePeriodsWithBURecordFilterCriteria payload,
                                                    string accountCategory,
                                                    string cosSubLevelName) returns json[]|error {

    json[] mainJsonPayload = [];
    json[] cosRows = [];
    json valueJson = {};

    map<json> cosTitle = {title: cosSubLevelName};
    map<json> cosBonus = {title: AC_SUB_CAT_BONUS};
    map<json> cosConsultancy = {title: AC_SUB_CAT_CONSULTANCY};
    map<json> cosHR = {title: AC_SUB_CAT_HR};
    map<json> cosInfraIT = {title: AC_SUB_CAT_INFRA_IT};
    map<json> cosPartnerCommission = {title: AC_SUB_CAT_PARTNER_COMMISSION};
    map<json> cosPassThroughExp = {title: AC_SUB_CAT_PASSTHROUGH_EXP};
    map<json> cosPrograms = {title: AC_SUB_CAT_PROGRAMS};
    map<json> cosPublicCloud = {title: AC_SUB_CAT_PUBLIC_CLOUD};
    map<json> cosRentNUtils = {title: AC_SUB_CAT_RENT_UTILITIES};
    map<json> cosRoyalties = {title: AC_SUB_CAT_ROYALTIES};
    map<json> cosSWSupport = {title: AC_SUB_CAT_SW_SUPPORT};
    map<json> cosTrainingNWelfare = {title: AC_SUB_CAT_TRAINING_WELFARE};
    map<json> cosTravel = {title: AC_SUB_CAT_TRAVEL};

    int periodNo = 0;

    map<json> dateRange = {};

    foreach var period in payload.dateRange {

        json[] cosRowsPeriod = [];

        periodNo += 1;
        var periodStr = "period" + periodNo.toString();

        DatePeriodWithBURecord datePeriodWithBURecord = {
            businessUnit: payload.businessUnit,
            period: {
                startDate: period.startDate,
                endDate: period.endDate
            }
        };

        cosRowsPeriod = check getSummaryCosDetailsPerBUDateRange(datePeriodWithBURecord,
                                                                        accountCategory,
                                                                        cosSubLevelName);

        dateRange[periodStr] = period.startDate + " " + period.endDate;

        cosTitle[periodStr] = check cosRowsPeriod[0].value;
        cosBonus[periodStr] = check cosRowsPeriod[1].value;
        cosConsultancy[periodStr] = check cosRowsPeriod[2].value;
        cosHR[periodStr] = check cosRowsPeriod[3].value;
        cosInfraIT[periodStr] = check cosRowsPeriod[4].value;
        cosPartnerCommission[periodStr] = check cosRowsPeriod[5].value;
        cosPassThroughExp[periodStr] = check cosRowsPeriod[6].value;
        cosPrograms[periodStr] = check cosRowsPeriod[7].value;
        cosPublicCloud[periodStr] = check cosRowsPeriod[8].value;
        cosRentNUtils[periodStr] = check cosRowsPeriod[9].value;
        cosRoyalties[periodStr] = check cosRowsPeriod[10].value;
        cosSWSupport[periodStr] = check cosRowsPeriod[11].value;
        cosTrainingNWelfare[periodStr] = check cosRowsPeriod[12].value;
        cosTravel[periodStr] = check cosRowsPeriod[13].value;

    }
    cosRows = check formatRangeArray([
        cosTitle,
        cosBonus,
        cosConsultancy,
        cosHR,
        cosInfraIT,
        cosPartnerCommission,
        cosPassThroughExp,
        cosPrograms,
        cosPublicCloud,
        cosRentNUtils,
        cosRoyalties,
        cosSWSupport,
        cosTrainingNWelfare,
        cosTravel
    ]);

    match accountCategory {
        AC_CAT_ALL => {
            valueJson = {
                "COS_SUB_LEVEL": cosRows
            };
        }
        COS_RECURRING_REVENUE => {
            valueJson = {
                "COS_RECURRING_SUB_LEVEL": cosRows
            };
        }
        COS_NON_RECURRING_REVENUE => {
            valueJson = {
                "COS_NON_RECURRING_SUB_LEVEL": cosRows
            };
        }
        COS_CLOUD => {
            valueJson = {
                "COS_CLOUD_SUB_LEVEL": cosRows
            };
        }
    }

    mainJsonPayload.push({
        dateRange: dateRange,
        values: valueJson
    });

    return mainJsonPayload;

}

isolated function getSummaryCosDetailsPerBUDateRange(DatePeriodWithBURecord payload,
                                                    string accountCategory,
                                                    string cosSubLevelName) returns json[]|error {

    json[] cosRows = [];

    decimal cosTotalBU = 0.00;
    decimal cosBonusTotalBU = 0.00;
    decimal cosConsultancyTotalBU = 0.00;
    decimal cosHRTotalBU = 0.00;
    decimal cosInfraITTotalBU = 0.00;
    decimal cosPartnerCommTotalBU = 0.00;
    decimal cosPassthroughExpTotalBU = 0.00;
    decimal cosProgramsTotalBU = 0.00;
    decimal cosPublicCloudTotalBU = 0.00;
    decimal cosRentNUtilTotalBU = 0.00;
    decimal cosRoyaltiesTotalBU = 0.00;
    decimal cosSWSupportTotalBU = 0.00;
    decimal cosTrainingNWelfareTotalBU = 0.00;
    decimal cosTravelTotalBU = 0.00;

    json|error costOfSales = getCostOfSalesRecords(payload.period);

    if (costOfSales is json) {
        foreach var item in <json[]>costOfSales {
            CostOfSalesSummaryRecord summaryObject = check item.cloneWithType(CostOfSalesSummaryRecord);

            if (accountCategory != AC_CAT_ALL) {
                if (payload.businessUnit == BU_INTEGRATION_SW) {
                    if (summaryObject.AccountCategory == accountCategory &&
                    (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                    summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE)) {
                        match summaryObject.Type {
                            AC_SUB_CAT_BONUS => {
                                cosBonusTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_CONSULTANCY => {
                                cosConsultancyTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_HR => {
                                cosHRTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_INFRA_IT => {
                                cosInfraITTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PARTNER_COMMISSION => {
                                cosPartnerCommTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PASSTHROUGH_EXP => {
                                cosPassthroughExpTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PROGRAMS => {
                                cosProgramsTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PUBLIC_CLOUD => {
                                cosPublicCloudTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_RENT_UTILITIES => {
                                cosRentNUtilTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_ROYALTIES => {
                                cosRoyaltiesTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_SW_SUPPORT => {
                                cosSWSupportTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAINING_WELFARE => {
                                cosTrainingNWelfareTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAVEL => {
                                cosTravelTotalBU += summaryObject.Amount;
                            }
                            // Not working
                            // _ => {
                            //     cosTotalBU += summaryObject.Amount;
                            // }
                        }
                    }
                } else if (payload.businessUnit == BU_ALL_WSO2) {
                    if (summaryObject.AccountCategory == accountCategory) {
                        match summaryObject.Type {
                            AC_SUB_CAT_BONUS => {
                                cosBonusTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_CONSULTANCY => {
                                cosConsultancyTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_HR => {
                                cosHRTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_INFRA_IT => {
                                cosInfraITTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PARTNER_COMMISSION => {
                                cosPartnerCommTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PASSTHROUGH_EXP => {
                                cosPassthroughExpTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PROGRAMS => {
                                cosProgramsTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PUBLIC_CLOUD => {
                                cosPublicCloudTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_RENT_UTILITIES => {
                                cosRentNUtilTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_ROYALTIES => {
                                cosRoyaltiesTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_SW_SUPPORT => {
                                cosSWSupportTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAINING_WELFARE => {
                                cosTrainingNWelfareTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAVEL => {
                                cosTravelTotalBU += summaryObject.Amount;
                            }
                        }
                    }
                } else {
                    if (summaryObject.AccountCategory == accountCategory &&
                    summaryObject.BusinessUnit == payload.businessUnit) {
                        match summaryObject.Type {
                            AC_SUB_CAT_BONUS => {
                                cosBonusTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_CONSULTANCY => {
                                cosConsultancyTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_HR => {
                                cosHRTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_INFRA_IT => {
                                cosInfraITTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PARTNER_COMMISSION => {
                                cosPartnerCommTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PASSTHROUGH_EXP => {
                                cosPassthroughExpTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PROGRAMS => {
                                cosProgramsTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PUBLIC_CLOUD => {
                                cosPublicCloudTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_RENT_UTILITIES => {
                                cosRentNUtilTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_ROYALTIES => {
                                cosRoyaltiesTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_SW_SUPPORT => {
                                cosSWSupportTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAINING_WELFARE => {
                                cosTrainingNWelfareTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAVEL => {
                                cosTravelTotalBU += summaryObject.Amount;
                            }
                        }
                    }
                }
            }
        else {
                if (payload.businessUnit == BU_INTEGRATION_SW) {
                    if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                    summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                        match summaryObject.Type {
                            AC_SUB_CAT_BONUS => {
                                cosBonusTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_CONSULTANCY => {
                                cosConsultancyTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_HR => {
                                cosHRTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_INFRA_IT => {
                                cosInfraITTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PARTNER_COMMISSION => {
                                cosPartnerCommTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PASSTHROUGH_EXP => {
                                cosPassthroughExpTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PROGRAMS => {
                                cosProgramsTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PUBLIC_CLOUD => {
                                cosPublicCloudTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_RENT_UTILITIES => {
                                cosRentNUtilTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_ROYALTIES => {
                                cosRoyaltiesTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_SW_SUPPORT => {
                                cosSWSupportTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAINING_WELFARE => {
                                cosTrainingNWelfareTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAVEL => {
                                cosTravelTotalBU += summaryObject.Amount;
                            }
                            // Not working
                            // _ => {
                            //     cosTotalBU += summaryObject.Amount;
                            // }
                        }
                    }
                } else if (payload.businessUnit == BU_ALL_WSO2) {
                    match summaryObject.Type {
                        AC_SUB_CAT_BONUS => {
                            cosBonusTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_CONSULTANCY => {
                            cosConsultancyTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_HR => {
                            cosHRTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_INFRA_IT => {
                            cosInfraITTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PARTNER_COMMISSION => {
                            cosPartnerCommTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PASSTHROUGH_EXP => {
                            cosPassthroughExpTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PROGRAMS => {
                            cosProgramsTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PUBLIC_CLOUD => {
                            cosPublicCloudTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_RENT_UTILITIES => {
                            cosRentNUtilTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_ROYALTIES => {
                            cosRoyaltiesTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_SW_SUPPORT => {
                            cosSWSupportTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_TRAINING_WELFARE => {
                            cosTrainingNWelfareTotalBU += summaryObject.Amount;
                        }
                        AC_SUB_CAT_TRAVEL => {
                            cosTravelTotalBU += summaryObject.Amount;
                        }
                        // Not working
                        // _ => {
                        //     cosTotalBU += summaryObject.Amount;
                        // }
                    }
                } else {
                    if (summaryObject.BusinessUnit == payload.businessUnit) {
                        match summaryObject.Type {
                            AC_SUB_CAT_BONUS => {
                                cosBonusTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_CONSULTANCY => {
                                cosConsultancyTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_HR => {
                                cosHRTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_INFRA_IT => {
                                cosInfraITTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PARTNER_COMMISSION => {
                                cosPartnerCommTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PASSTHROUGH_EXP => {
                                cosPassthroughExpTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PROGRAMS => {
                                cosProgramsTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_PUBLIC_CLOUD => {
                                cosPublicCloudTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_RENT_UTILITIES => {
                                cosRentNUtilTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_ROYALTIES => {
                                cosRoyaltiesTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_SW_SUPPORT => {
                                cosSWSupportTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAINING_WELFARE => {
                                cosTrainingNWelfareTotalBU += summaryObject.Amount;
                            }
                            AC_SUB_CAT_TRAVEL => {
                                cosTravelTotalBU += summaryObject.Amount;
                            }
                            // Not working
                            // _ => {
                            //     cosTotalBU += nsCOSSumResp.amount;
                            // }
                        }
                    }
                }
            }

        }

        cosTotalBU += cosBonusTotalBU + cosConsultancyTotalBU + cosHRTotalBU + cosInfraITTotalBU + cosPartnerCommTotalBU +
        cosPassthroughExpTotalBU + cosProgramsTotalBU + cosPublicCloudTotalBU + cosRentNUtilTotalBU +
        cosRoyaltiesTotalBU + cosSWSupportTotalBU + cosTrainingNWelfareTotalBU + cosTravelTotalBU;

        cosRows.push(
        {
            title: cosSubLevelName,
            value: cosTotalBU
        },
        {
            title: AC_SUB_CAT_BONUS,
            value: cosBonusTotalBU
        },
        {
            title: AC_SUB_CAT_CONSULTANCY,
            value: cosConsultancyTotalBU
        },
        {
            title: AC_SUB_CAT_HR,
            value: cosHRTotalBU
        },
        {
            title: AC_SUB_CAT_INFRA_IT,
            value: cosInfraITTotalBU
        },
        {
            title: AC_SUB_CAT_PARTNER_COMMISSION,
            value: cosPartnerCommTotalBU
        },
        {
            title: AC_SUB_CAT_PASSTHROUGH_EXP,
            value: cosPassthroughExpTotalBU
        },
        {
            title: AC_SUB_CAT_PROGRAMS,
            value: cosProgramsTotalBU
        },
        {
            title: AC_SUB_CAT_PUBLIC_CLOUD,
            value: cosPublicCloudTotalBU
        },
        {
            title: AC_SUB_CAT_RENT_UTILITIES,
            value: cosRentNUtilTotalBU
        },
        {
            title: AC_SUB_CAT_ROYALTIES,
            value: cosRoyaltiesTotalBU
        },
        {
            title: AC_SUB_CAT_SW_SUPPORT,
            value: cosSWSupportTotalBU
        },
        {
            title: AC_SUB_CAT_TRAINING_WELFARE,
            value: cosTrainingNWelfareTotalBU
        },
        {
            title: AC_SUB_CAT_TRAVEL,
            value: cosTravelTotalBU
        }
    );

    }
    return cosRows;
}
