public class CalculateDaysDiffExcludingHoliday {
    list<ivybase__Holiday__c> holidayList= new list<ivybase__Holiday__c>();
    List<JourneyPlanActivity__c> jrnyPlanActList = new List<JourneyPlanActivity__c>();
    Integer month = Date.today().Month();
    public CalculateDaysDiffExcludingHoliday(){
        //Fetch all holiday list from the organization- you can check this from             //setup-->Company Profile-->Holidays
        list<ivybase__Resource__c> Resource=[select ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:userinfo.getUserId()];
        
        if(Resource.size()>0){
            holidayList= [select id,ivybase__End__c,ivybase__Start__c,ivybase__Description__c from ivybase__Holiday__c where Location_Hierarchy__c=:Resource[0].ivybase__Location_Hierarchy__c];
            jrnyPlanActList = [Select Id,JourneyPlan__r.Territory__c,JourneyPlan__r.Month__c,Date__c,JourneyPlan__r.Territory__r.ivybase__Primary_Resource__c,TypeId__r.ivybase__List_Code__c 
                                                                                          from JourneyPlanActivity__c 
                                                                                          where JourneyPlan__r.Territory__r.ivybase__Primary_Resource__c =:Resource[0].Id
                                                                                          AND JourneyPlan__r.Month__c =:month
                                                                                          AND TypeId__r.ivybase__List_Code__c = 'PL'];
        } 
        system.debug('Holidaylist***'+Holidaylist);
        System.debug('jrnyPlanActList::'+jrnyPlanActList);
        //holidayList=[Select StartTimeInMinutes, Name, ActivityDate From Holiday];
    }
    public integer CalculateWorkingDays(date startdt, Date enddt){
        // to include both start and end date in calculation, add 1 with days //difference.
        Date todayDate = Date.today();
        Integer allDaysBetween = Date.daysInMonth(todayDate.year(), todayDate.month());
        //Integer allDaysBetween = startdt.daysBetween(enddt)+1;
        system.debug('**allDaysBetween'+allDaysBetween);
        Integer allWorkingDays=0;
        //If start date and end date are same, then check is this date not fall in //holiday or weekoff
        if(startdt == enddt){
            system.debug('**startdt'+startdt+'enddt'+enddt);
            boolean isHoliday= false;
            //For excluding weekoff- week starts with Monday,As my week starts    //with sunday subtract 1 from weekstart. 
            Date weekStart = startdt.toStartofWeek().addDays(-1);
            system.debug('**weekStart'+weekStart);
            for(ivybase__Holiday__c hDay:holidayList){
                
                integer d1=hDay.ivybase__Start__c.day();
                integer m1=hDay.ivybase__Start__c.month();
                integer y1=hDay.ivybase__Start__c.year();
                Date hdate = Date.newInstance(y1, m1, d1);
                if(startdt.daysBetween(hdate) == 0){
                    isHoliday= true;
                }
            }
            for(JourneyPlanActivity__c jpa : jrnyPlanActList){
                integer d1=jpa.Date__c.day();
                integer m1=jpa.Date__c.month();
                integer y1=jpa.Date__c.year();
                Date hdate = Date.newInstance(y1, m1, d1);
                if(startdt.daysBetween(hdate) == 0){
                    isHoliday= true;
                }
            }
            if(weekStart.daysBetween(startdt) ==7 || weekStart.daysBetween(startdt) == 6){
                isHoliday= true;
            }
            system.debug('**isHoliday'+isHoliday);
            if(isHoliday == false){
                allWorkingDays = 1;
            }
        }
        else{//start date and end date are not same, so need to loop with all //dates to exclude weekoff and holiday list
            for(Integer k=0;k<allDaysBetween;k++ ){
                if(checkifItisWorkingDay(startdt.addDays(k),holidayList,jrnyPlanActList)){
                    system.debug('**working day:'+startdt.addDays(k));
                    allWorkingDays++;//increment working date for each working //date.
                } 
                /*if(checkifItisWorkingDay(startdt.addDays(k),null,jrnyPlanActList)){
                    system.debug('**working day jrny:'+startdt.addDays(k));
                    allWorkingDays++;//increment working date for each working //date.
                } */
                
            }
        }
        System.debug('All Working days finally:::'+allWorkingDays);
        return allWorkingDays;
    }
    public boolean checkifItisWorkingDay(Date currentDate,List<ivybase__Holiday__c> holidays,List<JourneyPlanActivity__c> jrnyPlanActList){
        system.debug('**currentDate'+currentDate);
        Date weekStart = currentDate.toStartofWeek().addDays(-1);
        
        system.debug('**weekStart'+weekStart);
        for(ivybase__Holiday__c hDay:holidays){
            System.debug('holidays:: '+hDay);
            //if date fall inholiday then return false.
            integer d1=hDay.ivybase__Start__c.day();
            integer m1=hDay.ivybase__Start__c.month();
            integer y1=hDay.ivybase__Start__c.year();
            Date hdate = Date.newInstance(y1, m1, d1); 
            
            if(hdate>=currentDate  && currentDate.daysBetween(hdate) == 0){
                system.debug('inside if'); 
                return false;
            }
        }
        for(JourneyPlanActivity__c jrny:jrnyPlanActList){
            System.debug('jrnyPlans:: '+jrny);
            //if date fall inholiday then return false.
            integer d1=jrny.Date__c.day();
            integer m1=jrny.Date__c.month();
            integer y1=jrny.Date__c.year();
            Date hdate = Date.newInstance(y1, m1, d1); 
            
            if(hdate>=currentDate  && currentDate.daysBetween(hdate) == 0){
                system.debug('inside if'); 
                return false;
            }
        }
        //if date fall in weeknd return false
        system.debug('weekStart.daysBetween(currentDate)'+weekStart.daysBetween(currentDate));
        System.debug('currentDate weekends:: '+currentDate);
        if(weekStart.daysBetween(currentDate) ==7 || weekStart.daysBetween(currentDate) == 1){  
            return false;
        } 
        else{//if date is not in holiday list and not in weekoff, return true to //indicate as working date.
            return true;
        }
    }
}