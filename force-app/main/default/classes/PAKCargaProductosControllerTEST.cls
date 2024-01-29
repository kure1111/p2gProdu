@isTest(seeAllData=true)
public class PAKCargaProductosControllerTEST {
    @isTest static void testA(){
        String jsn = '{\n' +
            '"paisOrigen":["Mexico"],' +
            '"estadoOrigen":["Tamaulipas"],' +
            '"ciudadOrigen":["Altamira"],' +
            '"paisDestino":["Mexico"],' +
            '"estadoDestino":["Nuevo Leon"],' +
            '"ciudadDestino":["Rayones"],' +
            '"cantidad":["1"],' +
            '"frecuencia":["Diario"],'+
            '"modalidad":["Rabon"],' +
            '"unidadPorFrecuencia":["Desc"],' +
            '"tipoDeMercancia":["na"],' +
            '"pesoDeCarga":["5000"],' +
            '"tiempoDeCarga":["24"],' +
            '"tiempoDeDescarga":["12"],' +
            '"direccionDeCarga":["AV. HIDALGO"],\n' +
            '"direccionDeDescarga":["CALZ COAH"]' +
            '}';
		
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        PAKCargaProductosController.cargarTarifario(jsn, opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testB(){
        Test.startTest();
        PAKCargaProductosController.test();
        PAKCargaProductosController.CsvProducts product = new PAKCargaProductosController.CsvProducts();
        product.paisOrigen = 'Origen';
        product.estadoOrigen = 'EstadoOrigen';
        product.ciudadOrigen = 'CiudadOrigen';
        product.paisDestino = 'Destino';
        product.estadoDestino = 'EstadoDestino';
        product.ciudadDestino = 'CiudadDestino';
        product.cantidad = 10.0;
        product.frecuencia = 'Frecuencia';
        product.modalidad = 'Modalidad';
        product.unidadPorFrecuencia = 'Unidad';
        product.tipoDeMercancia = 'TipoMercancia';
        product.pesoDeCarga = 100.0;
        product.tiempoDeCarga = 5;
        product.tiempoDeDescarga = 3;
        product.direccionDeCarga = 'Carga';
        product.direccionDeDescarga = 'Descarga';
        Test.stopTest();
    }
}