import ballerina/http;

// import ballerina/io;

# A service representing a network-accessible API
# bound to port `9090`.
service /finance on new http:Listener(9090) {

    # A resource for generating greetings
    // # + name - the input string name
    # + return - string name with hello message or error
    resource function post summary/revenue(http:Request request,
                                        @http:Payload json payload) returns http:Ok|http:BadRequest|error {

        DatePeriodFilterCriteria|error datePeriodFilterCriteria = payload.cloneWithType(DatePeriodFilterCriteria);

        if (datePeriodFilterCriteria is DatePeriodFilterCriteria) {

            json|error revenue = getIncomeRecords(datePeriodFilterCriteria);

            if (revenue is json) {
                json|error revenueSummary = getRevenueSummary(revenue);

                if (revenueSummary is json) {
                    return getHTTPOkResponse(revenueSummary, API_OK_MSG_GENERAL);
                } else {
                    return getHTTPBadRequestResponse(revenueSummary, API_ERR_MSG_PAYLOAD_SOR_ERROR);
                }

            } else {
                return getHTTPBadRequestResponse(revenue, API_ERR_MSG_PAYLOAD_SOR_ERROR);
            }

        } else {
            return getHTTPBadRequestResponse(datePeriodFilterCriteria, API_ERR_MSG_PAYLOAD_MISSING_PARAMETERS);
        }

    }
}
