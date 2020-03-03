({
    doInit : function(component, event, helper) {

		console.log('selected records'+JSON.stringify(component.get("v.selectedrecord")));        
        
        let recordSelected = [];
     recordSelected =  recordSelected.concat(component.get("v.selectedrecord"));
        console.log('abc ***'+JSON.stringify(recordSelected));
        
        let  rintenRecord= recordSelected.find(item => item.IsDoko__c == false);
        
        //console.log('dokoRecord'+ JSON.stringify(dokoRecord));
        
        let  dokoRecord= recordSelected.find(item => item.IsDoko__c == true);
        //console.log('rintenRecord'+ JSON.stringify(rintenRecord));
        var recordDataTypeName ;
        if(dokoRecord !== undefined) {
            recordDataTypeName = 'doko';
            component.set("v.isDoko",true);
            
        } else if(rintenRecord !== undefined){
            recordDataTypeName = 'rinten';
            component.set("v.isRinten",true);
        } else {
            recordDataTypeName = 'jp';
            component.set("v.JPActivity",true);
        }
        console.log('recordDataTypeName'+ recordDataTypeName);
        //component.set("v.recordDataTypeName",recordDataTypeName);
        
        
        
        
        
        
    },
    Close: function(component, event, helper) {
        var eventAttribute = component.getEvent("closeCalenderModal");
        eventAttribute.fire();
    },
    testfunction : function(st){

		let strlst = [];
		strlst.concat(st.split('-'));
        
    }
})