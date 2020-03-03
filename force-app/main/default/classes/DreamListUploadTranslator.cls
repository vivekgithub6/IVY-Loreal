public class DreamListUploadTranslator {
   public static void translate(List<LorealUploadclass.DreamListInfo> DreamList){
        system.debug('DreamList'+DreamList);
        try{
            
            Id sellerId = ResourceService.getLoginSellerId();
            map<String,Account> AccountInternalIdmap=new  map<string,Account>();
            map<String,Account> ConquestInternalIdmap=new  map<string,Account>();
            list<Dream_List_Detail__c> NewDreamList=new   list<Dream_List_Detail__c>();
            list<Account> AccountList=DreamListService.getDreamList(sellerId);
            list<Account> Coqquestlist=DreamListService.getConquest();
            list<Account> Accountstobeupdated=new list<Account>();
            for(Account A:AccountList)
                AccountInternalIdmap.put(string.valueof(A.ivybase__Internal_Id__c),A);
            system.debug('AccountInternalIdmap'+AccountInternalIdmap);
            for(Account A: Coqquestlist)
                ConquestInternalIdmap.put(string.valueof(A.ivybase__Internal_Id__c), A);
            
            System.debug('ConquestInternalIdmap::'+ConquestInternalIdmap);
            if(DreamList!=null)
            {
                for(LorealUploadclass.DreamListInfo res:DreamList)
                {
                    
                    if(!String.isBlank(res.Rid) && res.IsConquest!='1'){
                        AccountInternalIdmap.get(res.Rid).Progress_Percentage__c=Decimal.valueOf(res.ProgressPercentage);
                        AccountInternalIdmap.get(res.Rid).Dream_List_Status__c=res.Status;
                        AccountInternalIdmap.get(res.Rid).Remarks__c=res.Remarks;
                        AccountInternalIdmap.get(res.Rid).Last_Visit_Date__c=ConversionUtility.StringToDateConversion(res.date_x);
                        Accountstobeupdated.add( AccountInternalIdmap.get(res.Rid));
                        Dream_List_Detail__c dreamlistRec=new Dream_List_Detail__c();
                        system.debug('hi');
                        system.debug('AccountInternalIdmap.get(res.Rid).id'+AccountInternalIdmap.get(res.Rid).id);
                        dreamlistRec.Account__c=AccountInternalIdmap.get(res.Rid).id;
                        if(!String.isBlank(res.ProgressPercentage)){
                            dreamlistRec.Progress__c=Decimal.valueOf(res.ProgressPercentage);
                            // AccountInternalIdmap.get(res.Rid).Progress_Percentage__c=Integer.valueOf(res.ProgressPercentage);
                        }
                        
                        dreamlistRec.Remarks__c=res.Remarks;
                        // AccountInternalIdmap.get(res.Rid).Dream_List_Status__c=res.Status;
                        dreamlistRec.Visited_Date__c=ConversionUtility.StringToDateConversion(res.date_x);
                        NewDreamList.add(dreamlistRec); 
                        System.debug('NewDreamList::'+NewDreamList);
                    }
                    
                    //checking for Account fields  
                    if(!String.isBlank(res.Rid) && res.IsConquest=='1'){
                        // if(!String.isBlank(res.ProgressPercentage))
                        System.debug('Related Acc::'+ConquestInternalIdmap.get(res.Rid));
                        ConquestInternalIdmap.get(res.Rid).Progress_Percentage__c=Decimal.valueof(res.ProgressPercentage);
                        ConquestInternalIdmap.get(res.Rid).Dream_List_Status__c=res.Status;
                        ConquestInternalIdmap.get(res.Rid).Remarks__c=res.Remarks;
                        ConquestInternalIdmap.get(res.Rid).Last_Visit_Date__c=ConversionUtility.StringToDateConversion(res.date_x);
                        Accountstobeupdated.add(ConquestInternalIdmap.get(res.Rid));
                    }
                    
                }
                if(NewDreamList.size()>0)
                    insert  NewDreamList;
                system.debug('Accountstobeupdated'+Accountstobeupdated);
                update Accountstobeupdated;
                
            }
        }
        Catch(Exception e){
            system.debug('error'+e.getMessage());
        }
        
    }
}