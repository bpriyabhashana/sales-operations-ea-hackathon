public function getSFARRPerGivenPeriod(DatePeriodFilterCriteria datePeriodRecord) returns json[]|error {

    json[] jsonSFOpeningClosingARR = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFARRForAGivenPeriod(datePeriodRecord));

    error? obj = resultStream.forEach(function(record {} result) {
        jsonSFOpeningClosingARR.push(result.toJson());
    });

    if obj is error {
        return obj;
    }

    return jsonSFOpeningClosingARR;
}

public function getSFAccountsWithFilter(DatePeriodFilterCriteria datePeriodRecord) returns json[]|error {

    json[] jsonSFAccounts = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFAccountsWithFilterQuery(datePeriodRecord));

    error? obj = resultStream.forEach(function(record {} result) {
        jsonSFAccounts.push(result.toJson());
    });

    if obj is error {
        return obj;
    }

    return jsonSFAccounts;
}

public function getSFOpportunitiesWithFilter(DatePeriodFilterCriteria datePeriodRecord, string action) returns json[]|error {

    json[] jsonSFOpportunities = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFOpportunitiesWithFilterQuery(datePeriodRecord, action));

    error? obj = resultStream.forEach(function(record {} result) {
        jsonSFOpportunities.push(result.toJson());
    });

    if obj is error {
        return obj;
    }

    return jsonSFOpportunities;
}

public function getSFBookingSummariesPerGivenPeriod(DatePeriodFilterCriteria datePeriodRecord) returns json|error {

    json jsonBookingSummary = {};

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFBookingQuery(datePeriodRecord));

    error? obj = resultStream.forEach(function(record {} result) {
        jsonBookingSummary = result.toJson();
    });

    if obj is error {
        return obj;
    }

    return jsonBookingSummary;
}
