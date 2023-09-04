({
    waiting: function(component, event, helper) {
        component.set("v.HideSpinner", true);
    },
    
    doneWaiting: function(component, event, helper) {
        component.set("v.HideSpinner", false);
    },
    
    CreateRecord: function (component, event, helper) { 
      
        var fileInput = component.get("v.fileToBeUploaded"); 
        
        if (fileInput && fileInput.length > 0) {
            component.set("v.HideSpinner", true);
            var file = fileInput[0][0];
            var array = file.name.split(".");
            var ext = array[array.length - 1];
            console.log('ext: ' + ext);
            if(ext == "csv"){
                var reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                reader.onload = function (evt) {
                    var csv = evt.target.result;
                    console.log('CSV: ' + csv);
                    var result = helper.CSV2JSON(component,csv);
                    console.log('@@@ result = ' + result);
                    helper.Save(component, result);
                   
                }
                reader.onerror = function (evt) {
                    console.log("error reading file");
                    component.set("v.HideSpinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: "error reading file",
                        type: "error"
                    });
                    toastEvent.fire();
                }
            }else{
                component.set("v.HideSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Please upload supported file (csv)",
                    type: "error"
                });
                toastEvent.fire();
            }
        }else{
            component.set("v.HideSpinner", false);
            alert("Seleccionar un archivo a procesar");
        }        
    }
})