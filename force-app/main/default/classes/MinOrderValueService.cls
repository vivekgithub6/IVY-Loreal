public class MinOrderValueService {
	public static List<Minimum_Order_Amount__c> getMinOrderAmount(){
      
         id loctritoryid;
        list<ivybase__Location_Hierarchy__c> loctritoryidlist=LocationMasterService.getUserTerritory();
       if(loctritoryidlist.size()>0)
        loctritoryid=loctritoryidlist[0].id;
        
        map<id,set<id>> divloctionmap= new map<id,set<id>>();
        list<DivisionLocation__c> divlocation= [select Division__c,Location_Hierarchy__c from DivisionLocation__c ];
        if(divlocation!=null){
        for(DivisionLocation__c divloc:divlocation){
            if(divloctionmap.containskey(divloc.Division__c)){
                divloctionmap.get(divloc.Division__c).add(divloc.Location_Hierarchy__c);  
            }
            else{
                set<id> lochirid = new set<id>();
                lochirid.add(divloc.Location_Hierarchy__c);
                divloctionmap.put(divloc.Division__c,lochirid);
            }
        }
        }
        id mydisvisionid =AverageTurnoverPerRep.getdivisionforlocation(divloctionmap,loctritoryid);
        system.debug('mydisvisionid'+mydisvisionid);
     String[] Minorderfields = new String[]{'Name','Product_Hierarchy__c','Store_Hierarchy__c','Value__c','Division__c','From__c','To__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('Minimum_Order_Amount__c', Minorderfields)){
            system.debug('enetref in If');
		list<Minimum_Order_Amount__c> MinorderfieldsList= [select id,Name,Product_Hierarchy__c,Product_Hierarchy__r.ivybase__Internal_Id__c,Store_Hierarchy__c,Store_Hierarchy__r.ivybase__Internal_Id__c,Division__c,
                                                                 Division__r.Internal_Id__c,Division__r.name,Value__c,From__c,To__c
                                                      from Minimum_Order_Amount__c 
                                                      Where From__c<=:Date.today() AND Division__c =:mydisvisionid];//AND To__c>=:Date.today() 
		system.debug('MinorderfieldsList***'+MinorderfieldsList);
		return MinorderfieldsList;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
	} 

}