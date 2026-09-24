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
        //un archivo nuevo empieza limpio: fuera el reporte de la carga anterior
        component.set("v.mostrarErrores", false);
        component.set("v.erroresCarga", []);
        var fileInput = component.get("v.fileToBeUploadedProd");
        if (fileInput && fileInput.length > 0) {
            var file = fileInput[0][0];
            var array = file.name.split(".");
            //toLowerCase: 'RUTAS.CSV' de Windows es un csv perfectamente valido
            var ext = array[array.length - 1].toLowerCase();
            console.log('ext: ' + ext);
            if(ext == "csv"){
                var reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                reader.onload = $A.getCallback(function (evt) {
                    var csv = evt.target.result;
                    //el mapeo de columnas es POR NOMBRE: si falta un encabezado, avisar
                    //aqui mismo (antes la columna se ignoraba en silencio)
                    var faltan = helper.encabezadosFaltantes(csv);
                    if (faltan.length > 0) {
                        component.find("Id_spinner").set("v.class", 'slds-hide');
                        var toastHdr = $A.get("e.force:showToast");
                        toastHdr.setParams({
                            mode: 'sticky',
                            title: "El archivo no trae " + faltan.length + " columna(s) del template",
                            message: "Faltan (el nombre debe ser idéntico): " + faltan.join(', '),
                            type: "error"
                        });
                        toastHdr.fire();
                        return;
                    }
                    var result = helper.CSV2JSON(component,csv);
                   // result = result.replace(/"__c"/,"");
                    console.log('@@@ result = ' + result);
                    helper.CreateLines(component, result,"c.cargarTarifario");
                });
                //$A.getCallback: el evento del FileReader llega fuera del ciclo de
                //Aura; y el spinner SIEMPRE se apaga (antes quedaba girando)
                reader.onerror = $A.getCallback(function (evt) {
                    console.log("error reading file");
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Error al cargar precios",
                        message: "Error al leer el archivo",
                        type: "error"
                    });
                    toastEvent.fire();
                });
            }else{
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    title: "Error al cargar precios",
                    message: "Subir solamente archivo soportado (csv)",
                    type: "error"
                });
                toastEvent.fire();
            }
        }else{
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            alert("Seleccionar un archivo .csv para procesar");
        }

    },
    //Descarga el reporte de errores como CSV (con 95 renglones un toast no sirve)
    descargarErrores: function (component, event, helper) {
        var errores = component.get("v.erroresCarga") || [];
        if (errores.length === 0) { return; }
        var csv = helper.erroresACsv(errores);
        var csvFile = new Blob(["\ufeff", csv]);
        var downloadLink = document.createElement("a");
        downloadLink.download = 'Errores carga productos.csv';
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = "none";
        downloadLink.target = '_blank';
        document.body.appendChild(downloadLink);
        downloadLink.click();
    },
    //Copia el reporte al portapapeles, tabulado para pegarse en Excel
    copiarErrores: function (component, event, helper) {
        var errores = component.get("v.erroresCarga") || [];
        if (errores.length === 0) { return; }
        var texto = helper.erroresATexto(errores);
        var avisa = function (logrado) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams(logrado ? {
                title: "Copiado",
                message: "El reporte de errores está en el portapapeles",
                type: "success"
            } : {
                title: "No se pudo copiar",
                message: "Usa el botón Descargar errores (CSV)",
                type: "warning"
            });
            toastEvent.fire();
        };
        //el fallback confirma que execCommand de verdad copio antes de avisar
        var copiaRespaldo = function () {
            var logrado = false;
            try {
                var area = document.createElement("textarea");
                area.value = texto;
                document.body.appendChild(area);
                area.select();
                logrado = document.execCommand('copy');
                document.body.removeChild(area);
            } catch (ignorar) { logrado = false; }
            avisa(logrado);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(texto).then($A.getCallback(function () {
                avisa(true);
            })).catch($A.getCallback(copiaRespaldo));
        } else {
            copiaRespaldo();
        }
    },
    cerrarErrores: function (component, event, helper) {
        component.set("v.mostrarErrores", false);
        component.set("v.erroresCarga", []);
    }

})
