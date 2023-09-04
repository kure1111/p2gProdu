({
    CreateRecord: function (component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var fileInput = component.get("v.fileToBeUploaded"); 
        if (fileInput && fileInput.length > 0) {
            var file = fileInput[0][0];
            var array = file.name.split(".");
            var ext = array[array.length - 1];
            console.log('ext: ' + ext);
            if(ext == "csv"){
                var reader = new FileReader();
                reader.readAsText(file, "ISO-8859-1");
                reader.onload = function (evt) {
                    var csv = evt.target.result;
                    console.log('CSV: ' + csv);
                    var result = helper.CSV2JSON(component,csv);
                    console.log('json = ' + result);
                    helper.CreateLines(component, result);
                }
                reader.onerror = function (evt) {
                    console.log("error reading file");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Error Carga Tarifario",
                        message: "Error al leer el archivo",
                        type: "error"
                    });
                    toastEvent.fire();
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    title: "Error Carga Tarifario",
                    message: "Subir solamente archivo soportado (csv)",
                    type: "error"
                });
                toastEvent.fire();
                component.find("Id_spinner").set("v.class" , 'slds-hide');
            }
        }else{
            alert("Seleccionar un archivo .csv para procesar");
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        }        
    }
})