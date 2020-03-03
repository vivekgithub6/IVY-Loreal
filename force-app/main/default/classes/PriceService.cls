/**
 * Created By : Ivy Mobility
 * Created Date :
 * Purpose : This service class used to query the pricing data from the Organization and send through API's
 * Test Class :
 * Last Modified By  : Karthikeyan
 * Purpose : BOM pricing issue(Adding the BOM Id in the API's) - #BOMId-Addition
*/
public with sharing class PriceService {
    public static list<ivybase__Price_List_Entrie__c> getAllGrandChildPriceListEntries(Set<Id> priceListEntryIds) {

      Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId()); 
        system.debug('surveyProcessDate'+surveyProcessDate);
      String[] pricelistentryFields = new String[] {'ivybase__product__c','Parent__c','ivybase__UOM_1_Price__c','ivybase__UOM_2_Price__c',
          'ivybase__UOM_3_Price__c','ivybase__UOM_1_Credit_Price__c','ivybase__UOM_2_Credit_Price__c','ivybase__UOM_3_Credit_Price__c',
          'ivybase__Active__c','Type__c'}; 
      String[] pricelistentry1Fields = new String[] {'InternalId__c'};
      String[] pricelistFields = new String[] {'ivybase__Active__c','ivybase__Valid_From__c','ivybase__Valid_To__c',
          						'ivybase__Is_Standard__c','ivybase__Internal_Id__c'};
                                    
      if (SecurityUtility.checkIsAccessible('ivybase__Price_List_Entrie__c', pricelistentryFields) 
          && SecurityUtility.checkIsAccessible('ivybase__product__c', pricelistentry1Fields) 
          && SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)){
          list<ivybase__Price_List_Entrie__c> priceList = [
                                SELECT
                                 Id,
                                  ivybase__product__c,
                                  Parent__r.ivybase__product__c,
                                  Parent__r.ivybase__Price_List__c,
                                  ivybase__product__r.ivybase__InternalId__c,
                                  ivybase__Price_List__c,ivybase__Price_List__r.ivybase__Internal_Id__c,
                                  Name,
                                  ivybase__UOM_1_Price__c,ivybase__UOM_1_Credit_Price__c,
                                  ivybase__UOM_2_Price__c,ivybase__UOM_2_Credit_Price__c,
                                  ivybase__UOM_3_Price__c,ivybase__UOM_3_Credit_Price__c,
                                  ivybase__Price_List__r.ivybase__Valid_From__c,
                                  ivybase__Price_List__r.ivybase__Valid_To__c,
                                  ivybase__Price_List__r.ivybase__Is_Standard__c,
                                  Type__c, 
              					  Parent__r.ivybase__Product__r.ivybase__InternalId__c//#BOMId-Addition
                                FROM
                                  ivybase__Price_List_Entrie__c
                                WHERE
                                 Parent__c  IN: priceListEntryIds 
                                 AND ivybase__Active__c = 'Yes'
                                 AND ivybase__Price_List__r.ivybase__Active__c = 'Yes'
                                 AND ivybase__product__c != null
              					 AND ivybase__Product__r.ivybase__Active__c='Yes'
                                 AND ivybase__Product__r.ivybase__Is_Competitor__c = false
              					 AND ivybase__Product__r.ivybase__Non_Saleable__c = false
                                 AND 
                                     (
                                         (ivybase__Price_List__r.ivybase__Is_Standard__c = false AND 
                                          ivybase__Price_List__r.ivybase__Valid_From__c <= TODAY AND 
                                          (ivybase__Price_List__r.ivybase__Valid_To__c=null OR 
                                           ivybase__Price_List__r.ivybase__Valid_To__c >=TODAY))
                                          OR 
                                         (ivybase__Price_List__r.ivybase__Is_Standard__c = true AND 
                                          ivybase__Price_List__r.ivybase__Valid_From__c = null AND 
                                          ivybase__Price_List__r.ivybase__Valid_To__c = null AND 
                                          ivybase__Product__r.RecordType.DeveloperName = 'Bill_Of_Material_SKU')
                                     )
                              ];                              
          return priceList;
      } else {
          throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                               'INSUFFICIENT_PERMISSIONS');
      }
   } 
   public static list<ivybase__Price_List_Entrie__c> getAllPriceEntries(Set<String> priceListIds) {

      Date surveyProcessDate =  CommonUtility.surveyProcessDate(UserInfo.getUserId()); 
        system.debug('surveyProcessDate'+surveyProcessDate);
      String[] pricelistentryFields = new String[] {'ivybase__product__c','ivybase__UOM_1_Price__c','ivybase__UOM_2_Price__c',
          'ivybase__UOM_3_Price__c','ivybase__UOM_1_Credit_Price__c','ivybase__UOM_2_Credit_Price__c','ivybase__UOM_3_Credit_Price__c',
          'ivybase__Active__c','Type__c'}; 
      String[] pricelistentry1Fields = new String[] {'InternalId__c'};
      String[] pricelistFields = new String[] {'ivybase__Active__c','ivybase__Valid_From__c','ivybase__Valid_To__c',
          'ivybase__Is_Standard__c','ivybase__Internal_Id__c'};
      system.debug('::priceListIds :::>'+priceListIds );
         //getting lovids
           List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
            Set<Id> userTerritoryId = new Set<Id>(); 
            for(ivybase__Location_Hierarchy__c l:userTerritory)
             {
                 userTerritoryId.add(l.id);
             }
             Set<Id> divId = DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
        system.debug('divId'+divId);
      if (SecurityUtility.checkIsAccessible('ivybase__Price_List_Entrie__c', pricelistentryFields) 
          && SecurityUtility.checkIsAccessible('ivybase__product__c', pricelistentry1Fields) 
          && SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)){
          list<ivybase__Price_List_Entrie__c> priceList = [
                                SELECT
                                 Id,
                                  ivybase__product__c,   
                                  ivybase__product__r.ivybase__InternalId__c ,
                                  ivybase__Price_List__c,ivybase__Price_List__r.ivybase__Internal_Id__c,
                                  Name,
                                   Parent__c,
                                  ivybase__UOM_1_Price__c,ivybase__UOM_1_Credit_Price__c,
                                  ivybase__UOM_2_Price__c,ivybase__UOM_2_Credit_Price__c,
                                  ivybase__UOM_3_Price__c,ivybase__UOM_3_Credit_Price__c,
                                  ivybase__Price_List__r.ivybase__Valid_From__c,
                                  ivybase__Price_List__r.ivybase__Valid_To__c,
                                  ivybase__Price_List__r.ivybase__Is_Standard__c   ,
                                  Type__c, Parent__r.ivybase__Product__r.ivybase__InternalId__c //#BOMId-Addition
                                FROM
                                  ivybase__Price_List_Entrie__c
                                WHERE
                                 ivybase__Price_List__c IN: priceListIds 
                                 AND ivybase__Active__c = 'Yes'
                                 AND ivybase__Price_List__r.ivybase__Active__c = 'Yes'
                                 AND ivybase__product__c != null
                                 AND ivybase__product__r.Division__c= :divId
                                 AND ivybase__Product__r.ivybase__Active__c='Yes'
                                 AND ivybase__Product__r.ivybase__Is_Competitor__c = false
              					 AND ivybase__Product__r.ivybase__Non_Saleable__c = false
                                 AND 
                                     (
                                         (ivybase__Price_List__r.ivybase__Is_Standard__c = false 
                                          AND ivybase__Price_List__r.ivybase__Valid_From__c <= TODAY 
                                          AND (ivybase__Price_List__r.ivybase__Valid_To__c=null 
                                               OR ivybase__Price_List__r.ivybase__Valid_To__c >=TODAY))
                                          OR 
                                         (ivybase__Price_List__r.ivybase__Is_Standard__c = true 
                                          AND ivybase__Price_List__r.ivybase__Valid_From__c = null 
                                          AND ivybase__Price_List__r.ivybase__Valid_To__c = null 
                                          AND ivybase__Product__r.RecordType.DeveloperName != 'Bill_Of_Material_SKU')
                                     )
          ];                              
          return priceList;
      }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
      }
   } 
    
    public static String getSTDPriceListId() {
       String[] pricelistFields = new String[] {'ivybase__Active__c','ivybase__Is_Standard__c'};
       String stdPlId;
       
       if (SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)) {
           for(ivybase__Price_List__c pl : [SELECT Id FROM ivybase__Price_List__c WHERE ivybase__Is_Standard__c = true 
                                            AND ivybase__Active__c = 'Yes']) {
               stdPlId = pl.Id;
           }
       }
       return stdPlId;
   }
    //country wise
    public static String getSTDPriceListId(String CountryCode) {
       String[] pricelistFields = new String[] {'ivybase__Active__c','ivybase__Is_Standard__c'};
       String stdPlId;
       
       if (SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)) {
           for(ivybase__Price_List__c pl : [SELECT Id FROM ivybase__Price_List__c WHERE ivybase__Is_Standard__c = true 
                                            AND ivybase__Active__c = 'Yes' and Market_ISO__c=:CountryCode]) {
               stdPlId = pl.Id;
           }
       }
       return stdPlId;
   }

   /*  public static Set<String> getPriceListByStoreHieId(Set<String> storeHierachyIds){
      
      Set<String> priceListIds = new Set<String>();
      String[] pricelistmappingFields = new String[] {'ivybase__Price_List__c','ivybase__Store_Hierarchy__c'};
      String[] pricelistFields = new String[] {'ivybase__Active__c'};
      if (SecurityUtility.checkIsAccessible('ivybase__Price_List_Mapping__c', pricelistmappingFields ) 
		&& SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)){
          for(ivybase__Price_List_Mapping__c pricemap : [SELECT
                                                 Id,
                                                 ivybase__Price_List__c,
                                                 ivybase__Store_Hierarchy__c                  
                                                FROM
                                                  ivybase__Price_List_Mapping__c
                                                 WHERE 
                                                  ivybase__Store_Hierarchy__c  IN:  storeHierachyIds  
                                                  AND ivybase__Price_List__r.ivybase__Active__c = 'Yes'           
                                                ]){
              priceListIds.add(pricemap.ivybase__Price_List__c);                        
          }
          return priceListIds;
      }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
			'INSUFFICIENT_PERMISSIONS');
      }
    }
    public static List<ivybase__Price_List_Mapping__c> getPriceListByparenttStoreHieId(Set<String> storeHierachyIds){
      
      List<ivybase__Price_List_Mapping__c> priceLists = new List<ivybase__Price_List_Mapping__c>();
      String[] pricelistmappingFields = new String[] {'ivybase__Price_List__c','ivybase__Store_Hierarchy__c'};
      String[] pricelistFields = new String[] {'ivybase__Active__c'};
      if (SecurityUtility.checkIsAccessible('ivybase__Price_List_Mapping__c', pricelistmappingFields ) 
		&& SecurityUtility.checkIsAccessible('ivybase__Price_List__c', pricelistFields)){
           priceLists = [SELECT
                             Id,
                             ivybase__Price_List__c,
                             ivybase__Store_Hierarchy__c                  
                            FROM
                              ivybase__Price_List_Mapping__c
                             WHERE 
                              ivybase__Store_Hierarchy__c  IN:  storeHierachyIds  
                              AND ivybase__Price_List__r.ivybase__Active__c = 'Yes'           
                        ];                       
          
          return priceLists;
      }else {
		throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
			'INSUFFICIENT_PERMISSIONS');
	}
    }*/    
}