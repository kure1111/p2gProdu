@isTest
public class P2G_loadProductsCsvTest {
    @IsTest(SeeAllData=true)
    public static void testCargaCsv(){
        Product2 producto = [SELECT id, Name, PROJ_Site_of_load__c,PROJ_Site_of_discharge__c FROM Product2 limit 1];
        Id IdOportunidad = [SELECT Id,Name FROM Opportunity limit 1].Id;
        List <P2G_loadProducts.csvProduct> lista = new List<P2G_loadProducts.csvProduct>();
        P2G_loadProducts.csvProduct elemento = new P2G_loadProducts.csvProduct();
        elemento.cantidad = '1';
        elemento.destino='ZM de Veracruz';
        elemento.destinoId = producto.PROJ_Site_of_discharge__c;
        elemento.direccionCarga='dir';
        elemento.direccionDescarga='dir 2';
        elemento.frecuencia='Semanal';
        elemento.modalidad='Caja 53 FT';
        elemento.origen='ZM de Xalapa';
        elemento.origenId=producto.PROJ_Site_of_load__c;
        elemento.pesoDeCarga='1';
        elemento.tiempoCarga='1';
        elemento.tiempoDescarga='1';
        elemento.tipoMercancia='Papel higiénico';
        elemento.unidadPorFrecuencia='1';
        lista.add(elemento);
		elemento.cantidad = '1';
        elemento.destino='ZM de Veracruz Hoy';
        elemento.destinoId = producto.PROJ_Site_of_discharge__c;
        elemento.direccionCarga='dir';
        elemento.direccionDescarga='dir 2';
        elemento.frecuencia='Semanal';
        elemento.modalidad='Caja 53 FT';
        elemento.origen='ZM de Xalapa Choi';
        elemento.origenId=producto.PROJ_Site_of_load__c;
        elemento.pesoDeCarga='1';
        elemento.tiempoCarga='1';
        elemento.tiempoDescarga='1';
        elemento.tipoMercancia='Papel higiénico';
        elemento.unidadPorFrecuencia='1';      
        lista.add(elemento);
        P2G_loadProductsCsv.handleProduct(IdOportunidad,JSON.serialize(lista),'MXN');
        
    }    
    
}