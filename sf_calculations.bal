function calculateSalesforceARRAndBookings(DatePeriodFilterCriteria datePeriodRecord) returns [json[], json[]]|error {

    json[] arrRows = [];
    json[] bookingRows = [];

    decimal openingARRTotal = 0.00;
    decimal openingARRIAM = 0.00;
    decimal openingARRIntSW = 0.00;
    decimal closingARRTotal = 0.00;
    decimal closingARRIAM = 0.00;
    decimal closingARRIntSW = 0.00;
    decimal cloudARRTotal = 0.00;
    decimal cloudARRIAM = 0.00;
    decimal cloudARRIntSW = 0.00;
    decimal totalExitARR = 0.00;
    decimal totalExitARRIAM = 0.00;
    decimal totalExitARRIntSW = 0.00;

    // Salesforce ARR calculations for a given period
    // Opening/Closing/Cloud ARR Totals
    json[] resultSFOpeningClosingARR = check getSFARRPerGivenPeriod(datePeriodRecord);
    foreach var j in resultSFOpeningClosingARR {
        if (j.amount != null) {
            SalesforceARROpeningClosingRespRecord sfARROpenCloseResp = check j.cloneWithType(SalesforceARROpeningClosingRespRecord);
            if (sfARROpenCloseResp.arr_type == OPENING_ARR) {
                openingARRTotal += sfARROpenCloseResp.amount;
                openingARRIAM += sfARROpenCloseResp.amount_iam;
                openingARRIntSW += sfARROpenCloseResp.amount_intsw;
            } else if (sfARROpenCloseResp.arr_type == CLOSING_ARR) {
                closingARRTotal += sfARROpenCloseResp.amount;
                closingARRIAM += sfARROpenCloseResp.amount_iam;
                closingARRIntSW += sfARROpenCloseResp.amount_intsw;
            } else if (sfARROpenCloseResp.arr_type == CLOUD_ARR) {
                cloudARRTotal += sfARROpenCloseResp.amount;
                cloudARRIAM += sfARROpenCloseResp.amount_iam;
                cloudARRIntSW += sfARROpenCloseResp.amount_intsw;
            } else if (sfARROpenCloseResp.arr_type == OPENING_ARR_DELAYED) {
                openingARRTotal += sfARROpenCloseResp.amount;
                openingARRIAM += sfARROpenCloseResp.amount_iam;
                openingARRIntSW += sfARROpenCloseResp.amount_intsw;
            } else if (sfARROpenCloseResp.arr_type == CLOSING_ARR_DELAYED) {
                closingARRTotal += sfARROpenCloseResp.amount;
                closingARRIAM += sfARROpenCloseResp.amount_iam;
                closingARRIntSW += sfARROpenCloseResp.amount_intsw;
            }
        }
    }

    totalExitARR += cloudARRTotal + closingARRTotal;
    totalExitARRIAM += cloudARRIAM + closingARRIAM;
    totalExitARRIntSW += cloudARRIntSW + closingARRIntSW;

    SFNewExpRedLostValueRecord sfNewExpRedLostValueRecord = check calculateSalesforceARRNewExpRedLost(datePeriodRecord);

    arrRows = check formatArray([
        {
            title: ARR_OPENING,
            integration_cl: null,
            integration_sw: openingARRIntSW,
            iam: openingARRIAM,
            corporate: null,
            wso2: openingARRTotal
        },
        {
            title: ARR_NEW,
            integration_cl: null,
            integration_sw: sfNewExpRedLostValueRecord.newARRIntegration,
            iam: sfNewExpRedLostValueRecord.newARRIAM,
            corporate: null,
            wso2: sfNewExpRedLostValueRecord.newARRWSO2
        },
        {
            title: ARR_EXPANSION,
            integration_cl: null,
            integration_sw: sfNewExpRedLostValueRecord.expansionARRIntegration,
            iam: sfNewExpRedLostValueRecord.expansionARRIAM,
            corporate: null,
            wso2: sfNewExpRedLostValueRecord.expansionARRWSO2
        },
        {
            title: ARR_REDUCTION,
            integration_cl: null,
            integration_sw: sfNewExpRedLostValueRecord.reductionARRIntegration,
            iam: sfNewExpRedLostValueRecord.reductionARRIAM,
            corporate: null,
            wso2: sfNewExpRedLostValueRecord.reductionARRWSO2
        },
        {
            title: ARR_LOST,
            integration_cl: null,
            integration_sw: sfNewExpRedLostValueRecord.lostARRIntegration,
            iam: sfNewExpRedLostValueRecord.lostARRIAM,
            corporate: null,
            wso2: sfNewExpRedLostValueRecord.lostARRWSO2
        },
        {
            title: ARR_CLOSING,
            integration_cl: null,
            integration_sw: closingARRIntSW,
            iam: closingARRIAM,
            corporate: null,
            wso2: closingARRTotal
        },
        {
            title: ARR_CLOUD,
            integration_cl: null,
            integration_sw: cloudARRIntSW,
            iam: cloudARRIAM,
            corporate: null,
            wso2: cloudARRTotal
        },
        {
            title: ARR_TOTAL_EXIT,
            integration_cl: null,
            integration_sw: totalExitARRIntSW,
            iam: totalExitARRIAM,
            corporate: null,
            wso2: totalExitARR
        }
    ]);

    // Salesforce Bookings calculation for a given period
    json resultSFBookings = check getSFBookingSummariesPerGivenPeriod(datePeriodRecord);
    SalesforceBookingSummaryResponseRecord sfBookingResp = check resultSFBookings.cloneWithType(SalesforceBookingSummaryResponseRecord);
    bookingRows = check formatArray([
        {
            title: BOOKINGS_HEADING_TITLE,
            integration_cl: null,
            // Currently all cloud bookings are under Integration-Software
            integration_sw: sfBookingResp.Bookings_Integration_Recurring +
                        sfBookingResp.Bookings_Integration_Non_Recurring +
                        sfBookingResp.Bookings_Cloud_Total,
            iam: sfBookingResp.Bookings_IAM_Recurring +
                sfBookingResp.Bookings_IAM_Non_Recurring,
            corporate: null,
            wso2: sfBookingResp.Bookings_Recurring_Total +
                sfBookingResp.Bookings_Non_Recurring_Total +
                sfBookingResp.Bookings_Cloud_Total
        },
        {
            title: BOOKINGS_RECURRING_TITLE,
            integration_cl: null,
            integration_sw: sfBookingResp.Bookings_Integration_Recurring,
            iam: sfBookingResp.Bookings_IAM_Recurring,
            corporate: null,
            wso2: sfBookingResp.Bookings_Recurring_Total
        },
        {
            title: BOOKINGS_CLOUD_TITLE,
            integration_cl: null,
            // Currently all cloud bookings are under Integration-Software
            integration_sw: sfBookingResp.Bookings_Cloud_Total,
            iam: null,
            corporate: null,
            wso2: sfBookingResp.Bookings_Cloud_Total
        },
        {
            title: BOOKINGS_NON_RECURRING_TITLE,
            integration_cl: null,
            integration_sw: sfBookingResp.Bookings_Integration_Non_Recurring,
            iam: sfBookingResp.Bookings_IAM_Non_Recurring,
            corporate: null,
            wso2: sfBookingResp.Bookings_Non_Recurring_Total
        }
    ]);

    return [arrRows, bookingRows];
}

function calculateSalesforceARRNewExpRedLost(DatePeriodFilterCriteria datePeriodRecord) returns SFNewExpRedLostValueRecord|error {

    map<json> sfAccountsMap = {};

    decimal newARR = 0.00;
    decimal expansionARR = 0.00;
    decimal reductionARR = 0.00;
    decimal lostARR = 0.00;
    decimal newARRIAM = 0.00;
    decimal expansionARRIAM = 0.00;
    decimal reductionARRIAM = 0.00;
    decimal lostARRIAM = 0.00;
    decimal newARRIntegration = 0.00;
    decimal expansionARRIntegration = 0.00;
    decimal reductionARRIntegration = 0.00;
    decimal lostARRIntegration = 0.00;

    // 1. Create Accounts Map with ARR parameters
    json[] resultSFAccounts = check getSFAccountsWithFilter(datePeriodRecord);
    foreach var j in resultSFAccounts {
        SFAccountsRespRecord sfAccountsRespRecord = check j.cloneWithType(SFAccountsRespRecord);
        sfAccountsMap[sfAccountsRespRecord.Id] = {
            IsRenewalDelayed: 0,
            arrAmountPrevious: 0.00,
            arrAmountThis: 0.00,
            arrAmountPreviousIAM: 0.00,
            arrAmountThisIAM: 0.00,
            arrAmountPreviousIntegration: 0.00,
            arrAmountThisIntegration: 0.00
        };
    }

    // 2. Loop list of opportunities for a given criteria and update Accounts Map with relevant ARR values
    json[] resultsSFOpportunities = check getSFOpportunitiesWithFilter(datePeriodRecord, "getOpportunities");
    foreach var k in resultsSFOpportunities {
        SFOpportunityRespRecord sfOpportunityRespRecord = check k.cloneWithType(SFOpportunityRespRecord);
        if (sfAccountsMap[sfOpportunityRespRecord.AccountId] != ()) {
            SFAccountsMapRecord sfAccountsMapRecord = check sfAccountsMap[sfOpportunityRespRecord.AccountId].cloneWithType(SFAccountsMapRecord);
            if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c != () &&
                sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c != ()) {

                if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c.toString() <= datePeriodRecord.startDate &&
                    sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c.toString() >= datePeriodRecord.startDate) {
                    if (sfOpportunityRespRecord.ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountPrevious += sfOpportunityRespRecord.ARR__c;
                    }
                    if (sfOpportunityRespRecord.IAM_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountPreviousIAM += sfOpportunityRespRecord.IAM_ARR__c;
                    }
                    if (sfOpportunityRespRecord.Integration_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountPreviousIntegration += sfOpportunityRespRecord.Integration_ARR__c;
                    }
                }
                if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c.toString() <= datePeriodRecord.endDate &&
                    sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c.toString() >= datePeriodRecord.endDate) {
                    if (sfOpportunityRespRecord.ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountThis += sfOpportunityRespRecord.ARR__c;
                    }
                    if (sfOpportunityRespRecord.IAM_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountThisIAM += sfOpportunityRespRecord.IAM_ARR__c;
                    }
                    if (sfOpportunityRespRecord.Integration_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountThisIntegration += sfOpportunityRespRecord.Integration_ARR__c;
                    }
                }
            }
            sfAccountsMap[sfOpportunityRespRecord.AccountId] = sfAccountsMapRecord.toJson();
        }
    }

    // 3. Loop list of DELAYED opportunities for a given criteria and update Accounts Map with relevant ARR values
    json[] resultsSFDelayedOpportunities = check getSFOpportunitiesWithFilter(datePeriodRecord, "getOpportunitiesDelayed");
    foreach var k in resultsSFDelayedOpportunities {
        SFDelayedOpportunityRespRecord sfOpportunityRespRecord = check k.cloneWithType(SFDelayedOpportunityRespRecord);
        if (sfAccountsMap[sfOpportunityRespRecord.AccountId] != ()) {
            SFAccountsMapRecord sfAccountsMapRecord = check sfAccountsMap[sfOpportunityRespRecord.AccountId].cloneWithType(SFAccountsMapRecord);
            if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c != () &&
                sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c != ()) {

                if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c.toString() <= datePeriodRecord.startDate &&
                    sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c.toString() >= datePeriodRecord.startDate) {
                    sfAccountsMapRecord.IsRenewalDelayed = 1;
                    if (sfOpportunityRespRecord.Delayed_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountPrevious += sfOpportunityRespRecord.Delayed_ARR__c;
                    }
                    if (sfOpportunityRespRecord.IAM_Delayed_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountPreviousIAM += sfOpportunityRespRecord.IAM_Delayed_ARR__c;
                    }
                    if (sfOpportunityRespRecord.Integration_Delayed__c > 0d) {
                        sfAccountsMapRecord.arrAmountPreviousIntegration += sfOpportunityRespRecord.Integration_Delayed__c;
                    }
                }
                if (sfOpportunityRespRecord.PS_Support_Account_Start_Date_Roll_Up__c.toString() <= datePeriodRecord.endDate &&
                    sfOpportunityRespRecord.PS_Support_Account_End_Date_Roll_Up__c.toString() >= datePeriodRecord.endDate) {
                    sfAccountsMapRecord.IsRenewalDelayed = 1;
                    if (sfOpportunityRespRecord.Delayed_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountThis += sfOpportunityRespRecord.Delayed_ARR__c;
                    }
                    if (sfOpportunityRespRecord.IAM_Delayed_ARR__c > 0d) {
                        sfAccountsMapRecord.arrAmountThisIAM += sfOpportunityRespRecord.IAM_Delayed_ARR__c;
                    }
                    if (sfOpportunityRespRecord.Integration_Delayed__c > 0d) {
                        sfAccountsMapRecord.arrAmountThisIntegration += sfOpportunityRespRecord.Integration_Delayed__c;
                    }
                }
            }
            sfAccountsMap[sfOpportunityRespRecord.AccountId] = sfAccountsMapRecord.toJson();
        }
    }

    // 4. Compute ARR -> New, Expansion, Reduction and Lost values based on the updated Accounts Map ARR parameters
    sfAccountsMap.forEach(function(json value) {

        SFAccountsMapRecord|error sfAccountsMapRecord = value.cloneWithType(SFAccountsMapRecord);
        if (sfAccountsMapRecord is SFAccountsMapRecord) {

            // WSO2 ARR computation for New, Expansion, Reduction and Lost
            if (sfAccountsMapRecord.arrAmountPrevious == 0d && sfAccountsMapRecord.arrAmountThis > 0d) {
                newARR += sfAccountsMapRecord.arrAmountThis;
            } else if (sfAccountsMapRecord.arrAmountPrevious > 0d && sfAccountsMapRecord.arrAmountThis == 0d) {
                lostARR += sfAccountsMapRecord.arrAmountPrevious;
            } else if (sfAccountsMapRecord.arrAmountPrevious > 0d && sfAccountsMapRecord.arrAmountThis > 0d) {
                if (sfAccountsMapRecord.arrAmountPrevious > sfAccountsMapRecord.arrAmountThis) {
                    reductionARR += sfAccountsMapRecord.arrAmountPrevious - sfAccountsMapRecord.arrAmountThis;
                } else if (sfAccountsMapRecord.arrAmountPrevious < sfAccountsMapRecord.arrAmountThis) {
                    expansionARR += sfAccountsMapRecord.arrAmountThis - sfAccountsMapRecord.arrAmountPrevious;
                }
            }

            // IAM ARR computation for New, Expansion, Reduction and Lost
            if (sfAccountsMapRecord.arrAmountPreviousIAM == 0d && sfAccountsMapRecord.arrAmountThisIAM > 0d) {
                newARRIAM += sfAccountsMapRecord.arrAmountThisIAM;
            } else if (sfAccountsMapRecord.arrAmountPreviousIAM > 0d && sfAccountsMapRecord.arrAmountThisIAM == 0d) {
                lostARRIAM += sfAccountsMapRecord.arrAmountPreviousIAM;
            } else if (sfAccountsMapRecord.arrAmountPreviousIAM > 0d && sfAccountsMapRecord.arrAmountThisIAM > 0d) {
                if (sfAccountsMapRecord.arrAmountPreviousIAM > sfAccountsMapRecord.arrAmountThisIAM) {
                    reductionARRIAM += sfAccountsMapRecord.arrAmountPreviousIAM - sfAccountsMapRecord.arrAmountThisIAM;
                } else if (sfAccountsMapRecord.arrAmountPreviousIAM < sfAccountsMapRecord.arrAmountThisIAM) {
                    expansionARRIAM += sfAccountsMapRecord.arrAmountThisIAM - sfAccountsMapRecord.arrAmountPreviousIAM;
                }
            }

            // Integration ARR computation for New, Expansion, Reduction and Lost
            if (sfAccountsMapRecord.arrAmountPreviousIntegration == 0d && sfAccountsMapRecord.arrAmountThisIntegration > 0d) {
                newARRIntegration += sfAccountsMapRecord.arrAmountThisIntegration;
            } else if (sfAccountsMapRecord.arrAmountPreviousIntegration > 0d && sfAccountsMapRecord.arrAmountThisIntegration == 0d) {
                lostARRIntegration += sfAccountsMapRecord.arrAmountPreviousIntegration;
            } else if (sfAccountsMapRecord.arrAmountPreviousIntegration > 0d && sfAccountsMapRecord.arrAmountThisIntegration > 0d) {
                if (sfAccountsMapRecord.arrAmountPreviousIntegration > sfAccountsMapRecord.arrAmountThisIntegration) {
                    reductionARRIntegration += sfAccountsMapRecord.arrAmountPreviousIntegration - sfAccountsMapRecord.arrAmountThisIntegration;
                } else if (sfAccountsMapRecord.arrAmountPreviousIntegration < sfAccountsMapRecord.arrAmountThisIntegration) {
                    expansionARRIntegration += sfAccountsMapRecord.arrAmountThisIntegration - sfAccountsMapRecord.arrAmountPreviousIntegration;
                }
            }

        }

    });
    return {
        newARRWSO2: newARR,
        expansionARRWSO2: expansionARR,
        reductionARRWSO2: reductionARR,
        lostARRWSO2: lostARR,
        newARRIAM: newARRIAM,
        expansionARRIAM: expansionARRIAM,
        reductionARRIAM: reductionARRIAM,
        lostARRIAM: lostARRIAM,
        newARRIntegration: newARRIntegration,
        expansionARRIntegration: expansionARRIntegration,
        reductionARRIntegration: reductionARRIntegration,
        lostARRIntegration: lostARRIntegration
    };

}

