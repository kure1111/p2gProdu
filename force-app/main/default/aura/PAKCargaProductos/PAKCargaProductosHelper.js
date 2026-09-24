({
    //Import PE
    // Parser CSV real (RFC 4180): respeta comas y saltos de linea DENTRO de comillas
    // y las comillas escapadas "". El split(',') de antes rompia el renglon si una
    // direccion traia coma, y el arr.pop() tiraba el ultimo renglon del archivo
    // cuando no terminaba con salto de linea.
    parseCsv: function (texto) {
        // COMILLA en vez del literal: el parser de Aura truena con '"' dentro del JS
        var COMILLA = String.fromCharCode(34);
        var filas = [], fila = [], campo = '', entreComillas = false;
        if (texto.length > 0 && texto.charCodeAt(0) === 0xFEFF) { texto = texto.substring(1); }
        for (var i = 0; i < texto.length; i++) {
            var ch = texto.charAt(i);
            if (entreComillas) {
                if (ch === COMILLA) {
                    if (texto.charAt(i + 1) === COMILLA) { campo += COMILLA; i++; }
                    else { entreComillas = false; }
                } else { campo += ch; }
            } else if (ch === COMILLA) { entreComillas = true; }
            else if (ch === ',') { fila.push(campo); campo = ''; }
            else if (ch === '\r' || ch === '\n') {
                if (ch === '\r' && texto.charAt(i + 1) === '\n') { i++; }
                fila.push(campo); campo = '';
                filas.push(fila); fila = [];
            } else { campo += ch; }
        }
        if (campo !== '' || fila.length > 0) { fila.push(campo); filas.push(fila); }
        // fuera SOLO los renglones vacios del FINAL (los deja Excel); los de en
        // medio se CONSERVAN: si se quitaran, el numero de renglon del reporte de
        // errores ya no coincidiria con el archivo que el usuario ve en Excel
        var esVacia = function (f) {
            for (var c = 0; c < f.length; c++) {
                if (f[c].trim() !== '') { return false; }
            }
            return true;
        };
        while (filas.length > 0 && esVacia(filas[filas.length - 1])) { filas.pop(); }
        return filas;
    },
    CSV2JSON: function (component, csv) {
        var filas = this.parseCsv(csv);
        if (filas.length < 2) { return JSON.stringify([]); }
        var headers = filas[0];
        var jsonObj = [];
        for (var i = 1; i < filas.length; i++) {
            var data = filas[i];
            var obj = {};
            for (var j = 0; j < data.length && j < headers.length; j++) {
                if (headers[j].trim() === "IsActive" || headers[j].trim() === "Precio_en_Dollares__c" || headers[j].trim() === "Dollar__c")
                    obj[headers[j].trim()] = data[j].trim().toLowerCase();
                else
                    obj[headers[j].trim()] = data[j].trim();
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        return json;
    },
    // las columnas se mapean POR NOMBRE de encabezado: uno renombrado se ignoraba
    // EN SILENCIO y todas sus celdas llegaban vacias al servidor
    encabezadosFaltantes: function (csv) {
        var esperados = ['paisOrigen', 'estadoOrigen', 'ciudadOrigen', 'paisDestino', 'estadoDestino', 'ciudadDestino',
                         'cantidad', 'frecuencia', 'modalidad', 'unidadPorFrecuencia', 'tipoDeMercancia', 'pesoDeCarga',
                         'tiempoDeCarga', 'tiempoDeDescarga', 'direccionDeCarga', 'direccionDeDescarga'];
        var filas = this.parseCsv(csv);
        if (filas.length === 0) { return esperados; }
        var presentes = {};
        for (var j = 0; j < filas[0].length; j++) { presentes[filas[0][j].trim()] = true; }
        var faltan = [];
        for (var k = 0; k < esperados.length; k++) {
            if (!presentes[esperados[k]]) { faltan.push(esperados[k]); }
        }
        return faltan;
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
                    component.set("v.mostrarErrores", false);
                    component.set("v.erroresCarga", []);
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
                    // reporte completo de errores (todo o nada: no se cargo ningun renglon)
                    var reporte = null;
                    if (res && res.charAt && res.charAt(0) === '{') {
                        try {
                            var parseado = JSON.parse(res);
                            if (parseado && parseado.status === 'errores' && parseado.errores) { reporte = parseado; }
                        } catch (ignorar) {}
                    }
                    if (reporte) {
                        this.mostrarReporteErrores(component, reporte);
                        toastEvent.setParams({
                            mode: 'sticky',
                            title: "El archivo tiene " + reporte.total + " errores",
                            message: "No se cargó ningún renglón. El detalle está abajo, con opción de copiarlo o descargarlo.",
                            type: "error"
                        });
                        toastEvent.fire();
                    } else {
                        toastEvent.setParams({
                            mode: 'sticky',
                            title: "Error",
                            message: res,
                            type: "error"
                        });
                        toastEvent.fire();
                    }
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
    mostrarReporteErrores: function (component, reporte) {
        component.set("v.erroresCarga", reporte.errores);
        component.set("v.totalErrores", reporte.total);
        component.set("v.mostrarErrores", true);
    },
    erroresACsv: function (errores) {
        var COMILLA = String.fromCharCode(34);
        var esc = function (v) {
            v = (v === undefined || v === null) ? '' : String(v);
            if (v.indexOf(COMILLA) >= 0 || v.indexOf(',') >= 0 || v.indexOf('\n') >= 0) {
                v = COMILLA + v.split(COMILLA).join(COMILLA + COMILLA) + COMILLA;
            }
            return v;
        };
        var lineas = ['Renglon,Columna,Valor,Problema,Sugerencia'];
        for (var i = 0; i < errores.length; i++) {
            var e = errores[i];
            lineas.push([e.renglon, e.columna, esc(e.valor), esc(e.problema), esc(e.sugerencia)].join(','));
        }
        return lineas.join('\n');
    },
    // texto con tabuladores: al pegarlo en Excel cae en columnas
    erroresATexto: function (errores) {
        var TAB = String.fromCharCode(9);
        var lineas = [['Renglon', 'Columna', 'Valor', 'Problema', 'Sugerencia'].join(TAB)];
        for (var i = 0; i < errores.length; i++) {
            var e = errores[i];
            lineas.push([e.renglon, e.columna, e.valor || '', e.problema || '', e.sugerencia || ''].join(TAB));
        }
        return lineas.join('\n');
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
