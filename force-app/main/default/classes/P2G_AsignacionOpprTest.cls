@isTest
public class P2G_AsignacionOpprTest {
    @isTest
    static void monitoreoTest(){
        Test.startTest();
        list<String> datos = new list<String>();
        datos.add('2');
        datos.add('Pending');
        datos.add('2013-12-12');
        datos.add('2013-12-12');
        datos.add('all');
        datos.add('all');
        P2G_AsignacionOppr.seccion3(datos);
        P2G_AsignacionOppr.columns('a0JRL0000003BBp2AM',datos);
        P2G_AsignacionOppr.searchAccounts('hola');
        P2G_AsignacionOppr.searchOpExecutive('hola');
        P2G_AsignacionOppr.updateExecute('a0JRL0000006w4X2AQ',datos);
        Test.stopTest();
    }

}