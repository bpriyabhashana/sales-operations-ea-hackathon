import ballerina/http;

function getBalanceStatement(DatePeriodFilterCriteria payload) returns http:Ok|http:BadRequest|error {

    json|error summary = calculateBalance(check getAccountBalance(payload, "income"), check getAccountBalance(payload, "expense"));

    if (summary is json) {
        return getHTTPOkResponse(summary);
    } else {
        return getHTTPBadRequestResponse(summary);
    }
}

