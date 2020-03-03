global with sharing class GlobalConfigurationService {
global static ivybase__Global_Configuration__mdt getGlobalConfig() {
        List<ivybase__Global_Configuration__mdt> gcList = [SELECT 
                                                        Id, DeveloperName, ivybase__Active_Custom_Territory__c,
                                                        ivybase__Active_Resource_Based_Menu__c ,
                                                        ivybase__Active_Resource_Based_Module__c, 
                                                        ivybase__Active_Store_Multi_Territory__c,
                                                        ivybase__Allow_All_Users_to_Cancel_Order__c,
                                                        ivybase__Credit_Limit_Check__c,
                                                        ivybase__Last_X_Month_Visit__c,
                                                        ivybase__Last_X_Month_Visit_Count__c,
                                                        ivybase__No_of_Previous_Days__c,
                                                        ivybase__No_of_Future_Days__c,
                                                        ivybase__Active_Question_Result_Weight__c,
                                                        ivybase__Active_Route_Store_Mapping__c,
                                                        ivybase__Module_Wise_Last_Visit_Download__c 
                                                  FROM
                                                      ivybase__Global_Configuration__mdt
                                                  WHERE 
                                                      DeveloperName = 'Configuration'
                                                  ];
        if (gcList != null && gcList.size() > 0) {
            return gcList[0];
        } else {
            return null;
        }
    }
}