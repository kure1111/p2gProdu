global class P2G_sendEmailForsuppliersScheduler implements Schedulable {
	global void execute(SchedulableContext ctx) {
        P2G_sendEmailForsuppliers.sendEmailsToSupplyChainPartners();
    }
}