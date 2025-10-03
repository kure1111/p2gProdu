trigger P2G_DeleteInvoiceLine on Invoice_Line__c (before delete) {
    P2G_InvoiceLineTriggerHandler.validateDeletion(Trigger.old);
}