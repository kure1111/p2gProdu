({
   	init: function (cmp, event, helper) {

        cmp.set('v.planned_shipments_columns', [
				{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:checkin',
                    	label: 'Tracking', 
                    	name: 'Tracking', 
                    	title: 'Tracking', 
                    	disabled: false
                  	}
                },
            	{label: 'Shipment Number', fieldName: 'Name', type: 'text', sortable: true, cellAttributes:
                {
                    iconName: {fieldName: 'Mode_Lightning__c'}, 
                    iconPosition: 'left'}
                },
                {label: 'Import Status', fieldName: 'Ocean_Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Export Status', fieldName: 'Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Account for (Customer)', fieldName: 'Account_for__rName', type: 'text', sortable: true},
            	{label: 'ETD', fieldName: 'ETD_from_Point_of_Load__c', type: 'date', sortable: true},
            	{label: 'ETA', fieldName: 'ETA_Point_of_Discharge__c', type: 'date', sortable: true}
            ]);
        helper.getPlannedShipments(cmp);
       
       	cmp.set('v.intransit_shipments_columns', [
            	{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:checkin',
                    	label: 'Tracking', 
                    	name: 'Tracking', 
                    	title: 'Tracking', 
                    	disabled: false
                  	}
                },
                {label: 'Shipment Number', fieldName: 'Name', type: 'text', sortable: true, cellAttributes:
                {
                    iconName: {fieldName: 'Mode_Lightning__c'}, 
                    iconPosition: 'left'}
                },
                {label: 'Import Status', fieldName: 'Ocean_Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Export Status', fieldName: 'Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Account for (Customer)', fieldName: 'Account_for__rName', type: 'text', sortable: true},
            	{label: 'ETD', fieldName: 'ETD_from_Point_of_Load__c', type: 'date', sortable: true},
            	{label: 'ETA', fieldName: 'ETA_Point_of_Discharge__c', type: 'date', sortable: true}
            ]);
       	helper.getIntransitShipments(cmp);
       
       	cmp.set('v.delivered_shipments_columns', [
            	{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:checkin',
                    	label: 'Tracking', 
                    	name: 'Tracking', 
                    	title: 'Tracking', 
                    	disabled: false
                  	}
                },
                {label: 'Shipment Number', fieldName: 'Name', type: 'text', sortable: true, cellAttributes:
                {
                    iconName: {fieldName: 'Mode_Lightning__c'}, 
                    iconPosition: 'left'}
                },
                {label: 'Import Status', fieldName: 'Ocean_Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Export Status', fieldName: 'Shipment_Status__c', type: 'text', sortable: true},
                {label: 'Account for (Customer)', fieldName: 'Account_for__rName', type: 'text', sortable: true},
            	{label: 'ETD', fieldName: 'ETD_from_Point_of_Load__c', type: 'date', sortable: true},
            	{label: 'ETA', fieldName: 'ETA_Point_of_Discharge__c', type: 'date', sortable: true}
            ]);
       	helper.getDeliveredShipments(cmp);
        
        cmp.set('v.road_shipments_columns', [
            	{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:checkin',
                    	label: 'Tracking', 
                    	name: 'Tracking', 
                    	title: 'Tracking', 
                    	disabled: false
                  	}
                },
                {label: 'Shipment Number', fieldName: 'Name', type: 'text', sortable: true, cellAttributes:
                {
                    iconName: {fieldName: 'Mode_Lightning__c'}, 
                    iconPosition: 'left'}
                },
                {label: 'Road Status', fieldName: 'Shipment_Status_Mon__c', type: 'text', sortable: true},
                {label: 'Account for (Customer)', fieldName: 'Account_for__rName', type: 'text', sortable: true},
            	{label: 'ETD', fieldName: 'ETD_from_Point_of_Load__c', type: 'date', sortable: true},
            	{label: 'ETA', fieldName: 'ETA_Point_of_Discharge__c', type: 'date', sortable: true}
            ]);
       	helper.getRoadShipments(cmp);
        
        cmp.set('v.air_shipments_columns', [
            	{
                	type: 'button',
                  	typeAttributes: 
                  	{
                    	iconName: 'utility:checkin',
                    	label: 'Tracking', 
                    	name: 'Tracking', 
                    	title: 'Tracking', 
                    	disabled: false
                  	}
                },
                {label: 'Shipment Number', fieldName: 'Name', type: 'text', sortable: true, cellAttributes:
                {
                    iconName: {fieldName: 'Mode_Lightning__c'}, 
                    iconPosition: 'left'}
                },
                {label: 'Air Status', fieldName: 'air_shipments', type: 'text', sortable: true},
                {label: 'Account for (Customer)', fieldName: 'Account_for__rName', type: 'text', sortable: true},
            	{label: 'ETD', fieldName: 'ETD_from_Point_of_Load__c', type: 'date', sortable: true},
            	{label: 'ETA', fieldName: 'ETA_Point_of_Discharge__c', type: 'date', sortable: true}
            ]);
       	helper.getAirShipments(cmp);
    },
    
    handleRowActionSea: function (cmp, event, helper) {
        
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var row = event.getParam('row');
        var row_json = JSON.parse(JSON.stringify(row));
        var shipment_id = row_json['Id'];

        helper.getShipment(cmp, shipment_id, row_json['Freight_Mode__c']);
    },
    
    handleRowActionRoad: function (cmp, event, helper) {
        
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var row = event.getParam('row');
        var row_json = JSON.parse(JSON.stringify(row));
        var shipment_id = row_json['Id'];
        
        helper.getShipment(cmp, shipment_id, row_json['Freight_Mode__c']);
    },
    
    handleRowActionAir: function (cmp, event, helper) {
        
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var row = event.getParam('row');
        var row_json = JSON.parse(JSON.stringify(row));
        var shipment_id = row_json['Id'];
        
        helper.getShipment(cmp, shipment_id, row_json['Freight_Mode__c']);
    },
    
    getSelectedName: function (component, event) {
        
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
           console.log(selectedRows[i].Id);
        }
       
    },
    
    updateColumnSorting1: function (cmp, event, helper) {
        console.log(event.getParams());
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy1", fieldName);
        cmp.set("v.sortedDirection1", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.planned_shipments');
    },
    
    updateColumnSorting2: function (cmp, event, helper) {
        console.log(event.getParams());
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy2", fieldName);
        cmp.set("v.sortedDirection2", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.intransit_shipments');
    },
 
 	updateColumnSorting3: function (cmp, event, helper) {
        console.log(event.getParams());
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy3", fieldName);
        cmp.set("v.sortedDirection3", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.delivered_shipments');
    },
    
    updateColumnSorting4: function (cmp, event, helper) {
        console.log(event.getParams());
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy4", fieldName);
        cmp.set("v.sortedDirection4", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.road_shipments');
    },
    
    updateColumnSorting5: function (cmp, event, helper) {
        console.log(event.getParams());
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy5", fieldName);
        cmp.set("v.sortedDirection5", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection, 'v.air_shipments');
    },
    
    showTracking: function (cmp, event, helper) {

        event.preventDefault();
       	
        var shipmentid = event.target.getElementsByClassName('shipment-id')[0].value;
        var freightmode = event.target.getElementsByClassName('freight-mode')[0].value;
		
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");

        helper.getShipment(cmp, shipmentid, freightmode);
    },
})