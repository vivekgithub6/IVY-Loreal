public with sharing class Schemeutility {
    public static map<String,string> update_IsNewLaunchCheckbox(set<String> schemeid){
        //set<id> schemeid = new set<id>();
        /*for(Sales_Forecast_Detail__c sfd:sfdtail){
            if(sfd.Scheme__c!=null){
                schemeid.add(sfd.Scheme__c);
            }
        }*/
        date todaydate= date.today();
    list<ivydsd__Scheme_Group__c> schgrplist = [select id,Name,ivydsd__Scheme__r.ivydsd__Internal_Id__c,ivydsd__Group_Type__c,ivydsd__Scheme__c,(select id,ivydsd__Product1__c from ivydsd__Scheme_Group_Details__r) from ivydsd__Scheme_Group__c where ivydsd__Group_Type__c='BUY' AND ivydsd__Scheme__r.ivydsd__Internal_Id__c IN:schemeid];
    system.debug('schgrplist'+schgrplist);
        //set<id> prdid = new set<id>();
        map<string,set<id>> schemeproductgroupmap=new  map<string,set<id>>();
        for(ivydsd__Scheme_Group__c sg:schgrplist){
            set<id> prdid = new set<id>();
            for(ivydsd__Scheme_Group_Product__c sgd:sg.ivydsd__Scheme_Group_Details__r){
                if(sgd.ivydsd__Product1__c!=null){
                  prdid.add(sgd.ivydsd__Product1__c); 
                    
                }
            }
            schemeproductgroupmap.put(sg.ivydsd__Scheme__r.ivydsd__Internal_Id__c, prdid);
        }
        system.debug('schemeproductgroupmap'+schemeproductgroupmap);
        list<ivybase__Product_Group__c> pgrpList=[select id,RecordTypeId,RecordType.Name,(select id,ivybase__Product__c from ivybase__Product_Group_Details__r) from ivybase__Product_Group__c where RecordType.Name='New Launch' AND ivybase__Start_Date__c <=:todaydate AND ivybase__End_Date__c>=:todaydate];
        set<id> prgrpproducts= new set<id>();
        for(ivybase__Product_Group__c pgp:pgrpList){
            for(ivybase__Product_Group_Detail__c pgd:pgp.ivybase__Product_Group_Details__r){
                if(pgd.ivybase__Product__c!=null){
                prgrpproducts.add(pgd.ivybase__Product__c);
                }
            }
        }
        system.debug('prgrpproducts'+ prgrpproducts);
        map<String,string> schemebooleanmap = new map<String,string>();
        for(String schid:schemeid){
            if(schemeproductgroupmap.containskey(schid)) {
                if(prgrpproducts.size()>0 && schemeproductgroupmap.get(schid).size()>0 && prgrpproducts.containsall(schemeproductgroupmap.get(schid))){
                    schemebooleanmap.put(schid, 'New_Launch');
                }else{
                    schemebooleanmap.put(schid,'Promotion');
                }
            } 
        }
     return schemebooleanmap; 
    }
}