public class ActivityCalculationBatchHandler {
    
    public Static void CalculateRecords(LIST<ivybase__Resource__c> ScopeRecords) {
        
        SET<Id> relatedUserIdSET = new SET<Id>();
        SET<String> activityLIST = new SET<String>{'Business Visit','Agent Visit','Rinten','Doko'};
        MAP<Id,  Integer> aPlanJPActivityMAP = new MAP<Id, Integer>();
        MAP<Id,Integer> bPlanJPActivityMap = new MAP<Id, Integer>();
        
        Integer calculatedMonth; // To store month of the calculated date for the batch
        Integer calculateYear;
        system.debug('ScopeRecords'+ ScopeRecords);
        
        for(ivybase__Resource__c resource : ScopeRecords) {
            relatedUserIdSET.add(resource.ivybase__Related_User__c);
        }
        
        system.debug('relatedUserIdSET'+ relatedUserIdSET);
        
        for(ivybase__Visit__c visit : [select Id, Name, ivybase__Time_In__c,ivybase__Visit_Date__c, ivybase__Time_Out__c, ivybase__Type__c, JourneyPlan_Activity__r.Date__c, JourneyPlan_Activity__r.Start_Time__c, JourneyPlan_Activity__r.End_Time__c, JourneyPlan_Activity__r.Activity_Name__c, CreatedById, ivybase__Resource__r.ivybase__Related_User__c FROM ivybase__Visit__c WHERE (JourneyPlan_Activity__r.Date__c = TODAY AND ivybase__Status__c = 'Completed') OR (ivybase__Status__c = 'Completed' AND ivybase__Type__c ='Unplanned' and ivybase__Visit_Date__c = today)]){
            
            Time startTime ;
            Time endTime;
            Long differenceTime;
            if(visit.JourneyPlan_Activity__r.Start_Time__c != NULL)
                startTime = Time.newInstance(Integer.valueOf(visit.JourneyPlan_Activity__r.Start_Time__c.Split(':')[0]), Integer.valueOf(visit.JourneyPlan_Activity__r.Start_Time__c.Split(':')[1]), 0, 0);
            if(visit.JourneyPlan_Activity__r.End_Time__c != NULL)
                endTime = Time.newInstance(Integer.valueOf(visit.JourneyPlan_Activity__r.End_Time__c.Split(':')[0]), Integer.valueOf(visit.JourneyPlan_Activity__r.End_Time__c.Split(':')[1]), 0, 0);
            if(endTime != NULL && startTime != NULL)
                differenceTime = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute());
            
            if(visit.JourneyPlan_Activity__r.Date__c != NULL) {
                calculatedMonth = visit.JourneyPlan_Activity__r.Date__c.Month();
                calculateYear = visit.JourneyPlan_Activity__r.Date__c.year();
            }
            
            if(visit.JourneyPlan_Activity__c == NULL) {
                
                //Long differenceTime = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute()); 
                Long  startTimed = visit.ivybase__Time_In__c.gettime();
                Long  endTimed = visit.ivybase__Time_Out__c.gettime();
                
                system.debug('startTimed '+ startTimed);
                system.debug('endTimed '+ endTimed);
                
                Long  milliseconds = endTimed - startTimed;
                
                long seconds = milliseconds/1000;
                
                Long minutes = seconds/60;
                
                if(seconds != NULL && minutes != 0){
					differenceTime = minutes;
                } else if(seconds != NULL && minutes == 0){
                     differenceTime = 1;
                }
                calculatedMonth = visit.ivybase__Visit_Date__c.Month();
                calculateYear = visit.ivybase__Visit_Date__c.year();
                
            }  
            
            system.debug('differenceTime'+ differenceTime);
            system.debug('calculatedMonth: visit '+ calculatedMonth); 
            system.debug('calculateYear: visit '+ calculateYear);
            system.debug('visit**'+ visit+ '**&& '+ visit.JourneyPlan_Activity__r.Activity_Name__c);
            
            if(activityLIST.contains(visit.JourneyPlan_Activity__r.Activity_Name__c) || visit.ivybase__Type__c == 'Unplanned') {
                if(aPlanJPActivityMAP.containsKey(visit.ivybase__Resource__r.ivybase__Related_User__c)) {
                    Integer dummyValue = aPlanJPActivityMAP.get(visit.ivybase__Resource__r.ivybase__Related_User__c);
                    aPlanJPActivityMAP.put(visit.ivybase__Resource__r.ivybase__Related_User__c,dummyValue + Integer.valueOf(differenceTime));
                    system.debug('line 31');
                } else {
                    aPlanJPActivityMAP.put(visit.ivybase__Resource__r.ivybase__Related_User__c,Integer.valueOf(differenceTime));
                    system.debug('line 34');                    
                } 
            }
        }
        system.debug('aPlanJPActivityMAP*'+ aPlanJPActivityMAP);
        
        for(RintinDokoVisitActual__c rdv: [select Id, Name, Rintin_Plan__r.StartTime__c, Rintin_Plan__r.Date__c, Rintin_Plan__r.EndTime__c,CreatedById FROM RintinDokoVisitActual__c WHERE Rintin_Plan__C != NULL AND Rintin_Plan__r.Date__c = TODAY]) {
            
            Time startTime ;
            Time endTime;
            Long differenceTime;
            if(rdv.Rintin_Plan__r.StartTime__c != NULL)
           	startTime  = Time.newInstance(Integer.valueOf(rdv.Rintin_Plan__r.StartTime__c.Split(':')[0]), Integer.valueOf(rdv.Rintin_Plan__r.StartTime__c.Split(':')[1]), 0, 0);
           
            if(rdv.Rintin_Plan__r.EndTime__c != NULL)
            endTime = Time.newInstance(Integer.valueOf(rdv.Rintin_Plan__r.EndTime__c.Split(':')[0]), Integer.valueOf(rdv.Rintin_Plan__r.EndTime__c.Split(':')[1]), 0, 0);
            
            if(endTime != NULL && startTime != NULL)
            differenceTime = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute());
            
            if(rdv.Rintin_Plan__r.Date__c != NULL){
                calculatedMonth = rdv.Rintin_Plan__r.Date__c.Month();
                calculateYear = rdv.Rintin_Plan__r.Date__c.year();
            }
            
            system.debug('calculatedMonth: actual '+ calculatedMonth); 
            system.debug('calculateYear: actual '+ calculateYear);
            
            if(aPlanJPActivityMAP.containsKey(rdv.CreatedById)) {
                Integer dummyValue = aPlanJPActivityMAP.get(rdv.CreatedById);
                aPlanJPActivityMAP.put(rdv.CreatedById,dummyValue + Integer.valueOf(differenceTime));
                system.debug('line 50');
            } else {
                aPlanJPActivityMAP.put(rdv.CreatedById,Integer.valueOf(differenceTime));
                system.debug('line 53');                    
            }
            
        }
        system.debug('aPlanJPActivityMAP**'+ aPlanJPActivityMAP);
        
        for(JourneyPlanActivity__c jpa : [SELECT ID, Start_Time__c, End_Time__c, Date__c, Activity_Name__c,CreatedById FROM JourneyPlanActivity__c WHERE CreatedById IN: relatedUserIdSET and Date__c = TODAY AND (Activity_Name__c not IN:activityLIST) AND TypeId__r.ivybase__Flex1__c = '1']) {
            
            Time startTime ;
            Time endTime;
            Long differenceTime;
            
            if(jpa.Start_Time__c != NULL)
                startTime = Time.newInstance(Integer.valueOf(jpa.Start_Time__c.Split(':')[0]), Integer.valueOf(jpa.Start_Time__c.Split(':')[1]), 0, 0);
            if(jpa.End_Time__c != NULL)
                endTime = Time.newInstance(Integer.valueOf(jpa.End_Time__c.Split(':')[0]), Integer.valueOf(jpa.End_Time__c.Split(':')[1]), 0, 0);
            if(endTime != NULL && startTime != NULL)
                differenceTime = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute());
            
            if(jpa.Date__c != NULL){
                calculatedMonth = jpa.Date__c.Month();
                calculateYear = jpa.Date__c.year();
            }
            
            system.debug('calculatedMonth: jpa '+ calculatedMonth); 
            system.debug('calculateYear: jpa '+ calculateYear);
            system.debug('differenceTime*****  '+ differenceTime);
            
            if(bPlanJPActivityMap.containsKey(jpa.CreatedById)) {
                Integer dummyValue = bPlanJPActivityMap.get(jpa.CreatedById);
                bPlanJPActivityMap.put(jpa.CreatedById,dummyValue + Integer.valueOf(differenceTime));
                system.debug('line 86'); 
            } else {
                bPlanJPActivityMap.put(jpa.CreatedById,Integer.valueOf(differenceTime));
                system.debug('line 89');                     
            }
            
        }
        
        system.debug('bPlanJPActivityMap***'+ bPlanJPActivityMap);
        
        for(AdhocActivityPlanDetail__c apa : [SELECT ID, StartTime__c,Date__c, EndTime__c,Hour_Spent__c,CreatedById FROM AdhocActivityPlanDetail__c WHERE CreatedById IN: relatedUserIdSET and Date__c = TODAY AND Standard_List_Master__r.ivybase__Flex1__c = '1']) {
            
            //Time startTime = Time.newInstance(Integer.valueOf(apa.StartTime__c.Split(':')[0]), Integer.valueOf(apa.StartTime__c.Split(':')[1]), 0, 0);
            //Time endTime = Time.newInstance(Integer.valueOf(apa.EndTime__c.Split(':')[0]), Integer.valueOf(apa.EndTime__c.Split(':')[1]), 0, 0);
            //Long differenceTime = (endTime.hour() * 60 + endTime.minute()) - (startTime.hour() * 60 + startTime.minute());
            
            String spent = apa.Hour_Spent__c.removeEnd(' HH:MM');
            Time HoursSpent;
            Long differenceTime;
            
            if(spent != NULL)
            HoursSpent =  Time.newInstance(Integer.valueOf(spent.Split(':')[0]), Integer.valueOf(spent.Split(':')[1]), 0, 0);
            
            if(HoursSpent != NULL)
            differenceTime = (HoursSpent.hour() * 60 + HoursSpent.minute());
            
            if(apa.Date__c != NULL){
                calculatedMonth = apa.Date__c.Month();
                calculateYear = apa.Date__c.year();
            }
            
            system.debug('calculatedMonth: apa '+ calculatedMonth); 
            system.debug('calculateYear: apa '+ calculateYear);
            
            
            
            // system.debug('differenceTime*****  '+ differenceTime);
            if(bPlanJPActivityMap.containsKey(apa.CreatedById)) {
                Integer dummyValue = bPlanJPActivityMap.get(apa.CreatedById);
                bPlanJPActivityMap.put(apa.CreatedById,dummyValue + Integer.valueOf(differenceTime));
                system.debug('line 109'); 
            } else {
                bPlanJPActivityMap.put(apa.CreatedById,Integer.valueOf(differenceTime)); 
                system.debug('line 112'); 
            }
        }
        
        system.debug('bPlanJPActivityMap****'+ bPlanJPActivityMap);
        // Now we have 2 maps with each having A plan and B plan time for each user.
        
        LIST<Market_Visit_Calculation__c> marketCalculationLIST = new LIST<Market_Visit_Calculation__c>();
        
         LIST<Market_Visit_Calculation__c> existingMarketVisitCalculationRecordsList = new LIST<Market_Visit_Calculation__c>();
        
        existingMarketVisitCalculationRecordsList = [SELECT Resource__c   
                                                     FROM Market_Visit_Calculation__c 
                                                     WHERE CreatedDate = TODAY ];
        
        SET<Id> resourceIdSet = new SET<Id>();
        
        for(Market_Visit_Calculation__c mvc : existingMarketVisitCalculationRecordsList) {
            resourceIdSet.add(mvc.Resource__c);
        }
        
        for(ivybase__Resource__c resource : ScopeRecords) {
            
            if(!resourceIdSet.contains(resource.Id)){
                Market_Visit_Calculation__c marketVisitCalculation = new Market_Visit_Calculation__c();
                
                if(aPlanJPActivityMAP.containsKey(resource.ivybase__Related_User__c)) {
                    marketVisitCalculation.A_Hours__c = Double.valueOf(aPlanJPActivityMAP.get(resource.ivybase__Related_User__c))/60;
                    system.debug('line 125'+ marketVisitCalculation.A_Hours__c); 
                } else {
                    marketVisitCalculation.A_Hours__c = 0;
                }
                if(bPlanJPActivityMap.containsKey(resource.ivybase__Related_User__c)) {
                    marketVisitCalculation.B_Hours__c = Double.valueOf(bPlanJPActivityMap.get(resource.ivybase__Related_User__c))/60;
                    system.debug('line 129'+ marketVisitCalculation.B_Hours__c); 
                } else {
                    marketVisitCalculation.B_Hours__c  = 0;
                }
                
                if(marketVisitCalculation.B_Hours__c >= 240 && marketVisitCalculation.A_Hours__c == 0){
                    marketVisitCalculation.Number_Of_Working_Days__c = 0.0;
                } else if(marketVisitCalculation.B_Hours__c >0 && marketVisitCalculation.A_Hours__c > 0){
                    marketVisitCalculation.Number_Of_Working_Days__c = 0.5;
                } else if(marketVisitCalculation.B_Hours__c == 0 && marketVisitCalculation.A_Hours__c > 0){
                    marketVisitCalculation.Number_Of_Working_Days__c = 1.0;
                } else {
                    marketVisitCalculation.Number_Of_Working_Days__c = 0.0;
                }
                
                
                /*system.debug('Bplan Value*'+ bPlanJPActivityMap.get(resource.ivybase__Related_User__c));
system.debug('APlan Value*'+ aPlanJPActivityMAP.containsKey(resource.ivybase__Related_User__c));
system.debug('APlan Value*'+ aPlanJPActivityMAP.get(resource.ivybase__Related_User__c));
if(bPlanJPActivityMap.containsKey(resource.ivybase__Related_User__c) && aPlanJPActivityMAP.containsKey(resource.ivybase__Related_User__c)) {
if(Integer.valueOf(bPlanJPActivityMap.get(resource.ivybase__Related_User__c)) >= 240 && aPlanJPActivityMAP.get(resource.ivybase__Related_User__c) == 0)
marketVisitCalculation.Number_Of_Working_Days__c = 0.0;
system.debug('line 134'+ marketVisitCalculation.Number_Of_Working_Days__c); 
} 
if(bPlanJPActivityMap.containsKey(resource.ivybase__Related_User__c) && aPlanJPActivityMAP.containsKey(resource.ivybase__Related_User__c)){
if(bPlanJPActivityMap.get(resource.ivybase__Related_User__c)>= 0 && aPlanJPActivityMAP.get(resource.ivybase__Related_User__c) > 0) {
marketVisitCalculation.Number_Of_Working_Days__c = 0.5; 
system.debug('line 138'+ marketVisitCalculation.Number_Of_Working_Days__c);
} else if(bPlanJPActivityMap.get(resource.ivybase__Related_User__c) == 0 && aPlanJPActivityMAP.get(resource.ivybase__Related_User__c) > 0){
marketVisitCalculation.Number_Of_Working_Days__c = 1.0; 
}
} */
                // A + B Hours
                if(marketVisitCalculation.A_Hours__c != NULL && marketVisitCalculation.B_Hours__c != NULL) {
                    marketVisitCalculation.A_B_hours__c =  marketVisitCalculation.A_Hours__c + marketVisitCalculation.B_Hours__c;
                    
                } else if(marketVisitCalculation.A_Hours__c != NULL ){
                    marketVisitCalculation.A_B_hours__c =  marketVisitCalculation.A_Hours__c ;
                } else {
                    marketVisitCalculation.A_B_hours__c = marketVisitCalculation.B_Hours__c;
                }
                
                marketVisitCalculation.Resource__c = resource.Id;
                marketVisitCalculation.Month__c = String.valueOf(calculatedMonth);
                marketVisitCalculation.Year__c = STring.valueOf(calculateYear);
                
                if(marketVisitCalculation.B_Hours__c != NULL || marketVisitCalculation.A_Hours__c != NULL) {
                    marketCalculationLIST.add(marketVisitCalculation);
                }
            }
        }
        
        system.debug('marketCalculationLIST'+ marketCalculationLIST);
        database.SaveResult[] sv = database.insert(marketCalculationLIST);
        
        for(database.SaveResult s : sv) {
            if(s.isSuccess()) {
                system.debug('inserted record Id'+s);
            } else {
                for(Database.Error err : s.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        } 
    }
}