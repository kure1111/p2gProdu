@isTest(SeeAllData=true)
public class P2G_tiempoTranscurridoOppoTest {
	@isTest
    static void prueba() {
        Opportunity oppo = [SELECT Id, StageName, CreatedDate, AccountId FROM Opportunity LIMIT 1];
        Test.startTest();
        oppo.StageName = 'Entendimiento';
        update oppo;
        String etapa = P2G_tiempoTranscurridoOppo.etapa(oppo);
        P2G_tiempoTranscurridoOppo.multiplicacionAnual(23.23,'Diario');
        P2G_tiempoTranscurridoOppo.multiplicacionAnual(23.23,'Semanal');
        P2G_tiempoTranscurridoOppo.multiplicacionAnual(23.23,'Mensual');
        P2G_tiempoTranscurridoOppo.multiplicacionAnual(23.23,'Anual');
        P2G_tiempoTranscurridoOppo.multiplicacionAnual(23.23,'sdkhskf');
        
        DateTime fechaActual = System.now();
        
        // Fecha y hora de creación (por ejemplo, hace 7 días)
        DateTime fechaCreacion = System.now().addDays(-7);
        
        P2G_tiempoTranscurridoOppo.tiempoTranscurridoOli(fechaCreacion,fechaActual);
        List<String> lista = new List<String>();
        lista.add(oppo.Id);
        P2G_tiempoTranscurridoOppo.sumaTotalAmount(lista);
        P2G_tiempoTranscurridoOppo.quoteVendida(oppo.Id);
        P2G_tiempoTranscurridoOppo.statusOpportunityProduct(oppo.Id);
        OpportunityLineItem oli = new OpportunityLineItem ();
        oli.PROJ_Frecuencia__c = 'Diario';
        oli.Quantity = 2;
        P2G_tiempoTranscurridoOppo.multiplicacionTotalAmount(123.45,oli);
        oli.PROJ_Frecuencia__c = 'Semanal';
        P2G_tiempoTranscurridoOppo.multiplicacionTotalAmount(123.45,oli);
        oli.PROJ_Frecuencia__c = 'Mensual';
        P2G_tiempoTranscurridoOppo.multiplicacionTotalAmount(123.45,oli);
        oli.PROJ_Frecuencia__c = 'Anual';
        P2G_tiempoTranscurridoOppo.multiplicacionTotalAmount(123.45,oli);
        oli.PROJ_Frecuencia__c = 'hfgj';
        P2G_tiempoTranscurridoOppo.multiplicacionTotalAmount(123.45,oli);
        P2G_tiempoTranscurridoOppo.validaCliente(oppo.AccountId);
        P2G_tiempoTranscurridoOppo.pase();
        Test.stopTest();
    }
}