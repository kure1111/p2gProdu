@IsTest
public class P2G_PAK_ReporteVentasTest {
  
	@IsTest
    static void main_test() {
		PAK_ReporteVentas rv = new PAK_ReporteVentas();        
        
        rv.lsResponse = new List<PAK_ReporteVentas.Response>();
        rv.lsR = new List<PAK_ReporteVentas.Response>();
        rv.Filtro = new Account();
        User user = [SELECT Id, SalesEmployer__c  FROM User WHERE Id =:UserInfo.getUserId()];
		      
        if (user.SalesEmployer__c == null){
        	user.SalesEmployer__c = '9999';
            update user;
        }
        rv.Filtro.SAP_Create_Date__c = Date.newInstance(2026, 2, 11);
        rv.Filtro.Fecha_Recepcion_Factura__c = Date.newInstance(2026, 2, 13);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(6));
        rv.SendWs();
        Test.stopTest();
    }
    @IsTest
    static void error_test() {
        
		PAK_ReporteVentas rv = new PAK_ReporteVentas();        
        
        rv.lsResponse = new List<PAK_ReporteVentas.Response>();
        rv.lsR = new List<PAK_ReporteVentas.Response>();
        rv.Filtro = new Account();
        User user = [SELECT Id, SalesEmployer__c  FROM User WHERE Id =:UserInfo.getUserId()];
		      
        if (user.SalesEmployer__c == null){
        	user.SalesEmployer__c = '9999';
            update user;
        }
        rv.Filtro.SAP_Create_Date__c = Date.newInstance(2026, 2, 11);
        rv.Filtro.Fecha_Recepcion_Factura__c = Date.newInstance(2026, 2, 13);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(7));
        rv.SendWs();
        Test.stopTest();
    }
}