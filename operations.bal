import ballerina/http;

function calculateSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {


    if (payload is DatePeriodFilterCriteria) {

        json|error revenue = getIncomeRecords(payload);
        json|error costOfSales = getExpenseRecords(payload);

        if (revenue is json && costOfSales is json) {
            json|error summary = getSummary(revenue, costOfSales);

            if (summary is json) {
                return getHTTPOkResponse(summary, API_OK_MSG_GENERAL);
            } else {
                return getHTTPBadRequestResponse(summary, API_ERR_MSG_PAYLOAD_SOR_ERROR);
            }

        } else if (revenue is error) {
            return getHTTPBadRequestResponse(revenue, API_ERR_MSG_PAYLOAD_SOR_ERROR);
        }
                else if (costOfSales is error) {
            return getHTTPBadRequestResponse(costOfSales, API_ERR_MSG_PAYLOAD_SOR_ERROR);
        } else {
            return getHTTPUnknownResponse(API_ERR_MSG_PAYLOAD_UNKNOWN_ERROR);
        }

    }
}

function calculateRangeSummary(MultipleDatePeriodsWithBURecordFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error summaryPerBUPerMonth = getSummaryPerBUPerMonth(payload);

    if (summaryPerBUPerMonth is json) {
        return getHTTPOkResponse(summaryPerBUPerMonth, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(summaryPerBUPerMonth, API_ERR_MSG_PAYLOAD_SOR_ERROR);
    }

}

isolated function calculateCostOfSalesSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesSummary = getCostOfSalesSummary(payload);

    if (costOfSalesSummary is json) {
        return getHTTPOkResponse(costOfSalesSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesSummary, API_ERR_MSG_PAYLOAD_SOR_ERROR);
    }

}

isolated function calculateCostOfSalesRecurringSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesRecurringSummary = getCostOfSalesRecurringSummary(payload);

    if (costOfSalesRecurringSummary is json) {
        return getHTTPOkResponse(costOfSalesRecurringSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesRecurringSummary, API_ERR_MSG_PAYLOAD_SOR_ERROR);
    }

}
