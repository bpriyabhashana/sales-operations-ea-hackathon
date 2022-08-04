

function getSummary(json revenue, json cos) returns json|error {

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

    foreach var item in <json[]>cos {
        IncomeExpenseSummaryRecord summaryObject = check item.cloneWithType(IncomeExpenseSummaryRecord);

        if (summaryObject.AccountCategory == COS_RECURRING_REVENUE) {
            cosRecurringTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                cosRecurringTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                cosRecurringTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                cosRecurringTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                cosRecurringTotalCorporate += summaryObject.Amount;
            }
        } else if (summaryObject.AccountCategory == COS_NON_RECURRING_REVENUE) {
            cosNonRecurringTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                cosNonRecurringTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                cosNonRecurringTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                cosNonRecurringTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                cosNonRecurringTotalCorporate += summaryObject.Amount;
            }
        } else if (summaryObject.AccountCategory == COS_CLOUD) {
            cosCloudTotal += summaryObject.Amount;
            if (summaryObject.BusinessUnit == BU_IAM) {
                cosCloudTotalIAM += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_SW || summaryObject.BusinessUnit == BU_BFSI ||
                summaryObject.BusinessUnit == BU_IPAAS || summaryObject.BusinessUnit == BU_HEALTHCARE) {
                cosCloudTotalINTSW += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_INTEGRATION_CL) {
                cosCloudTotalINTCL += summaryObject.Amount;
            } else if (summaryObject.BusinessUnit == BU_CORPORATE) {
                cosCloudTotalCorporate += summaryObject.Amount;
            }
        }

    }

    costOfSalesTotalIAM = cosRecurringTotalIAM + cosNonRecurringTotalIAM + cosCloudTotalIAM;
    costOfSalesTotalINTSW = cosRecurringTotalINTSW + cosNonRecurringTotalINTSW + cosCloudTotalINTSW;
    costOfSalesTotalINTCL = cosRecurringTotalINTCL + cosNonRecurringTotalINTCL + cosCloudTotalINTCL;
    costOfSalesTotalCorporate = cosRecurringTotalCorporate + cosNonRecurringTotalCorporate + cosCloudTotalCorporate;

    costOfSalesTotal = cosRecurringTotal + cosNonRecurringTotal + cosCloudTotal;

    cosRows.push(
        {
        id: "1",
        title: COS_HEADING_TITLE,
        integration_cl: costOfSalesTotalINTCL,
        integration_sw: costOfSalesTotalINTSW,
        iam: costOfSalesTotalIAM,
        corporate: costOfSalesTotalCorporate,
        wso2: costOfSalesTotal
    },
        {
        id: "2",
        title: COS_RECURRING_TITLE,
        integration_cl: cosRecurringTotalINTCL,
        integration_sw: cosRecurringTotalINTSW,
        iam: cosRecurringTotalIAM,
        corporate: cosRecurringTotalCorporate,
        wso2: cosRecurringTotal
    },
        {
        id: "3",
        title: COS_NON_RECURRING_TITLE,
        integration_cl: cosNonRecurringTotalINTCL,
        integration_sw: cosNonRecurringTotalINTSW,
        iam: cosNonRecurringTotalIAM,
        corporate: cosNonRecurringTotalCorporate,
        wso2: cosNonRecurringTotal
    },
        {
        id: "4",
        title: COS_PUBLIC_CLOUD_TITLE,
        integration_cl: cosCloudTotalINTCL,
        integration_sw: cosCloudTotalINTSW,
        iam: cosCloudTotalIAM,
        corporate: cosCloudTotalCorporate,
        wso2: cosCloudTotal
    }
    );

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

    return {Revenue: revenueRows, CostOfSales: cosRows, GrossProfit: gpRows, GrossMargin: gmRows};

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
