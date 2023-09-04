@isTest
public class NEU_Generate_Shipments_test {
 
    public static testMethod void test_NEU_Generate_Shipments() {
     	
/*NEU_StaticVariableHelper.setBoolean1(true);
     	
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(  Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address');
        insert importexportquote;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Units__c = 10);
        insert quote;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Pricebook2 standardPricebook = new Pricebook2(
		Id = Test.getStandardPricebookId(),
		IsActive = true*/
          NEU_Generate_Shipments  gs = new NEU_Generate_Shipments();
        gs.bypass();
        
    }
//Execute an update DML on the Pricebook2 record, to make IsStandard to true
/*
Update standardPricebook;
        //Id stdPriceBook = Test.getStandardPricebookId();
        List<Product2> prods = [SELECT Id FROM Product2 WHERE Name = 'Testsp'];
        Product2 p;
        PricebookEntry pbe;
        
        if(prods.size()>0){
            p = prods[0];
            pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id =:p.Id LIMIT 1];
        }else{
            p = new Product2(Name='Testsp', IsActive = true);
            insert p;
            
            pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = standardPricebook.ID;
            insert pbe;
        }         
        
        NEU_Generate_Shipments  gs = new NEU_Generate_Shipments(new ApexPages.StandardController( importexportquote ));

         
        gs.decimalSep = gs.decimalSep;
        gs.thousandSep = gs.thousandSep;
        gs.filter_shipment = gs.filter_shipment;
        gs.filter_program = gs.filter_program;
        gs.filter_vessel = gs.filter_vessel;
        gs.getcontainers();
        gs.new_route();
        gs.search_routes();
        gs.getrouteid();
        gs.setrouteid(route.Id);
        gs.actualizar_table_route();
        gs.new_filter_route.Country_of_Load__c= Country.Id;
        gs.new_filter_route.Country_of_Discharge__c= Country.Id;
        gs.getlist_route();
        gs.getnumero_dias2();
        gs.getShowLines();
        gs.getShowImportExportItemLines();
        gs.getLines();
        gs.orden_quotes  = 'total_pallet_linea-asc';
        gs.go_compare();
         gs.direccion_selected = gs.direccion_selected;
         gs.direccion_selected_destination = gs.direccion_selected_destination;
         gs.alertuser=gs.alertuser;
         gs.TotalNumberBoxes = gs.TotalNumberBoxes;
         gs.TotalNumberPallets=gs.TotalNumberPallets;
         gs.Grossweight = gs.Grossweight;
         gs.Cube=gs.Cube;
         gs.FreeSpaceCont=gs.FreeSpaceCont;
         gs.porc_ocupacion=gs.porc_ocupacion;
         gs.total_pallet_linea=gs.total_pallet_linea;
         gs.container_selected=gs.container_selected;
         gs.currency_cuenta=gs.currency_cuenta;
         gs.linea_modificada=gs.linea_modificada;
         gs.max_peso_container=gs.max_peso_container;
         gs.max_volumen_container=gs.max_volumen_container;
         gs.num_cont_x_pallet=gs.num_cont_x_pallet;
         gs.la_lista_no_cero=gs.la_lista_no_cero;
         gs.searchDestinationAddress=gs.searchDestinationAddress;
         gs.searchOriginAddress=gs.searchOriginAddress;
        for(NEU_Generate_Shipments.Line_s l : gs.getLines())
            l.selected = true;
        gs.applyLines();
        gs.splitQuoteLine(quote.Id,1);
         gs.check_shipment_created();
         gs.shipment_truckstop.Freight_MOde__c = 'Road';
         gs.createTrackingTruckstop();
		 gs.bypass();
        gs.bypass2();
        NEU_Generate_Shipments.Line_s lines_obj = new NEU_Generate_Shipments.Line_s(quote, true, '', 10, quote.Id, 10, 10, 10, false,'', 10, 10, 10, false);
        NEU_Generate_Shipments.Line_s lines_obj2 = new NEU_Generate_Shipments.Line_s(quote, true, '', 8, quote.Id, 8, 8, 8, false,'', 8, 8, 8, false);
        lines_obj.getintegersupply();
        lines_obj.getFinalUnits();
        lines_obj.getFinalStock();
        lines_obj.getId();
        lines_obj.getHeaderId();
        lines_obj.getItemId();
        lines_obj.getItemType();
        lines_obj.getSupplierId();
        lines_obj.getItemName();
        lines_obj.getFamilyName();
        lines_obj.campo_compare='total_pallet_linea';
        lines_obj.orden_de_comparacion='asc';
        lines_obj.compareTo(lines_obj);
        
        lines_obj.campo_compare='total_pallet_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='total_volumen_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='total_peso_linea';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='extension';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='totalcajas';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Item_Name__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Item_Supplier_Owner__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Account_for__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Delivery_Date__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Delivery_Number__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Supplier_Account__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Units__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Price__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.ETD__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Supplier_Quote_Line__r.Delivery_Date__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Amount__c';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        lines_obj.campo_compare='quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name';
        lines_obj.orden_de_comparacion='desc';
        lines_obj.compareTo(lines_obj2);
        
     }*/
}