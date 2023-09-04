({
    doInit: function(component,event,helper) 
    {
        System.debug('entra doInit');
        helper.getCurrencyOptions(component);
        
        // Fetch the Import-Export Quote/Order from the Apex controller
        helper.getImportExport(component);
        
        // For list.lenght
        helper.getLines(component, true); 
    },
    openModal: function(component,event,helper) 
    {
        helper.openModal(component);
        
    	// Fetch the Import-Export Cargo Lines list from the Apex controller   
        helper.getLines(component, false);        
    },    
	closeModal:function(component,event,helper)
    {    
        helper.closeModal(component);
    },   
    deleteLine: function(component, event, helper) 
    {
    	// Prevent the form from getting submitted
    	event.preventDefault();
        
        // Get Cargo Line Id
        var lineId = event.target.getElementsByClassName('line-id')[0].value;
        
        // Delete the Import-Export Cargo Line
        helper.deleteCargoLine(component, lineId);        
  	},
  	sendNotificationToPak2Go: function(component) 
    {
    	var action = component.get('c.sendToPak2Go');
   
        // Set Import-Export Id to use it on the query
        action.setParams({
        	recordId : component.get("v.recordId")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS") {
				component.set('v.status', 'SENT TO PAK2GO');
            }            	
    	});
    	
        $A.enqueueAction(action);
  	},
  	confirmQuoteToPak2Go: function(component) 
    {
    	var action = component.get('c.confirmToPak2Go');
   
        // Set Import-Export Id to use it on the query
        action.setParams({
        	recordId : component.get("v.recordId")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS") {
				component.set('v.status', 'CONFIRMED');
            }            	
    	});
    	
        $A.enqueueAction(action);
  	},
  	rejectToPak2Go: function(component) 
    {
    	var action = component.get('c.rejectQuote');
   
        // Set Import-Export Id to use it on the query
        action.setParams({
        	recordId : component.get("v.recordId"),
            reasons : component.get("v.reasons")
        });
        
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS") {
				component.set('v.status', 'REJECTED'); 
                var cmpTarget = component.find('ModalboxRejection');
                var cmpBack = component.find('modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');                 
            }            	
    	});
    	
        $A.enqueueAction(action);
        
        helper.closeModalRejection(component);
    },    
    openModalCreation: function(component,event,helper) 
    {
        helper.clear(component);
        
        helper.openModalCreation(component);
        
        // Create the action
        var action = component.get("c.initializeCargoLine");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) 
        {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
            	component.set("v.cargo_line_s", response.getReturnValue());
                component.set("v.cargo_line",response.getReturnValue().cargo_line);
                component.set("v.item",response.getReturnValue().item);
            }
            else 
            {
            	console.log("Failed with state: " + state);
            }
		});
        
        // Send action off to be executed
        $A.enqueueAction(action);        
    },
	closeModalCreation:function(component,event,helper)
    {    
        helper.closeModalCreation(component);
    },
    clickCreate: function(component, event, helper) 
    {
        var validationOK = true;
        
        var nameGoods = component.get("v.item.Name");
        if(nameGoods == null)
        {
            validationOK = false;
        }
        
        var namePack = component.get("v.cargo_line.Extension_Item_Name__c");
        if(namePack == null)
        {
            validationOK = false;
        }      

        var units = component.get("v.cargo_line.Units__c");
        if(units == null || units == 0)
        {
            validationOK = false;
        }

        var amount = component.get("v.cargo_line.Amount__c");
        if(amount == null || amount == 0)
        {
            validationOK = false;
        }          
		
        if(component.get("v.service_type") != 'FTL' && component.get("v.service_type") != 'FCL')
        {
            var length = component.get("v.item.Master_Box_Length_cm__c");
            if(length == null || length == 0) 
            {
                validationOK = false;
            }
            
            var width = component.get("v.item.Master_Box_Width_cm__c");
            if(width == null || width == 0)
            {
                validationOK = false;
            }
            
            var height = component.get("v.item.Master_Box_Height_cm__c");
            if(height == null || height == 0)
            {
                validationOK = false;
            }
		}
        
        var weight = component.get("v.cargo_line.Total_Shipping_Weight_Kgs__c");
        if(weight == null || weight == 0)
        {
            validationOK = false;
        }        
        
        console.log("reached if");
        
        if(validationOK)
        {
            // Create Import-Export Cargo Line
            var newiecargo = component.get("v.cargo_line_s");
            var record_ie = component.get("v.recordId");
            
            newiecargo.ie_cargo = component.get("v.cargo_line");
            newiecargo.item = component.get("v.item");
            
            helper.create_ie_cargo_helper(component, newiecargo, record_ie);
            
            // Reload Cargo Lines Table
            helper.getLines(component, false);
            
            // Close Creation Modal
            helper.closeModalCreation(component);  
            
            console.log("reached end true");
        }
        else
        {
   			helper.openModalError(component);
            console.log("reached end else");
        }
    },
    closeModalError: function(component,event,helper) 
    {
		helper.closeModalError(component);        
    },
    openModalRejection: function(component,event,helper) 
    {
		helper.openModalRejection(component);        
    },
    closeModalRejection: function(component,event,helper) 
    {
		helper.closeModalRejection(component);        
    },    
    clickS1: function() 
    {
    	// Go to Step 1
		document.getElementById('progress_bar_percent').style.width = '0%';
    	document.getElementById('li_step2').classList.remove('slds-is-active');
        document.getElementById('li_step1').classList.add('slds-is-active');
        document.getElementById('btn_save').style.display = 'none';
		document.getElementById('btn_next').style.display = 'block';
        document.getElementById('btn_previous').style.display = 'none';
        document.getElementById('modal-content-id-1').style.display = 'block';
        document.getElementById('modal-content-id-2').style.display = 'none';        
	},    
    clickNext: function() 
    {
    	// Display buttons
        document.getElementById('btn_save').style.display = 'block';
		document.getElementById('btn_next').style.display = 'none';
        // Go to next step
		document.getElementById('progress_bar_percent').style.width = '100%';
        document.getElementById('li_step2').classList.add('slds-is-active');
        document.getElementById('modal-content-id-1').style.display = 'none';
        document.getElementById('modal-content-id-2').style.display = 'block';
        document.getElementById('btn_previous').style.display = 'block';
	}    
})