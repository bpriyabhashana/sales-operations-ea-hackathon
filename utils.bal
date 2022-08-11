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

function getAccountBalance(DatePeriodFilterCriteria filterCriteria, string balanceType) returns json|error {
    string directQuery = string `{
                accountBalance(filterCriteria: {
                balanceType : ${balanceType.toJsonString()}
                startDate : ${filterCriteria.startDate.toJsonString()},
                endDate : ${filterCriteria.endDate.toJsonString()},
            }) {    
                AccountType,
                AccountCategory,
                BusinessUnit,
                Balance,
            }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if (response is json) {
        return check response.data.accountBalance;
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

public isolated function formatArray(json[] array) returns json[]|error {
    foreach int i in 1 ..< array.length() + 1 {
        array[i - 1] = check array[i - 1].mergeJson({id: i.toString()});
    }
    return array;
}
