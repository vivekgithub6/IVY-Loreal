@istest
public class Test_standardListmasterService {
    private static testMethod void teststandardlistmaster(){
       Id userId = UserInfo.getUserId();
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c='MY',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id);
        insert resource;
        
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
            
        List<ivybase__Standard_List_Master__c> assets = new List<ivybase__Standard_List_Master__c>{
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Competitor',ivybase__List_Code__c='PERC',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id ),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Planned',ivybase__List_Code__c='COMP', ivybase__List_Type__c = 'CONTACT_TITLE',  ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Eligible',ivybase__List_Code__c='ELG',ivybase__List_Type__c = 'CONTACT_TITLE',  ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Installed',ivybase__List_Code__c='INS',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Planned',ivybase__List_Code__c='INS',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Barcode Update',ivybase__List_Code__c='BAD', ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'MissingID',ivybase__List_Code__c='MID',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                 new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'RemovalRsnID',ivybase__List_Code__c='RRID',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                

                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'RejectedRsnID',ivybase__List_Code__c='RJRID',ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'ReasonID',ivybase__List_Code__c='RID', ivybase__List_Type__c = 'CONTACT_TITLE', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Removed',ivybase__List_Code__c='REM', ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Maintenance',ivybase__List_Code__c='AMR', ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                
               new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Piece',ivybase__List_Code__c='Piece', ivybase__List_Type__c = 'PRODUCT_UOM', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id),
                     new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'A    ',ivybase__List_Code__c='A', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = locationHierarchy.id, ivybase__Resource_Type__c = resType.id)
            };
            insert assets;
        list<string> stdtype= new list<string>();
        stdtype.add('PRODUCT_UOM');
        Test.startTest();
        StandardListMasterservice.getAllStandard_List();
        StandardListMasterservice.getStandardListUsingListType(stdtype);
        StandardListMasterservice.getAllClassTypeList();
        Test.stopTest();
}
}