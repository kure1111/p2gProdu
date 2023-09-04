({
	 CSV2JSON: function (component,csv) {
        var arr = []; 
        
        arr =  csv.split('\n');
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        var totaHeaders = headers.length -1;
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                
                if(j <= totaHeaders)
                {
                     obj[headers[j].trim()] = data[j].trim();
                }
             }
            jsonObj.push(obj);
            console.log(jsonObj);
        }        
        var json = JSON.stringify(jsonObj);
        return json;  
    },
    
    Save : function (component,jsonstr){
        var quoteId = component.get("v.recordId");
        var action = component.get("c.createLines");  
        action.setParams({
            "jsn" : jsonstr
        });
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (state === "SUCCESS") {  
                var res = response.getReturnValue();
                if(res == "ok"){
                    console.log("Insert correct"); 
                    component.set("v.HideSpinner", false);
                    toastEvent.setParams({
                        title: "Success",
                        message: "Cargo Lines inserted successfully",
                        type: "success"
                    });
                    toastEvent.fire();
                   // $A.get('e.force:refreshView').fire();
                }else{
                    console.log("Error: " + res);
                    component.set("v.HideSpinner", false);
                    toastEvent.setParams({
                        title: "Error",
                        message: res,
                        type: "error"
                    });
                    toastEvent.fire();
                }                            
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.HideSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        toastEvent.setParams({
                            title: "Error",
                            message: errors[0].message,
                            type: "error"
                        });
                        toastEvent.fire();
                    }
                } else {
                    component.set("v.HideSpinner", false);
                    console.log("Unknown error");
                    toastEvent.setParams({
                        title: "Error",
                        message: "Unknown error",
                        type: "error"
                    });
                    toastEvent.fire();
                }
            }
        }); 
        $A.enqueueAction(action);    
    }
})