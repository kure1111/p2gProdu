({
    // export data start from here    
    // ## function call on component load  
    loadContactList: function(component, event, helper){
         helper.onLoadProd(component, event);
        
    },
    // ## function call on Click on the "Download As CSV" Button. 
    downloadProdCsv : function(component,event,helper){
        
        //Agregamos spinner
        component.find("Id_spinner").set("v.class" , 'slds-show');
        
        //Funcion para mostrar spinner
        setTimeout($A.getCallback(function() {
            var i = 0;
            while(i < 1e5) {
                i++;
            }

            //Descargando Archivo
            // get the Records [contact] list from 'ListOfContact' attribute 
            var stockData = component.get("v.ListOfProduct");
            
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSVProd(component,stockData);   
            if (csv == null){
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                return;
            } 
                  
           //this code works for chrome but not for other browsers like IE or Edge 
           var csvFile = new Blob(["\ufeff",csv]); 
           var downloadLink = document.createElement("a"); 
           downloadLink.download = 'Alta productos.csv'; // CSV file Name* you can change it. [only name not .csv] 
           downloadLink.href = window.URL.createObjectURL(csvFile); 
           downloadLink.style.display = "none"; 
           downloadLink.target = '_blank';  
           document.body.appendChild(downloadLink); 
           downloadLink.click();
           component.find("Id_spinner").set("v.class" , 'slds-hide');
           //Termina descarga

        }),50);
        
    },
    //IMPORT PROD2
     CreateRecordProd: function (component, event, helper) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var fileInput = component.get("v.fileToBeUploadedProd"); 
        if (fileInput && fileInput.length > 0) {
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
                   // result = result.replace(/"__c"/,"");
                    console.log('@@@ result = ' + result);
                    helper.CreateLines(component, result,"c.cargarTarifario");
                }
                reader.onerror = function (evt) {
                    console.log("error reading file");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Error al cargar precios",
                        message: "Error al leer el archivo",
                        type: "error"
                    });
                    toastEvent.fire();
                    //component.find("Id_spinner").set("v.class" , 'slds-hide');
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    title: "Error al cargar precios",
                    message: "Subir solamente archivo soportado (csv)",
                    type: "error"
                });
                toastEvent.fire();
                //component.find("Id_spinner").set("v.class" , 'slds-hide');
            }
        }else{
            alert("Seleccionar un archivo .csv para procesar");
            //component.find("Id_spinner").set("v.class" , 'slds-hide');
        }
              
    }
    
})