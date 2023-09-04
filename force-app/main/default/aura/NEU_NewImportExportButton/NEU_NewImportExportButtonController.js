({
    createRecord : function (cmp, event, helper) {
        
        var account_id = '';
        
        var action = cmp.get('c.getAccount');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                account_id = response.getReturnValue();

                var createImportExport = $A.get("e.force:createRecord");
                createImportExport.setParams({
                    "entityApiName": "Customer_Quote__c",
                    "defaultFieldValues": {
                        'Name' : '<Se creará automáticamente>',
                        'Account_for__c' : account_id
                    }
                });
                createImportExport.fire();
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
	}
})