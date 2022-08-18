function calculateARRAndBookingsPerBUPerMonth(DatePeriodBuFilterCriteria datePeriodWithBURecord) returns [json[], json[]]|error {
    json[] arrRows = [];
    json[] bookingRows = [];

    decimal newARRBU = 0.00;
    decimal expansionARRBU = 0.00;
    decimal reductionARRBU = 0.00;
    decimal lostARRBU = 0.00;

    decimal openingARRBU = 0.00;
    decimal closingARRBU = 0.00;
    decimal cloudARRBU = 0.00;
    decimal totalExitARRBU = 0.00;

    // Salesforce ARR calculations for a given period, given BU
    // Opening/Closing/Cloud ARR for BU
    json[] resultSFOpeningClosingARR = check getSFARRPerGivenPeriod(datePeriodWithBURecord.period);
    foreach var j in resultSFOpeningClosingARR {
        // j.amount is equal or greater than to each BU ARR amounts, hence this valication is enough to check all ARR amounts
        if (j.amount != null) {
            SalesforceARROpeningClosingRespRecord sfARROpenCloseResp = check j.cloneWithType(SalesforceARROpeningClosingRespRecord);
            if (sfARROpenCloseResp.arr_type == "openingARR") {
                if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
                    openingARRBU += sfARROpenCloseResp.amount;
                } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
                    openingARRBU += sfARROpenCloseResp.amount_iam;
                } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
                    openingARRBU += sfARROpenCloseResp.amount_intsw;
                }
            } else if (sfARROpenCloseResp.arr_type == "closingARR") {
                if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
                    closingARRBU += sfARROpenCloseResp.amount;
                } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
                    closingARRBU += sfARROpenCloseResp.amount_iam;
                } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
                    closingARRBU += sfARROpenCloseResp.amount_intsw;
                }
            } else if (sfARROpenCloseResp.arr_type == "cloudARR") {
                if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
                    cloudARRBU += sfARROpenCloseResp.amount;
                } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
                    cloudARRBU += sfARROpenCloseResp.amount_iam;
                } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
                    cloudARRBU += sfARROpenCloseResp.amount_intsw;
                }
            } else if (sfARROpenCloseResp.arr_type == "openingARRDelayed") {
                if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
                    openingARRBU += sfARROpenCloseResp.amount;
                } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
                    openingARRBU += sfARROpenCloseResp.amount_iam;
                } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
                    openingARRBU += sfARROpenCloseResp.amount_intsw;
                }
            } else if (sfARROpenCloseResp.arr_type == "closingARRDelayed") {
                if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
                    closingARRBU += sfARROpenCloseResp.amount;
                } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
                    closingARRBU += sfARROpenCloseResp.amount_iam;
                } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
                    closingARRBU += sfARROpenCloseResp.amount_intsw;
                }
            }
        }
    }
    totalExitARRBU += cloudARRBU + closingARRBU;

    SFNewExpRedLostValueRecord sfNewExpRedLostValueRecord = check calculateSalesforceARRNewExpRedLost(datePeriodWithBURecord.period);
    if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
        newARRBU = sfNewExpRedLostValueRecord.newARRWSO2;
        expansionARRBU = sfNewExpRedLostValueRecord.expansionARRWSO2;
        reductionARRBU = sfNewExpRedLostValueRecord.reductionARRWSO2;
        lostARRBU = sfNewExpRedLostValueRecord.lostARRWSO2;
    } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
        newARRBU = sfNewExpRedLostValueRecord.newARRIAM;
        expansionARRBU = sfNewExpRedLostValueRecord.expansionARRIAM;
        reductionARRBU = sfNewExpRedLostValueRecord.reductionARRIAM;
        lostARRBU = sfNewExpRedLostValueRecord.lostARRIAM;
    } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
        newARRBU = sfNewExpRedLostValueRecord.newARRIntegration;
        expansionARRBU = sfNewExpRedLostValueRecord.expansionARRIntegration;
        reductionARRBU = sfNewExpRedLostValueRecord.reductionARRIntegration;
        lostARRBU = sfNewExpRedLostValueRecord.lostARRIntegration;
    }

    arrRows.push(
        {
        id: "1",
        title: ARR_OPENING,
        value: openingARRBU
    },
        {
        id: "2",
        title: ARR_NEW,
        value: newARRBU
    },
        {
        id: "3",
        title: ARR_EXPANSION,
        value: expansionARRBU
    },
        {
        id: "4",
        title: ARR_REDUCTION,
        value: reductionARRBU
    },
        {
        id: "5",
        title: ARR_LOST,
        value: lostARRBU
    },
        {
        id: "6",
        title: ARR_CLOSING,
        value: closingARRBU
    },
        {
        id: "7",
        title: ARR_CLOUD,
        value: cloudARRBU
    },
        {
        id: "8",
        title: ARR_TOTAL_EXIT,
        value: totalExitARRBU
    }
    );

    // Salesforce Bookings calculation for a given period, given BU
    json resultSFBookings = check getSFBookingSummariesPerGivenPeriod(datePeriodWithBURecord.period);
    SalesforceBookingSummaryResponseRecord sfBookingResp = check resultSFBookings.cloneWithType(SalesforceBookingSummaryResponseRecord);

    decimal bookingsTotalBU = 0.00;
    decimal bookingsRecurringBU = 0.00;
    decimal bookingsNonRecurring = 0.00;
    decimal bookingsCloud = 0.00;

    if (datePeriodWithBURecord.businessUnit == BU_ALL_WSO2) {
        bookingsTotalBU = sfBookingResp.Bookings_Recurring_Total + sfBookingResp.Bookings_Non_Recurring_Total +
            sfBookingResp.Bookings_Cloud_Total;
        bookingsRecurringBU = sfBookingResp.Bookings_Recurring_Total;
        bookingsNonRecurring = sfBookingResp.Bookings_Non_Recurring_Total;
        bookingsCloud = sfBookingResp.Bookings_Cloud_Total;
    } else if (datePeriodWithBURecord.businessUnit == BU_IAM) {
        bookingsTotalBU = sfBookingResp.Bookings_IAM_Recurring + sfBookingResp.Bookings_IAM_Non_Recurring;
        bookingsRecurringBU = sfBookingResp.Bookings_IAM_Recurring;
        bookingsNonRecurring = sfBookingResp.Bookings_IAM_Non_Recurring;
        bookingsCloud = 0.00;
    } else if (datePeriodWithBURecord.businessUnit == BU_INTEGRATION_SW) {
        // Currently all cloud bookings are under Integration-Software
        bookingsTotalBU = sfBookingResp.Bookings_Integration_Recurring + sfBookingResp.Bookings_Integration_Non_Recurring +
            sfBookingResp.Bookings_Cloud_Total;
        bookingsRecurringBU = sfBookingResp.Bookings_Integration_Recurring;
        bookingsNonRecurring = sfBookingResp.Bookings_Integration_Non_Recurring;
        // Currently all cloud bookings are under Integration-Software
        bookingsCloud = sfBookingResp.Bookings_Cloud_Total;
    }

    bookingRows.push(
        {
        id: "1",
        title: BOOKINGS_HEADING_TITLE,
        value: bookingsTotalBU
    },
        {
        id: "2",
        title: BOOKINGS_RECURRING_TITLE,
        value: bookingsRecurringBU
    },
        {
        id: "3",
        title: BOOKINGS_CLOUD_TITLE,
        value: bookingsCloud
    },
        {
        id: "4",
        title: BOOKINGS_NON_RECURRING_TITLE,
        value: bookingsNonRecurring
    }
    );

    return [arrRows, bookingRows];
}
