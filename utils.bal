import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

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


configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

final mysql:Client mysqlClientSalesforce = check new (host = dbHost,
                                    user = dbUser,
                                    password = dbPassword,
                                    database = dbName,
                                    port = dbPort);

function getSumOfIncomeAccounts(DatePeriodFilterCriteria filterCriteria) returns json|error {
    string directQuery = string `{
                sumOfIncomeAccounts(filterCriteria: {
                    range : {
                        startDate: ${filterCriteria.startDate.toJsonString()} 
                        endDate: ${filterCriteria.endDate.toJsonString()}
                    }
                    groupBy : {
                        accountType: true,
                        accountCategory: true,
                        incomeType: false,
                        businessUnit: true
                    }
                        }) {    
                            accountType,
                            accountCategory,
                            businessUnit,
                            balance,
                        }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if response is json {
        return check response.data.sumOfIncomeAccounts;
    } else {
        return response;
    }
}

function getSumOfExpenseAccounts(DatePeriodFilterCriteria filterCriteria) returns json|error {
    string directQuery = string `{
                sumOfExpenseAccounts(filterCriteria: {
                    range : {
                        startDate: ${filterCriteria.startDate.toJsonString()} 
                        endDate: ${filterCriteria.endDate.toJsonString()}
                    }
                    groupBy : {
                        accountType: true,
                        accountCategory: true,
                        expenseType: false,
                        businessUnit: true
                    }
                        }) {    
                            accountType,
                            accountCategory,
                            businessUnit,
                            balance,
                        }
        }`;

    json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

    if response is json {
        return check response.data.sumOfExpenseAccounts;
    } else {
        return response;
    }
}

public isolated function calculateGrossMargin(decimal revenue, decimal costOfSales) returns decimal|string {
    // io:println(revenue ," ", costOfSales);

    if revenue != 0d {
        //  io:println(HUNDRED_PERCENT * (revenue - costOfSales) / revenue );
        return (HUNDRED_PERCENT * (revenue - costOfSales) / revenue);
    } else {
        return "N/A";
    }
}

public isolated function getHeaders() returns map<string> {
    return {"Access-Control-Allow-Origin": "*"};
}

public isolated function getHTTPOkResponse(json result) returns http:Ok {
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
