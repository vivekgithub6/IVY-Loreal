@isTest
private class TESTRestMagClassification {
    private static testMethod void testMagClass(){
        
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        List<Mag_Classification__c> magClassList = new List<Mag_Classification__c>{
            new Mag_Classification__c(Name='Test MagClass One',Range__c='50-100',Criteria__c='# Of Hair Stylist',Market_ISO__c=usr.Market_ISO__c),
                new Mag_Classification__c(Name='Test MagClass Two',Range__c='100-200',Criteria__c='SERVICE FEE',Market_ISO__c=usr.Market_ISO__c)
                };
                    insert   magClassList;        
        
        List<Salon_Catagory__c> salCategory = new List<Salon_Catagory__c>{
            new Salon_Catagory__c(Name='Test Category',Criteria1__c=magClassList[0].Id,Criteria2__c=magClassList[1].Id,Salon_Catagoty__c='A1',Market_ISO__c=usr.Market_ISO__c)
                };
                    insert salCategory;
        
        Test.startTest();
        RestMagClassification.getSaloonMagClassification();
        Test.stopTest();
    }   
    
    @isTest
    private static void  testtMagClassificationException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RestMagClassification.getSaloonMagClassification();
            }Catch(Exception ex) {
            }
        }
        Test.stoptest();
    }
}