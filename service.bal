import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/balanceStatement(http:Request request,
                                            @http:Payload DatePeriodFilterCriteria payload)
                                            returns http:Ok|http:BadRequest|error {
        return getBalanceStatement(payload);
    }

}
