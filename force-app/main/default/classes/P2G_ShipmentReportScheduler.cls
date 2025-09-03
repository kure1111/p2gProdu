global class P2G_ShipmentReportScheduler implements Schedulable {
    //String jobName = 'P2G_ShipmentReportSchedulerJob';
	//String cronExp = '0 0 0/3 * * ?'; // Ejecutar cada 3 horas
	//System.schedule(jobName, cronExp, new P2G_ShipmentReportScheduler());
    
    global void execute(SchedulableContext SC) {
        P2G_reporteSAC.classifyShipments();
    }
}