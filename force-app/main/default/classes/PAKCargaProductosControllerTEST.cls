@isTest(seeAllData=true)
public class PAKCargaProductosControllerTEST {

    // fila valida anclada a ciudades que existen en UAT y Produ (las mismas del test original)
    private static PAKCargaProductosController.csvProducts filaBase(){
        PAKCargaProductosController.csvProducts prod = new PAKCargaProductosController.csvProducts();
        prod.paisOrigen = 'Mexico';
        prod.estadoOrigen = 'Tamaulipas';
        prod.ciudadOrigen = 'Altamira';
        prod.paisDestino = 'Mexico';
        prod.estadoDestino = 'Nuevo Leon';
        prod.ciudadDestino = 'Rayones';
        prod.cantidad = 1;
        prod.frecuencia = 'Diario';
        prod.modalidad = 'Rabon';
        prod.unidadPorFrecuencia = 'Desc';
        prod.tipoDeMercancia = 'na';
        prod.pesoDeCarga = 500;
        prod.tiempoDeCarga = 24;
        prod.tiempoDeDescarga = 12;
        prod.direccionDeCarga = 'dri';
        prod.direccionDeDescarga = 'dir';
        return prod;
    }

    private static Integer cuentaOlis(Id oppId){
        return [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId = :oppId];
    }

    @isTest static void testA(){
        List<PAKCargaProductosController.csvProducts> jsonList = new List<PAKCargaProductosController.csvProducts>();
        jsonList.add(filaBase());
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(JSON.serialize(jsonList), opp.Id);
        Test.stopTest();
    }

    // los errores se ACUMULAN (antes se detenia en el primero) y traen sugerencia
    @isTest static void testErroresAcumuladosYSugerencias(){
        List<PAKCargaProductosController.csvProducts> jsonList = new List<PAKCargaProductosController.csvProducts>();
        PAKCargaProductosController.csvProducts conTypoCiudad = filaBase();
        conTypoCiudad.ciudadDestino = 'Altamirra'; // typo: la real es Altamira
        jsonList.add(conTypoCiudad);
        PAKCargaProductosController.csvProducts conTypoEstado = filaBase();
        conTypoEstado.estadoOrigen = 'Tamaulipass';
        jsonList.add(conTypoEstado);
        PAKCargaProductosController.csvProducts conFrecuenciaMala = filaBase();
        conFrecuenciaMala.frecuencia = 'CadaLuna';
        jsonList.add(conFrecuenciaMala);

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Integer olisAntes = cuentaOlis(opp.Id);
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(JSON.serialize(jsonList), opp.Id);
        Test.stopTest();

        System.assert(resul.startsWith('{'), 'Esperaba reporte JSON de errores, vino: ' + resul);
        Map<String, Object> rep = (Map<String, Object>) JSON.deserializeUntyped(resul);
        System.assertEquals('errores', (String) rep.get('status'));
        List<Object> errs = (List<Object>) rep.get('errores');
        System.assert(errs.size() >= 3, 'Esperaba al menos 3 errores acumulados, vinieron: ' + errs.size());

        Boolean sugiereAltamira = false;
        Boolean reportaEstadoRenglon3 = false;
        Boolean reportaFrecuenciaRenglon4 = false;
        for (Object o : errs) {
            Map<String, Object> e = (Map<String, Object>) o;
            String columna = (String) e.get('columna');
            Integer renglon = (Integer) e.get('renglon');
            String sugerencia = String.valueOf(e.get('sugerencia'));
            if (columna == 'ciudadDestino' && renglon == 2 && sugerencia.contains('Altamira')) sugiereAltamira = true;
            if (columna == 'estadoOrigen' && renglon == 3) reportaEstadoRenglon3 = true;
            if (columna == 'frecuencia' && renglon == 4) reportaFrecuenciaRenglon4 = true;
        }
        System.assert(sugiereAltamira, 'El typo Altamirra debia sugerir Altamira: ' + resul);
        System.assert(reportaEstadoRenglon3, 'Faltó el error de estado del renglon 3: ' + resul);
        System.assert(reportaFrecuenciaRenglon4, 'Faltó el error de frecuencia del renglon 4: ' + resul);
        // TODO O NADA: con errores no se carga ningun renglon
        System.assertEquals(olisAntes, cuentaOlis(opp.Id), 'Con errores no debe cargarse nada');
    }

    // un numero invalido o vacio se reporta con renglon y columna, ya no tumba el archivo
    @isTest static void testNumeroInvalidoYCeldaVacia(){
        String jsn = '[{"paisOrigen":"Mexico","estadoOrigen":"Tamaulipas","ciudadOrigen":"Altamira",'
            + '"paisDestino":"Mexico","estadoDestino":"Nuevo Leon","ciudadDestino":"Rayones",'
            + '"cantidad":"abc","frecuencia":"Diario","modalidad":"Rabon","unidadPorFrecuencia":"Desc",'
            + '"tipoDeMercancia":"na","pesoDeCarga":"","tiempoDeCarga":"24","tiempoDeDescarga":"12",'
            + '"direccionDeCarga":"x","direccionDeDescarga":"y"}]';
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(jsn, opp.Id);
        Test.stopTest();

        System.assert(resul.startsWith('{'), 'Esperaba reporte JSON, vino: ' + resul);
        Map<String, Object> rep = (Map<String, Object>) JSON.deserializeUntyped(resul);
        Boolean cantidadNoNumero = false;
        Boolean pesoVacio = false;
        for (Object o : (List<Object>) rep.get('errores')) {
            Map<String, Object> e = (Map<String, Object>) o;
            if ((String) e.get('columna') == 'cantidad' && (Integer) e.get('renglon') == 2
                && String.valueOf(e.get('valor')) == 'abc') cantidadNoNumero = true;
            if ((String) e.get('columna') == 'pesoDeCarga' && (Integer) e.get('renglon') == 2) pesoVacio = true;
        }
        System.assert(cantidadNoNumero, 'Faltó el error de cantidad no numérica: ' + resul);
        System.assert(pesoVacio, 'Faltó el error de peso vacío: ' + resul);
    }

    // renglon vacio = UN error con numero correcto; tiempo con decimales = error de
    // entero; frecuencia en minusculas NO es error (se normaliza al valor oficial)
    @isTest static void testRenglonVacioTiempoNoEnteroYFrecuenciaNormalizada(){
        String vacia = '{"paisOrigen":"","estadoOrigen":"","ciudadOrigen":"","paisDestino":"","estadoDestino":"","ciudadDestino":"","cantidad":"","frecuencia":"","modalidad":"","unidadPorFrecuencia":"","tipoDeMercancia":"","pesoDeCarga":"","tiempoDeCarga":"","tiempoDeDescarga":"","direccionDeCarga":"","direccionDeDescarga":""}';
        String conDecimal = '{"paisOrigen":"Mexico","estadoOrigen":"Tamaulipas","ciudadOrigen":"Altamira",'
            + '"paisDestino":"Mexico","estadoDestino":"Nuevo Leon","ciudadDestino":"Rayones",'
            + '"cantidad":"1","frecuencia":"diario","modalidad":"Rabon","unidadPorFrecuencia":"Desc",'
            + '"tipoDeMercancia":"na","pesoDeCarga":"500","tiempoDeCarga":"2.5","tiempoDeDescarga":"12",'
            + '"direccionDeCarga":"x","direccionDeDescarga":"y"}';
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario('[' + vacia + ',' + conDecimal + ']', opp.Id);
        Test.stopTest();

        System.assert(resul.startsWith('{'), 'Esperaba reporte JSON, vino: ' + resul);
        Map<String, Object> rep = (Map<String, Object>) JSON.deserializeUntyped(resul);
        Boolean renglonVacio = false;
        Boolean tiempoNoEntero = false;
        Boolean errorDeFrecuencia = false;
        for (Object o : (List<Object>) rep.get('errores')) {
            Map<String, Object> e = (Map<String, Object>) o;
            if ((Integer) e.get('renglon') == 2 && String.valueOf(e.get('problema')).contains('vacío')
                && (String) e.get('columna') == '(todo el renglón)') renglonVacio = true;
            if ((Integer) e.get('renglon') == 3 && (String) e.get('columna') == 'tiempoDeCarga'
                && String.valueOf(e.get('problema')).contains('entero')) tiempoNoEntero = true;
            if ((String) e.get('columna') == 'frecuencia') errorDeFrecuencia = true;
        }
        System.assert(renglonVacio, 'Faltó el error único de renglón vacío: ' + resul);
        System.assert(tiempoNoEntero, 'Faltó el error de tiempo no entero: ' + resul);
        System.assert(!errorDeFrecuencia, 'La frecuencia en minúsculas no debía ser error: ' + resul);
    }

    // ciudad y estado existen por separado pero la combinacion no: sugiere el estado real
    @isTest static void testCombinacionSugiereEstado(){
        PAKCargaProductosController.csvProducts fila = filaBase();
        fila.ciudadDestino = 'Guadalajara';
        fila.estadoDestino = 'Nuevo Leon';
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(
            JSON.serialize(new List<PAKCargaProductosController.csvProducts>{ fila }), opp.Id);
        Test.stopTest();

        System.assert(resul.startsWith('{'), 'Esperaba reporte JSON, vino: ' + resul);
        Map<String, Object> rep = (Map<String, Object>) JSON.deserializeUntyped(resul);
        Boolean combinacion = false;
        for (Object o : (List<Object>) rep.get('errores')) {
            Map<String, Object> e = (Map<String, Object>) o;
            if ((String) e.get('columna') == 'ciudadDestino'
                && String.valueOf(e.get('problema')).contains('no en ese estado')
                && String.valueOf(e.get('sugerencia')).contains('existe en')) combinacion = true;
        }
        System.assert(combinacion, 'Faltó el error de combinación con sugerencia de estado: ' + resul);
    }

    // una fila buena + una mala: no se carga NINGUNA (sin control de duplicados,
    // una carga parcial mas el reintento corregido duplicaria las buenas)
    @isTest static void testTodoONada(){
        List<PAKCargaProductosController.csvProducts> jsonList = new List<PAKCargaProductosController.csvProducts>();
        jsonList.add(filaBase());
        PAKCargaProductosController.csvProducts mala = filaBase();
        mala.ciudadDestino = 'Xyzinexistente';
        jsonList.add(mala);
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Integer olisAntes = cuentaOlis(opp.Id);
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(JSON.serialize(jsonList), opp.Id);
        Test.stopTest();

        System.assert(resul.startsWith('{'), 'Esperaba reporte JSON, vino: ' + resul);
        System.assertEquals(olisAntes, cuentaOlis(opp.Id), 'La fila buena no debió cargarse si otra falló');
    }
}
