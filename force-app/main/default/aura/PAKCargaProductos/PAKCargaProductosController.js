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
      //todo el handler bajo try/catch: un TypeError aqui dentro se lo tragaba
      //Aura y dejaba el spinner prendido PARA SIEMPRE, sin toast ni peticion
      try {
        console.log('[CargaProductos] click recibido');
        component.find("Id_spinner").set("v.class" , 'slds-show');
        //un archivo nuevo empieza limpio: fuera el reporte de la carga anterior
        component.set("v.mostrarErrores", false);
        component.set("v.erroresCarga", []);
        var fileInput = component.get("v.fileToBeUploadedProd");
        console.log('[CargaProductos] fileInput typeof=' + typeof fileInput + ' len=' + (fileInput ? fileInput.length : 'na') + ' | [0] typeof=' + (fileInput && fileInput.length > 0 ? typeof fileInput[0] : 'na'));
        //el atributo puede traer el File ENVUELTO ([0][0]) o DIRECTO ([0]) segun
        //la version del componente: aceptar ambas y, si ninguna, leer del input
        var file = null;
        if (fileInput && fileInput.length > 0) {
            var primero = fileInput[0];
            file = (primero && primero.name) ? primero : ((primero && primero[0] && primero[0].name) ? primero[0] : null);
        }
        if (!file) {
            try {
                var archivosDelInput = component.find("inputArchivo").get("v.files");
                console.log('[CargaProductos] respaldo v.files len=' + (archivosDelInput ? archivosDelInput.length : 'na'));
                if (archivosDelInput && archivosDelInput.length > 0 && archivosDelInput[0] && archivosDelInput[0].name) {
                    file = archivosDelInput[0];
                }
            } catch (errRespaldo) {
                console.log('[CargaProductos] respaldo fallo: ' + errRespaldo);
            }
        }
        if (file) {
            console.log('[CargaProductos] archivo=' + file.name + ' bytes=' + file.size);
            var array = file.name.split(".");
            //toLowerCase: 'RUTAS.CSV' de Windows es un csv perfectamente valido
            var ext = array[array.length - 1].toLowerCase();
            console.log('ext: ' + ext);
            if(ext == "csv"){
                var reader = new FileReader();
                //manejadores registrados ANTES de arrancar la lectura
                reader.onload = $A.getCallback(function (evt) {
                  try {
                    var csv = evt.target.result;
                    console.log('[CargaProductos] archivo leido, chars=' + (csv ? csv.length : 'na'));
                    //el mapeo de columnas es POR NOMBRE: si falta o SOBRA un
                    //encabezado, avisar aqui mismo (una columna del template
                    //repetida y vacia pisa el valor bueno al mapear)
                    var faltan = helper.encabezadosFaltantes(csv);
                    var repetidos = helper.encabezadosRepetidos(csv);
                    if (faltan.length > 0 || repetidos.length > 0) {
                        component.find("Id_spinner").set("v.class", 'slds-hide');
                        helper.limpiaInputArchivo(component);
                        var detalle = '';
                        if (faltan.length > 0) { detalle += 'Faltan (el nombre debe ser idéntico): ' + faltan.join(', ') + '. '; }
                        if (repetidos.length > 0) { detalle += 'Vienen REPETIDAS (borra las columnas duplicadas): ' + repetidos.join(', ') + '.'; }
                        var toastHdr = $A.get("e.force:showToast");
                        toastHdr.setParams({
                            mode: 'sticky',
                            title: "El archivo no coincide con las 16 columnas del template",
                            message: detalle,
                            type: "error"
                        });
                        toastHdr.fire();
                        return;
                    }
                    var result = helper.CSV2JSON(component,csv);
                   // result = result.replace(/"__c"/,"");
                    console.log('@@@ result = ' + result);
                    helper.CreateLines(component, result,"c.cargarTarifario");
                  } catch (errLectura) {
                    console.log('[CargaProductos] ERROR procesando el archivo: ' + (errLectura && errLectura.message ? errLectura.message : errLectura));
                    component.find("Id_spinner").set("v.class", 'slds-hide');
                    helper.limpiaInputArchivo(component);
                    var toastLectura = $A.get("e.force:showToast");
                    toastLectura.setParams({
                        mode: 'sticky',
                        title: "Error procesando el archivo",
                        message: '' + (errLectura && errLectura.message ? errLectura.message : errLectura),
                        type: "error"
                    });
                    toastLectura.fire();
                  }
                });
                //$A.getCallback: el evento del FileReader llega fuera del ciclo de
                //Aura; y el spinner SIEMPRE se apaga (antes quedaba girando)
                reader.onerror = $A.getCallback(function (evt) {
                    console.log("error reading file");
                    component.find("Id_spinner").set("v.class" , 'slds-hide');
                    helper.limpiaInputArchivo(component);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: "Error al cargar precios",
                        message: "Error al leer el archivo",
                        type: "error"
                    });
                    toastEvent.fire();
                });
                reader.readAsText(file, "UTF-8");
            }else{
                component.find("Id_spinner").set("v.class" , 'slds-hide');
                helper.limpiaInputArchivo(component);
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
            //ni envuelto, ni directo, ni en el input: avisar en vez de morir mudo
            console.log('[CargaProductos] sin archivo utilizable');
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            helper.limpiaInputArchivo(component);
            var toastSinArchivo = $A.get("e.force:showToast");
            toastSinArchivo.setParams({
                mode: 'sticky',
                title: "No se pudo leer el archivo seleccionado",
                message: "Vuelve a elegir el archivo .csv. Si sigue pasando, manda una foto de la consola (F12).",
                type: "error"
            });
            toastSinArchivo.fire();
        }
      } catch (errorInesperado) {
        //pase lo que pase: spinner apagado y el error A LA VISTA
        console.log('[CargaProductos] ERROR INESPERADO: ' + (errorInesperado && errorInesperado.message ? errorInesperado.message : errorInesperado));
        try { component.find("Id_spinner").set("v.class", 'slds-hide'); } catch (ig1) {}
        try { helper.limpiaInputArchivo(component); } catch (ig2) {}
        var toastInesperado = $A.get("e.force:showToast");
        toastInesperado.setParams({
            mode: 'sticky',
            title: "Error inesperado en la carga",
            message: '' + (errorInesperado && errorInesperado.message ? errorInesperado.message : errorInesperado),
            type: "error"
        });
        toastInesperado.fire();
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
