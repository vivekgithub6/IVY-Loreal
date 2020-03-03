/*
* Test class Name : TESTLOrealUpload
*/
@RestResource(urlMapping='/v1/LOrealUpload')
global with sharing class LOrealUpload {
    
    global static String jsonRes;
    @HTTPPost
    global static List<PostResponse.PostResponseObject> UploadHandler(){
        
        List<PostResponse.PostResponseObject> response = new List<PostResponse.PostResponseObject>();
        String ExtraMessage='';
        RestRequest req = RestContext.request;
        Map<String, String> reqHeaderParamMap = req.headers; 
        Blob requestBody = req.requestBody;
        String requestStr = requestBody.toString();
        requestStr = requestStr.replace('"date"','"date_x"');
        requestStr = requestStr.replace('"HId"','"HAId"');
        requestStr = requestStr.replace('"Date"', '"Date_x"');
        requestStr = requestStr.replace('"CompetitorHeader"','"CompetitorHeaderNew"');
        requestStr = requestStr.replace('"CompetitorDetails"', '"CompetitorDetailsNew"');
        requestStr = requestStr.replace('"CompetitorPhotoDetails"','"CompetitorPhotoDetailsNew"');
        requestStr = requestStr.replace('"SchemeDetail"','"SchemeDetailNew"');
        requestStr = requestStr.replace('"OrderDetail"','"OrderDetailNew"');
        requestStr = requestStr.replace('"OrderHeader"','"OrderHeaderNew"');
        requestStr = requestStr.replace('"SchemeFreeProductDetail"','"SchemeFreeProductDetailNew"');
        requestStr=requestStr.replace('"LastVisitDate"', '"Date_x"');
        PostResponse.PostResponseObject resp = new PostResponse.PostResponseObject();
        ivybase__Upload_Status__c  upload = new ivybase__Upload_Status__c ();
        upload.ivybase__Status__c='Processing';
        
        upload.name=UserInfo.getName()+'-'+DateTime.now()+''; 
        insert upload;
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf(requestStr);
        attachment.Name = UserInfo.getName()+'-'+DateTime.now()+'- Upload.txt'; 
        attachment.ParentId = upload.Id; 
        insert attachment;
        asyncUpload(requestStr,reqHeaderParamMap,upload.id);
        resp.Response = '1';
        resp.ErrorMsg = 'Success';
        response.add(resp);
        return response;
    }
    
    @future (callout=true) public static void asyncUpload(String requestStr,Map<String, String> reqHeaderParamMap,id uploadId)
    {
        ivybase__Upload_Status__c  upload = [select id,name,ivybase__Error_Description__c,ivybase__Status__c from ivybase__Upload_Status__c where id=:uploadId];
        PostResponse.PostResponseObject resp = new PostResponse.PostResponseObject();
        try{
            Map<String, List<SObject>> params = new Map<String, List<SObject>> ();
            Boolean skipRExCommonLogic = true;
            //--added newly
            LorealUploadclass.MultipleResponseInfo jsonCastVar = (LorealUploadclass.MultipleResponseInfo)JSON.deserialize(requestStr,LorealUploadclass.MultipleResponseInfo.class);
            //visit and visit detail Upload area
            List<PostResponse.PostResponseObject> resultUploadVisitDetails = LOrealUploadTranslator.uploadVisitDetails(jsonCastVar.OutletTimestamp, jsonCastVar.OutletTimeStampDetail, jsonCastVar.Nonproductivereasonmaster);
            for(PostResponse.PostResponseObject r: resultUploadVisitDetails) {
                if(r.Response=='0') {
                    if(r.ErrorMsg.contains('Error')) {
                        resp.Response='0';
                        resp.ErrorMsg+='\n'+r.ErrorMsg;
                    }
                }
            }
            
            if(!test.isRunningTest()){
                List<Map<String,String>> inst1 = ivype.RexUploadFacade.RExUpload(requestStr, reqHeaderParamMap, params);
                List<Map<String, String>> inst2 = ivydsd.DSDUploadFacade.DSDUpload(requestStr, reqHeaderParamMap, params, skipRExCommonLogic);
            }
           // System.debug('::::inst1:::'+inst1);
           // System.debug('::::inst2:::'+inst2);
            resp=AsyncLorealUpload(requestStr, reqHeaderParamMap);
            if(resp.Response=='0')
            {
                upload.ivybase__Error_Description__c=resp.ErrorMsg; 
                upload.ivybase__Status__c='Failure';
                
            }
            else
            {
                upload.ivybase__Error_Description__c='';
                upload.ivybase__Status__c='Success';
                
            }
        }catch(Exception e)
        {
            
            upload.ivybase__Error_Description__c=resp.ErrorMsg+e.getCause()+e.getMessage()+e.getStackTraceString()+e.getTypeName(); 
            upload.ivybase__Status__c='Failure';
            
        }
        update upload;
    }
    public static PostResponse.PostResponseObject AsyncLorealUpload(String paramRequestStr, Map<String, String> reqHeaderParamMap){
        /*Id currentUserId = UserInfo.getUserId();
ivybase__Resource__c resList = [SELECT Id, ivybase__Related_User__c,ivybase__Location_Hierarchy__c,ivybase__Resource_Type__c FROM ivybase__Resource__c WHERE ivybase__Related_User__c = :currentUserId limit 1];

map<string,string> statusMapListCode = new map<string,string>();
map<string,string> statusMapListName = new map<string,string>();
for(ivybase__Standard_List_Master__c stMaster: [select name,ivybase__List_Code__c,ivybase__List_Name__c,ivybase__List_Type__c from ivybase__Standard_List_Master__c where ivybase__Location_Hierarchy__c =:resList.ivybase__Location_Hierarchy__c AND ivybase__Resource_Type__c=:reslist.ivybase__Resource_Type__c])
{
statusMapListCode.put(stMaster.Name,stMaster.ivybase__List_Name__c);
statusMapListName.put(stMaster.Name,stMaster.ivybase__List_Code__c);
}*/
        system.debug('Entered AsyncUpload');
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        system.debug('userTerritory'+userTerritory);
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            
            LorealUploadclass.MultipleResponseInfo jsonCastVar = (LorealUploadclass.MultipleResponseInfo)JSON.deserialize(paramRequestStr,LorealUploadclass.MultipleResponseInfo.class);
            system.debug('jsonCastVar '+jsonCastVar);
            //visit and visit detail Upload area
            /* List<PostResponse.PostResponseObject> resultUploadVisitDetails = LOrealUploadTranslator.uploadVisitDetails(jsonCastVar.OutletTimestamp, jsonCastVar.OutletTimeStampDetail, jsonCastVar.Nonproductivereasonmaster);
for(PostResponse.PostResponseObject r: resultUploadVisitDetails) {
if(r.Response=='0') {
if(r.ErrorMsg.contains('Error')) {
str.Response='0';
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}
}*/
            //Retailer Edit  
            List<PostResponse.PostResponseObject> resultForRetailerEdit=LOrealUploadTranslator.RetailerEditTransaction(jsonCastVar.NewRetailerEditHeader,jsonCastVar.NewRetailerEditDetail,jsonCastVar.HairDresserNew);
            for(PostResponse.PostResponseObject r:resultForRetailerEdit)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        if(str.ErrorMsg.contains('Success'))
                        {
                            str.ErrorMsg=r.ErrorMsg;  
                        }
                        else{
                            str.ErrorMsg+='\n'+r.ErrorMsg;
                        }
                    }
                    
                }
            }  
            
            //JourneyPlan Upload area
            List<PostResponse.PostResponseObject> resultForJourneyPlan=LOrealUploadTranslator.journeyPlanTransaction(jsonCastVar.JourneyPlanHeader,jsonCastVar.JourneyPlan_MarketVisitDetail,jsonCastVar.JourneyPlanDetail,userTerritory,jsonCastVar.RintinDokoHeader);
            for(PostResponse.PostResponseObject r:resultForJourneyPlan)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.contains('Error'))
                    {
                        str.Response='0';
                        str.ErrorMsg+='\n'+r.ErrorMsg;
                        
                    }
                    
                }
            }
            
            // This is for Japan, AdhocActivityPlanDetail.
            
            LIST<PostResponse.PostResponseObject> resultForAdhocActivityPlan = LOrealUploadTranslator.AdhocActivityPlanDetailTransaction(jsonCastVar.AdhocActivityPlanDetail);
            for(PostResponse.PostResponseObject adhocResult : resultForAdhocActivityPlan) {
                 if(adhocResult.Response=='0')
                {
                    if(adhocResult.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        str.ErrorMsg+='\n'+adhocResult.ErrorMsg;
                        
                    }
                }
            }
            
            //CompetitorTracking Upload area
            System.debug('CompetitorTracking:::');
            List<PostResponse.PostResponseObject> resultForCompetitorTracking=LOrealUploadTranslator.CompetitorTrackingTransaction(jsonCastVar.CompetitorHeaderNew,jsonCastVar.CompetitorDetailsNew,jsonCastVar.CompetitorPhotoDetailsNew);
            System.debug('resultForCompetitorTracking:::'+resultForCompetitorTracking);
            for(PostResponse.PostResponseObject r:resultForCompetitorTracking)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        str.ErrorMsg+='\n'+r.ErrorMsg;
                        
                    }
                    
                }
            }
            //Promotional Planning Upload Area
            List<PostResponse.PostResponseObject> resultForPromotionalPlan=LOrealUploadTranslator.PromotionalPlanningTransaction(jsonCastVar.PromotionalPlanningHeader,jsonCastVar.PromotionalPlanningDetails,userTerritory);
            for(PostResponse.PostResponseObject r:resultForPromotionalPlan)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        str.ErrorMsg+='\n'+r.ErrorMsg;
                        
                    }
                    
                }
            } 
            //Dream List
            system.debug('jsonCastVar.DreamList'+jsonCastVar);
            List<PostResponse.PostResponseObject> resultForDreamList=LOrealUploadTranslator.DreamListTransaction(jsonCastVar.RetailerDreamList);
            for(PostResponse.PostResponseObject r:resultForDreamList)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        if(str.ErrorMsg.contains('Success'))
                        {
                            str.ErrorMsg=r.ErrorMsg;  
                        }
                        else{
                            str.ErrorMsg+='\n'+r.ErrorMsg;
                        }
                    }
                    
                }
            } 
            //HaiDresser
            /* List<PostResponse.PostResponseObject> resultForHairDresserList=LOrealUploadTranslator.HairDresserListTransaction(jsonCastVar.HairDresserNew);
for(PostResponse.PostResponseObject r:resultForHairDresserList)
{
if(r.Response=='0')
{
if(r.ErrorMsg.containsIgnoreCase('Error'))
{
str.Response='0';
if(str.ErrorMsg.contains('Success'))
{
str.ErrorMsg=r.ErrorMsg;  
}
else{
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}

}
} */
            
            
            // Commented code for japan deployment
           //OrderHeader and Detail Transaction
            List<PostResponse.PostResponseObject> resultForOrderHeaderAndDetail=LOrealUploadTranslator.orderTransaction(jsonCastVar.OrderHeaderNew,jsonCastVar.OrderDetailNew,jsonCastVar.SchemeDetailNew,jsonCastVar.SchemeFreeProductDetailNew);
            for(PostResponse.PostResponseObject r:resultForOrderHeaderAndDetail)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        str.ErrorMsg+='\n'+r.ErrorMsg;
                        
                    }
                    
                }
            }
            //--order headerDetail end-- 
            
            /*List<PostResponse.PostResponseObject> resultForRetailerCheckList=LOrealUploadTranslator.RetailerCheckListTransaction(jsonCastVar.DocumentDetail);
for(PostResponse.PostResponseObject r:resultForRetailerCheckList)
{
if(r.Response=='0')
{
if(r.ErrorMsg.containsIgnoreCase('Error'))
{
str.Response='0';
if(str.ErrorMsg.contains('Success'))
{
str.ErrorMsg=r.ErrorMsg;  
}
else{
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}

}
} 
*/
            // Commented for uploading for Japan
            //Retailer Edit  
            /*  List<PostResponse.PostResponseObject> resultForRetailerEdit=LOrealUploadTranslator.RetailerEditTransaction(jsonCastVar.NewRetailerEditHeader,jsonCastVar.NewRetailerEditDetail,jsonCastVar.HairDresserNew);
for(PostResponse.PostResponseObject r:resultForRetailerEdit)
{
if(r.Response=='0')
{
if(r.ErrorMsg.containsIgnoreCase('Error'))
{
str.Response='0';
if(str.ErrorMsg.contains('Success'))
{
str.ErrorMsg=r.ErrorMsg;  
}
else{
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}

}
}  
*///Not using the above because it is creaated above
            
            
            // Survey
            if(jsonCastVar.AnswerHeaderNew!=null && jsonCastVar.AnswerDetailNew!=null)
            {
                Set<String> surveyInternalIds = new Set<String>();
                Set<String> storeInternalIds = new Set<String>();
                Set<String> questionInternalIds = new Set<String>();
                Map<String,Boolean> syncprocessMap = SyncProcessConfigurationService.getsyncprocesses();
                List<Set<String>> surveyAnsStoreInternalIds = AnswerTranslator.getInternalIds(jsonCastVar.AnswerHeaderNew);
                questionInternalIds = AnswerTranslator.getQuestionInternalId(jsonCastVar.AnswerDetailNew);
                if (surveyAnsStoreInternalIds != null && surveyAnsStoreInternalIds.size() >=2) {
                    surveyInternalIds = surveyAnsStoreInternalIds[0];
                    storeInternalIds = surveyAnsStoreInternalIds[1];
                }     
                system.debug('surveyInternalIds'+ surveyInternalIds);
                Map<String, ivybase__Survey__c> surveyInternalIdwithId =surveyInternalIds!=null ? SurveyService.getSurveyIds(surveyInternalIds) : null;
                system.debug('surveyInternalIdwithId'+ surveyInternalIdwithId);
                ivybase__Resource__c resource = ivybase.ResourceFacade.getSellerId(userInfo.getUserId());
                Id sellerId = resource != null ? resource.Id : null;
                
                Map<String, Id> storeInternalIdwithId = storeInternalIds!=null ? AccountService.getAccIdbyInternalIdandrectype_Map(storeInternalIds,'Retail_Account') : null;
                Map<String, Id> quetionInternalIdwithId = questionInternalIds!=null ? SurveyService.getSurveyQuestionsByInternalId(questionInternalIds) : null; 
                Map<String, Id> surveyquestionWithQuestionIdMap = SurveyQuestionService.getSuveryQuestionUsingSurveyandQuestionInternalId(surveyInternalIds, questionInternalIds);   
                List<PostResponse.PostResponseObject> resultForSurvey=LOrealUploadTranslator.surveyUpload(jsonCastVar.AnswerHeaderNew,jsonCastVar.AnswerDetailNew,surveyInternalIdwithId,sellerId,storeInternalIdwithId,quetionInternalIdwithId,surveyquestionWithQuestionIdMap,reqHeaderParamMap ); 
                
                for(PostResponse.PostResponseObject r:resultForSurvey)
                {
                    if(r.Response=='0')
                    {
                        if(r.ErrorMsg.containsIgnoreCase('Error'))
                        {
                            str.Response='0';
                            if(str.ErrorMsg.contains('Success'))
                            {
                                str.ErrorMsg=r.ErrorMsg;  
                            }
                            else{
                                str.ErrorMsg+='\n'+r.ErrorMsg;
                            }
                        }
                    }
                }
            }
            
            //orederReturn Edit 
            
            /*List<PostResponse.PostResponseObject> resultForOrderReturn=LOrealUploadTranslator.OrderReturnTransaction(jsonCastVar.SalesReturnHeader,jsonCastVar.SalesReturnDetails);
for(PostResponse.PostResponseObject r:resultForOrderReturn)
{
if(r.Response=='0')
{
if(r.ErrorMsg.containsIgnoreCase('Error'))
{
str.Response='0';
if(str.ErrorMsg.contains('Success'))
{
str.ErrorMsg=r.ErrorMsg;  
}
else{
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}

}
}*/
            
            
            // To send data only for japan
            ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
            
            if(loggedInResource.Market_ISO__c == 'JPN') {
                
                
                // Rintin and Doko
                List<PostResponse.PostResponseObject> rintinDokoReturn=LOrealUploadTranslator.RintinDokoTransaction(jsonCastVar.RintinDokoHeader,jsonCastVar.RintinDokoSalonDetails,jsonCastVar.RintinDokoHairdresserAndAgentDetails);
                system.debug('rintinDokoReturn'+ rintinDokoReturn);
                for(PostResponse.PostResponseObject r:rintinDokoReturn)
                {
                    if(r.Response=='0')
                    {
                        if(r.ErrorMsg.containsIgnoreCase('Error'))
                        {
                            str.Response='0';
                            if(str.ErrorMsg.contains('Success'))
                            {
                                str.ErrorMsg=r.ErrorMsg;  
                            }
                            else{
                                str.ErrorMsg+='\n'+r.ErrorMsg;
                            }
                        }
                        
                    }
                }
                
                //RINTIN & DOKO ACTUALS :
                
                List<PostResponse.PostResponseObject> rintinDokoActualsReturn=LOrealUploadTranslator.RintinDokoActualsTransaction( jsonCastVar.RintinDokoVisitHeader, jsonCastVar.RintinDokoVisitDetail );
                /*system.debug('rintinDokoReturn'+ rintinDokoReturn);
for(PostResponse.PostResponseObject r:rintinDokoReturn)
{
if(r.Response=='0')
{
if(r.ErrorMsg.containsIgnoreCase('Error'))
{
str.Response='0';
if(str.ErrorMsg.contains('Success'))
{
str.ErrorMsg=r.ErrorMsg;  
}
else{
str.ErrorMsg+='\n'+r.ErrorMsg;
}
}

}
} */           
                
            }
            //Digital content upload data
            List<PostResponse.PostResponseObject> DigitalContentActual=LOrealUploadTranslator.Digitalcontentdata(jsonCastVar.DigitalContentTrainingDetail);
            for(PostResponse.PostResponseObject r:DigitalContentActual)
            {
                if(r.Response=='0')
                {
                    if(r.ErrorMsg.containsIgnoreCase('Error'))
                    {
                        str.Response='0';
                        if(str.ErrorMsg.contains('Success'))
                        {
                            str.ErrorMsg=r.ErrorMsg;  
                        }
                        else{
                            str.ErrorMsg+='\n'+r.ErrorMsg;
                        }
                    }
                    
                }
            }
            
        }
        catch (Exception e)
        {   
            System.debug('Error: '+e.getMessage());
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg;
            //ErrorLogUtility.processGenericErrors('','RESTBATUpload','AsyncBATUpload','BATPostResponse.BATPostResponseObject',e.getStackTraceString(),e.getMessage(),String.valueOf(e.getCause()));
            
        }
        
        return str;
    }    
}