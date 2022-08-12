// ------ filter criteria ------

public type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

// --------- record data ---------

public type SumOfExpenseAccountData record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Balance;
};

public type SumOfIncomeAccountData record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Balance;
};
