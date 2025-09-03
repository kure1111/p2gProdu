({
    //Import PE
    CSV2JSON: function (component,csv) {
        var arr = []; 
        
        arr =  csv.split('\n');
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
         
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                if(headers[j] === "IsActive" || headers[j]==="Precio_en_Dollares__c" || headers[j] ==="Dollar__c")
                obj[headers[j].trim()] = data[j].trim().toLowerCase();
                else
                     obj[headers[j].trim()] = data[j].trim();
            }
            jsonObj.push(obj);
        }        
        var json = JSON.stringify(jsonObj);
        return json;  
    },
    CreateLines : function (component,jsonstr,funApex){
          //  jsonstr = jsonstr.replace(/__c/,"");
        var entryId = component.get("v.recordId");
        var action = component.get(funApex);  
        action.setParams({
            "jsn" : jsonstr,
            "idOpportunity" : entryId
        });
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class", "slds-hide");
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (state === "SUCCESS") {  
                var res = response.getReturnValue();
                if(res == "ok"){
                    console.log("Insert correct");    
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "La carga de precios finalizo con exito",
                        message: "La lista se cargo existosamente",
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
    },
    //export helper start from here PRODUCT2
    onLoadProd: function(component, event) {
        //call apex class method
      /*  var action = component.get('c.fetchProduct');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.ListOfProduct', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);*/
    },
    //Descarga de csvPRODUCT2
    convertArrayOfObjectsToCSVProd : function(component,objectRecords){
        console.log('objectRecords' + objectRecords);
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys variable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ["Id","Name","Description ","Family", "ProductCode", "Unidad_de_medida__c", "Descfam_prod__r","IsActive", "Dollar__c"];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]; 
              
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                } 
                // if condition for blank column display if value is empty
                if(objectRecords[i][skey] != undefined){
                    
                    if(skey !="IsActive" && skey !="Dollar__c" && skey !="Descfam_prod__r")
                        
                    {
                        var str = objectRecords[i][skey];
                        str = str.toString().replace(/,/g,"").replace(/[""]/g,"").replace(/~/g,"");
                        csvStringResult +=  str; 
                    }
                    else if(skey =="Descfam_prod__r")
                        
                    {
                        var str = objectRecords[i][skey];
                        csvStringResult +=  str.Name; 
                    }
                    else
                        csvStringResult += objectRecords[i][skey]; 
                }else
                {
                    csvStringResult += '"'+ '' +'"';
                }
                counter++;
                
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult; 
        
    }

})