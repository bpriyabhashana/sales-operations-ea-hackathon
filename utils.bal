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

public function calculateGrossMargin(decimal revenue, decimal costOfSales) returns decimal|string {
    if (revenue != 0d) {
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
        body: {
            success: true,
            message: msg,
            data: result
        }

    };
}

public isolated function getHTTPBadRequestResponse(error err, string msg) returns http:BadRequest {
    return {
        headers: getHeaders(),
        body: {
            success: false,
            message: msg,
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
