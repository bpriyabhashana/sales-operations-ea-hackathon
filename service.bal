import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/summary(http:Request request,
                                            @http:Payload DatePeriodFilterCriteria payload)
                                            returns http:Ok|http:BadRequest|error {
        return calculateSummary(payload);
    }

    # A resource for generating greetings
    # + payload - MultipleDatePeriodsWithBURecordFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/summary/bu/range(http:Request request,
                                        @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateRangeSummary(payload);

    }

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary(http:Request request,
                                        @http:Payload DatePeriodFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCostOfSalesSummary(payload);
    }

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/recurring(http:Request request,
                                        @http:Payload DatePeriodFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCostOfSalesRecurringSummary(payload);
    }

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/nonrecurring(http:Request request,
                                        @http:Payload DatePeriodFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCostOfSalesNonRecurringSummary(payload);
    }

    # A resource for generating greetings
    # + payload - DatePeriodFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/cloud(http:Request request,
                                        @http:Payload DatePeriodFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCostOfSalesCloudSummary(payload);
    }

    # A resource for generating greetings
    # + payload - MultipleDatePeriodsWithBURecordFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/range/bu(http:Request request,
                                        @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCOSRangeBUSummary(payload);
    }

    # A resource for generating greetings
    # + payload - MultipleDatePeriodsWithBURecordFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/range/bu/recurring(http:Request request,
                                        @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload)
                                        returns http:Ok|http:BadRequest|error {
        return calculateCOSRangeBURecurringSummary(payload);
    }

    # A resource for generating greetings
    # + payload - MultipleDatePeriodsWithBURecordFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/range/bu/nonrecurring(http:Request request,
                                            @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload)
                                            returns http:Ok|http:BadRequest|error {
        return calculateCOSRangeBUNonRecurringSummary(payload);
    }

    # A resource for generating greetings
    # + payload - MultipleDatePeriodsWithBURecordFilterCriteria (refer records.bal for more details)
    # + return - formatted http response
    resource function post finance/cossummary/range/bu/cloud(http:Request request,
                                            @http:Payload MultipleDatePeriodsWithBURecordFilterCriteria payload)
                                            returns http:Ok|http:BadRequest|error {
        return calculateCOSRangeBUCloudSummary(payload);
    }
}
