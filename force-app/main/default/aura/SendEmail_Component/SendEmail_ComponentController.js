({
    doInit : function(component, event, helper) {

        var recordId = component.get("v.recordId");
        var url = 'www.google.com';//'/apex/AddProductosPedidos?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();

    }
})