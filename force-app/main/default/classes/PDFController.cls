public with sharing class PDFController {
    
    Public String ObjType {get;set;}
    Public ID detailId {get;set;}
   	// Public PDFDetails PDFRecord{get;set;}
    Public list<PDFDetails> wrapperInstanceLIST = new LIST<PDFDetails>();
    
    public LIST<PDFDetails> getPDFValues() {
    
        system.debug('RelatedId'+ detailId);
        //LIST<PDFDetails> wrapperInstanceLIST = new LIST<PDFDetails>();
        // Checking if RelatedId is not NULL
        if(detailId != NULL || detailId != '') {
        	
           PDFDetails wrapperInstance = new PDFDetails();
           MAP<string,string> divisionMap = ResourceService.GetAllResourceDivisionNameIdmap();
            system.debug('divisionMap'+ divisionMap);
            if(divisionMap != NULL && !divisionMap.isEMpty()) {
                
                LIST<String> divisionLIST = new LISt<String>();
                divisionLIST.addALL(divisionMap.keySet());
               system.debug('divisionLIST'+ divisionLIST);
                wrapperInstance.divisionName  = divisionLIST[0];
            }            
            
            LIST<RintinDokoVisitDetail__c> rintinDokoRecordList = new LIST<RintinDokoVisitDetail__c>();
            if(detailId != NULL) {
                rintinDokoRecordList = [ SELECT ID, Name, Hair_Dresser__r.Name,  RintinDokoVisitActual__r.Training_Name__c,
                                        RintinDokoVisitActual__r.Date__c,
                                        
                                        RintinDokoVisitActual__r.Rintin_Plan__r.SignatureText__c,
                                        RintinDokoVisitActual__r.Rintin_Plan__r.BrandText__c, 
                                        RintinDokoVisitActual__r.Rintin_Plan__r.SubAxeText__c
                                        FROM RintinDokoVisitDetail__c 
                                        WHERE Id =: detailId limit 1];
            }
            
            if( rintinDokoRecordList.size()>0 ) {
                wrapperInstance.hairDresserName = rintinDokoRecordList[0].Hair_Dresser__r.Name;
                wrapperInstance.certificateDate = rintinDokoRecordList[0].RintinDokoVisitActual__r.Date__c;
                wrapperInstance.trainingname = rintinDokoRecordList[0].RintinDokoVisitActual__r.Training_Name__c;
                wrapperInstance.signature = rintinDokoRecordList[0].RintinDokoVisitActual__r.Rintin_Plan__r.SignatureText__c;
                wrapperInstance.brand = rintinDokoRecordList[0].RintinDokoVisitActual__r.Rintin_Plan__r.BrandText__c;
                wrapperInstance.subAxe = rintinDokoRecordList[0].RintinDokoVisitActual__r.Rintin_Plan__r.SubAxeText__c;
            }
            wrapperInstanceLIST.add(wrapperInstance);
        }
        //PDFRecord = wrapperInstance;
       return wrapperInstanceLIST;        
    }    
    
    
    
    Public class PDFDetails{
        
        public String divisionName {get;set;}
        public String hairDresserName {get;set;}
        public String programName{get;set;}
        public date certificateDate{get;set;}
        Public String trainingname{get;set;}
        Public String brand{get;set;}
        Public String subAxe{get;set;}
        Public String signature{get;set;}
    }
    
    
    
    

}