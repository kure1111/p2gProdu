@isTest(SeeAllData=true)
public class P2G_tiempoTranscurridoOppoTest {
	@isTest
    static void prueba() {
        List<OpportunityLineItem> listOli =[SELECT Id, Name, Status__c, OpportunityId FROM OpportunityLineItem 
                                            WHERE Status__c = 'Aceptada'
                                            AND Precio_Sugerido_Venta__c != 0 AND Precio_Sugerido_Venta__c != null];
        Opportunity oppo = [SELECT Id, StageName, CreatedDate, AccountId FROM Opportunity WHERE StageName = 'Entendimiento' LIMIT 1];
        Opportunity oppoC = [SELECT Id, StageName, CreatedDate, AccountId, Data_Time_Cotizacion__c FROM Opportunity 
                             WHERE StageName = 'Cotización' AND Data_Time_Cotizacion__c != null LIMIT 1];
        Opportunity oppoN = [SELECT Id, StageName, CreatedDate, AccountId, Data_Time_Negociacion__c FROM Opportunity
                             WHERE StageName = 'Negociación' AND Data_Time_Negociacion__c != null LIMIT 1];
        
        Test.startTest();
        String etapa = P2G_tiempoTranscurridoOppo.etapa(oppo);
        String etapaC = P2G_tiempoTranscurridoOppo.etapa(oppoC);
        String etapaN = P2G_tiempoTranscurridoOppo.etapa(oppoN);
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
        lista.add(listOli[0].OpportunityId);
        P2G_tiempoTranscurridoOppo.sumaTotalAmount(lista);
        P2G_tiempoTranscurridoOppo.quoteVendida(listOli[0].OpportunityId);
        P2G_tiempoTranscurridoOppo.statusOpportunityProduct(listOli[0].OpportunityId);
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
        Test.stopTest();
    }
}