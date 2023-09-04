public class PK2_Utils {
    public static Transient list<Shipment_Fee_Line__History> lsFeelineHis {get;set;}
    public PK2_Utils(){
        
    }
    public pagereference getHistoriaFeeline(){
        Datetime Inicio =  DateTime.newInstance(Date.today().year(), date.today().month()-1, 1, 0-5, 0, 0);
        lsFeelineHis = new list<Shipment_Fee_Line__History>();
        lsFeelineHis =  [Select OldValue,NewValue,Parent.Shipment__c,Parent.Id,Parent.Name,Parent.CreatedDate,Parent.CreatedById,Field,CreatedDate,CreatedById,Parent.Service_Rate_Name__c From Shipment_Fee_Line__History 
                         Where (Field='Shipment_Buy_Price__c' or Field='Shipment_Sell_Price__c') and CreatedDate>=:Inicio and (Parent.Shipment__r.Name Like 'SP-A-%' or Parent.Shipment__r.Name Like 'SP-M-%'
                         or Parent.Shipment__r.Name Like 'SP-PTO-%') Order By Parent.Shipment__c desc];
        return null;
    }
}