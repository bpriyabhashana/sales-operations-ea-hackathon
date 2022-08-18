import ballerina/http;

function getBalanceStatement(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json summary = {};
    json[] arrRows = [];
    json[] bookingRows = [];
    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];

    do {
        [revenueRows, cosRows, gpRows, gmRows] = check calculateBalance(check getSumOfIncomeAccounts(payload), check getSumOfExpenseAccounts(payload));

        [arrRows, bookingRows] = check calculateSalesforceARRAndBookings(payload);

            summary = {
                arr: arrRows,
                bookings: bookingRows,
                revenue: revenueRows,
                costOfSales: cosRows,
                grossProfit: gpRows,
                grossMargin: gmRows
            };
            return getHTTPOkResponse( summary);
    
    } on fail error err {
        return getHTTPBadRequestResponse(err);
    }

}

function getArrAndBookingsPerBuPerMonth(DatePeriodBuFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json[] arrRows = [];
    json[] bookingRows = [];

    do {
            [arrRows, bookingRows] = check calculateARRAndBookingsPerBUPerMonth(payload);
             return getHTTPOkResponse( {arr: arrRows, bookings: bookingRows});
        } on fail error err {
            return getHTTPBadRequestResponse(err);
        }

}

