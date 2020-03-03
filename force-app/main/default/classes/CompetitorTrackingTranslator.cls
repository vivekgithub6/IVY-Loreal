public class CompetitorTrackingTranslator {
    public static void translate(List < LorealUploadclass.CompetitorHeaderInfo > CompetitorHeader,
                                List < LorealUploadclass.CompetitorDetailsInfo > CompetitorDetails,
                                List < LorealUploadclass.CompetitorPhotoDetailsInfo > CompetitorPhotoDetails) {

        List < ivybase__Visit__c > visitlist = new List < ivybase__Visit__c > ();
        ivybase__Visit__c visit = new ivybase__Visit__c();
        ivybase.AccountDomain.accountIdandNameInfo accInfo = new ivybase.AccountDomain.accountIdandNameInfo();

        map < String, ivybase__Visit__c > retailerId_VisitMap = new map < String, ivybase__Visit__c > ();
        map < String, string > retailerId_TidMap = new map < String, String > ();
        Set < String > retailInternalIds = new Set < String > ();

        List < ivybase__Standard_List_Master__c > slmList = StandardListMasterService.getStandardListUsingListType(New List < String > { 'SUB_AXE_LEVEL' });
        Map < String, String > listCodeWithName = new Map < String, String > ();

        if (slmList != null && slmList.size() > 0) {
            for (ivybase__Standard_List_Master__c slm: slmList) {

                listCodeWithName.put(slm.Name, slm.Id);
            }
        }

        System.debug('listCodeWithName:::' + listCodeWithName);

        string endpoint;
        string bucketname;
        String hostUrl;
        Map < String, ivybase__Standard_List_Master__c > TrackingListId = new Map < String, ivybase__Standard_List_Master__c > ();
        for (ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List < String > {
                                                                    ('COMPETITOR_TRACKING_TYPE'),
                                                                    ('Amazon_Configuration')
                                                                })) {

            TrackingListId.put(stdListMaster.Name, stdListMaster);
            if (stdListMaster.ivybase__List_Code__c == 'AS_BUCKET_NAME')
                bucketname = stdListMaster.ivybase__List_Name__c;
            if (stdListMaster.ivybase__List_Code__c == 'AS_END_POINT')
                endpoint = stdListMaster.ivybase__List_Name__c;
            if (stdListMaster.ivybase__List_Code__c == 'AS_HOST')
                hostUrl = stdListMaster.ivybase__List_Name__c;

        }


        map < String, LorealUploadclass.CompetitorHeaderInfo > Tid_CompetitorHeaderMAP = new map < String, LorealUploadclass.CompetitorHeaderInfo > ();
        if (CompetitorHeader != null) {
            for (LorealUploadclass.CompetitorHeaderInfo temp: CompetitorHeader) {
                Tid_CompetitorHeaderMAP.put(temp.Tid, temp);
                retailInternalIds.add(temp.RetailerId);
            }
        }

        //---------
        if (retailInternalIds.size() > 0) {

            accInfo = ivybase.Accountfacade.getAccountIdByInternalId(retailInternalIds);
            System.debug('accInfo.internalIdAndSFIdMap.values:::' + accInfo.internalIdAndSFIdMap.values());
            System.debug('ivybase.ResourceFacade.getLoginSellerId::' + ivybase.ResourceFacade.getLoginSellerId());
            visitList = ivype.VisitFacade.getVisitList(accInfo.internalIdAndSFIdMap.values(), ivybase.ResourceFacade.getLoginSellerId());
        }
        for (LorealUploadclass.CompetitorHeaderInfo temp: CompetitorHeader) {
            if (temp.RetailerId != null && temp.Date_x != null) {

                Date visitDate = (temp.Date_x.trim() != '') ? ConversionUtility.StringToDateConversion(temp.Date_x) : null;
                Id storeId = accInfo.internalIdAndSFIdMap.get(temp.RetailerId);
                System.debug('storeId::' + storeId);
                System.debug('visitDate:: ' + visitDate);
                System.debug('getVisit:::: ' + getVisit(visitList, storeId, visitDate));
                if (visitDate != null)
                    visit = (storeId != null) ? getVisit(visitList, storeId, visitDate) : new ivybase__Visit__c(Name = 'TestVisit', ivybase__Store__c = storeId, ivybase__Visit_Date__c = visitDate);
                System.debug('visit Inside::' + visit);
                retailerId_VisitMap.put(temp.RetailerId, visit);
                retailerId_TidMap.put(temp.Tid, temp.RetailerId);
                visit = new ivybase__Visit__c();
            }
        }

        //----------

        map < String, ivype__Competitor_Tracking__c > tcompetitorid_CompetitorTrackingMAP = new map < String, ivype__Competitor_Tracking__c > ();
        list < string > competitorList = new list < string > ();
        list < ivype__Competitor_Tracking__c > insertCompetiroTrakckingList = new list < ivype__Competitor_Tracking__c > ();

        Set < String > compproductInternalIds = new Set < String > ();

        map < String, map < String, ivype__Competitor_Tracking_Detail__c >> tcompetitorid_tipPid_CompetitorTrackingDetailMap = new map < String, map < String, ivype__Competitor_Tracking_Detail__c >> ();
        map < String, map < string, ivype__Photo_Capture_Tracking__c >> tcompetitorid_tipPid_PhotoCaptureTrackingMap = new map < String, map < string, ivype__Photo_Capture_Tracking__c >> ();
                                    if(CompetitorDetails!=null){
        for (LorealUploadclass.CompetitorDetailsInfo temp: CompetitorDetails) {
            tcompetitorid_tipPid_CompetitorTrackingDetailMap.put(temp.tcompetitorid, new map < string, ivype__Competitor_Tracking_Detail__c > ());
            compproductInternalIds.add(temp.tcompetitorid);
        }
                                    }

        for (LorealUploadclass.CompetitorPhotoDetailsInfo temp: CompetitorPhotoDetails) {
            tcompetitorid_tipPid_PhotoCaptureTrackingMap.put(temp.tcompetitorid, new map < string, ivype__Photo_Capture_Tracking__c > ());
            compproductInternalIds.add(temp.tcompetitorid);
        }

        Map < String, ProductDomain.cls_ProductService > InternalIdwithpidorphidMap = ProductService.getPhIdOrProdId(compproductInternalIds);
                                    system.debug('InternalIdwithpidorphidMap'+InternalIdwithpidorphidMap);
        integer tempInt = 0;
        //System.debug(CompetitorDetails.size());
        
        if (CompetitorDetails != null) {
            for (LorealUploadclass.CompetitorDetailsInfo temp: CompetitorDetails) {
                //---------------------
                ProductDomain.cls_ProductService prodservice = InternalIdwithpidorphidMap.get(temp.tcompetitorid);
                system.debug('prodservice '+prodservice);
                if (tcompetitorid_CompetitorTrackingMAP.get(temp.tcompetitorid) == null) {
                    Id tempVisitId = null;
                    if (retailerId_TidMap.get(temp.Tid) != null) {
                        if (retailerId_VisitMap.get(retailerId_TidMap.get(temp.Tid)) != null) {
                            tempVisitId = retailerId_VisitMap.get(retailerId_TidMap.get(temp.Tid)).Id;
                        }
                    }

                    ivype__Competitor_Tracking__c compTrack = new ivype__Competitor_Tracking__c();
                    compTrack.ivype__Visit__c = tempVisitId;
                    if (prodservice.objtype == 'ivybase__Product__c') {
                        compTrack.Competitor_Product__c = prodservice.sfid;
                    } else if (prodservice.objtype == 'ivybase__Product_Hierarchy__c') {
                        compTrack.Competitor_ProductHierarchy__c = prodservice.sfid;
                    }
                    /*remove code if changes required*/
                    compTrack.Average_Price__c = temp.avgPrice.length() == 0 || temp.avgPrice == null ? 0 : Decimal.valueOf(temp.avgPrice);
                    compTrack.ivype__Comment__c = temp.Comments;
                    compTrack.Contract__c = temp.contract.length() == 0 || temp.contract == null ? 0 : Integer.valueOf(temp.contract);
                    compTrack.Educational_Visit_Frequency__c = temp.FrqOfEduVisit.length() == 0 || temp.FrqOfEduVisit == null ? 0 : Decimal.valueOf(temp.FrqOfEduVisit);
                    compTrack.Quantity__c = temp.qty.length() == 0 || temp.qty == null ? 0 : Decimal.valueOf(temp.qty);
                    compTrack.No_Of_Training__c = temp.NoOfTraining.length() == 0 || temp.NoOfTraining == null ? 0 : Decimal.valueOf(temp.NoOfTraining);
                    compTrack.Quantity_Size__c = temp.qtySize.length() == 0 || temp.qtySize == null ? 0 : Decimal.valueOf(temp.qtySize);
                    compTrack.Rebate__c = temp.Rebate.length() == 0 || temp.Rebate == null ? 0 : Decimal.valueOf(temp.Rebate);
                    compTrack.SalesRep_Visit_Frequency__c = temp.FrqOfRepVisit.length() == 0 || temp.FrqOfRepVisit == null ? 0 : Decimal.valueOf(temp.FrqOfRepVisit);
                    compTrack.Retailer_Price__c = temp.RetailPrice.length() == 0 || temp.RetailPrice == null ? 0 : Decimal.valueOf(temp.RetailPrice);
                    compTrack.Type_Of_Training__c = temp.TypeOfTraining;
                    /*upto here*/
                    
                    insertCompetiroTrakckingList.add(compTrack);
                    competitorList.add(temp.tcompetitorid);
                    tcompetitorid_CompetitorTrackingMAP.put(temp.tcompetitorid, compTrack);
                    //**********

                    //System.debug('super');
                    //*********
                }
                try {
                    ivype__Competitor_Tracking_Detail__c trackDetail = new ivype__Competitor_Tracking_Detail__c();

                    trackDetail.Average_Price__c = temp.avgPrice.length() == 0 || temp.avgPrice == null ? 0 : Decimal.valueOf(temp.avgPrice);
                    trackDetail.ivype__Comment__c = temp.Comments;
                    //trackDetail.Competitor_ProductHierarchy__c = prodservice.sfid;
                    //---added by pranav
                    if (prodservice.objtype == 'ivybase__Product__c') {
                        trackDetail.Competitor_Product__c = prodservice.sfid;
                    } else if (prodservice.objtype == 'ivybase__Product_Hierarchy__c') {
                        trackDetail.Competitor_ProductHierarchy__c = prodservice.sfid;
                    }
                    //-----end
                    trackDetail.ivype__Competitor_Tracking__c = null;
                    trackDetail.Contract__c = temp.contract.length() == 0 || temp.contract == null ? 0 : Integer.valueOf(temp.contract);
                    trackDetail.Educational_Visit_Frequency__c = temp.FrqOfEduVisit.length() == 0 || temp.FrqOfEduVisit == null ? 0 : Decimal.valueOf(temp.FrqOfEduVisit);
                    trackDetail.Quantity__c = temp.qty.length() == 0 || temp.qty == null ? 0 : Decimal.valueOf(temp.qty);
                    trackDetail.No_Of_Training__c = temp.NoOfTraining.length() == 0 || temp.NoOfTraining == null ? 0 : Decimal.valueOf(temp.NoOfTraining);
                    trackDetail.Quantity_Size__c = temp.qtySize.length() == 0 || temp.qtySize == null ? 0 : Decimal.valueOf(temp.qtySize);
                    trackDetail.Rebate__c = temp.Rebate.length() == 0 || temp.Rebate == null ? 0 : Decimal.valueOf(temp.Rebate);
                    trackDetail.SalesRep_Visit_Frequency__c = temp.FrqOfRepVisit.length() == 0 || temp.FrqOfRepVisit == null ? 0 : Decimal.valueOf(temp.FrqOfRepVisit);
                    trackDetail.Retailer_Price__c = temp.RetailPrice.length() == 0 || temp.RetailPrice == null ? 0 : Decimal.valueOf(temp.RetailPrice);
                    trackDetail.Type_Of_Training__c = temp.TypeOfTraining;
                    trackDetail.ivype__TrackingListId__c = listCodeWithName.get(temp.pid);
                    tcompetitorid_tipPid_CompetitorTrackingDetailMap.get(temp.tcompetitorid).put(temp.tcompetitorid + '' + temp.Tid + '' + temp.pid, trackDetail);
                    tempInt++;
                } catch (Exception e) {
                    System.debug(e.getCause() + ' ' + e.getLineNumber() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
                }

                //----------------------------

            }
            System.debug(tempInt);
        }
        if (CompetitorPhotoDetails != null) {
            for (LorealUploadclass.CompetitorPhotoDetailsInfo temp: CompetitorPhotoDetails) {
                ProductDomain.cls_ProductService prodservice = new ProductDomain.cls_ProductService();
                //------------------
                if (InternalIdwithpidorphidMap.containsKey(temp.tcompetitorid))
                    prodservice = InternalIdwithpidorphidMap.get(temp.tcompetitorid);
                if (tcompetitorid_CompetitorTrackingMAP.containsKey(temp.tcompetitorid)) {
                    if (tcompetitorid_CompetitorTrackingMAP.get(temp.tcompetitorid) == null) {
                        Id tempVisitId = null;
                        if (retailerId_TidMap.containsKey(temp.Tid)) {
                            if (retailerId_TidMap.get(temp.Tid) != null) {
                                if (retailerId_VisitMap.containsKey(retailerId_TidMap.get(temp.Tid))) {
                                    if (retailerId_VisitMap.get(retailerId_TidMap.get(temp.Tid)) != null) {
                                        tempVisitId = retailerId_VisitMap.get(retailerId_TidMap.get(temp.Tid)).Id;
                                    }
                                }
                            }
                        }
                        ivype__Competitor_Tracking__c compTrack = new ivype__Competitor_Tracking__c();
                        compTrack.ivype__Visit__c = tempVisitId;
                        if (prodservice.objtype == 'ivybase__Product__c') {
                            compTrack.Competitor_Product__c = prodservice.sfid;
                        } else if (prodservice.objtype == 'ivybase__Product_Hierarchy__c') {
                            compTrack.Competitor_ProductHierarchy__c = prodservice.sfid;
                        }
                        insertCompetiroTrakckingList.add(compTrack);
                        competitorList.add(temp.tcompetitorid);
                        tcompetitorid_CompetitorTrackingMAP.put(temp.tcompetitorid, compTrack);
                        //*************

                        //*************
                    }
                }
                system.debug('competitorList123add'+competitorList);
                try {
                    ivype__Photo_Capture_Tracking__c Photo_Capture_Trackingm = new ivype__Photo_Capture_Tracking__c();
                    if (temp.avgPrice != null && String.isEmpty(temp.avgPrice) == false) {
                        Photo_Capture_Trackingm.Average_Price__c = ConversionUtility.StringToDecimal(temp.avgPrice);
                    }
                    if (temp.Description != null) {
                        Photo_Capture_Trackingm.ivype__Comment__c = temp.Description;
                    }
                    if (temp.Name != null) {
                        Photo_Capture_Trackingm.Competitor_Name__c = temp.Name;
                    }
                    Photo_Capture_Trackingm.Competitor_Tracking__c = null;
                    if (temp.ImageName != null) {
                        Photo_Capture_Trackingm.Image_Name__c = temp.ImageName;
                    }
                    if (temp.ImagePath != null) {
                        //compTrack.ivype__ImagePath__c = endpoint+'/'+bucketname+'/'+temp.ImagePath;
                        Photo_Capture_Trackingm.Image_Path__c = hostUrl + '/' + temp.ImagePath;
                    }
                    if (!String.isBlank(temp.tcompetitorid) && InternalIdwithpidorphidMap.containskey(temp.tcompetitorid) && InternalIdwithpidorphidMap.get(temp.tcompetitorid)!=null) {
                       system.debug('InternalIdwithpidorphidMap123'+InternalIdwithpidorphidMap);
                     //------added by pranav
                        if (InternalIdwithpidorphidMap.get(temp.tcompetitorid).objtype == 'ivybase__Product__c') {
                            Photo_Capture_Trackingm.ivype__Product__c = InternalIdwithpidorphidMap.get(temp.tcompetitorid).sfid;
                        } else if (InternalIdwithpidorphidMap.get(temp.tcompetitorid).objtype == 'ivybase__Product_Hierarchy__c') {
                            Photo_Capture_Trackingm.ivype__Product_Hierarchy__c = InternalIdwithpidorphidMap.get(temp.tcompetitorid).sfid;
                        }
                        //----end
                        //Photo_Capture_Trackingm.ivype__Product_Hierarchy__c = prodservice.sfid;
                    }
                    if (temp.qty != null && String.isEmpty(temp.qty) == false) {
                        Photo_Capture_Trackingm.Quantity__c = ConversionUtility.StringToInteger(temp.qty);
                    }
                    if (temp.qtysize != null && String.isEmpty(temp.qtysize) == false) {
                        Photo_Capture_Trackingm.Quantity_Size__c = ConversionUtility.StringToInteger(temp.qtysize);
                    }
                    if (temp.SellingPrice != null && String.isEmpty(temp.SellingPrice) == false) {
                        Photo_Capture_Trackingm.Selling_Price__c = ConversionUtility.StringToDecimal(temp.SellingPrice);
                    }
                   system.debug('tcompetitorid_tipPid_PhotoCaptureTrackingMap'+tcompetitorid_tipPid_PhotoCaptureTrackingMap);
                    if (tcompetitorid_tipPid_PhotoCaptureTrackingMap.containsKey(temp.tcompetitorid))
                        tcompetitorid_tipPid_PhotoCaptureTrackingMap.get(temp.tcompetitorid).put(temp.Name + '' + temp.tcompetitorid, Photo_Capture_Trackingm);
                } catch (Exception e) {
                    System.debug(e.getCause() + ' ' + e.getLineNumber() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
                }
                //--------------------
            }
        }
        if(insertCompetiroTrakckingList != null && insertCompetiroTrakckingList.isEmpty() == false) {
            insert insertCompetiroTrakckingList;
        }
        system.debug(insertCompetiroTrakckingList.size());
        for (Integer i = 0; i < competitorList.size(); i++) {
            string tempCompetiorId = competitorList[i];
            ivype__Competitor_Tracking__c compTrack = insertCompetiroTrakckingList[i];
            tcompetitorid_CompetitorTrackingMAP.put(tempCompetiorId, compTrack);
        }
        list < ivype__Competitor_Tracking_Detail__c > insertCompetitor_Tracking_DetailList = new list < ivype__Competitor_Tracking_Detail__c > ();
        list < ivype__Photo_Capture_Tracking__c > insertPhoto_Capture_TrackingList = new list < ivype__Photo_Capture_Tracking__c > ();
       system.debug('competitorList'+competitorList);
         system.debug('tcompetitorid_tipPid_CompetitorTrackingDetailMap'+tcompetitorid_tipPid_CompetitorTrackingDetailMap);                           
         for (String tempCompetiorId: competitorList) {
            if (tcompetitorid_tipPid_CompetitorTrackingDetailMap.containsKey(tempCompetiorId)) {
                if (tcompetitorid_tipPid_CompetitorTrackingDetailMap.get(tempCompetiorId) != null) {
                    for (ivype__Competitor_Tracking_Detail__c Competitor_Tracking_Detail: tcompetitorid_tipPid_CompetitorTrackingDetailMap.get(tempCompetiorId).values()) {
                        Competitor_Tracking_Detail.ivype__Competitor_Tracking__c = tcompetitorid_CompetitorTrackingMAP.get(tempCompetiorId).id;
                        insertCompetitor_Tracking_DetailList.add(Competitor_Tracking_Detail);
                    }
                }
            }
                system.debug('tcompetitorid_tipPid_PhotoCaptureTrackingMap'+tcompetitorid_tipPid_PhotoCaptureTrackingMap);
            if (tcompetitorid_tipPid_PhotoCaptureTrackingMap.containsKey(tempCompetiorId)) {
                if (tcompetitorid_tipPid_PhotoCaptureTrackingMap.get(tempCompetiorId) != null) {
                    for (ivype__Photo_Capture_Tracking__c Photo_Capture_Tracking: tcompetitorid_tipPid_PhotoCaptureTrackingMap.get(tempCompetiorId).values()) {
                        Photo_Capture_Tracking.Competitor_Tracking__c = tcompetitorid_CompetitorTrackingMAP.get(tempCompetiorId).id;
                        insertPhoto_Capture_TrackingList.add(Photo_Capture_Tracking);
                    }
                }
            }
        }
        System.debug('insert phto'+insertPhoto_Capture_TrackingList);
                                    system.debug('insertCompetitor_Tracking_DetailList'+insertCompetitor_Tracking_DetailList);
        if(insertCompetitor_Tracking_DetailList != null && insertCompetitor_Tracking_DetailList.isEmpty() == false) {
            insert insertCompetitor_Tracking_DetailList;
        }
        if(insertPhoto_Capture_TrackingList != null && insertPhoto_Capture_TrackingList.isEmpty() == false) {
            insert insertPhoto_Capture_TrackingList;
        }
        System.debug(insertCompetitor_Tracking_DetailList.size());
        //System.debug(insertPhoto_Capture_TrackingList.size());
    }
    public static Date convertStringToDate(String datestr) {

        Date dateVal;
        List < String > dateList;
        if(datestr!=null)
        dateList = datestr.split('/');
        dateVal = Date.newInstance(Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]));
        return dateVal;
    }
    public static ivybase__Visit__c getVisit(List < ivybase__Visit__c > visitlist, Id storeId, Date visitDate) {

        for (ivybase__Visit__c visit: visitlist) {

            if (visit.ivybase__Store__c == storeId && visit.ivybase__Visit_Date__c == visitDate) {
                return visit;
            }
        }
        return null;
    }


}