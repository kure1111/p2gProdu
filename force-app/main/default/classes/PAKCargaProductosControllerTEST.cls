@isTest(seeAllData=true)
public class PAKCargaProductosControllerTEST {
    
    /**
    * @author		Diego Aguilar
    * @version 		1.0
    * @date 		26/04/22
    * @description	Clase TEST de la clase Apex "PAKCargaProductosController".
    */
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
        Test.stopTest();
    }
}