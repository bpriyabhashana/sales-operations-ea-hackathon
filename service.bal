import ballerina/http;

// import ballerina/io;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + payload - the request payload
    # + return - formatted http response
    resource function post finance/summary(http:Request request,
                                        @http:Payload json payload) returns http:Ok|http:BadRequest|error {

        return calculateSummary(payload);

    }

    # A resource for generating greetings
    # + payload - the request payload
    # + return - formatted http response
    resource function post finance/summary/bu/range(http:Request request,
                                        @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload) returns http:Ok|http:BadRequest|error {

        return calculateRangeSummary(payload);

    }
}
