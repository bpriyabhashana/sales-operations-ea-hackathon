import ballerina/sql;

function getSFAccountsWithFilterQuery(DatePeriodFilterCriteria datePeriodRecord) returns sql:ParameterizedQuery {
    return `SELECT a.Id 
            FROM arr_sf_account AS a
            JOIN arr_sf_opportunity AS o
              ON a.IsInSF = 1 AND
                 o.AccountId = a.Id AND
                 o.IsInSF = 1 AND
                 (
                   (o.PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.startDate} AND 
                    o.PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.startDate}) 
                   OR
                   (o.PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                    o.PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate})
                 )`;
}

function getSFOpportunitiesWithFilterQuery(DatePeriodFilterCriteria datePeriodRecord, string action) returns sql:ParameterizedQuery {

    sql:ParameterizedQuery query = ``;

    if (action == GET_OPPORTUNITIES) {
        query = `SELECT o.AccountId, 
                        o.ARR__c, 
                        o.IAM_ARR__c, 
                        o.Integration_ARR__c, 
                        o.Renewal_Delayed__c, 
                        o.PS_Support_Account_Start_Date_Roll_Up__c, 
                        o.PS_Support_Account_End_Date_Roll_Up__c
                 FROM arr_sf_opportunity AS o 
                 JOIN arr_sf_account AS a 
                    ON o.AccountId = a.Id AND 
                       o.StageName = '50 - Closed Won' AND 
                       o.IsInSF = 1 AND
                       o.ARR__c > 0 AND
                       (
                         (o.PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.startDate} AND 
                          o.PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.startDate}) 
                         OR
                         (o.PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                          o.PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate})
                       )`;

    } else if (action == GET_OPPORTUNITIES_DELAYED) {
        query = `SELECT o.AccountId, 
                        o.Delayed_ARR__c, 
                        o.IAM_Delayed_ARR__c, 
                        o.Integration_Delayed__c, 
                        o.Renewal_Delayed__c, 
                        o.PS_Start_Date_Roll_Up__c AS PS_Support_Account_Start_Date_Roll_Up__c,  
                        o.PS_End_Date_Roll_Up__c AS PS_Support_Account_End_Date_Roll_Up__c 
                 FROM arr_sf_opportunity AS o 
                 JOIN arr_sf_account AS a 
                    ON o.AccountId = a.Id AND 
                       o.StageName NOT IN ('51 - Closed Lost', 
                                           '52 - Moved/Refactored', 
                                           '49 - Closed Won (Partial Contracts)', 
                                           '50 - Closed Won') AND 
                       o.Renewal_Delayed__c = 1 AND  
                       o.IsInSF = 1 AND
                       o.Delayed_ARR__c > 0 AND
                       (
                         (o.PS_Start_Date_Roll_Up__c <= ${datePeriodRecord.startDate} AND 
                          o.PS_End_Date_Roll_Up__c >= ${datePeriodRecord.startDate}) 
                         OR
                         (o.PS_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                          o.PS_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate})
                       )`;
    }
    return query;
}

function getSFARRForAGivenPeriod(DatePeriodFilterCriteria datePeriodRecord) returns sql:ParameterizedQuery {
    return `SELECT ${OPENING_ARR} as arr_type, 
                   SUM(ARR__c) AS amount,
                   SUM(IAM_ARR__c) AS amount_iam, 
                   SUM(Integration_ARR__c) AS amount_intsw
            FROM arr_sf_opportunity 
            WHERE ARR__c > 0 AND 
                  StageName = "50 - Closed Won" AND 
                  PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.startDate} AND 
                  PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.startDate} AND 
                  IsInSF = 1
            UNION
            SELECT ${CLOSING_ARR} as arr_type, 
                   SUM(ARR__c) AS ${ARR_AMOUNT},
                   SUM(IAM_ARR__c) AS ${BU1_AMOUNT}, 
                   SUM(Integration_ARR__c) AS ${BU2_AMOUNT}
            FROM arr_sf_opportunity 
            WHERE ARR__c > 0 AND 
                  StageName = "50 - Closed Won" AND 
                  PS_Support_Account_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                  PS_Support_Account_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate} AND 
                  IsInSF = 1
            UNION
            SELECT ${CLOUD_ARR} as arr_type, 
                   SUM(CL_ARR_Today__c) AS ${ARR_AMOUNT},
                   0 AS ${BU1_AMOUNT}, 
                   SUM(CL_ARR_Today__c) AS ${BU2_AMOUNT}
            FROM arr_sf_opportunity
            WHERE CL_ARR_Today__c > 0 AND
                  StageName = "50 - Closed Won" AND 
                  CL_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                  CL_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate} AND 
                  IsInSF = 1
            UNION
            SELECT ${OPENING_ARR_DELAYED} as arr_type, 
                SUM(Delayed_ARR__c) AS ${ARR_AMOUNT},
                SUM(IAM_Delayed_ARR__c) AS ${BU1_AMOUNT}, 
                SUM(Integration_Delayed__c) AS ${BU2_AMOUNT}
            FROM arr_sf_opportunity 
            WHERE Delayed_ARR__c > 0 AND 
                Renewal_Delayed__c = 1 AND 
                StageName NOT IN ('51 - Closed Lost', 
                                    '52 - Moved/Refactored', 
                                    '49 - Closed Won (Partial Contracts)', 
                                    '50 - Closed Won') AND 
                PS_Start_Date_Roll_Up__c <= ${datePeriodRecord.startDate} AND 
                PS_End_Date_Roll_Up__c >= ${datePeriodRecord.startDate} AND 
                IsInSF = 1
            UNION
            SELECT ${CLOSING_ARR_DELAYED} as arr_type, 
                SUM(Delayed_ARR__c) AS ${ARR_AMOUNT},
                SUM(IAM_Delayed_ARR__c) AS ${BU1_AMOUNT}, 
                SUM(Integration_Delayed__c) AS ${BU2_AMOUNT}
            FROM arr_sf_opportunity 
            WHERE Delayed_ARR__c > 0 AND 
                Renewal_Delayed__c = 1 AND 
                StageName NOT IN ('51 - Closed Lost', 
                                    '52 - Moved/Refactored', 
                                    '49 - Closed Won (Partial Contracts)', 
                                    '50 - Closed Won') AND 
                PS_Start_Date_Roll_Up__c <= ${datePeriodRecord.endDate} AND 
                PS_End_Date_Roll_Up__c >= ${datePeriodRecord.endDate} AND 
                IsInSF = 1`;
}

function getSFBookingQuery(DatePeriodFilterCriteria datePeriodRecord) returns sql:ParameterizedQuery {
    return `SELECT SUM(CASE WHEN Integration_ARR__c > 0 THEN Integration_ARR__c ELSE 0 END) AS Bookings_Integration_Recurring,
                   SUM(CASE WHEN IAM_ARR__c > 0 THEN IAM_ARR__c ELSE 0 END) AS Bookings_IAM_Recurring,
                   SUM(CASE WHEN Integration_ARR__c > 0 THEN Integration_ARR__c ELSE 0 END) + SUM(CASE WHEN IAM_ARR__c > 0 THEN IAM_ARR__c ELSE 0 END) AS Bookings_Recurring_Total,
                   SUM(CASE WHEN Integration_PSO__c > 0 THEN Integration_PSO__c ELSE 0 END) AS Bookings_Integration_Non_Recurring,
                   SUM(CASE WHEN IAM_PSO__c > 0 THEN IAM_PSO__c ELSE 0 END) AS Bookings_IAM_Non_Recurring,
                   SUM(CASE WHEN Integration_PSO__c > 0 THEN Integration_PSO__c ELSE 0 END) + SUM(CASE WHEN IAM_PSO__c > 0 THEN IAM_PSO__c ELSE 0 END) AS Bookings_Non_Recurring_Total,
                   SUM(CASE WHEN Cloud_ARR_Opportunity__c > 0 THEN Cloud_ARR_Opportunity__c ELSE 0 END) AS Bookings_Cloud_Total
            FROM arr_sf_opportunity  
            WHERE StageName = '50 - Closed Won' AND
                  IsInSF = 1 AND
                  CloseDate > ${datePeriodRecord.startDate} AND
                  CloseDate <= ${datePeriodRecord.endDate}`;
}
