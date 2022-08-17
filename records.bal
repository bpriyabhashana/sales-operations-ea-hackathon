// ------ filter criteria ------

public type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
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
