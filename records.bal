// ------ filter criteria ------

public type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

// --------- record data ---------

public type IncomeExpenseSummaryRecord record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Balance;
};
