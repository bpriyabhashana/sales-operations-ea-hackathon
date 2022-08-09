import ballerina/http;

configurable string CHOREO_TOKEN_ENDPOINT = ?;
configurable string CHOREO_CLIENT_ID = ?;
configurable string CHOREO_CLIENT_SECRET = ?;
configurable string CHOREO_API_ENDPOINT = ?;

final http:Client clientEndpoint =
                        check new (CHOREO_API_ENDPOINT, auth = {
    tokenUrl: CHOREO_TOKEN_ENDPOINT,
    clientId: CHOREO_CLIENT_ID,
    clientSecret: CHOREO_CLIENT_SECRET
});

function getIncomeRecords(DatePeriodFilterCriteria datePeriodFilterCriteria) returns json|error {
    string directQuery = string `{
                income(filterCriteria: {
                startDate : ${datePeriodFilterCriteria.startDate.toJsonString()},
                endDate : ${datePeriodFilterCriteria.endDate.toJsonString()},
            }) {    
                 AccountType,
                AccountCategory,
                BusinessUnit,
                Amount,
            }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if (response is json) {
        return check response.data.income;
    } else {
        return response;
    }
}

function getExpenseRecords(DatePeriodFilterCriteria datePeriodFilterCriteria) returns json|error {
    string directQuery = string `{
                expense(filterCriteria: {
                startDate : ${datePeriodFilterCriteria.startDate.toJsonString()},
                endDate : ${datePeriodFilterCriteria.endDate.toJsonString()},
            }) {    
                 AccountType,
                AccountCategory,
                BusinessUnit,
                Amount,
            }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if (response is json) {
        return check response.data.expense;
    } else {
        return response;
    }
}

public isolated function getCostOfSalesRecords(DatePeriodFilterCriteria datePeriodFilterCriteria) returns json|error {
    string directQuery = string `{
                expenseCOS(filterCriteria: {
                startDate : ${datePeriodFilterCriteria.startDate.toJsonString()},
                endDate : ${datePeriodFilterCriteria.endDate.toJsonString()},
            }) {    
                 AccountType,
                AccountCategory,
                Type,
                BusinessUnit,
                Amount,
            }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if (response is json) {
        return check response.data.expenseCOS;
    } else {
        return response;
    }
}

public isolated function calculateGrossMargin(decimal revenue, decimal costOfSales) returns decimal|string {
    // io:println(revenue ," ", costOfSales);

    if (revenue != 0d) {
        //  io:println(HUNDRED_PERCENT * (revenue - costOfSales) / revenue );
        return (HUNDRED_PERCENT * (revenue - costOfSales) / revenue);
    } else {
        return "N/A";
    }
}

public isolated function getHeaders() returns map<string> {
    return {"Access-Control-Allow-Origin": "*"};
}

public isolated function getHTTPOkResponse(json result, string msg) returns http:Ok {
    return {
        headers: getHeaders(),
        body: result
    };
}

public isolated function getHTTPBadRequestResponse(error err) returns http:BadRequest {
    return {
        headers: getHeaders(),
        body: {
            'error: err.toString()
        }
    };
}

public isolated function getHTTPUnauthorizedResponse(error err, string msg) returns http:Unauthorized {
    return {
        headers: getHeaders(),
        body: {
            success: false,
            message: msg,
            'error: err.toString()
        }
    };
}

public isolated function getHTTPUnknownResponse(string msg) returns http:BadRequest {
    return {
        headers: getHeaders(),
        body: {
            success: false,
            message: msg
        }
    };
}

public isolated function formatArray(json[] array) returns json[]|error {
    foreach int i in 1 ..< array.length()+1 {
        array[i-1] = check array[i-1].mergeJson({id: i.toString()});
    }
    return array;
}

public isolated function formatRangeArray(json[] array) returns json[]|error {
    foreach int i in 0 ..< array.length() {
        array[i] = check array[i].mergeJson({id: i.toString()});
    }
    return array;
}
