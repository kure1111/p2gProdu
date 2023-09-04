({
    CSV2JSON: function (component,csv) {
        var arr = []; 
        
        arr =  csv.split('\n');
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = this.splitString(arr[i]);
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
            }
            jsonObj.push(obj);
        }        
        var json = JSON.stringify(jsonObj);
        return json;  
    },
    splitString : function(str){
        var delimiter = ',';  
        var quotes = '"';  
        var elements = str.split(delimiter);  
        var newElements = [];  
        for (var i = 0; i < elements.length; ++i) {  
            if (elements[i].indexOf(quotes) >= 0) {//the left double quotes is found  
                var indexOfRightQuotes = -1;  
                var tmp = elements[i];  
                //find the right double quotes  
                for (var j = i + 1; j < elements.length; ++j) {  
                    if (elements[j].indexOf(quotes) >= 0) {  
                        indexOfRightQuotes = j; 
                        break;
                    }  
                }  
                //found the right double quotes  
                //merge all the elements between double quotes  
                if (-1 != indexOfRightQuotes) {   
                    for (var j = i + 1; j <= indexOfRightQuotes; ++j) {  
                        tmp = tmp + delimiter + elements[j];  
                    }  
                    newElements.push(tmp);  
                    i = indexOfRightQuotes;  
                }  
                else { //right double quotes is not found  
                    newElements.push(elements[i]);  
                }  
            }  
            else {//no left double quotes is found  
                newElements.push(elements[i]);  
            }  
        }  
        
        return newElements;
    },
    CreateLines : function (component,jsonstr){
        var entryId = component.get("v.recordId");
        var action = component.get("c.cargarTarifario");  
        action.setParams({
            "jsn" : jsonstr
        });
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (state === "SUCCESS") {  
                var res = response.getReturnValue();
                if(res == "ok"){
                    console.log("Insert correct");    
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Carga de tarifario exitosa",
                        message: "El tarifario se cargo existosamente",
                        type: "success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                    console.log("Error: " + res);
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Error",
                        message: res,
                        type: "error"
                    });
                    toastEvent.fire();
                }                            
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        toastEvent.setParams({
                            mode: 'sticky',
                            title: "Error",
                            message: errors[0].message,
                            type: "error"
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                    toastEvent.setParams({
                        mode: 'sticky',
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