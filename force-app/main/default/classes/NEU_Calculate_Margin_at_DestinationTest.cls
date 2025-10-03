@isTest
public class NEU_Calculate_Margin_at_DestinationTest {
@isTest(SeeAllData=true)
     public static void test_NEU_Calculate_Margin_at_Destination() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, Owner.Id,
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];

        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c=a.Id);
        insert b;
        Customer_Quote__c  importexportquote = new Customer_Quote__c( Catalog_Price_List__c= b.id, Account_for__c = a.Id, Only_Warehouse_Service__c = true, Pricing_Executive__c = a.Owner.Id);
        insert importexportquote;
        Customer_Price_List__c d = new Customer_Price_List__c(Customer__c = a.id,Price_List__c = b.Id);
        insert d;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Margin_at_Destination__c = 10);
        insert quote;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_Calculate_Margin_at_Destination cmad=new NEU_Calculate_Margin_at_Destination(new ApexPages.StandardController( importexportquote ));
        cmad.decimalSep=cmad.decimalSep;
        cmad.thousandSep=cmad.thousandSep;
        cmad.margin_general=cmad.margin_general;
        List<NEU_Calculate_Margin_at_Destination.Line_s> listado_lineas_new = new List<NEU_Calculate_Margin_at_Destination.Line_s>();
        listado_lineas_new.add(new NEU_Calculate_Margin_at_Destination.Line_s(quote,10,10,10,10,10,'MXN',10));
         listado_lineas_new.add(new NEU_Calculate_Margin_at_Destination.Line_s(quote,11,11,11,11,11,'MXN',11));
       // cmad.Lines = listado_lineas_new;
        
        cmad.getShowImportExportItemLines();
        cmad.getLines();
        cmad.save_margin();
        cmad.orden_quotes = 'totalsellamount-asc';
        cmad.go_compare();
        
        NEU_Calculate_Margin_at_Destination.Line_s nueva_clase = new NEU_Calculate_Margin_at_Destination.Line_s(quote,10,10,10,10,10,'MXN',10);
        nueva_clase.getId();
        nueva_clase.orden_de_comparacion = 'asc';
        nueva_clase.campo_compare = 'totalsellamount';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'precio_margin';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'unitoriginprice';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Units__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Import_Export_Quote__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Number__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Date__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Item_Name__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]); 
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Extension_Item_Name__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Import_Export_Quote__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Number__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Delivery_Date__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Item_Name__r.Name';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
        nueva_clase.campo_compare = 'quote_line.Extension_Item_Name__c';
        nueva_clase.compareTo(listado_lineas_new[0]);
        nueva_clase.compareTo(listado_lineas_new[1]);
    }
}