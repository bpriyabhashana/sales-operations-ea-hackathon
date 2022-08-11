import ballerina/http;

function getBalanceStatement(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error summary = getSummary(check getAccountBalance(payload, "income"), check getAccountBalance(payload, "expense"));

    if (summary is json) {
        return getHTTPOkResponse(summary, API_OK_MSG_GENERAL);
    } else {
        return getHTTPBadRequestResponse(summary);
    }
}

