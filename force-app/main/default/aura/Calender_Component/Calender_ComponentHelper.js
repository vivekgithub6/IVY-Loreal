({
    
    loadCalendar :function(component,data){   
        
        var m = $('#calendar').fullCalendar('getDate');
        var defView = $('#calendar').fullCalendar('getView');
        var viewName = 'month';
        if(defView.name !== undefined){
            viewName = defView.name;
        }
        
        if(m.get('date') === undefined){
            m = moment();
        }
        
        $('#calendar').fullCalendar('destroy');
        $('#calendar').fullCalendar({
            
            customButtons: {
                /*addnew: {
                    text: 'ADD NEW',
                    click: function(jsEvent, view) {
                        component.set("v.dayclick",true);
                        
                    }
                },
                AddIcon:{
                    text: '+',
                    click: function(jsEvent, view) {
                        component.set("v.dayclick",true);
                        
                    }
                }*/
                
            },
            
            header: {
                left: 'prev,next,today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,addnew,AddIcon'
            },
            buttonText:{
                today:'TODAY',
                month:'MONTH',
                agendaDay:'DAY',
                agendaWeek:'WEEK'
                
            },
            //   themeSystem:'standard',
            //    allDayDefault:false,
            displayEventTime:true,
            handleWindowResize:false,
            //  aspectRatio:1,
            // height:700,
            defaultDate: m.format(),
            defaultView: viewName,
            editable: false,
            navLinks: true, // can click day/week names to navigate views
            weekNumbers: false,
            weekNumbersWithinDays: true,
            weekNumberCalculation: 'ISO',
            timeFormat: 'H(:mm)',
            eventLimit: true,
            
            allDayText:'All-Day',
            views: {
                agendaWeek: {
                    slotLabelFormat:['HH:mm'],
                    
                },
                agendaDay: {
                    slotLabelFormat:['HH:mm'],
                    
                }
            },  
            
            minTime: "00:00:00",
            maxTime: "24:00:00",
            businessHours: {
                // days of week. an array of zero-based day of week integers (0=Sunday)
                dow: [ 1, 2, 3, 4,5,6,7], // Monday - Sunday
                
                start: '00:00', // a start time (10am in this example)
                end: '24:00', // an end time (6pm in this example)
            }, 
            
            //  timeZone:'Australia/Brisbane',
            events:data,
            selectable : true,
            eventTextColor:'Black',
            dragScroll : true,
            droppable: true,
            nowIndicator:true,
            //  allDay:false,
            //displayEventEnd:true,
            eventDrop: false,
            
            eventClick: function(event, jsEvent, view) {
                
                
                let jsArray = [];
                jsArray = component.get("v.jpActivityList");
                var clickedRecords;
                console.log('jsArray->'+ jsArray);
                for(var i = 0;i<jsArray.length;i++){
                    if(jsArray[i].Id === event.id){
                        
                        clickedRecords = jsArray[i];
                    }
                }
                console.log('leads'+ JSON.stringify(clickedRecords));
                component.set("v.childjpActivity",clickedRecords);
                component.set("v.istask",true); 
            }
        });
    },
    tranformJPActivityToFullCalendarFormat : function(component,Tasks) {
        component.set("v.TaskRecords",Tasks);
        var eventArr = [];
        
        for(var i = 0;i < Tasks.length;i++){
            
            let startDate = Tasks[i].Date__c + ' ' + Tasks[i].Start_Time__c + ':00';
            let enddate = Tasks[i].Date__c + ' ' + Tasks[i].End_Time__c + ':00';
            
            eventArr.push({
                'id':Tasks[i].Id,
                'title':Tasks[i].Activity_Name__c,
                'start':startDate,
                'end': enddate,
                allDay:false,
                color:'#00a3ad'
            });
        }
        
        return eventArr;
        
    },
    tranformRintenToFullCalendarFormat : function(component,Rinten) {
        console.log('entered cal');
        component.set("v.EventRecords",Rinten);
        var eventArr = [];
        for(var i = 0;i < Rinten.length;i++){
            
            let startDateRinten = Rinten[i].Rintin_Plan__r.Date__c + ' ' + Rinten[i].Rintin_Plan__r.StartTime__c + ':00';
            let enddateRinten = Rinten[i].Rintin_Plan__r.Date__c + ' ' + Rinten[i].Rintin_Plan__r.EndTime__c + ':00';
            
            eventArr.push({
                'id':Rinten[i].Id,
                'title':Rinten[i].Rintin_Plan__r.Name,
                'start':startDateRinten,
                'end': enddateRinten,   
                color:'#FF6e7e' 
            });
        }
        
        return eventArr;
    },
    tranformDokoToFullCalendarFormat : function(component,Doko) {
        component.set("v.AppointmentRecords",Doko);
        var eventArr = [];
        
        for(var i = 0;i < Doko.length;i++){
            
            let startDateDoko = Doko[i].Rintin_Plan__r.Date__c + ' ' + Doko[i].Rintin_Plan__r.StartTime__c + ':00';
            let enddateDoko = Doko[i].Rintin_Plan__r.Date__c + ' ' + Doko[i].Rintin_Plan__r.EndTime__c + ':00';
            
            eventArr.push({
                'id':Doko[i].Id,
                'title':Doko[i].Rintin_Plan__r.Name,
                'start':startDateDoko,
                'end':enddateDoko,
                color:'#C79DF0'
                
            });
        }
        return eventArr;
    },
    handleCalendarItems:function(component, event, helper){
        var self = this;
        
        var calendaritems=[];
        
        var action=component.get("c.loadCalender");
        action.setParams({
            "salesRepUserId" : component.get("v.selectedrepRecord").ivybase__Related_User__c
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var CalendarResponse=[];
                let allActivities = [];
                if(response.getReturnValue().journeyPlanActivityRecords != undefined){
                    //component.set("v.jpActivityList",response.getReturnValue().journeyPlanActivityRecords);
                    allActivities = allActivities.concat(response.getReturnValue().journeyPlanActivityRecords);
                    CalendarResponse = CalendarResponse.concat(self.tranformJPActivityToFullCalendarFormat(component,response.getReturnValue().journeyPlanActivityRecords));
                }
                if(response.getReturnValue().RintinPlanDetails != undefined){
                    allActivities = allActivities.concat(response.getReturnValue().RintinPlanDetails);
                    CalendarResponse = CalendarResponse.concat(self.tranformRintenToFullCalendarFormat(component,response.getReturnValue().RintinPlanDetails));
                }
                if(response.getReturnValue().DokoPlanDetails != undefined){
                    allActivities = allActivities.concat(response.getReturnValue().DokoPlanDetails);
                    CalendarResponse = CalendarResponse.concat(self.tranformDokoToFullCalendarFormat(component,response.getReturnValue().DokoPlanDetails));
                }
                console.log('allActivities *'+ JSON.stringify(allActivities));
                component.set("v.jpActivityList",allActivities);
                self.loadCalendar(component,CalendarResponse);
                component.set("v.isspinner",false);
            }
            
        });
        
        $A.enqueueAction(action);
    }   
    
})