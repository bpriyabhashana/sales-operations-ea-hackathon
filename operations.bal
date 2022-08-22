// import ballerina/http;

function getBalanceStatement(DatePeriodFilterCriteria payload) returns BalanceStatement|error {

    BusinessUnitSummary[]? arrRows;
    BusinessUnitSummary[]? bookingRows;
    BusinessUnitSummary[]? revenueRows;
    BusinessUnitSummary[]? cosRows;
    BusinessUnitSummary[]? gpRows;
    BusinessUnitSummary[]? gmRows;

    do {
        [revenueRows, cosRows, gpRows, gmRows] = check calculateBalance(check getSumOfIncomeAccounts(payload), check getSumOfExpenseAccounts(payload));

        [arrRows, bookingRows] = check calculateSalesforceARRAndBookings(payload);

      BalanceStatement summary =  {
                arr: <BusinessUnitSummary[]>arrRows,
                bookings: <BusinessUnitSummary[]>bookingRows,
                revenue: <BusinessUnitSummary[]>revenueRows,
                costOfSales: <BusinessUnitSummary[]>cosRows,
                grossProfit: <BusinessUnitSummary[]>gpRows,
                grossMargin: <BusinessUnitSummary[]>gmRows
            };

        BalanceStatement balanceStatement = summary;

            return balanceStatement;
    
    } on fail error err {
        return err;
    }

}

// function getArrAndBookingsPerBuPerMonth(DatePeriodBuFilterCriteria payload) returns http:Ok|http:BadRequest|error {

//     json[] arrRows = [];
//     json[] bookingRows = [];

//     do {
//             [arrRows, bookingRows] = check calculateARRAndBookingsPerBUPerMonth(payload);
//              return getHTTPOkResponse( {arr: arrRows, bookings: bookingRows});
//         } on fail error err {
//             return getHTTPBadRequestResponse(err);
//         }

// }

