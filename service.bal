import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - formatted http response
    resource function get balanceStatement(string startDate, string endDate)
                                            returns http:Ok|http:BadRequest|error {

        DatePeriodFilterCriteria payload = {
            startDate: startDate,
            endDate: endDate
        };
        return getBalanceStatement(payload);
    }

}
