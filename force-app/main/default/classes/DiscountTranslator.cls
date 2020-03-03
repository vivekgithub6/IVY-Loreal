/**
 * Created By : Ivy Mobility(Absyz Team)
 * Purpose : To form the JSON for the Discount API
 * Modified By : Karthikeyan
 * Changes : Changed the Response to JSON Generator Class, Added the IsBOM and BOMId columns and values in the Response String
*/
public with sharing class DiscountTranslator {

   public static JSONGenerator objectToDiscountInfo(JSONGenerator jsongen, List<ivydsd__Discount__c> discountList, 
                                                    List<ivybase__Standard_List_Master__c> SLMList, 
                                             String errorCode) {
       
       List<Pricing_Group__mdt> pricingGroup = [select id,DeveloperName,Grouping__c  from Pricing_Group__mdt];
        
        map<string,string> conditionmaps= new map<string,string>();
        for(Pricing_Group__mdt pg:pricingGroup)
        {
            if(pg.DeveloperName!=null && pg.Grouping__c!=null)
            {
                conditionmaps.put(pg.DeveloperName,pg.Grouping__c);
            }
        }
        
        Map<String,String>  nameIdMap = new Map<String,String>();
        if(SLMList != null && SLMList.size()>0){
            
            for(ivybase__Standard_List_Master__c slm : SLMList){
               String combo = slm.ivybase__List_Type__c + slm.ivybase__List_Name__c;
                if(!nameIdMap.Containskey(combo)){
                    nameIdMap.put(combo,slm.Name);
                }
            }
        }
        
        jsongen.writeStartObject();
        jsongen.writeFieldName('Tables');
        jsongen.writeStartArray();
            
        jsongen.writeStartObject();        
        jsongen.writeStringField('Next', '0');     
        jsongen.writeStringField('Master', 'DiscountMaster');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('DiscountId');
        jsongen.WriteString('TypeId');
        jsongen.WriteString('Description');
        jsongen.WriteString('ApplyLevelId');
        jsongen.WriteString('ModuleId');
        jsongen.WriteString('IsCompanyGiven');
        jsongen.WriteString('Code');
        
        jsongen.writeEndArray();        
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);  
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();                    
                
                
        if(discountList != null && errorCode == null) {
           
            for (ivydsd__Discount__c discount : discountList) {
            
                jsongen.writeStartArray();
                jsongen.writeString(discount.ivydsd__Internal_Id__c);//DiscountId
                String combo = 'DISCOUNT_TYPE' + discount.ivydsd__Discount_Type__c;
                if(discount.ivydsd__Discount_Type__c != NULL && nameIdMap.containskey(combo)){
                    jsongen.writeString(nameIdMap.get(combo));
                } else{
                    jsongen.writeString('');
                }//Type Id
                
                if(discount.ivydsd__Description__c != NULL ){
                    jsongen.writeString(discount.ivydsd__Description__c);
                } else{
                    jsongen.writeString('');
                }//Description
                String combo1 = 'DISCOUNT_APPLY_TYPE' + discount.ivydsd__Apply_Type__c;
                if(discount.ivydsd__Apply_Type__c != NULL && nameIdMap.containskey(combo1)){
                    jsongen.writeString(nameIdMap.get(combo1));
                } else{
                    jsongen.writeString('');
                }//ApplyLevelId
                String combo2 = 'DISCOUNT_MODULE_TYPE' + discount.ivydsd__Module_Type__c;
                if(discount.ivydsd__Module_Type__c != NULL && nameIdMap.containskey(combo2)){
                     jsongen.writeString(nameIdMap.get(combo2));
                } else{
                     jsongen.writeString('');
                }//ModuleId
                
                jsongen.writeString('0'); //IsCompanyGiven

                if(discount.Type__c != NULL ){
                    if(conditionmaps.containsKey(discount.Type__c))
                    {
                      jsongen.writeString(conditionmaps.get(discount.Type__c));  
                    }
                     
                } else{
                    jsongen.writeString('');
                }//Code
                jsongen.writeEndArray();
            }
        }

        jsongen.writeEndArray(); 
                                              
        jsongen.writeEndObject();
        return jsongen;
    }
    
    public static JSONGenerator objectToDiscountDetailInfo(JSONGenerator jsongen, List<ivydsd__Discount_Detail__c> discproddetlist,
                                                           Map<Id,Map<Id,Decimal>> BOMFinalPrice, String errorCode) {
        
        UserwiseCountryValues__c user = UserwiseCountryValues__c.getInstance(UserInfo.getUserId());
                
        jsongen.writeStartObject();    
        jsongen.writeStringField('Next', '0');          
        jsongen.writeStringField('Master', 'DiscountProductMapping');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('DiscountId');
        jsongen.WriteString('ProductId');
        jsongen.WriteString('Value');
        jsongen.WriteString('IsPercentage');
        jsongen.WriteString('MinValue');
        jsongen.WriteString('MaxValue');
        jsongen.WriteString('toValue');
        jsongen.WriteString('IsBOM');
                                                               
        //if(user != NULL && user.Market_ISO__c == 'SG')                                                       
        	jsongen.WriteString('BOMId');
                                                               
        jsongen.writeEndArray();                                           
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);   
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();          
        
        if(discproddetlist != null && errorCode == null) {

            for (ivydsd__Discount_Detail__c discdet : discproddetlist) {
                
                jsongen.writeStartArray();                
                if(discdet.Parent__c!=null)
                {
                    jsongen.writeString(discdet.Parent__r.ivydsd__Discounts__r.ivydsd__Internal_Id__c); 
                }
                else if(discdet.ivydsd__Discounts__r.ivydsd__Internal_Id__c != null){
                    jsongen.writeString(discdet.ivydsd__Discounts__r.ivydsd__Internal_Id__c);
                }else{
                    jsongen.writeString('');
                }//DiscountId
                if(discdet.ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c != null){
                      jsongen.writeString(String.valueOf(discdet.ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c));
                }
                else if(discdet.ivydsd__Product__r.ivybase__InternalId__c != null){
                     jsongen.writeString(String.valueOf(discdet.ivydsd__Product__r.ivybase__InternalId__c));
                }
                else if(discdet.Division__r.Internal_Id__c != null)
                {
                    jsongen.writeString(String.valueOf(discdet.Division__r.Internal_Id__c));
                }
                else{
                    jsongen.writeString('');
                }//ProductId
                
                if(discdet.ivydsd__Value__c != null){
                     jsongen.writeString(discdet.ivydsd__Value__c != null ? String.valueOf(discdet.ivydsd__Value__c): '0');
                }
                else{
                    jsongen.writeString('');
                }//Value
                
                if(discdet.ivydsd__Is_Percentage__c){
                    jsongen.writeString('1');
                }else{
                    jsongen.writeString('1');
                }//IsPercentage
                
                if(discdet.ivydsd__Min_Slab__c != null){
                     jsongen.writeString(discdet.ivydsd__Min_Slab__c != null ? String.valueOf(discdet.ivydsd__Min_Slab__c): '0');
                }else{
                     jsongen.writeString('');
                }//MinValue
                
                if(discdet.ivydsd__Max_Slab__c != null){
                     jsongen.writeString(discdet.ivydsd__Max_Slab__c != null ? String.valueOf(discdet.ivydsd__Max_Slab__c): '0');
                }else{
                     jsongen.writeString('');
                }//MaxValue
                if(discdet.ToValue__c  != null){
                     jsongen.writeString(discdet.ToValue__c  != null ? String.valueOf(discdet.ToValue__c ): '0');
                }else{
                    jsongen.writeString('');
                }
                //toValue
                if(discdet.Parent__c != null) {
                    jsongen.writeString('1'); 
                }
                else {
                    jsongen.writeString('0'); 
                }//IsBom
                //if(user != NULL && user.Market_ISO__c == 'SG') {
                    if(discdet.Parent__c != null && discdet.Parent__r.ivydsd__Product__c != null) {
                        jsongen.writeString(String.valueOf(discdet.Parent__r.ivydsd__Product__r.ivybase__InternalId__c));
                    } else {
                        jsongen.writeString('0');
                    }//BOMId
                //}
                jsongen.writeEndArray();
            }            
        }  
        
        jsongen.writeEndArray(); 
                                              
        jsongen.writeEndObject();
        return jsongen;      
    }
    
    public static JSONGenerator objectToDiscountMappingInfo(JSONGenerator jsongen, List<ivydsd__Discount_Mapping__c> discmaplist, 
                                                                                String errorCode) {
        
        jsongen.writeStartObject();     
        jsongen.writeStringField('Next', '0');       
        jsongen.writeStringField('Master', 'DiscountMapping');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('DiscountId');
        jsongen.WriteString('RetailerId');
        jsongen.WriteString('ChannelId');
        jsongen.WriteString('LocationId');
        jsongen.WriteString('AccountId');
        jsongen.WriteString('DistributorId');
        
        jsongen.writeEndArray();        
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode); 
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();   
        
        if(discmaplist != null && errorCode == null){
            
            for(ivydsd__Discount_Mapping__c discmap: discmaplist){
                
                jsongen.writeStartArray();
                            
                if(discmap.ivydsd__Discount__r.ivydsd__Internal_Id__c != null){
                    jsongen.WriteString(discmap.ivydsd__Discount__r.ivydsd__Internal_Id__c);
                }else{
                    jsongen.WriteString('0');
                }//DiscountId

                if(discmap.ivydsd__Account__r.ivybase__Internal_Id__c != null){
                    jsongen.WriteString(String.valueOf(discmap.ivydsd__Account__r.ivybase__Internal_Id__c));  
                }else{
                    jsongen.WriteString('0');
                } //RetailerId
                        
                if(discmap.ivydsd__Store_Hierarchy__r.ivybase__Internal_Id__c != null){
                    jsongen.WriteString(discmap.ivydsd__Store_Hierarchy__r.ivybase__Internal_Id__c);  
                }else{
                    jsongen.WriteString('0');
                }//channelid

                jsongen.WriteString('0'); //LocationId
                jsongen.WriteString('0'); //accid
                jsongen.WriteString('0'); //Distributorid
                                         
                jsongen.writeEndArray(); 
            }
        }
               
        jsongen.writeEndArray();                                
        jsongen.writeEndObject();
      
        jsongen.writeEndArray();
        jsongen.writeEndObject();
        
        return jsongen;    
    }  
      
}