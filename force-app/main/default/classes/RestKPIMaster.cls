@RestResource(urlMapping='/v1/KPIMaster/Masters/')
global class RestKPIMaster {
    
    @HttpGet
    global static RExAPIResponseDomain.multipleResponseInfo getKPIdata() {
        
        RExAPIResponseDomain.multipleResponseInfo response = new RExAPIResponseDomain.multipleResponseInfo();
        
        
        try {
            list<KPIWrapper.SellerKPI> KPIWrapperList=new list<KPIWrapper.SellerKPI>();
            KPIWrapper.SellerKPI TurnoverKPI = TurnOverServiceClass.getTurnOvers();
            KPIWrapperList.add(TurnoverKPI);
             KPIWrapper.SellerKPI MessageKPI=SellerMessageBoardService.getSellerMessageBoard();
              KPIWrapperList.add(MessageKPI);
           //KPIWrapper.SellerKPI SalesKPI=SalesKpi.AverageStrikerate();
           KPIWrapper.SellerKPI SalesKPI=SalesKpiServiceClass.getSalesKPIs();
            KPIWrapperList.add(SalesKPI);
            KPIWrapper.SellerKPI SalesTargets=IncentiveServiceClass.getSalesTargets();
            system.debug('SalesTargets'+SalesTargets);
            KPIWrapperList.add(SalesTargets);
            KPIWrapper.SellerKPI Keybets=Keybets.CalculateKeybets();
            KPIWrapperList.add(Keybets);
            response = KPITranslator.TranslateKPIHeaderTOJson(KPIWrapperList,null);
            
            
            
         } catch (SecurityUtility.SFDCAccessControlException ex) {
            
            system.debug(ex.getmessage());
            response = KPITranslator.TranslateKPIHeaderTOJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
        }
      
        return response;
    }
}