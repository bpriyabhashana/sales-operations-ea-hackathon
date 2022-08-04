import ballerina/http;

function calculateSummary(json payload) returns http:Ok|http:BadRequest|error {

    DatePeriodFilterCriteria|error datePeriodFilterCriteria = payload.cloneWithType(DatePeriodFilterCriteria);

    if (datePeriodFilterCriteria is DatePeriodFilterCriteria) {

        json|error revenue = getIncomeRecords(datePeriodFilterCriteria);
        json|error costOfSales = getExpenseRecords(datePeriodFilterCriteria);

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

    } else {
        return getHTTPBadRequestResponse(datePeriodFilterCriteria, API_ERR_MSG_PAYLOAD_MISSING_PARAMETERS);
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
