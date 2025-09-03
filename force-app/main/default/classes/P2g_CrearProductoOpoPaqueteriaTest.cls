@isTest
public class P2g_CrearProductoOpoPaqueteriaTest {
	@isTest(SeeAllData=true)
    static void claseTest(){
        OpportunityLineItem oli = [SELECT OpportunityId, Product2Id, PricebookEntryId FROM OpportunityLineItem LIMIT 1];
        List<PricebookEntry> getProductos = P2g_CrearProductoOpoPaqueteria.getProductos();
        P2g_CrearProductoOpoPaqueteria.csvProduct getCsv = P2g_CrearProductoOpoPaqueteria.getCsv();
        getCsv.Name = '';
        getCsv.opportunityId = oli.OpportunityId;
        getCsv.PricebookEntryId = oli.PricebookEntryId;
        getCsv.Product2Id = oli.Product2Id;
        getCsv.idProduct2 = '';
        getCsv.status = 'Cotizada';
        getCsv.cantidad = '1';
        getCsv.precioVenta = '10';
        getCsv.frecuencia = 'Semanal';
        getCsv.comentarios = '';
        getCsv.currencyOli = 'MXN';
        OpportunityLineItem llenarProducto = P2g_CrearProductoOpoPaqueteria.llenarProducto(getCsv);
        String jsonString = json.serialize(getCsv);
        String cargarProducto = P2g_CrearProductoOpoPaqueteria.cargarProducto(jsonString);
    }
}