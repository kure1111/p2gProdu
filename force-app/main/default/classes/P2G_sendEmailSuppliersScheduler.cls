global class P2G_sendEmailSuppliersScheduler implements Schedulable {
	global void execute(SchedulableContext ctx) {
        P2G_sendEmailSuppliers.sendEmailsToSupplyChainPartners();
    }
}