public class JunctionCreatorWrapperClass {
    
    @AuraEnabled
    public Scheme_Product_creator__mdt config;
    
    @AuraEnabled
    public string Parent2LabelName;
   
    @AuraEnabled
    public list<SObject> JunctionRecords;
    
    @AuraEnabled
    public list<string> JunctionFieldLabel;
    
    public class wrapperClass {
        
        @AuraEnabled public string label;
        @AuraEnabled public string fieldName;
        @AuraEnabled public string type;
    }
}