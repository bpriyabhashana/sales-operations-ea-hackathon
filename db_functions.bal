public function getSFARRPerGivenPeriod(DatePeriodFilterCriteria datePeriodRecord) returns json[]|error {

    json[] jsonSFOpeningClosingARR = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFARRForAGivenPeriod(datePeriodRecord));

    error? e = resultStream.forEach(function(record {} result) {
        jsonSFOpeningClosingARR.push(result.toJson());
    });

    if (e is error) {
        return e;
    }

    return jsonSFOpeningClosingARR;
}

public function getSFAccountsWithFilter(DatePeriodFilterCriteria datePeriodRecord) returns json[]|error {

    json[] jsonSFAccounts = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFAccountsWithFilterQuery(datePeriodRecord));

    error? e = resultStream.forEach(function(record {} result) {
        jsonSFAccounts.push(result.toJson());
    });

    if (e is error) {
        return e;
    }

    return jsonSFAccounts;
}

public function getSFOpportunitiesWithFilter(DatePeriodFilterCriteria datePeriodRecord, string action) returns json[]|error {

    json[] jsonSFOpportunities = [];

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFOpportunitiesWithFilterQuery(datePeriodRecord, action));

    error? e = resultStream.forEach(function(record {} result) {
        jsonSFOpportunities.push(result.toJson());
    });

    if (e is error) {
        return e;
    }

    return jsonSFOpportunities;
}

public function getSFBookingSummariesPerGivenPeriod(DatePeriodFilterCriteria datePeriodRecord) returns json|error {

    json jsonBookingSummary = {};

    stream<record {}, error?> resultStream = mysqlClientSalesforce->query(getSFBookingQuery(datePeriodRecord));

    error? e = resultStream.forEach(function(record {} result) {
        jsonBookingSummary = result.toJson();
    });

    if (e is error) {
        return e;
    }

    return jsonBookingSummary;
}
