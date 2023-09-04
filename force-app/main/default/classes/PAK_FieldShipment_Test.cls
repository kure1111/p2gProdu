@istest
private class PAK_FieldShipment_Test {
 static testMethod void NEU_Shipment_Assign_Service_Charges  ()
    {
     // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        
         List<Account> list_accountsb = NEU_Utils.getAccounts('Transporter,');
        Account b = list_accountsb[0];
        insert b;
        
        /*Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = a.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Type__c = 'Shipping Address	';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = a.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Type__c = 'Shipping Address	';
        insert address2;*/
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = b.Id;
        operador.Operador_Validado__c = True;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        insert operador;
        
        Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403, Vehiculo_Validado__c = True);//, 2.17403
        insert vehicle;
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-23-107098',
                                           carrier__C = b.id,
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now(),
                                           Approved_date_time__c= Datetime.now()
                                          );
        insert ship;

        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Buy_Rate__c = 10, Fee_Rate__c = 10, Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        
        /*Shipment_Fee_Line__c shipfeeline2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Units__c=10);
        insert shipfeeline2;*/

       /* try
        {
            shipfeeline2.Record_Locked__c = true;
            //update shipfeeline2;
            delete shipfeeline2;
          
        }   catch(Exception ex)
        {
            
            Boolean expectedExceptionThrown =  ex.getMessage().contains('No se puede eliminar la línea si ya ha sido enviada a SAP') ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }*/
    }
}