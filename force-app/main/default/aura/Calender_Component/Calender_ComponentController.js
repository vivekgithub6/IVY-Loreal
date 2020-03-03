({
    afterScriptsLoaded : function(component, event, helper) {
        component.set("v.isspinner",true);      
        helper.handleCalendarItems(component, event, helper);
        
    }, 
    Cancel: function(component, event, helper) {
        component.set("v.dayclick",false);
        $A.util.removeClass(component.find("Recmodal"), "slds-show");
        $A.util.addClass(component.find("Recmodal"), "slds-hide");
    },
    
    createtask : function(component, event, helper) {
        
        component.set("v.dayclick",false);       
        component.set("v.TaskRecords",{});
        component.set("v.TaskCreateButton",true);
        component.set("v.istask",true);
        
    },
    
    createevent : function(component, event, helper) {       
        
        component.set("v.dayclick",false);
        component.set("v.EventRecords",{})
        component.set("v.EventCreateButton",true);
        component.set("v.isevent",true);
        
    },
    createappointment : function(component, event, helper) {        
        component.set("v.dayclick",false); 
        component.set("v.AppointmentRecords",{})
        component.set("v.AppointmentCreateButton",true);
        component.set("v.isappointment",true);
        
    },
    
    keyword : function(component, event, helper) {
        
        var searchkey= component.find("searchword").get("v.value");
        var action=component.get("c.fetchLookUpValues");
        action.setParams({
            "searchKeyWord":searchkey
        });
        action.setCallback(this, function(response) {
            // $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    handleCheckbox: function (component, event, helper) {
        
        helper.handleCalendarItems(component, event, helper)
        
    },
    handleDateEvent: function(component, event, helper) {
        
        var value = event.getParam("calendardate");
        component.set("v.MonthViewDate",value)
        var selecteddatetime=component.get("v.MonthViewDate");
        var selectedmonth =("0" + (selecteddatetime.getMonth() + 1)).slice(-2)
        var selectedday =  ("0" + (selecteddatetime.getDate())).slice(-2)
        
        var selectdate = selecteddatetime.getFullYear() + "-" + selectedmonth + "-" + selectedday;
        
        $('#calendar').fullCalendar('changeView', 'agendaDay', selectdate);
        var view = $('#calendar').fullCalendar('getView');
        
        
        if(view.name == 'month'){
            
            $('#calendar').fullCalendar('changeView', 'month', selectdate);
            
        } 
        if(view.name == 'agendaDay')
        {	
            $('#calendar').fullCalendar('changeView', 'agendaDay', selectdate);
        }
        if(view.name == 'agendaWeek')
        {
            
            $('#calendar').fullCalendar('changeView', 'agendaWeek', selectdate);
        } 
        
        
    },
    CloseNavigationModal:function(component, event, helper) {
        component.set("v.dayclick",false);
    },
    closeModal : function(component, event, helper) {
        console.log('inside close modal');
        component.set("v.istask",false);
    }
    
    
});