({
    doInit : function(component, event, helper) {
        var record = component.get("v.record");
        var field = component.get("v.field");
        console.log('field'+JSON.stringify(field));
        if(field.fieldName.indexOf(".") >= 0){
           var ParentSobject = record[field.fieldName.split(".")[0]];
            console.log('ParentSobject'+JSON.stringify(ParentSobject));
           component.set("v.cellValue", ParentSobject[field.fieldName.split(".")[1]]);
        }
        else{
        component.set("v.cellValue", record[field.fieldName]);
        console.log('value'+record[field.fieldName]);
        }
        
        if(field.type == 'string' || field.type == 'text'||field.type == 'phone')
        {    
            component.set("v.isTextField", true);
        }
        else if(field.type == 'date'){
            component.set("v.isDateField", true);
        }
            else if(field.type == 'picklist'){
                component.set("v.isPicklistField", true);
            }
                else if(field.type == 'datetime'){
                    component.set("v.isDateTimeField", true);
                }
                    else if(field.type == 'currency'){
                        component.set("v.isCurrencyField", true);
                    }
                        else if(field.type == 'number'){
                            component.set("v.isNumber", true);
                        }
                            else if(field.type == 'boolean'){
                                component.set("v.isBoolean", true);
                            }
                                else if(field.type == 'REFERENCE'){
                                    component.set("v.isReferenceField", true);
                                    var relationShipName = '';
                                    if(field.name.indexOf('__c') == -1) {
                                        relationShipName = field.name.substring(0, field.name.indexOf('Id'));
                                    }
                                    else {
                                        relationShipName = field.name.substring(0, field.name.indexOf('__c')) + '__r';
                                    }
                                    component.set("v.cellLabel", record[relationShipName].Name);
                                }
                                    else{
                                        component.set("v.isTextField", true);
                                    }
    }
})