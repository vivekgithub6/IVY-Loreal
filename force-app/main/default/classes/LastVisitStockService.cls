public class LastVisitStockService {
    public static LocationStockWrp getLastVisitStock(Map<String, Set<String>> hierarchyNamewithSetOfIdsMap)
    {
       String[] LocationStockFields = new String[] {
			
			'ivybase__Visit__c',
			'ivybase__Location__c',
			'ivybase__Type__c',
			'ivybase__Product__c',
			'ivybase__Product__c',
			'ivybase__Visit__c',
			'ivybase__UOM1__c',
			'ivybase__Product__c',
			'ivybase__Reason__c',
			'ivybase__Reason_Master__c'
		};
            String[] visitFields = new String[]{'ivybase__Store__c','ivybase__Visit_Date__c'};
            String[] prodFields = new String[]{'ivybase__InternalId__c'};
            String[] uomFields = new String[]{'id', 'ivybase__UOM_Number__c', 'ivybase__UOM__c', 'ivybase__Product__c'};  
            String[] storeFields = new String[] {'ivybase__Internal_Id__c','ivybase__Location_Hierarchy__c'};
        
                
            set<String> Accountlst = new Set<String>();
             LocationStockWrp wrp = new LocationStockWrp();   
            if(hierarchyNamewithSetOfIdsMap != NULL && hierarchyNamewithSetOfIdsMap.size() > 0){
                if (hierarchyNamewithSetOfIdsMap.containskey('Account')) {
                Accountlst = hierarchyNamewithSetOfIdsMap.get('Account');
            }
           System.debug('Account List' +Accountlst);     
		   if (SecurityUtility.checkIsAccessible('ivybase__Location_Stock__c', LocationStockFields)&&Accountlst!=null
           && SecurityUtility.checkIsAccessible('ivybase__Visit__c', visitFields) 
           && SecurityUtility.checkIsAccessible('ivybase__Product__c', prodFields)
           && SecurityUtility.checkIsAccessible('Account', storeFields)) {
			Set<Id> AccId = new Set <Id>();
			Set<Id> VisitId = new Set <Id>();
			Map <ivybase__Location_Stock__c,list<ivybase__Product_UOM__c>> MapOUM = new Map <ivybase__Location_Stock__c,list<ivybase__Product_UOM__c>> ();
			Map<String,string> OUMCodeMap = new Map<String,string>();

			list <ivybase__Visit__c> visitlst = new list<ivybase__Visit__c>();
             System.debug('Accounts:::' +Accountlst);
           
			if (Accountlst != null) {
				if (Accountlst.size() > 0) {
					
					list <Id> productLst = new list <Id>();
					list <Date> visitdate = new list <date>();
                    System.debug('Inside loop account::' +Accountlst);
					list<ivybase__Location_Stock__c> Locationlst = [Select 	id,
																				ivybase__Visit__r.ivybase__Visit_Date__c,
																				ivybase__Location__r.ivybase__Standard_List_Master__r.Name,
											                                    ivybase__Product__c,
																				ivybase__Product__r.ivybase__InternalId__c,
                                                                    ivybase__Visit__r.ivybase__Store__c,
                                                                    ivybase__Visit__r.ivybase__Store__r.ivybase__Location_Hierarchy__c,
																				ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c,
																				ivybase__UOM1__c,
                                                                                ivybase__Reason_Master__r.Name,
																				ivybase__Location__r.RecordType.DeveloperName
                                                                                from ivybase__Location_Stock__c where ivybase__Visit__r.ivybase__Store__c IN: Accountlst
                                                                                order by ivybase__Visit__r.ivybase__Visit_Date__c DESC LIMIT 10000];

					system.debug('Location Stock' + Locationlst);

					
					Map<Id,ivybase__Location_Stock__c> StockAssortmentMap = new Map < Id,ivybase__Location_Stock__c>();
					
					Map<String,ivybase__Location_Stock__c> storeProductlocationStockMap = new Map<String,ivybase__Location_Stock__c>();
 					for (ivybase__Location_Stock__c loc: Locationlst) {
						
						String storeProduct = loc.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c + '-' + loc.ivybase__Product__c;
						System.debug('Store Product::' +storeProduct);
                        if(!storeProductlocationStockMap.containsKey(storeProduct)
							&& loc.ivybase__Location__r.RecordType.DeveloperName == 'In_Store'){
							storeProductlocationStockMap.put(storeProduct,loc);
							productLst.add(loc.ivybase__Product__c);
                                System.debug('Products List::' +productLst);
						}
						

					}

					system.debug('Location STock Map' + storeProductlocationStockMap);
					//system.debug('Location STock list' + locationStocklst);
					if (!storeProductlocationStockMap.isEmpty() && SecurityUtility.checkIsAccessible('ivybase__Visit__c', visitFields)) {
						
						system.debug(productLst);
						list < ivybase__Product_UOM__c > productUOMlst = [Select id, ivybase__UOM_Number__c, ivybase__UOM__c, ivybase__Product__c from ivybase__Product_UOM__c where ivybase__Product__c IN: productLst];
						system.debug('Product UOM' + productUOMlst);
						for (ivybase__Location_Stock__c st: storeProductlocationStockMap.values()) {
                          
							if (productUOMlst.size() > 0) {
								for (ivybase__Product_UOM__c uom: productUOMlst) {
									if (st.ivybase__Product__c == uom.ivybase__Product__c) {
										if (MapOUM.containsKey(st)) {
											List <ivybase__Product_UOM__c> oumlst = MapOUM.get(st);
											oumlst.add(uom);
											MapOUM.put(st, oumlst);
										}
										else {
											List <ivybase__Product_UOM__c> oumlst = new list <ivybase__Product_UOM__c>();
											oumlst.add(uom);
											MapOUM.put(st, oumlst);
										}
									}
									
								}
							}
							else {
								List < ivybase__Product_UOM__c > oumlst = new list <ivybase__Product_UOM__c> ();
								MapOUM.put(st, oumlst);
							}
						}
						system.debug('Map in Service class' + MapOUM);
                        
					   list < ivybase__Standard_List_Master__c > listMaster = [Select Name, ivybase__List_Name__c, ivybase__List_Code__c,ivybase__List_Type__c from ivybase__Standard_List_Master__c where ivybase__List_Type__c = 'PRODUCT_UOM'];
						system.debug('List Master' + listMaster);
						if (listMaster.size() > 0) {
							for (ivybase__Standard_List_Master__c master: listMaster) {
								OUMCodeMap.put(master.ivybase__List_Name__c, master.Name);
							}
						} else {
							listMaster = [Select Name,ivybase__List_Name__c, ivybase__List_Code__c,ivybase__List_Type__c from ivybase__Standard_List_Master__c where ivybase__List_Type__c = 'PRODUCT_UOM'];
							if (listMaster.size() > 0) {
								for (ivybase__Standard_List_Master__c master: listMaster) {
									OUMCodeMap.put(master.ivybase__List_Name__c, master.Name);
								}
							}
						}

					}

				

				}
                System.debug('MapOUM:::' +MapOUM);
                System.debug('Standard code::' +OUMCodeMap);
				wrp.LocationStockUOM = MapOUM;
				wrp.StandardCode = OUMCodeMap;
			}
		}
            
		else {
			throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'), 'INSUFFICIENT_PERMISSIONS');

		}
            
            }   
		
		return wrp;
            
	}
/*************************************************************
* @description Wrapper class to send both Location Stock and UOM

*************************************************************/
	public class LocationStockWrp {
		public Map < ivybase__Location_Stock__c,
		list < ivybase__Product_UOM__c >> LocationStockUOM;
		public Map < String,
		string > StandardCode;
	}
}