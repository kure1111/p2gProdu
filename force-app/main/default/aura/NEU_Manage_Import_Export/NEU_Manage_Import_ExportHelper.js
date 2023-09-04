({
  	getImportExport: function(component) 
    {
    	var action = component.get('c.getImportExport');
   
        // Set Import-Export Id to use it on the query
        action.setParams({
        	recordId : component.get("v.recordId")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) 
        {
     		component.set('v.ie', actionResult.getReturnValue());
            component.set('v.status', actionResult.getReturnValue().Community_Status__c);
    	});
    	
        $A.enqueueAction(action);
  	},
    // Fetch the Import-Export Cargo Lines from the Apex controller
  	getLines: function(component, show_hide_spinner) 
    {
    	var action = component.get('c.getLines');
        
        // Set Import-Export Id to use it on the query
        action.setParams({
        	recordId : component.get("v.recordId")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) 
        {
     		component.set('v.lines', actionResult.getReturnValue());
            
            if(show_hide_spinner)
            {
            	var spinner = component.find("mySpinner");
       			$A.util.toggleClass(spinner, "slds-hide");   
            }
    	});
    	
        $A.enqueueAction(action);
  	},
  	deleteCargoLine: function(component, recordId) 
    {
    	var action = component.get('c.deleteCargoLine');
   
        action.setParams({
            recordId : recordId,
        	importExportId : component.get("v.recordId")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) 
        {
     		component.set('v.lines', actionResult.getReturnValue());
    	});
    	
        $A.enqueueAction(action);
  	},    
	save_ie_cargo_helper: function(component, newiecargo, record_ie, callback) 
    {
    	var action = component.get("c.saveCargoLine");

        action.setParams({
            "serializedCargoLine": JSON.stringify(newiecargo),
            "recordId": record_ie,
            "conType": component.get("v.conType")
        });
        
        if (callback) {
            action.setCallback(this, callback);
        }
        
        $A.enqueueAction(action);
    },
    create_and_new_ie_cargo_helper: function(component, newiecargo, record_ie) 
    {
    	this.save_ie_cargo_helper(component, newiecargo, record_ie, function(response)
        {
            var state = response.getState();
            
            if (state === "SUCCESS") 
            {
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
            }
            else
            {
                console.log("error "+state);
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else 
                {
                    console.log("Unknown error");
                }
            }
        });
	},
	create_ie_cargo_helper: function(component, newiecargo, record_ie) 
    {
    	this.save_ie_cargo_helper(component, newiecargo, record_ie, function(response)
        {
        	var state = response.getState();
    		if (state === "SUCCESS") 
            {
            	var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
            }
            else
            {
            	console.log("error "+state);
                var errors = response.getError();
                if (errors) 
                {
                	if (errors[0] && errors[0].message) 
                    {
                    	console.log("Error message: " + errors[0].message);
                    }
                } 
                else 
                {
                	console.log("Unknown error");
                }
            }
        });
    },
  	getCurrencyOptions: function(component) 
    {
    	var action = component.get('c.getCurrencyOptions');
        
    	var self = this;
    	action.setCallback(this, function(actionResult) 
        {
     		component.set('v.options', actionResult.getReturnValue());
    	});
    	
        $A.enqueueAction(action);
  	},
    clear: function(component)
    {
        // Set Up Clear Scenario
        component.set("v.cargo_line.Name",null);      
        component.set("v.cargo_line.Extension_Item_Name__c",null);        
        component.set("v.cargo_line.Units__c",null);
        component.set("v.cargo_line.Extension_Item_Name__c",null);
        component.set("v.cargo_line.Stackable__c",null);
        component.set("v.cargo_line.Total_Shipping_Weight_Kgs__c",null);
        component.set("v.cargo_line.Total_Shipping_Volume_m3__c",null);
        
        component.set("v.item.Name",null);
        component.set("v.item.Master_Box_Packing_Weight_kg__c",null);
        component.set("v.item.Master_Box_Height_cm__c",null);
        component.set("v.item.Master_Box_Length_cm__c",null);
        component.set("v.item.Master_Box_Width_cm__c",null);  
        component.set("v.item.Master_Box_Volume_m3__c",null);
        
		document.getElementById('progress_bar_percent').style.width = '0%';
    	document.getElementById('li_step2').classList.remove('slds-is-active');
        document.getElementById('li_step1').classList.add('slds-is-active');
        document.getElementById('btn_save').style.display = 'none';
		document.getElementById('btn_next').style.display = 'block';
        document.getElementById('btn_previous').style.display = 'none';
        document.getElementById('modal-content-id-1').style.display = 'block';
        document.getElementById('modal-content-id-2').style.display = 'none';
    },
	openModal:function(component)
    {    
		var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
	closeModal:function(component)
    {    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.get('e.force:refreshView').fire();
    },
	openModalCreation:function(component)
    {    
		var cmpTarget = component.find('Modalbox2');
        var cmpBack = component.find('modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },    
	closeModalCreation:function(component)
    {   
        var cmpTarget = component.find('Modalbox2');
        var cmpBack = component.find('Modalbox1');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
	openModalError:function(component)
    {   
		var cmpTarget = component.find('ModalboxError');
        var cmpBack = component.find('modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
	closeModalError:function(component)
    {    
        var cmpTarget = component.find('ModalboxError');
        var cmpBack = component.find('modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
	openModalRejection:function(component)
    {    
		var cmpTarget = component.find('ModalboxRejection');
        var cmpBack = component.find('modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
	closeModalRejection:function(component)
    {    
        var cmpTarget = component.find('ModalboxRejection');
        var cmpBack = component.find('modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');  
    }     
})