isolated function calculateBalance(json income, json expense) returns [json[], json[], json[], json[]]|error {

    json[] cosRows = [];
    json[] revenueRows = [];
    json[] gpRows = [];
    json[] gmRows = [];

    decimal revenueTotal = 0.00;
    decimal revenueTotalIAM = 0.00;
    decimal revenueTotalINTSW = 0.00;
    decimal revenueTotalINTCL = 0.00;
    decimal revenueTotalCorporate = 0.00;
    decimal revenueCloudTotal = 0.00;
    decimal revenueCloudTotalIAM = 0.00;
    decimal revenueCloudTotalINTSW = 0.00;
    decimal revenueCloudTotalINTCL = 0.00;
    decimal revenueCloudTotalCorporate = 0.00;
    decimal revenueRecurringTotal = 0.00;
    decimal revenueRecurringTotalIAM = 0.00;
    decimal revenueRecurringTotalINTSW = 0.00;
    decimal revenueRecurringTotalINTCL = 0.00;
    decimal revenueRecurringTotalCorporate = 0.00;
    decimal revenueNonRecurringTotal = 0.00;
    decimal revenueNonRecurringTotalIAM = 0.00;
    decimal revenueNonRecurringTotalINTSW = 0.00;
    decimal revenueNonRecurringTotalINTCL = 0.00;
    decimal revenueNonRecurringTotalCorporate = 0.00;

    decimal costOfSalesTotal = 0.00;
    decimal costOfSalesTotalIAM = 0.00;
    decimal costOfSalesTotalINTSW = 0.00;
    decimal costOfSalesTotalINTCL = 0.00;
    decimal costOfSalesTotalCorporate = 0.00;
    decimal cosCloudTotal = 0.00;
    decimal cosCloudTotalIAM = 0.00;
    decimal cosCloudTotalINTSW = 0.00;
    decimal cosCloudTotalINTCL = 0.00;
    decimal cosCloudTotalCorporate = 0.00;
    decimal cosRecurringTotal = 0.00;
    decimal cosRecurringTotalIAM = 0.00;
    decimal cosRecurringTotalINTSW = 0.00;
    decimal cosRecurringTotalINTCL = 0.00;
    decimal cosRecurringTotalCorporate = 0.00;
    decimal cosNonRecurringTotal = 0.00;
    decimal cosNonRecurringTotalIAM = 0.00;
    decimal cosNonRecurringTotalINTSW = 0.00;
    decimal cosNonRecurringTotalINTCL = 0.00;
    decimal cosNonRecurringTotalCorporate = 0.00;

    foreach var item in <json[]>expense {
        SumOfExpenseAccountData summaryObject = check item.cloneWithType(SumOfExpenseAccountData);

        match summaryObject.accountCategory {
            COS_RECURRING_REVENUE => {
                cosRecurringTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    cosRecurringTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    cosRecurringTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    cosRecurringTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    cosRecurringTotalCorporate += summaryObject.balance;
                }
            }
            COS_NON_RECURRING_REVENUE => {
                cosNonRecurringTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    cosNonRecurringTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    cosNonRecurringTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    cosNonRecurringTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    cosNonRecurringTotalCorporate += summaryObject.balance;
                }
            }
            COS_CLOUD => {
                cosCloudTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    cosCloudTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    cosCloudTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    cosCloudTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    cosCloudTotalCorporate += summaryObject.balance;
                }
            }
        }
    }

    costOfSalesTotalIAM = cosRecurringTotalIAM + cosNonRecurringTotalIAM + cosCloudTotalIAM;
    costOfSalesTotalINTSW = cosRecurringTotalINTSW + cosNonRecurringTotalINTSW + cosCloudTotalINTSW;
    costOfSalesTotalINTCL = cosRecurringTotalINTCL + cosNonRecurringTotalINTCL + cosCloudTotalINTCL;
    costOfSalesTotalCorporate = cosRecurringTotalCorporate + cosNonRecurringTotalCorporate + cosCloudTotalCorporate;

    costOfSalesTotal = cosRecurringTotal + cosNonRecurringTotal + cosCloudTotal;

    cosRows = check formatArray([
        {
            title: COS_HEADING_TITLE,
            integration_cl: costOfSalesTotalINTCL,
            integration_sw: costOfSalesTotalINTSW,
            iam: costOfSalesTotalIAM,
            corporate: costOfSalesTotalCorporate,
            wso2: costOfSalesTotal
        },
        {
            title: COS_RECURRING_TITLE,
            integration_cl: cosRecurringTotalINTCL,
            integration_sw: cosRecurringTotalINTSW,
            iam: cosRecurringTotalIAM,
            corporate: cosRecurringTotalCorporate,
            wso2: cosRecurringTotal
        },
        {
            title: COS_NON_RECURRING_TITLE,
            integration_cl: cosNonRecurringTotalINTCL,
            integration_sw: cosNonRecurringTotalINTSW,
            iam: cosNonRecurringTotalIAM,
            corporate: cosNonRecurringTotalCorporate,
            wso2: cosNonRecurringTotal
        },
        {
            title: COS_PUBLIC_CLOUD_TITLE,
            integration_cl: cosCloudTotalINTCL,
            integration_sw: cosCloudTotalINTSW,
            iam: cosCloudTotalIAM,
            corporate: cosCloudTotalCorporate,
            wso2: cosCloudTotal
        }
    ]);

    foreach var item in <json[]>income {

        SumOfIncomeAccountData summaryObject = check item.cloneWithType(SumOfIncomeAccountData);

        match summaryObject.accountCategory {
            REVENUE_RECURRING => {
                revenueRecurringTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    revenueTotalIAM += summaryObject.balance;
                    revenueRecurringTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    revenueTotalINTSW += summaryObject.balance;
                    revenueRecurringTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    revenueTotalINTCL += summaryObject.balance;
                    revenueRecurringTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    revenueTotalCorporate += summaryObject.balance;
                    revenueRecurringTotalCorporate += summaryObject.balance;
                }
            }
            REVENUE_NON_RECURRING => {
                revenueNonRecurringTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    revenueTotalIAM += summaryObject.balance;
                    revenueNonRecurringTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    revenueTotalINTSW += summaryObject.balance;
                    revenueNonRecurringTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    revenueTotalINTCL += summaryObject.balance;
                    revenueNonRecurringTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    revenueTotalCorporate += summaryObject.balance;
                    revenueNonRecurringTotalCorporate += summaryObject.balance;
                }
            }
            REVENUE_CLOUD => {
                revenueCloudTotal += summaryObject.balance;
                if summaryObject.businessUnit == BU_IAM {
                    revenueTotalIAM += summaryObject.balance;
                    revenueCloudTotalIAM += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_SW || summaryObject.businessUnit == BU_BFSI ||
                    summaryObject.businessUnit == BU_IPAAS || summaryObject.businessUnit == BU_HEALTHCARE {
                    revenueTotalINTSW += summaryObject.balance;
                    revenueCloudTotalINTSW += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_INTEGRATION_CL {
                    revenueTotalINTCL += summaryObject.balance;
                    revenueCloudTotalINTCL += summaryObject.balance;
                } else if summaryObject.businessUnit == BU_CORPORATE {
                    revenueTotalCorporate += summaryObject.balance;
                    revenueCloudTotalCorporate += summaryObject.balance;
                }
            }
        }
    }

    revenueTotalIAM = revenueRecurringTotalIAM + revenueNonRecurringTotalIAM + revenueCloudTotalIAM;
    revenueTotalINTSW = revenueRecurringTotalINTSW + revenueNonRecurringTotalINTSW + revenueCloudTotalINTSW;
    revenueTotalINTCL = revenueRecurringTotalINTCL + revenueNonRecurringTotalINTCL + revenueCloudTotalINTCL;
    revenueTotalCorporate = revenueRecurringTotalCorporate + revenueNonRecurringTotalCorporate + revenueCloudTotalCorporate;

    revenueTotal = revenueRecurringTotal + revenueNonRecurringTotal + revenueCloudTotal;

    revenueRows = check formatArray(
        [
        {
            title: REVENUE_HEADING_TITLE,
            integration_cl: revenueTotalINTCL,
            integration_sw: revenueTotalINTSW,
            iam: revenueTotalIAM,
            corporate: revenueTotalCorporate,
            wso2: revenueTotal
        },
        {
            title: REVENUE_RECURRING_TITLE,
            integration_cl: revenueRecurringTotalINTCL,
            integration_sw: revenueRecurringTotalINTSW,
            iam: revenueRecurringTotalIAM,
            corporate: revenueRecurringTotalCorporate,
            wso2: revenueRecurringTotal
        },
        {
            title: REVENUE_NON_RECURRING_TITLE,
            integration_cl: revenueNonRecurringTotalINTCL,
            integration_sw: revenueNonRecurringTotalINTSW,
            iam: revenueNonRecurringTotalIAM,
            corporate: revenueNonRecurringTotalCorporate,
            wso2: revenueNonRecurringTotal
        },
        {
            title: REVENUE_CLOUD_TITLE,
            integration_cl: revenueCloudTotalINTCL,
            integration_sw: revenueCloudTotalINTSW,
            iam: revenueCloudTotalIAM,
            corporate: revenueCloudTotalCorporate,
            wso2: revenueCloudTotal
        }
    ]
    );

    gpRows = check formatArray([
        {
            title: GP_HEADING_TITLE,
            integration_cl: revenueTotalINTCL - costOfSalesTotalINTCL,
            integration_sw: revenueTotalINTSW - costOfSalesTotalINTSW,
            iam: revenueTotalIAM - costOfSalesTotalIAM,
            corporate: revenueTotalCorporate - costOfSalesTotalCorporate,
            wso2: revenueTotal - costOfSalesTotal
        },
        {
            title: GP_RECURRING_TITLE,
            integration_cl: revenueRecurringTotalINTCL - cosRecurringTotalINTCL,
            integration_sw: revenueRecurringTotalINTSW - cosRecurringTotalINTSW,
            iam: revenueRecurringTotalIAM - cosRecurringTotalIAM,
            corporate: revenueRecurringTotalCorporate - cosRecurringTotalCorporate,
            wso2: revenueRecurringTotal - cosRecurringTotal
        },
        {
            title: GP_NON_RECURRING_TITLE,
            integration_cl: revenueNonRecurringTotalINTCL - cosNonRecurringTotalINTCL,
            integration_sw: revenueNonRecurringTotalINTSW - cosNonRecurringTotalINTSW,
            iam: revenueNonRecurringTotalIAM - cosNonRecurringTotalIAM,
            corporate: revenueNonRecurringTotalCorporate - cosNonRecurringTotalCorporate,
            wso2: revenueNonRecurringTotal - cosNonRecurringTotal
        },
        {
            title: GP_PUBLIC_CLOUD_TITLE,
            integration_cl: revenueCloudTotalINTCL - cosCloudTotalINTCL,
            integration_sw: revenueCloudTotalINTSW - cosCloudTotalINTSW,
            iam: revenueCloudTotalIAM - cosCloudTotalIAM,
            corporate: revenueCloudTotalCorporate - cosCloudTotalCorporate,
            wso2: revenueCloudTotal - cosCloudTotal
        }
    ]);

    gmRows = check formatArray([
        {
            title: GM_HEADING_TITLE,
            integration_cl: calculateGrossMargin(revenueTotalINTCL, costOfSalesTotalINTCL),
            integration_sw: calculateGrossMargin(revenueTotalINTSW, costOfSalesTotalINTSW),
            iam: calculateGrossMargin(revenueTotalIAM, costOfSalesTotalIAM),
            corporate: calculateGrossMargin(revenueTotalCorporate, costOfSalesTotalCorporate),
            wso2: calculateGrossMargin(revenueTotal, costOfSalesTotal)
        },
        {
            title: GM_RECURRING_TITLE,
            integration_cl: calculateGrossMargin(revenueRecurringTotalINTCL, cosRecurringTotalINTCL),
            integration_sw: calculateGrossMargin(revenueRecurringTotalINTSW, cosRecurringTotalINTSW),
            iam: calculateGrossMargin(revenueRecurringTotalIAM, cosRecurringTotalIAM),
            corporate: calculateGrossMargin(revenueRecurringTotalCorporate, cosRecurringTotalCorporate),
            wso2: calculateGrossMargin(revenueRecurringTotal, cosRecurringTotal)
        },
        {
            title: GM_NON_RECURRING_TITLE,
            integration_cl: calculateGrossMargin(revenueNonRecurringTotalINTCL, cosNonRecurringTotalINTCL),
            integration_sw: calculateGrossMargin(revenueNonRecurringTotalINTSW, cosNonRecurringTotalINTSW),
            iam: calculateGrossMargin(revenueNonRecurringTotalIAM, cosNonRecurringTotalIAM),
            corporate: calculateGrossMargin(revenueNonRecurringTotalCorporate, cosNonRecurringTotalCorporate),
            wso2: calculateGrossMargin(revenueNonRecurringTotal, cosNonRecurringTotal)
        },
        {
            title: GM_PUBLIC_CLOUD_TITLE,
            integration_cl: calculateGrossMargin(revenueCloudTotalINTCL, cosCloudTotalINTCL),
            integration_sw: calculateGrossMargin(revenueCloudTotalINTSW, cosCloudTotalINTSW),
            iam: calculateGrossMargin(revenueCloudTotalIAM, cosCloudTotalIAM),
            corporate: calculateGrossMargin(revenueCloudTotalCorporate, cosCloudTotalCorporate),
            wso2: calculateGrossMargin(revenueCloudTotal, cosCloudTotal)
        }
    ]);

    return [revenueRows, cosRows, gpRows, gmRows];

}

