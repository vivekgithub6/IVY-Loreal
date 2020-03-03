({
    loadmonthcalendar : function(component, event, helper) {
        $('#month').calendar({
            
            select: function(date) {
                
                var SelectedDate= date;
                component.set("v.SelectedDate",SelectedDate);
                // var selecteddate=component.get("v.SelectedDate");
                var myEvent =component.getEvent("DateFromCalendar");
                
                myEvent.setParams({
                    "calendardate": component.get("v.SelectedDate")
                });
                myEvent.fire(); 
            },
        });
    }
})