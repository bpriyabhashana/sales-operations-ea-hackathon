public type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

public type MultipleDatePeriodsWithBURecordFilterCriteria record {
    string businessUnit;
    DatePeriodFilterCriteria[] dateRange;
};

public type DatePeriodWithBURecord record {
    string businessUnit;
    DatePeriodFilterCriteria period;
};

public type IncomeExpenseSummaryRecord record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Amount;
};
