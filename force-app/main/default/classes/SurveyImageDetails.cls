public class SurveyImageDetails {
public string SurveyId{get;set;}
public list<ivybase__Survey_Image__c> SurveyImageList = new list<ivybase__Survey_Image__c>();

public list<ivybase__Survey_Image__c> getSurveyImageList()
{
    SurveyImageList = [select id,name,Image_Path__c,ivybase__URL__c,Image_URL__c from ivybase__Survey_Image__c where id=:SurveyId];    
    return SurveyImageList;
}
}