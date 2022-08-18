// ------ filter criteria ------

public type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

public type DatePeriodBuFilterCriteria record {
    string businessUnit;
    DatePeriodFilterCriteria period;
};

// ------ records ---------

public type SalesforceARROpeningClosingRespRecord record {
    string arr_type;
    decimal amount;
    decimal amount_iam;
    decimal amount_intsw;
};

public type SalesforceBookingSummaryResponseRecord record {
    decimal Bookings_Integration_Recurring;
    decimal Bookings_IAM_Recurring;
    decimal Bookings_Recurring_Total;
    decimal Bookings_Integration_Non_Recurring;
    decimal Bookings_IAM_Non_Recurring;
    decimal Bookings_Non_Recurring_Total;
    decimal Bookings_Cloud_Total;
};

public type SFNewExpRedLostValueRecord record {
    decimal newARRWSO2;
    decimal expansionARRWSO2;
    decimal reductionARRWSO2;
    decimal lostARRWSO2;
    decimal newARRIAM;
    decimal expansionARRIAM;
    decimal reductionARRIAM;
    decimal lostARRIAM;
    decimal newARRIntegration;
    decimal expansionARRIntegration;
    decimal reductionARRIntegration;
    decimal lostARRIntegration;
};

public type SFAccountsRespRecord record {
    string Id;
};

public type SFOpportunityRespRecord record {
    string AccountId;
    decimal ARR__c;
    decimal IAM_ARR__c;
    decimal Integration_ARR__c;
    int Renewal_Delayed__c;
    string? PS_Support_Account_Start_Date_Roll_Up__c;
    string? PS_Support_Account_End_Date_Roll_Up__c;
};

public type SFAccountsMapRecord record {
    int IsRenewalDelayed;
    decimal arrAmountPrevious;
    decimal arrAmountThis;
    decimal arrAmountPreviousIAM;
    decimal arrAmountThisIAM;
    decimal arrAmountPreviousIntegration;
    decimal arrAmountThisIntegration;
};

public type SFDelayedOpportunityRespRecord record {
    string AccountId;
    decimal Delayed_ARR__c;
    decimal IAM_Delayed_ARR__c;
    decimal Integration_Delayed__c;
    int Renewal_Delayed__c;
    string? PS_Support_Account_Start_Date_Roll_Up__c;
    string? PS_Support_Account_End_Date_Roll_Up__c;
};

// --------- record data ---------

public type SumOfExpenseAccountData record {
    string accountType;
    string accountCategory;
    string businessUnit;
    decimal balance;
};

public type SumOfIncomeAccountData record {
    string accountType;
    string accountCategory;
    string businessUnit;
    decimal balance;
};
