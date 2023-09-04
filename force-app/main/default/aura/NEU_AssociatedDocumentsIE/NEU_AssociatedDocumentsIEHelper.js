({
	getDocuments : function(cmp) {
        var action = cmp.get('c.getDocuments');
        action.setParams({recordId : cmp.get("v.recordId")});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.documents', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    deleteDocument : function(cmp, document_id) {
        var action = cmp.get('c.deleteDocument');
        action.setParams({recordId : cmp.get("v.recordId"), document_id : document_id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.documents', response.getReturnValue());
                var spinner = cmp.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    sortData: function (cmp, fieldName, sortDirection, table_name) {
        var data = cmp.get(table_name);
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set(table_name, data);
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})