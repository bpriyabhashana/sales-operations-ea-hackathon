// import ballerina/io;

function getRevenueSummary(json revenue) returns json|error {

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

    foreach var item in <json[]>revenue {

        IncomeExpenseSummaryRecord summaryObject = check item.cloneWithType(IncomeExpenseSummaryRecord);

        if (summaryObject.AccountCategory == REVENUE_RECURRING) {
            revenueRecurringTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                revenueTotalIAM += summaryObject.Amount;
                revenueRecurringTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                revenueTotalINTSW += summaryObject.Amount;
                revenueRecurringTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                revenueTotalINTCL += summaryObject.Amount;
                revenueRecurringTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                revenueTotalCorporate += summaryObject.Amount;
                revenueRecurringTotalCorporate += summaryObject.Amount;
            }
        } else if (summaryObject.AccountCategory == REVENUE_NON_RECURRING) {
            revenueNonRecurringTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                revenueTotalIAM += summaryObject.Amount;
                revenueNonRecurringTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                revenueTotalINTSW += summaryObject.Amount;
                revenueNonRecurringTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                revenueTotalINTCL += summaryObject.Amount;
                revenueNonRecurringTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                revenueTotalCorporate += summaryObject.Amount;
                revenueNonRecurringTotalCorporate += summaryObject.Amount;
            }
        } else if (summaryObject.AccountCategory == REVENUE_CLOUD) {
            revenueCloudTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                revenueTotalIAM += summaryObject.Amount;
                revenueCloudTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                revenueTotalINTSW += summaryObject.Amount;
                revenueCloudTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                revenueTotalINTCL += summaryObject.Amount;
                revenueCloudTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                revenueTotalCorporate += summaryObject.Amount;
                revenueCloudTotalCorporate += summaryObject.Amount;
            }
        }
    }

    revenueTotalIAM = revenueRecurringTotalIAM + revenueNonRecurringTotalIAM + revenueCloudTotalIAM;
    revenueTotalINTSW = revenueRecurringTotalINTSW + revenueNonRecurringTotalINTSW + revenueCloudTotalINTSW;
    revenueTotalINTCL = revenueRecurringTotalINTCL + revenueNonRecurringTotalINTCL + revenueCloudTotalINTCL;
    revenueTotalCorporate = revenueRecurringTotalCorporate + revenueNonRecurringTotalCorporate + revenueCloudTotalCorporate;

    revenueTotal = revenueRecurringTotal + revenueNonRecurringTotal + revenueCloudTotal;

    revenueRows.push(
        {
        id: "1",
        title: REVENUE_HEADING_TITLE,
        integration_cl: revenueTotalINTCL,
        integration_sw: revenueTotalINTSW,
        iam: revenueTotalIAM,
        corporate: revenueTotalCorporate,
        wso2: revenueTotal
    },
        {
        id: "2",
        title: REVENUE_RECURRING_TITLE,
        integration_cl: revenueRecurringTotalINTCL,
        integration_sw: revenueRecurringTotalINTSW,
        iam: revenueRecurringTotalIAM,
        corporate: revenueRecurringTotalCorporate,
        wso2: revenueRecurringTotal
    },
        {
        id: "3",
        title: REVENUE_NON_RECURRING_TITLE,
        integration_cl: revenueNonRecurringTotalINTCL,
        integration_sw: revenueNonRecurringTotalINTSW,
        iam: revenueNonRecurringTotalIAM,
        corporate: revenueNonRecurringTotalCorporate,
        wso2: revenueNonRecurringTotal
    },
        {
        id: "4",
        title: REVENUE_CLOUD_TITLE,
        integration_cl: revenueCloudTotalINTCL,
        integration_sw: revenueCloudTotalINTSW,
        iam: revenueCloudTotalIAM,
        corporate: revenueCloudTotalCorporate,
        wso2: revenueCloudTotal
    }
    );

    gpRows.push(
        {
        id: "1",
        title: GP_HEADING_TITLE,
        integration_cl: revenueTotalINTCL - costOfSalesTotalINTCL,
        integration_sw: revenueTotalINTSW - costOfSalesTotalINTSW,
        iam: revenueTotalIAM - costOfSalesTotalIAM,
        corporate: revenueTotalCorporate - costOfSalesTotalCorporate,
        wso2: revenueTotal - costOfSalesTotal
    },
        {
        id: "2",
        title: GP_RECURRING_TITLE,
        integration_cl: revenueRecurringTotalINTCL - cosRecurringTotalINTCL,
        integration_sw: revenueRecurringTotalINTSW - cosRecurringTotalINTSW,
        iam: revenueRecurringTotalIAM - cosRecurringTotalIAM,
        corporate: revenueRecurringTotalCorporate - cosRecurringTotalCorporate,
        wso2: revenueRecurringTotal - cosRecurringTotal
    },
        {
        id: "3",
        title: GP_NON_RECURRING_TITLE,
        integration_cl: revenueNonRecurringTotalINTCL - cosNonRecurringTotalINTCL,
        integration_sw: revenueNonRecurringTotalINTSW - cosNonRecurringTotalINTSW,
        iam: revenueNonRecurringTotalIAM - cosNonRecurringTotalIAM,
        corporate: revenueNonRecurringTotalCorporate - cosNonRecurringTotalCorporate,
        wso2: revenueNonRecurringTotal - cosNonRecurringTotal
    },
        {
        id: "4",
        title: GP_PUBLIC_CLOUD_TITLE,
        integration_cl: revenueCloudTotalINTCL - cosCloudTotalINTCL,
        integration_sw: revenueCloudTotalINTSW - cosCloudTotalINTSW,
        iam: revenueCloudTotalIAM - cosCloudTotalIAM,
        corporate: revenueCloudTotalCorporate - cosCloudTotalCorporate,
        wso2: revenueCloudTotal - cosCloudTotal
    }
    );

    gmRows.push(
        {
        id: "1",
        title: GM_HEADING_TITLE,
        integration_cl: calculateGrossMargin(revenueTotalINTCL, costOfSalesTotalINTCL),
        integration_sw: calculateGrossMargin(revenueTotalINTSW, costOfSalesTotalINTSW),
        iam: calculateGrossMargin(revenueTotalIAM, costOfSalesTotalIAM),
        corporate: calculateGrossMargin(revenueTotalCorporate, costOfSalesTotalCorporate),
        wso2: calculateGrossMargin(revenueTotal, costOfSalesTotal)
    },
        {
        id: "2",
        title: GM_RECURRING_TITLE,
        integration_cl: calculateGrossMargin(revenueRecurringTotalINTCL, cosRecurringTotalINTCL),
        integration_sw: calculateGrossMargin(revenueRecurringTotalINTSW, cosRecurringTotalINTSW),
        iam: calculateGrossMargin(revenueRecurringTotalIAM, cosRecurringTotalIAM),
        corporate: calculateGrossMargin(revenueRecurringTotalCorporate, cosRecurringTotalCorporate),
        wso2: calculateGrossMargin(revenueRecurringTotal, cosRecurringTotal)
    },
        {
        id: "3",
        title: GM_NON_RECURRING_TITLE,
        integration_cl: calculateGrossMargin(revenueNonRecurringTotalINTCL, cosNonRecurringTotalINTCL),
        integration_sw: calculateGrossMargin(revenueNonRecurringTotalINTSW, cosNonRecurringTotalINTSW),
        iam: calculateGrossMargin(revenueNonRecurringTotalIAM, cosNonRecurringTotalIAM),
        corporate: calculateGrossMargin(revenueNonRecurringTotalCorporate, cosNonRecurringTotalCorporate),
        wso2: calculateGrossMargin(revenueNonRecurringTotal, cosNonRecurringTotal)
    },
        {
        id: "4",
        title: GM_PUBLIC_CLOUD_TITLE,
        integration_cl: calculateGrossMargin(revenueCloudTotalINTCL, cosCloudTotalINTCL),
        integration_sw: calculateGrossMargin(revenueCloudTotalINTSW, cosCloudTotalINTSW),
        iam: calculateGrossMargin(revenueCloudTotalIAM, cosCloudTotalIAM),
        corporate: calculateGrossMargin(revenueCloudTotalCorporate, cosCloudTotalCorporate),
        wso2: calculateGrossMargin(revenueCloudTotal, cosCloudTotal)
    }
    );

    return {revenue: revenueRows, grossProfit: gpRows, grossMargin: gmRows};

}
