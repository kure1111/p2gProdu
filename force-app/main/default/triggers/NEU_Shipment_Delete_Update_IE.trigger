/**
 * Created by aserrano on 22/11/2017.
 */

trigger NEU_Shipment_Delete_Update_IE on Shipment__c (before delete)
{

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    List<Customer_Quote__c> ieToUpdate = new List<Customer_Quote__c>();

    for (Shipment__c shipment:Trigger.old)
    {

        List<Shipment_Disbursement__c> sDisbur = [SELECT Id from Shipment_Disbursement__c where Shipment__c = :shipment.Id];
        List<Invoice__c> sInvoice = [SELECT Id from Invoice__c where Shipment__c = :shipment.Id];

        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];

        if( (sDisbur.size() > 0 || sInvoice.size() > 0) && ProfileName.Name != 'System Administrator' )
        //if( (sDisbur.size() > 0 || sInvoice.size() > 0))
        {
            shipment.addError('Error, you can\'t delete a shipment that contains Invoices / Disbursements');
        }
        else
        {
            List<Customer_Quote__c> ies = [
                    SELECT Id, Quotation_Status__c
                    FROM Customer_Quote__c
                    WHERE
                            Last_Shipment__c = :shipment.Id
            ];

            if (ies.size() > 0)
            {
                ies[0].Quotation_Status__c = 'Approved as Succesful';
                ieToUpdate.add(ies[0]);
            }
        }
    }

    if (ieToUpdate.size()>0)
        update ieToUpdate;
}