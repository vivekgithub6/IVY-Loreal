/*
 * Block comments with details of changes
 */
public class SalonDataservice
{
    public static List<Account> getAllRetailerMaster_List_For_All_Ids(Set<Decimal> Accids) {
        List< Account > RetailerListInfo = new List< Account >();
        String[] ck2Fields = new String[] {'ivybase__Internal_Id__c', 'ivybase__StoreCode__c','BillingStreet', 'ivybase__Customer_Category__c', 'BillingCity',
            'BillingState', 'BillingPostalCode', 'ivybase__Credit_Limit__c', 'ivybase__TIN_Number__c', 'ShippingStreet', 
            'ShippingCity', 'ivybase__Store_Hierarchy__c', 'ShippingState', 'ShippingPostalCode', 'ivybase__Contact_Email__c',
            'ivybase__Contact_PhoneNo__c','Price_List__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Credit_Period__c', 'Phone', 'Fax', 'ivybase__Lat_and_Long__c',
            'ivybase__Lat_and_Long__latitude__s', 'ivybase__Lat_and_Long__longitude__s','ivybase__Visit_Plan__c','ivybase__Seller_Name__c','ivybase__Resource__c','ivybase__Image_Path__c',
            'ivybase__Image_Name__c','ivybase__Last_Visit__c','Location_Hierarchy__c','AccountNumber','ivybase__Second_LastVisit__c','Is_Dream_List__c','Converted_to_Normal_Saloon__c','Is_Conquest__c','Payer_Code__c','Phone','Kerastase_Luxury_Mag__c',
            'Salon_Person_Contact_Code__c','Due_Amount__c','Store_Address__c','Remarks__c','Last_Visit_Date__c'};
                
                if (SecurityUtility.checkIsAccessible('Account', ck2Fields)) { 
                    
                    if(Accids.size() > 0) {
                        RetailerListInfo = [ SELECT ivybase__Internal_Id__c,
                                            ivybase__StoreCode__c ,
                                            Name,
                                            ivybase__Parent_Branch__r.ivybase__Internal_Id__c,
                                            BillingStreet,
                                            ivybase__Customer_Category__c,
                                            BillingCity,
                                            BillingState,
                                            Price_List__c,
                                            BillingPostalCode,
                                            ivybase__Credit_Limit__c,
                                            ivybase__TIN_Number__c,
                                            ShippingStreet,
                                            ShippingCity,
                                            Location_Hierarchy__c,
                                            ivybase__Store_Hierarchy__c,
                                            ShippingState,
                                            ShippingPostalCode,
                                            ivybase__Contact_Email__c,
                                            ivybase__Contact_PhoneNo__c,
                                            ivybase__Location_Hierarchy__c,
                                            ivybase__Credit_Period__c,
                                            Phone,Stock_Location__c,
                                            Fax,Salon_Frequency__c,
                                            ivybase__Lat_and_Long__c,
                                            ivybase__Lat_and_Long__latitude__s, 
                                            ivybase__Lat_and_Long__longitude__s,
                                            ivybase__Visit_Plan__c,ivybase__Resource__c,
                                            ivybase__Image_Name__c,
                                            ivybase__Image_Path__c,
                                            ivybase__Last_Visit__c,
                                            ivybase__Second_LastVisit__c,
                                            Is_Dream_List__c,
                                            Converted_to_Normal_Saloon__c,
                                            Is_Conquest__c,
                                            Remarks__c,
                                            AccountNumber,
                                            Average_Order_Value__c,
                                            LastInvoiceDate__c,
                                            Last_Visit_Date__c,
                                            Payer_Code__c,
                                            Kerastase_Luxury_Mag__c,
                                            AgreedActiveCustomer__c,
                                            Salon_Person_Contact_Code__c,
                                            Progress_Percentage__c,
                                            Dream_List_Status__c,
                                            Due_Amount__c,
                                            Store_Address__c,
                                            ivybase__Active__c,IsAgent__c,
                                            SecondLastInvoiceDate__c,Social_Media_Id__c,Order_Email__c,
                                            
                                            Sold_To_Party_Number__c,
                                            ivybase__Area_Code__c,IsFocus__c,Last_Vist_Date__c,Preferred_Time__c
                                            
                                            
                                            FROM Account 
                                            WHERE 
                                            ivybase__Active__c = 'Yes'
                                            AND
                                            ivybase__Internal_Id__c IN: Accids 
                                                                                    
                                            
                                           ];
                    }
                    return RetailerListInfo;
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
        
    }
    public static list<Contract__c> getContractList(Set<Decimal> accid){
         String[] ContractFields = new String[] {'Account__c','Internal_Id__c','Description__c','Contract_Value__c','Start_Date__c','End_Date__c','Status__c','Contract_Type__c'};
             String[] AccountFields =new string[] {'ivybase__Internal_Id__c'};
                if(SecurityUtility.checkIsAccessible('Contract__c', ContractFields) && SecurityUtility.checkIsAccessible('Account', AccountFields)){
            
    list<Contract__c> ContractList=[select Account__c, Account__r.ivybase__Internal_Id__c,Internal_Id__c,Description__c,Contract_Value__c,Start_Date__c,End_Date__c,Status__c,Contract_Type__c from Contract__c where Account__r.ivybase__Internal_Id__c IN:accid AND ( (Start_Date__c<=:date.today() AND End_Date__c>=:date.today()) OR ((Start_Date__c=Null OR Start_Date__c<=:date.today()) AND (End_Date__c=Null OR End_Date__c>=:date.today())))];
        system.debug('ContractList'+ContractList);
                    return ContractList;
                } 
                     else{
                 throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
   
        }
    }
    
    public static Map<Id,Decimal> getYTDValue(Set<Id> retailerIds){
        Map<Id,Decimal> YTDMap = new Map<Id,Decimal>();
        Id resId = ResourceService.getLoginSellerId();
        AggregateResult[] groupedResults = [select SUM(Total_Amount__c)Amt,ivydsd__Store__c from ivydsd__Invoice__c  where ivydsd__Store__c in:retailerIds
                                            AND ivydsd__Invoice_Date__c = THIS_YEAR 
                                            group by ivydsd__Store__c];        
        System.debug('groupedResults:::' +groupedResults);    
        if(groupedResults.size()>0){
            Decimal d=    (Decimal)groupedResults[0].get('Amt');
            for(AggregateResult ar : groupedResults){ 
                if( (string)ar.get('ivydsd__Store__c')!=Null){
                    //Decimal totalMonths = (Decimal)Date.today().month();
                    YTDMap.put((Id)ar.get('ivydsd__Store__c'),(Decimal)ar.get('Amt'));
                }
            }
        }
        
        return YTDMap;
    }
}