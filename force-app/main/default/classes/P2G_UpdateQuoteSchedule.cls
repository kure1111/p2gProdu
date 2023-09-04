public class P2G_UpdateQuoteSchedule implements Schedulable {
    private String idfolio;
    
    public P2G_UpdateQuoteSchedule(String idfolio) {
        this.idfolio = idfolio;
    }
    public void execute(SchedulableContext sc){
        Customer_Quote__c folio = [SELECT Id, Quotation_Status__c FROM Customer_Quote__c WHERE Id=:this.idfolio limit 1];
        folio.Quotation_Status__c = 'Approved as Succesful';
        update folio;
        String IdQuote = folio.Id;
		P2G_CreaServiceLineShipment myQueueable = new P2G_CreaServiceLineShipment(IdQuote);
		System.enqueueJob(myQueueable);
    }
}