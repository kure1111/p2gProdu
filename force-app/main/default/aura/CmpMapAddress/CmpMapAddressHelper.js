({
	getHost : function(cmp, event, helper) {
		var action = cmp.get("c.getDomain");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.Host", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
		$A.enqueueAction(action);
	}
})