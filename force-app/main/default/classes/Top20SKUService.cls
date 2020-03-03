public class Top20SKUService {
	public static Map<String,Map<String,Decimal>> get_NetSales_Top20_Product_Netsale_For_Retailer(Set<Id> retailer,Set<Id> top20SkuProductIdSet)
    {
        Date todayDate = date.Today();
        Date ThisYearStart = Date.newInstance(todayDate.year(),1,1);
       	Date LastYearStart = Date.newInstance(todayDate.year()-1,1,1);
        system.debug('retailer'+retailer);
        system.debug('top20SkuProductIdSet'+top20SkuProductIdSet);
     String[] SKU_SalonFields = new String[]{'Id','Account_Internal_Id__c','SaleAmount__c','Product_Internal_Id__c'};  
         if(SecurityUtility.checkIsAccessible('SKU_SaloonSale__c', SKU_SalonFields)){
         AggregateResult[] groupedResults = [select Account_Internal_Id__c,
                                             sum(SaleAmount__c),
                                             Product_Internal_Id__c  
                                             from SKU_SaloonSale__c
                                             where InvoiceDate__c >=: LastYearStart
                                             and InvoiceDate__c <: ThisYearStart
                                             and Account__c=:retailer
                                             and Product_Master__c=:top20SkuProductIdSet
                                             group by Product_Internal_Id__c,Account_Internal_Id__c];
             system.debug('groupedResults'+groupedResults);
             Map<String,Map<String,Decimal>> Retailer_With_Product_LYTD_Map = new Map<String,Map<String,Decimal>>();
             for (AggregateResult ar : groupedResults)  {
                 if(Retailer_With_Product_LYTD_Map.containsKey((String)ar.get('Account_Internal_Id__c')))
                 {
                     
                     Retailer_With_Product_LYTD_Map.get((String)ar.get('Account_Internal_Id__c')).put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                 }
                 else
                 {
                     Map<String,Decimal> productWithValue = new Map<String,Decimal>();
                     productWithValue.put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                     Retailer_With_Product_LYTD_Map.put((String)ar.get('Account_Internal_Id__c'),productWithValue);
                 }
             
             }
             system.debug('groupedResults'+groupedResults);
          return  Retailer_With_Product_LYTD_Map;  
         }
        else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
    }
    public static Map<String,Map<String,Decimal>> get_YTD_Top20_Product_Netsale_For_Retailer(Set<Id> retailer,Set<Id> top20SkuProductIdSet)
    {
        Date todayDate = date.Today();
        
        Date ThisYearStart = Date.newInstance(todayDate.year(),1,1);
        
        String[] SKU_SalonFields = new String[]{'Id','Product_Internal_Id__c','SaleAmount__c','Account_Internal_Id__c'};  
         if(SecurityUtility.checkIsAccessible('SKU_SaloonSale__c', SKU_SalonFields)){
         AggregateResult[] groupedResults = [select Account_Internal_Id__c,
                                             sum(SaleAmount__c),
                                             Product_Internal_Id__c  
                                             from SKU_SaloonSale__c 
                                             where InvoiceDate__c >=: ThisYearStart
                                             and InvoiceDate__c <=: todayDate
                                             and Account__c=:retailer
                                             and Product_Master__c=:top20SkuProductIdSet
                                             group by Account_Internal_Id__c,Product_Internal_Id__c];
             Map<String,Map<String,Decimal>> Retailer_With_Product_LYTD_Map = new Map<String,Map<String,Decimal>>();
                          system.debug('groupedResults'+groupedResults);
             for (AggregateResult ar : groupedResults)  {
                 if(Retailer_With_Product_LYTD_Map.containsKey((String)ar.get('Account_Internal_Id__c')))
                 {
                     
                     Retailer_With_Product_LYTD_Map.get((String)ar.get('Account_Internal_Id__c')).put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                 }
                 else
                 {
                     Map<String,Decimal> productWithValue = new Map<String,Decimal>();
                     productWithValue.put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                     Retailer_With_Product_LYTD_Map.put((String)ar.get('Account_Internal_Id__c'),productWithValue);
                 }
             
             }
             
          return  Retailer_With_Product_LYTD_Map;
         }else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
        
    }
    public static Map<String,Map<String,Decimal>> get_LYTD_Top20_Product_Netsale_For_Retailer(Set<Id> retailer,Set<Id> top20SkuProductIdSet)
    {
        Date todayDate = date.Today();
        Date LastYearToday = Date.newInstance(todayDate.year()-1,todayDate.month(),todayDate.day());
        Date LastYearStart = Date.newInstance(todayDate.year()-1,1,1);
        system.debug('LastYearToday'+LastYearToday);
        String[] SKU_SalonFields = new String[]{'Id','Product_Internal_Id__c','SaleAmount__c','Account_Internal_Id__c'};  
         if(SecurityUtility.checkIsAccessible('SKU_SaloonSale__c', SKU_SalonFields)){
         AggregateResult[] groupedResults = [select Account_Internal_Id__c,
                                             sum(SaleAmount__c),
                                             Product_Internal_Id__c 
                                             from SKU_SaloonSale__c 
                                             where InvoiceDate__c >=: LastYearStart
                                             and InvoiceDate__c <=: LastYearToday
                                             and Account__c=:retailer
                                             and Product_Master__c=:top20SkuProductIdSet
                                             group by Account_Internal_Id__c,Product_Internal_Id__c];
             Map<String,Map<String,Decimal>> Retailer_With_Product_LYTD_Map = new Map<String,Map<String,Decimal>>();
                         system.debug('groupedResults'+groupedResults);
             for (AggregateResult ar : groupedResults)  {
                 if(Retailer_With_Product_LYTD_Map.containsKey((String)ar.get('Account_Internal_Id__c')))
                 {
                     
                     Retailer_With_Product_LYTD_Map.get((String)ar.get('Account_Internal_Id__c')).put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                 }
                 else
                 {
                     Map<String,Decimal> productWithValue = new Map<String,Decimal>();
                     productWithValue.put((String)ar.get('Product_Internal_Id__c'),(Decimal)ar.get('expr0'));
                     Retailer_With_Product_LYTD_Map.put((String)ar.get('Account_Internal_Id__c'),productWithValue);
                 }
                 
             
             }
             
          return  Retailer_With_Product_LYTD_Map;
             
         }else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
        
    }
}