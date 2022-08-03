import ballerina/http;

function calculateSummary(json payload) returns http:Ok|http:BadRequest|error {

    DatePeriodFilterCriteria|error datePeriodFilterCriteria = payload.cloneWithType(DatePeriodFilterCriteria);

    if (datePeriodFilterCriteria is DatePeriodFilterCriteria) {

        json|error revenue = getIncomeRecords(datePeriodFilterCriteria);
        json|error cos = getExpenseRecords(datePeriodFilterCriteria);

        if (revenue is json && cos is json) {
            json|error revenueSummary = getSummary(revenue, cos);

            if (revenueSummary is json) {
                return getHTTPOkResponse(revenueSummary, API_OK_MSG_GENERAL);
            } else {
                return getHTTPBadRequestResponse(revenueSummary, API_ERR_MSG_PAYLOAD_SOR_ERROR);
            }

        } else if (revenue is error) {
            return getHTTPBadRequestResponse(revenue, API_ERR_MSG_PAYLOAD_SOR_ERROR);
        }
                else if (cos is error) {
            return getHTTPBadRequestResponse(cos, API_ERR_MSG_PAYLOAD_SOR_ERROR);
        } else {
            return getHTTPUnknownResponse(API_ERR_MSG_PAYLOAD_UNKNOWN_ERROR);
        }

    } else {
        return getHTTPBadRequestResponse(datePeriodFilterCriteria, API_ERR_MSG_PAYLOAD_MISSING_PARAMETERS);
    }
}
