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
}