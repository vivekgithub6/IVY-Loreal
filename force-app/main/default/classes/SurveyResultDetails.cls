public class SurveyResultDetails {
public string SurveyId{get;set;}
public list<ivybase__Survey_Result__c> SurveyImageList = new list<ivybase__Survey_Result__c>();
public list<account> AccountList = new list<account>();    
    
public string StoreId ;
public list<ivybase__Survey_Result__c> getSurveyImageList()
{
    SurveyImageList = [select id,name,Image_Path__c,Image_URL__c,createddate,
                       ivybase__Survey__c,ivybase__Survey__r.name,
                       ivybase__Store__c,ivybase__Store__r.name,ivybase__Store__r.Sold_To_Party_Number__c,
                       ivybase__Store__r.Store_Address__c,ivybase__Visit__c,
                       ivybase__Visit__r.name,ivybase__Visit__r.ivybase__Resource__r.name,ivybase__Visit__r.ivybase__Resource__r.SAP_Id__c
                       from ivybase__Survey_Result__c where id=:SurveyId];    
    return SurveyImageList;
}
}