({
	init: function (cmp, event, helper) {
        
        var action = cmp.get("c.getShipment");
        action.setParams({recordId : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
		$A.enqueueAction(action);
        
        cmp.set('v.documents_columns', [
				{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:preview',
                    	label: 'View', 
                    	name: 'View', 
                    	title: 'View', 
                    	disabled: false
                  	}
                },
            	{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'action:delete',
                    	label: 'Delete', 
                    	name: 'Delete', 
                    	title: 'Delete', 
                    	disabled: false
                  	}
                },
                {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
            	{label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true},
            	{label: 'Document Type', fieldName: 'Document_Type__c', type: 'text', sortable: true},
            	{label: 'Document Reference', fieldName: 'Document_Reference__c', type: 'text', sortable: true},
            	{label: 'Document Description', fieldName: 'Document_Description__c', type: 'text', sortable: true}
            ]);
        helper.getDocuments(cmp);
	},
	
	handleRowAction: function (cmp, event, helper) {
		
		var row = event.getParam('row');
        var row_json = JSON.parse(JSON.stringify(row));
        
        if(JSON.parse(JSON.stringify(event.getParams()))['action'].name == 'View')
        {
            
            if(row_json['Type__c'] == undefined || row_json['Type__c'] == 'Document')
                window.open('/customers'+row_json['Document_URL__c']);
            else
            {
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [row_json['Document_URL__c']]
                });
            }
        }
        if(JSON.parse(JSON.stringify(event.getParams()))['action'].name == 'Delete')
        {
            var spinner = cmp.find("mySpinner");
        	$A.util.toggleClass(spinner, "slds-hide");
            
            helper.deleteDocument(cmp, row_json['Id']);
        }
    },
    
    handleUploadFinished: function (cmp, event, helper) {
        var uploadedFiles = event.getParam("files");
        var ids_files = [];
        for(var i = 0; i < uploadedFiles.length; i++)
        {
            ids_files.push(uploadedFiles[i].documentId+'|'+uploadedFiles[i].name);
        }
        helper.createAssociatedDocuments(cmp, ids_files);
    },
    
    showFile: function (cmp, event, helper) {
		
        event.preventDefault();
       	 
        var documentid = event.target.getElementsByClassName('document-id')[0].value;
        var documenttype = event.target.getElementsByClassName('document-type')[0].value;
        var documenturl = event.target.getElementsByClassName('document-url')[0].value;
		
        if(documenttype == '' || documenttype == null || documenttype == 'Document')
            window.open('/customers'+documenturl);
        else
        {
            $A.get('e.lightning:openFiles').fire({
                recordIds: [documenturl]
            });
        }
    },
    
    deleteFile: function (cmp, event, helper) {
		
		event.preventDefault();
       	 
        var documentid = event.target.getElementsByClassName('document-id')[0].value;
        var documenttype = event.target.getElementsByClassName('document-type')[0].value;
        var documenturl = event.target.getElementsByClassName('document-url')[0].value;
        
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        helper.deleteDocument(cmp, documentid);
    },
    
    getSelectedName: function (component, event) {
        
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
           console.log(selectedRows[i].Id);
        }
       
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.documents');
    }
})