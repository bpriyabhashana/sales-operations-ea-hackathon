import ballerina/http;

configurable string CHOREO_TOKEN_ENDPOINT = ?;
configurable string CHOREO_CLIENT_ID = ?;
configurable string CHOREO_CLIENT_SECRET = ?;
configurable string CHOREO_API_ENDPOINT = ?;

# A service representing a network-accessible API
# bound to port `9090`.
service /finance on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get revenue/summary(http:Request request,
                                        @http:Payload json payload) returns string[]|error {
       
       DatePeriodFilterCriteria|error filterCriteria = payload.cloneWithType(DatePeriodFilterCriteria);

       if(filterCriteria is DatePeriodFilterCriteria) {
           string directQuery = string `{
                account(filterCriteria: {
                    startDate : "${filterCriteria.startDate}",
                    endDate : "${filterCriteria.endDate}",
            }) {    
                AccountType,
                AccountCategory,
                BusinessUnit,
                Amount,
            }
        }`;

            final http:Client clientEndpoint =
                        check new (CHOREO_API_ENDPOINT, auth = {
                tokenUrl: CHOREO_TOKEN_ENDPOINT,
                clientId: CHOREO_CLIENT_ID,
                clientSecret: CHOREO_CLIENT_SECRET
            });

         json|error response = check clientEndpoint->post("/graphql", {"query": (directQuery)});

       }
    }
}
