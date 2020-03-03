public class ActualWorkingDaysKPITranslator {
    
    public static RExAPIResponseDomain.ResponseInfo translateData(AggregateResult[] records, String errorCode) {
        
        RExAPIResponseDomain.ResponseInfo dataList = new RExAPIResponseDomain.ResponseInfo();
        
        dataList.Master = 'ActualWorkingDaysKPI';
        dataList.Next = '0';
        dataList.ErrorCode = errorCode!= NULL ? errorCode: '0';
        dataList.Field = new LIST<String>{'Month','WorkingDay','Year'};
                     
        LIST<LIST<String>> recordsLIST = new LIST<LIST<String>>();
       
        if(errorCode == NULL){
            for(AggregateResult agr : records){
                
                system.debug('agr+ '+ agr);
                LIST<String> tempList = new LIST<String>();
                tempList.add(agr.get('month') != NULL ? String.valueof(agr.get('month')) : '');
                tempList.add(agr.get('expr0') != NULL ? String.valueOf(agr.get('expr0')): '');
                tempList.add(agr.get('Year') != NULL ? String.valueOf(agr.get('Year')): '');
                recordsLIST.add(tempList);  
            }
            dataList.Data = recordsLIST;
        }
        return dataList;
    }
}