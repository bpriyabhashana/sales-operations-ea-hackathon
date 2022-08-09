isolated function getCostOfSalesSummary(DatePeriodFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check getCoSSummaryForGivenAccountCategory(payload,
                                                                        AC_CAT_ALL,
                                                                        COS_HEADING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

isolated function getCostOfSalesRecurringSummary(DatePeriodFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check getCoSSummaryForGivenAccountCategory(payload,
                                                                        COS_RECURRING_REVENUE,
                                                                        COS_RECURRING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

isolated function getCostOfSalesNonRecurringSummary(DatePeriodFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check getCoSSummaryForGivenAccountCategory(payload,
                                                                        COS_NON_RECURRING_REVENUE,
                                                                        COS_NON_RECURRING_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

isolated function getCostOfSalesCloudSummary(DatePeriodFilterCriteria payload) returns json|error {
    do {
        json[] cosRows = check getCoSSummaryForGivenAccountCategory(payload,
                                                                            COS_CLOUD,
                                                                            COS_PUBLIC_CLOUD_TITLE);
        return cosRows;
    } on fail error err {
        return err;
    }
}

public isolated function getCoSSummaryForGivenAccountCategory(DatePeriodFilterCriteria payload,
                                                    string accountCategory,
                                                    string cosSubLevelName) returns json[]|error {

    json[] cosRows = [];

    decimal cosTotal = 0.00;
    decimal cosTotalIAM = 0.00;
    decimal cosTotalINTSW = 0.00;
    decimal cosTotalINTCL = 0.00;
    decimal cosTotalCorporate = 0.00;

    decimal cosBonusTotal = 0.00;
    decimal cosBonusIAM = 0.00;
    decimal cosBonusINTSW = 0.00;
    decimal cosBonusINTCL = 0.00;
    decimal cosBonusCorporate = 0.00;

    decimal cosConsultancyTotal = 0.00;
    decimal cosConsultancyIAM = 0.00;
    decimal cosConsultancyINTSW = 0.00;
    decimal cosConsultancyINTCL = 0.00;
    decimal cosConsultancyCorporate = 0.00;

    decimal cosHRTotal = 0.00;
    decimal cosHRIAM = 0.00;
    decimal cosHRINTSW = 0.00;
    decimal cosHRINTCL = 0.00;
    decimal cosHRCorporate = 0.00;

    decimal cosInfraITTotal = 0.00;
    decimal cosInfraITIAM = 0.00;
    decimal cosInfraITINTSW = 0.00;
    decimal cosInfraITINTCL = 0.00;
    decimal cosInfraITCorporate = 0.00;

    decimal cosPartnerCommTotal = 0.00;
    decimal cosPartnerCommIAM = 0.00;
    decimal cosPartnerCommINTSW = 0.00;
    decimal cosPartnerCommINTCL = 0.00;
    decimal cosPartnerCommCorporate = 0.00;

    decimal cosPassthroughExpTotal = 0.00;
    decimal cosPassthroughExpIAM = 0.00;
    decimal cosPassthroughExpINTSW = 0.00;
    decimal cosPassthroughExpINTCL = 0.00;
    decimal cosPassthroughExpCorporate = 0.00;

    decimal cosProgramsTotal = 0.00;
    decimal cosProgramsIAM = 0.00;
    decimal cosProgramsINTSW = 0.00;
    decimal cosProgramsINTCL = 0.00;
    decimal cosProgramsCorporate = 0.00;

    decimal cosPublicCloudTotal = 0.00;
    decimal cosPublicCloudIAM = 0.00;
    decimal cosPublicCloudINTSW = 0.00;
    decimal cosPublicCloudINTCL = 0.00;
    decimal cosPublicCloudCorporate = 0.00;

    decimal cosRentNUtilTotal = 0.00;
    decimal cosRentNUtilIAM = 0.00;
    decimal cosRentNUtilINTSW = 0.00;
    decimal cosRentNUtilINTCL = 0.00;
    decimal cosRentNUtilCorporate = 0.00;

    decimal cosRoyaltiesTotal = 0.00;
    decimal cosRoyaltiesIAM = 0.00;
    decimal cosRoyaltiesINTSW = 0.00;
    decimal cosRoyaltiesINTCL = 0.00;
    decimal cosRoyaltiesCorporate = 0.00;

    decimal cosSWSupportTotal = 0.00;
    decimal cosSWSupportIAM = 0.00;
    decimal cosSWSupportINTSW = 0.00;
    decimal cosSWSupportINTCL = 0.00;
    decimal cosSWSupportCorporate = 0.00;

    decimal cosTrainingNWelfareTotal = 0.00;
    decimal cosTrainingNWelfareIAM = 0.00;
    decimal cosTrainingNWelfareINTSW = 0.00;
    decimal cosTrainingNWelfareINTCL = 0.00;
    decimal cosTrainingNWelfareCorporate = 0.00;

    decimal cosTravelTotal = 0.00;
    decimal cosTravelIAM = 0.00;
    decimal cosTravelINTSW = 0.00;
    decimal cosTravelINTCL = 0.00;
    decimal cosTravelCorporate = 0.00;

    json|error costOfSales = getCostOfSalesRecords(payload);

    if (costOfSales is json) {
        foreach var item in <json[]>costOfSales {

            CostOfSalesSummaryRecord summaryObject = check item.cloneWithType(CostOfSalesSummaryRecord);

            if (accountCategory != AC_CAT_ALL) {
                if (summaryObject.AccountCategory == accountCategory) {
                    match summaryObject.Type {
                        AC_SUB_CAT_BONUS => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosBonusIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosBonusINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosBonusINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosBonusINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosBonusINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosBonusINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosBonusCorporate += summaryObject.Amount;
                                }
                            }
                            cosBonusTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_CONSULTANCY => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosConsultancyIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosConsultancyINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosConsultancyINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosConsultancyINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosConsultancyINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosConsultancyINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosConsultancyCorporate += summaryObject.Amount;
                                }
                            }
                            cosConsultancyTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_HR => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosHRIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosHRINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosHRINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosHRINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosHRINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosHRINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosHRCorporate += summaryObject.Amount;
                                }
                            }
                            cosHRTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_INFRA_IT => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosInfraITIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosInfraITINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosInfraITINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosInfraITINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosInfraITINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosInfraITINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosInfraITCorporate += summaryObject.Amount;
                                }
                            }
                            cosInfraITTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PARTNER_COMMISSION => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosPartnerCommIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosPartnerCommINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosPartnerCommINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosPartnerCommINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosPartnerCommINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosPartnerCommINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosPartnerCommCorporate += summaryObject.Amount;
                                }
                            }
                            cosPartnerCommTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PASSTHROUGH_EXP => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosPassthroughExpIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosPassthroughExpINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosPassthroughExpINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosPassthroughExpINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosPassthroughExpINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosPassthroughExpINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosPassthroughExpCorporate += summaryObject.Amount;
                                }
                            }
                            cosPassthroughExpTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PROGRAMS => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosProgramsIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosProgramsINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosProgramsINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosProgramsINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosProgramsINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosProgramsINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosProgramsCorporate += summaryObject.Amount;
                                }
                            }
                            cosProgramsTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_PUBLIC_CLOUD => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosPublicCloudIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosPublicCloudINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosPublicCloudINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosPublicCloudINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosPublicCloudINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosPublicCloudINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosPublicCloudCorporate += summaryObject.Amount;
                                }
                            }
                            cosPublicCloudTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_RENT_UTILITIES => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosRentNUtilIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosRentNUtilINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosRentNUtilINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosRentNUtilINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosRentNUtilINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosRentNUtilINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosRentNUtilCorporate += summaryObject.Amount;
                                }
                            }
                            cosRentNUtilTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_ROYALTIES => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosRoyaltiesIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosRoyaltiesINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosRoyaltiesINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosRoyaltiesINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosRoyaltiesINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosRoyaltiesINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosRoyaltiesCorporate += summaryObject.Amount;
                                }
                            }
                            cosRoyaltiesTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_SW_SUPPORT => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosSWSupportIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosSWSupportINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosSWSupportINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosSWSupportINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosSWSupportINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosSWSupportINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosSWSupportCorporate += summaryObject.Amount;
                                }
                            }
                            cosSWSupportTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_TRAINING_WELFARE => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosTrainingNWelfareIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosTrainingNWelfareINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosTrainingNWelfareINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosTrainingNWelfareINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosTrainingNWelfareINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosTrainingNWelfareINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosTrainingNWelfareCorporate += summaryObject.Amount;
                                }
                            }
                            cosTrainingNWelfareTotal += summaryObject.Amount;
                        }
                        AC_SUB_CAT_TRAVEL => {
                            match summaryObject.BusinessUnit {
                                BU_IAM => {
                                    cosTravelIAM += summaryObject.Amount;
                                }
                                BU_INTEGRATION_SW => {
                                    cosTravelINTSW += summaryObject.Amount;
                                }
                                BU_INTEGRATION_CL => {
                                    cosTravelINTCL += summaryObject.Amount;
                                }
                                BU_BFSI => {
                                    cosTravelINTSW += summaryObject.Amount;
                                }
                                BU_IPAAS => {
                                    cosTravelINTSW += summaryObject.Amount;
                                }
                                BU_HEALTHCARE => {
                                    cosTravelINTSW += summaryObject.Amount;
                                }
                                BU_CORPORATE => {
                                    cosTravelCorporate += summaryObject.Amount;
                                }
                            }
                            cosTravelTotal += summaryObject.Amount;
                        }
                    }
                }
            } else {
                match summaryObject.Type {
                    AC_SUB_CAT_BONUS => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosBonusIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosBonusINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosBonusINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosBonusINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosBonusINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosBonusINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosBonusCorporate += summaryObject.Amount;
                            }
                        }
                        cosBonusTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_CONSULTANCY => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosConsultancyIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosConsultancyINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosConsultancyINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosConsultancyINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosConsultancyINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosConsultancyINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosConsultancyCorporate += summaryObject.Amount;
                            }
                        }
                        cosConsultancyTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_HR => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosHRIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosHRINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosHRINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosHRINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosHRINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosHRINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosHRCorporate += summaryObject.Amount;
                            }
                        }
                        cosHRTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_INFRA_IT => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosInfraITIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosInfraITINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosInfraITINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosInfraITINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosInfraITINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosInfraITINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosInfraITCorporate += summaryObject.Amount;
                            }
                        }
                        cosInfraITTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_PARTNER_COMMISSION => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosPartnerCommIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosPartnerCommINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosPartnerCommINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosPartnerCommINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosPartnerCommINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosPartnerCommINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosPartnerCommCorporate += summaryObject.Amount;
                            }
                        }
                        cosPartnerCommTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_PASSTHROUGH_EXP => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosPassthroughExpIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosPassthroughExpINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosPassthroughExpINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosPassthroughExpINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosPassthroughExpINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosPassthroughExpINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosPassthroughExpCorporate += summaryObject.Amount;
                            }
                        }
                        cosPassthroughExpTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_PROGRAMS => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosProgramsIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosProgramsINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosProgramsINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosProgramsINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosProgramsINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosProgramsINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosProgramsCorporate += summaryObject.Amount;
                            }
                        }
                        cosProgramsTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_PUBLIC_CLOUD => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosPublicCloudIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosPublicCloudINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosPublicCloudINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosPublicCloudINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosPublicCloudINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosPublicCloudINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosPublicCloudCorporate += summaryObject.Amount;
                            }
                        }
                        cosPublicCloudTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_RENT_UTILITIES => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosRentNUtilIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosRentNUtilINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosRentNUtilINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosRentNUtilINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosRentNUtilINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosRentNUtilINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosRentNUtilCorporate += summaryObject.Amount;
                            }
                        }
                        cosRentNUtilTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_ROYALTIES => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosRoyaltiesIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosRoyaltiesINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosRoyaltiesINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosRoyaltiesINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosRoyaltiesINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosRoyaltiesINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosRoyaltiesCorporate += summaryObject.Amount;
                            }
                        }
                        cosRoyaltiesTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_SW_SUPPORT => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosSWSupportIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosSWSupportINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosSWSupportINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosSWSupportINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosSWSupportINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosSWSupportINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosSWSupportCorporate += summaryObject.Amount;
                            }
                        }
                        cosSWSupportTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_TRAINING_WELFARE => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosTrainingNWelfareIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosTrainingNWelfareINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosTrainingNWelfareINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosTrainingNWelfareINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosTrainingNWelfareINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosTrainingNWelfareINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosTrainingNWelfareCorporate += summaryObject.Amount;
                            }
                        }
                        cosTrainingNWelfareTotal += summaryObject.Amount;
                    }
                    AC_SUB_CAT_TRAVEL => {
                        match summaryObject.BusinessUnit {
                            BU_IAM => {
                                cosTravelIAM += summaryObject.Amount;
                            }
                            BU_INTEGRATION_SW => {
                                cosTravelINTSW += summaryObject.Amount;
                            }
                            BU_INTEGRATION_CL => {
                                cosTravelINTCL += summaryObject.Amount;
                            }
                            BU_BFSI => {
                                cosTravelINTSW += summaryObject.Amount;
                            }
                            BU_IPAAS => {
                                cosTravelINTSW += summaryObject.Amount;
                            }
                            BU_HEALTHCARE => {
                                cosTravelINTSW += summaryObject.Amount;
                            }
                            BU_CORPORATE => {
                                cosTravelCorporate += summaryObject.Amount;
                            }
                        }
                        cosTravelTotal += summaryObject.Amount;
                    }
                }
            }

        }

        cosTotal += cosBonusTotal + cosConsultancyTotal + cosHRTotal + cosInfraITTotal + cosPartnerCommTotal +
        cosPassthroughExpTotal + cosProgramsTotal + cosPublicCloudTotal + cosRentNUtilTotal +
        cosRoyaltiesTotal + cosSWSupportTotal + cosTrainingNWelfareTotal + cosTravelTotal;

        cosTotalIAM += cosBonusIAM + cosConsultancyIAM + cosHRIAM + cosInfraITIAM + cosPartnerCommIAM +
        cosPassthroughExpIAM + cosProgramsIAM + cosPublicCloudIAM + cosRentNUtilIAM + cosRoyaltiesIAM +
        cosSWSupportIAM + cosTrainingNWelfareIAM + cosTravelIAM;
        cosTotalINTSW += cosBonusINTSW + cosConsultancyINTSW + cosHRINTSW + cosInfraITINTSW +
        cosPartnerCommINTSW + cosPassthroughExpINTSW + cosProgramsINTSW + cosPublicCloudINTSW +
        cosRentNUtilINTSW + cosRoyaltiesINTSW + cosSWSupportINTSW + cosTrainingNWelfareINTSW + cosTravelINTSW;
        cosTotalINTCL += cosBonusINTCL + cosConsultancyINTCL + cosHRINTCL + cosInfraITINTCL +
        cosPartnerCommINTCL + cosPassthroughExpINTCL + cosProgramsINTCL + cosPublicCloudINTCL +
        cosRentNUtilINTCL + cosRoyaltiesINTCL + cosSWSupportINTCL + cosTrainingNWelfareINTCL + cosTravelINTCL;
        cosTotalCorporate += cosBonusCorporate + cosConsultancyCorporate + cosHRCorporate +
        cosInfraITCorporate + cosPartnerCommCorporate + cosPassthroughExpCorporate + cosProgramsCorporate +
        cosPublicCloudCorporate + cosRentNUtilCorporate + cosRoyaltiesCorporate + cosSWSupportCorporate +
        cosTrainingNWelfareCorporate + cosTravelCorporate;

cosRows = check formatArray([
        {
            title: cosSubLevelName,
            integration_cl: cosTotalINTCL,
            integration_sw: cosTotalINTSW,
            iam: cosTotalIAM,
            corporate: cosTotalCorporate,
            wso2: cosTotal
        },
        {
            title: AC_SUB_CAT_BONUS,
            integration_cl: cosBonusINTCL,
            integration_sw: cosBonusINTSW,
            iam: cosBonusIAM,
            corporate: cosBonusCorporate,
            wso2: cosBonusTotal
        },
        {
            title: AC_SUB_CAT_CONSULTANCY,
            integration_cl: cosConsultancyINTCL,
            integration_sw: cosConsultancyINTSW,
            iam: cosConsultancyIAM,
            corporate: cosConsultancyCorporate,
            wso2: cosConsultancyTotal
        },
        {
            title: AC_SUB_CAT_HR,
            integration_cl: cosHRINTCL,
            integration_sw: cosHRINTSW,
            iam: cosHRIAM,
            corporate: cosHRCorporate,
            wso2: cosHRTotal
        },
        {
            title: AC_SUB_CAT_INFRA_IT,
            integration_cl: cosInfraITINTCL,
            integration_sw: cosInfraITINTSW,
            iam: cosInfraITIAM,
            corporate: cosInfraITCorporate,
            wso2: cosInfraITTotal
        },
        {
            title: AC_SUB_CAT_PARTNER_COMMISSION,
            integration_cl: cosPartnerCommINTCL,
            integration_sw: cosPartnerCommINTSW,
            iam: cosPartnerCommIAM,
            corporate: cosPartnerCommCorporate,
            wso2: cosPartnerCommTotal
        },
        {
            title: AC_SUB_CAT_PASSTHROUGH_EXP,
            integration_cl: cosPassthroughExpINTCL,
            integration_sw: cosPassthroughExpINTSW,
            iam: cosPassthroughExpIAM,
            corporate: cosPassthroughExpCorporate,
            wso2: cosPassthroughExpTotal
        },
        {
            title: AC_SUB_CAT_PROGRAMS,
            integration_cl: cosProgramsINTCL,
            integration_sw: cosProgramsINTSW,
            iam: cosProgramsIAM,
            corporate: cosProgramsCorporate,
            wso2: cosProgramsTotal
        },
        {
            title: AC_SUB_CAT_PUBLIC_CLOUD,
            integration_cl: cosPublicCloudINTCL,
            integration_sw: cosPublicCloudINTSW,
            iam: cosPublicCloudIAM,
            corporate: cosPublicCloudCorporate,
            wso2: cosPublicCloudTotal
        },
        {
            title: AC_SUB_CAT_RENT_UTILITIES,
            integration_cl: cosRentNUtilINTCL,
            integration_sw: cosRentNUtilINTSW,
            iam: cosRentNUtilIAM,
            corporate: cosRentNUtilCorporate,
            wso2: cosRentNUtilTotal
        },
        {
            title: AC_SUB_CAT_ROYALTIES,
            integration_cl: cosRoyaltiesINTCL,
            integration_sw: cosRoyaltiesINTSW,
            iam: cosRoyaltiesIAM,
            corporate: cosRoyaltiesCorporate,
            wso2: cosRoyaltiesTotal
        },
        {
            title: AC_SUB_CAT_SW_SUPPORT,
            integration_cl: cosSWSupportINTCL,
            integration_sw: cosSWSupportINTSW,
            iam: cosSWSupportIAM,
            corporate: cosSWSupportCorporate,
            wso2: cosSWSupportTotal
        },
        {
            title: AC_SUB_CAT_TRAINING_WELFARE,
            integration_cl: cosTrainingNWelfareINTCL,
            integration_sw: cosTrainingNWelfareINTSW,
            iam: cosTrainingNWelfareIAM,
            corporate: cosTrainingNWelfareCorporate,
            wso2: cosTrainingNWelfareTotal
        },
        {
            title: AC_SUB_CAT_TRAVEL,
            integration_cl: cosTravelINTCL,
            integration_sw: cosTravelINTSW,
            iam: cosTravelIAM,
            corporate: cosTravelCorporate,
            wso2: cosTravelTotal
        }
]);
 
        return cosRows;

    } else {
        return costOfSales;
    }

}
