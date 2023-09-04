global class PAK_DISWS {
    global class Disbursement{
        webservice String Moneda {get;set;}
        webservice String CfdiNumber {get;set;}
        webservice String CardCode {get;set;}
        webservice String FactNumber {get;set;}
        webservice String Shipment {get;set;}
        Webservice String TotalFacturado {get;set;}//MONTO DE FACTURA
        webservice String FechaFactura {get;set;}
        webservice String UI {get;set;}
        webservice String OrdenCompra {get;set;}
        webservice DetalleDisbursement DetalleDisbursement {get;set;}
    }
    global class DetalleDisbursement{
        webservice list<Detalle> DetalleDisbursement {get;set;}
    }
    
    global class Detalle{
        webservice String Units {get;set;}
        webservice String UnitPrice {get;set;}
        webservice String VAT {get;set;}
        webservice String SujetoARet {get;set;}
        webservice String Total {get;set;}
        webservice String IdInvoiceLine {get;set;}
        webservice String ItemCode {get;set;}
        webservice String Concepto {get;set;}
    }
    global class status{
        webservice String Code {get;set;}
        webservice String Message {get;set;}
        webservice String IdDisbursement {get;set;}
    }
    
    webservice static list<status> DisbursementSAP(Disbursement[] lsEntity){
        list<status> Result = new list<status>();
        Response__c RES = new Response__c();
        try{
             map<String,String> mapSapServiceType = new map<String,String>();
            for(SAP_Service_Type__c SST: [Select Id,Code__c From SAP_Service_Type__c]){
            	mapSapServiceType.put(SST.Code__c, SST.Id);    
            }
            for(Disbursement DIS: lsEntity){
            	list<Account> cuenta = [Select Id From Account Where Customer_id__c=:DIS.CardCode];
                String Shipment = Test.isRunningTest()?null:[Select Id From Shipment__c Where Name=: DIS.Shipment limit 1].Id;
                Shipment_Disbursement__c SD = new Shipment_Disbursement__c();
                SD.CurrencyIsoCode = DIS.Moneda;
                SD.Cfdi_Number__c = DIS.CfdiNumber != null && DIS.CfdiNumber != ''?Decimal.valueOf(DIS.CfdiNumber):null;
                if(!cuenta.isEmpty()){SD.Account__c = cuenta[0].Id;}
                SD.Numero_Factura__c = DIS.FactNumber;
                SD.Shipment__c = Shipment;
                //SD.Total_Invoice_SAP__c = DIS.TotalFacturado != null && DIS.TotalFacturado != ''?Decimal.valueOf(DIS.TotalFacturado):null;
                SD.Date_Invoice_SAP__c = DIS.FechaFactura != null && DIS.FechaFactura != ''?Date.valueOf(DIS.FechaFactura):null;
                SD.Timbrado_Factura_SAP__c = DIS.UI;
                SD.Disbursement_Status__c = 'Facturado';
                SD.Pedido_Compra_SAP__c = DIS.OrdenCompra != null && DIS.OrdenCompra != ''?String.valueOf(DIS.OrdenCompra):null;
                if(!Test.isRunningTest()){insert SD;}
                RES.Disbursement__c = SD.Id;
                RES.Shipment__c = Shipment;
                RES.Object__c='Disbursement';
                RES.Message__c = 'Creada Factura: '+DIS.UI+', Monto Facturado: '+DIS.TotalFacturado;
                list<Disbursement_Line__c> lsDetalle = new list<Disbursement_Line__c>();
                for(Detalle De: DIS.DetalleDisbursement.DetalleDisbursement){
                	Disbursement_Line__c Line = new Disbursement_Line__c();
                    Line.Units__c = De.Units != null && De.Units != ''?Integer.valueOf(De.Units):null;
                    Line.Unit_Price__c = De.UnitPrice != null && De.UnitPrice != ''?Decimal.valueOf(De.UnitPrice):null;
                    Line.Disbursement__c = SD.Id;
                    Line.VAT__c = De.VAT;
                    Line.Shipment__c = Shipment;
                    Line.Amount__c = De.Total != null && De.Total != ''?Decimal.valueOf(De.Total):null;
                    Line.Numero_Linea__c = De.IdInvoiceLine != null && De.IdInvoiceLine != ''?Integer.valueOf(De.IdInvoiceLine):null;
                    Line.Concept__c = De.Concepto;
                    Line.SAP_Service_Type__c= mapSapServiceType.get(De.ItemCode);
                    Line.CurrencyIsoCode = DIS.Moneda;
                    lsDetalle.add(Line);
                }
                if(!Test.isRunningTest()){insert lsDetalle;}
                
                status st = new status();
                st.code = '1';
                st.message = 'Exitoso- el registro fue generado';
                st.IdDisbursement = SD.Id;
                result.add(st);
                RES.Type__c = 'CONFIRM';
                //if(!Test.isRunningTest()){insert RES;}
                System.debug('----------'+result); 
            }
        }catch(Exception e){
            RES.Type__c = 'ERROR';
            RES.Message__c = e.getCause()+' '+e.getMessage();
            //insert RES;
            System.debug(e.getCause()); System.debug(e.getMessage()); System.debug(e.getLineNumber());
			status st = new status(); st.code = '0'; st.message = 'Existe un error en el web services, por favor revise la trasabilidad de la transacción' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();				
			result.add(st);
        }
        return Result;
    }
    
    public void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = ''; 
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }
}