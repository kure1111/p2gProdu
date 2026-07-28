public class P2G_ServiceRateDeactivation_Schedule implements Schedulable {
    /*
     * Cada lunes a las 4:30AM 
    System.schedule(
		'Desactivacion Automatica de Tarifarios',
		'0 30 4 ? * MON',
		new P2G_ServiceRateDeactivation_Schedule());
	*/
    public void execute (SchedulableContext sc) {
       
		P2G_ServiceRateDeactivation_Batch batch = new P2G_ServiceRateDeactivation_Batch();
        Database.executeBatch(batch, 100);
    }
}