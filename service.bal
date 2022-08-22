import ballerina/graphql;


service graphql:Service /graphql on new graphql:Listener(9090) {

    resource function get balanceStatement(DatePeriodFilterCriteria filterCriteria) returns BalanceStatement|error {

        return check getBalanceStatement(filterCriteria);

    }

}



// import ballerina/graphql;

// # A service representing a network-accessible API
// # bound to port `9090`.
// service /graphql on new graphql:Listener(9090) {

//      resource function get balanceStatement(string tresrt) returns BalanceStatement[]|error? {

//         return [];
//     }

//     // resource function get arrAndBookingsPerBuPerMonth(string businessUnit, string startDate, string endDate)
//     //                                         returns http:Ok|http:BadRequest|error {
//     //     DatePeriodBuFilterCriteria payload = {
//     //         businessUnit: businessUnit,
//     //         period: {
//     //             startDate: startDate,
//     //             endDate: endDate
//     //         }
//     //     };
//     //     return getArrAndBookingsPerBuPerMonth(payload);
//     // }
// }
