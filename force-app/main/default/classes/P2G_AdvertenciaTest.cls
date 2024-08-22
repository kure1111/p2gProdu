@IsTest
public class P2G_AdvertenciaTest {
    @IsTest(SeeAllData=true)
    public static void test(){
        List<Shipment_Fee_Line__c> lineas =  new List<Shipment_Fee_Line__c>();
        test.startTest();
        Shipment__c sp = [SELECT Id FROM Shipment__c WHERE id = 'a0JRQ0000001YfZ2AU' limit 1];
		sp.Shipment_Status_Plann__c = 'In Progress';
        P2G_Advertencia.getShipmentFeeLines(sp.Id);

        update sp;
        P2G_Advertencia.proceso(sp.Id,'prueba@gmail.com');
        Log_Aprobacion__c log = P2G_Advertencia.creaLogAprobacion(sp.Id,12,12,12);
        P2G_Advertencia.approveShipment(sp.Id, 'Aprobada');
        P2G_Advertencia.sendShipmentLink('prueba','prueba@gmail.com',log);
        P2G_Advertencia.mostrarAdvertencia(sp.Id);
        P2G_Advertencia.updateRate(lineas);
        test.stopTest();
    }

}