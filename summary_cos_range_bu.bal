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


public isolated function calculateCosDetailsPerBUDateRange(MultipleDatePeriodsWithBURecordFilterCriteria payload,
                                                    string accountCategory,
                                                    string cosSubLevelName) returns json[]|error {

    json[] mainJsonPayload = [];
    json[] cosRows = [];
    json valueJson = {};

    map<json> cosTitle = {id: "0", title: cosSubLevelName};
    map<json> cosBonus = {id: "1", title: AC_SUB_CAT_BONUS};
    map<json> cosConsultancy = {id: "2", title: AC_SUB_CAT_CONSULTANCY};
    map<json> cosHR = {id: "3", title: AC_SUB_CAT_HR};
    map<json> cosInfraIT = {id: "4", title: AC_SUB_CAT_INFRA_IT};
    map<json> cosPartnerCommission = {id: "5", title: AC_SUB_CAT_PARTNER_COMMISSION};
    map<json> cosPassThroughExp = {id: "6", title: AC_SUB_CAT_PASSTHROUGH_EXP};
    map<json> cosPrograms = {id: "7", title: AC_SUB_CAT_PROGRAMS};
    map<json> cosPublicCloud = {id: "8", title: AC_SUB_CAT_PUBLIC_CLOUD};
    map<json> cosRentNUtils = {id: "9", title: AC_SUB_CAT_RENT_UTILITIES};
    map<json> cosRoyalties = {id: "10", title: AC_SUB_CAT_ROYALTIES};
    map<json> cosSWSupport = {id: "11", title: AC_SUB_CAT_SW_SUPPORT};
    map<json> cosTrainingNWelfare = {id: "12", title: AC_SUB_CAT_TRAINING_WELFARE};
    map<json> cosTravel = {id: "13", title: AC_SUB_CAT_TRAVEL};

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
     cosRows = [cosTitle, cosBonus, cosConsultancy, cosHR, cosInfraIT, cosPartnerCommission, cosPassThroughExp,
               cosPrograms, cosPublicCloud, cosRentNUtils, cosRoyalties, cosSWSupport, cosTrainingNWelfare, cosTravel];

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
            id: "0",
            title: cosSubLevelName,
            value: cosTotalBU
        },
        {
            id: "1",
            title: AC_SUB_CAT_BONUS,
            value: cosBonusTotalBU
        },
        {
            id: "2",
            title: AC_SUB_CAT_CONSULTANCY,
            value: cosConsultancyTotalBU
        },
        {
            id: "3",
            title: AC_SUB_CAT_HR,
            value: cosHRTotalBU
        },
        {
            id: "4",
            title: AC_SUB_CAT_INFRA_IT,
            value: cosInfraITTotalBU
        },
        {
            id: "5",
            title: AC_SUB_CAT_PARTNER_COMMISSION,
            value: cosPartnerCommTotalBU
        },
        {
            id: "6",
            title: AC_SUB_CAT_PASSTHROUGH_EXP,
            value: cosPassthroughExpTotalBU
        },
        {
            id: "7",
            title: AC_SUB_CAT_PROGRAMS,
            value: cosProgramsTotalBU
        },
        {
            id: "8",
            title: AC_SUB_CAT_PUBLIC_CLOUD,
            value: cosPublicCloudTotalBU
        },
        {
            id: "9",
            title: AC_SUB_CAT_RENT_UTILITIES,
            value: cosRentNUtilTotalBU
        },
        {
            id: "10",
            title: AC_SUB_CAT_ROYALTIES,
            value: cosRoyaltiesTotalBU
        },
        {
            id: "11",
            title: AC_SUB_CAT_SW_SUPPORT,
            value: cosSWSupportTotalBU
        },
        {
            id: "12",
            title: AC_SUB_CAT_TRAINING_WELFARE,
            value: cosTrainingNWelfareTotalBU
        },
        {
            id: "13",
            title: AC_SUB_CAT_TRAVEL,
            value: cosTravelTotalBU
        }
    );
    
 }
return cosRows;
}