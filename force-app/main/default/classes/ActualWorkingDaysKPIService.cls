public class ActualWorkingDaysKPIService {
    
    public static AggregateResult[] getRecords(Id resourceId) {
        
         string currentMonth = String.valueOf(system.today().month());
        AggregateResult[] groupedResults = [select Month__c month  , Year__c Year, sum(Number_Of_Working_Days__c)  
                                            from Market_Visit_Calculation__c  
                                            WHERE Resource__c =:resourceId AND Month__c =: currentMonth 
                                            group by Month__c,Year__c];
        return groupedResults;
    }
}