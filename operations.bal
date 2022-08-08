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
                return getHTTPBadRequestResponse(summary);
            }

        } else if (revenue is error) {
            return getHTTPBadRequestResponse(revenue);
        } else if (costOfSales is error) {
            return getHTTPBadRequestResponse(costOfSales);
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
        return getHTTPBadRequestResponse(summaryPerBUPerMonth);
    }

}

isolated function calculateCostOfSalesSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesSummary = getCostOfSalesSummary(payload);

    if (costOfSalesSummary is json) {
        return getHTTPOkResponse(costOfSalesSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesSummary);
    }

}

isolated function calculateCostOfSalesRecurringSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesRecurringSummary = getCostOfSalesRecurringSummary(payload);

    if (costOfSalesRecurringSummary is json) {
        return getHTTPOkResponse(costOfSalesRecurringSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesRecurringSummary);
    }

}

isolated function calculateCostOfSalesNonRecurringSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesNonRecurringSummary = getCostOfSalesNonRecurringSummary(payload);

    if (costOfSalesNonRecurringSummary is json) {
        return getHTTPOkResponse(costOfSalesNonRecurringSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesNonRecurringSummary);
    }

}

isolated function calculateCostOfSalesCloudSummary(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error costOfSalesCloudSummary = getCostOfSalesCloudSummary(payload);

    if (costOfSalesCloudSummary is json) {
        return getHTTPOkResponse(costOfSalesCloudSummary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(costOfSalesCloudSummary);
    }

}
