import ballerina/http;

function getBalanceStatement(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error summary = {};
    json[] arrRows = [];
    json[] bookingRows = [];
    json[] revenueRows = [];
    json[] cosRows = [];
    json[] gpRows = [];
    json[] gmRows = [];

    do {
        [revenueRows, cosRows, gpRows, gmRows] = check calculateBalance(check getSumOfIncomeAccounts(payload), check getSumOfExpenseAccounts(payload));

        [arrRows, bookingRows] = check calculateSalesforceARRAndBookings(payload);

        if summary is json {
            summary = check summary.mergeJson({
                arr: arrRows,
                bookings: bookingRows,
                revenue: revenueRows,
                costOfSales: cosRows,
                grossProfit: gpRows,
                grossMargin: gmRows
            });
            return getHTTPOkResponse(check summary);
        }

        return getHTTPBadRequestResponse(summary);
    } on fail error err {
        return getHTTPBadRequestResponse(err);
    }

}

