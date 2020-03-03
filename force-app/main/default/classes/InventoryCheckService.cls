public class InventoryCheckService {
    public static void getBestSeller(){
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = [select Id,ivybase__Related_User__c from ivybase__Resource__c where ivybase__Related_User__c=:userId];
        System.debug('Resource:::' +res);
        List<Account> stores = [Select Id, ivybase__Resource__c from Account where ivybase__Resource__c=:res.Id];
        System.debug('Stores:::' +stores);
        AggregateResult[] totalQuantity = [Select ivydsd__Invoice__r.ivydsd__Store__c,ivydsd__Invoice__r.ivydsd__Store__r.Name, ivydsd__Product_Master1__r.Name product,
                                   SUM(ivydsd__UOM_1_Quantity__c) quantity from ivydsd__Invoice_Line_Item__c
                                  GROUP BY ivydsd__Invoice__r.ivydsd__Store__c,ivydsd__Invoice__r.ivydsd__Store__r.Name, ivydsd__Product_Master1__r.Name
                                  ORDER BY SUM(ivydsd__UOM_1_Quantity__c) DESC]; 
        System.debug('Total quantity:::' +totalQuantity);
        
        Map<String,List<String>> storeProducts = new Map<String,List<String>>();
        Set<String> accIds = new Set<String>();
       List<String> products = new List<String>();
        
        for(AggregateResult result : totalQuantity){
            System.debug('Total quantity:::' +result.get('Name')); 
            if(result.get('Name') != null){
               products.add((String)result.get('Product'));
               storeProducts.put((String)result.get('Name'),products); 
            }
         }
        System.debug('Store with products' +storeProducts);
         
        
    }

}