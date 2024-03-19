@isTest(seeAllData=true)
public class PAKCargaProductosControllerTEST {
    @isTest static void testA(){
    List<PAKCargaProductosController.csvProducts> jsonList = new List<PAKCargaProductosController.csvProducts>();
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
    jsonList.add(prod);
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        String resul = PAKCargaProductosController.cargarTarifario(JSON.serialize(jsonList), opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testB(){
        Test.startTest();
        
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