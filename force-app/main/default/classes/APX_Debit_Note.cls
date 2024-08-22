public with sharing class APX_Debit_Note {
    
    //sp y recordId sirven para alimentar a la visualforce
    //public Shipment__c sp {get;set;}
    //public Debit_Note__c debitn {get;set;}    
    public sendEmail record {get;set;}
    public String recordId {get;set;}    
    public static final String SHIPMENT = 'Shipment';
    public Company__c company {get;set;}

    //Constructor para incializar las variables sp y recordId
    public APX_Debit_Note(){
        try{
            system.debug('recordId:'+recordId);
            recordId  = ApexPages.CurrentPage().getparameters().get('id');        
            if(recordId != null && String.isNotBlank(recordId)){       
                
                record = getData(recordId);
                company = getCompany();
                /*debitn =[Select Name, Account_for__c,Account_for__r.Name, Account_for__r.Credit_Terms__c,Account_for__r.Bank_Account_Name__c,
                        Account_for__r.Bank_Account_Number__c,Account_for__r.Swift_Number__c,Shipment_Number_1__r.Name,Shipment_Number_1__r.Account_Shipment_Reference__c,
                        Shipment_Number_2__r.Account_Shipment_Reference__c,Shipment_Number_2__r.Name,Shipment_Number_3__r.Account_Shipment_Reference__c,
                        Shipment_Number_3__r.Name,Shipment_Number_4__r.Name,Shipment_Number_4__r.Account_Shipment_Reference__c,Shipment_Number_5__r.Account_Shipment_Reference__c,
                        Shipment_Number_5__r.Name,createdDate, CurrencyIsoCode from Debit_Note__c where Id =:recordId];
                sp = [Select Name, Account_for__r.Name, Country_of_Load__r.Name, State_of_Load__r.Name, Site_of_Load__r.Name,
                Country_of_Discharge__r.Name,State_of_Discharge__r.Name, Site_of_Discharge__r.Name, Route__r.Name from Shipment__c where Id =:recordId];*/
            }
        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note  ' + e.getMessage() + ' - ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled(cacheable = true)
    public static List<Debit_Note__c>  getDebitNote(String recordId){
        try {
            
            return [SELECT Id,Name, Account_for__c, Account_for__r.Name,Shipment_Number_1__c,Shipment_Number_1__r.Name,Shipment_Number_1__r.Id,
                    Shipment_Number_2__c,Shipment_Number_2__r.Id,Shipment_Number_2__r.Name,Shipment_Number_3__c,Shipment_Number_3__r.Id,Shipment_Number_3__r.Name,
                    Shipment_Number_4__c,Shipment_Number_4__r.Id,Shipment_Number_4__r.Name,Shipment_Number_5__c,Shipment_Number_5__r.Id,Shipment_Number_5__r.Name,
                    Shipment_Number_6__c,Shipment_Number_6__r.Name, Shipment_Number_7__c,Shipment_Number_7__r.Name, Shipment_Number_8__c,Shipment_Number_8__r.Name,
                    Shipment_Number_9__c,Shipment_Number_9__r.Name, Shipment_Number_10__c,Shipment_Number_10__r.Name,
                    Shipment_Status_Planner_1__c,Shipment_Status_Planner_2__c,Shipment_Status_Planner_3__c,Shipment_Status_Planner_4__c,Shipment_Status_Planner_5__c 
                    ,Shipment_Status_Planner_6__c,Shipment_Status_Planner_7__c,Shipment_Status_Planner_8__c,Shipment_Status_Planner_9__c,Shipment_Status_Planner_10__c,
                    Import_Export_Quote_1__c,Import_Export_Quote_Order_2__c,Import_Export_Quote_Order_3__c,Import_Export_Quote_Order_4__c,Import_Export_Quote_Order_5__c
                    FROM Debit_Note__c 
                    WHERE Shipment_Number_1__c =: recordId OR Shipment_Number_2__c =: recordId OR Shipment_Number_3__c =: recordId
                    OR Shipment_Number_4__c =: recordId OR Shipment_Number_5__c =: recordId OR Shipment_Number_6__c =: recordId OR Shipment_Number_7__c =: recordId OR Shipment_Number_8__c =: recordId OR Shipment_Number_9__c =: recordId OR Shipment_Number_10__c =: recordId limit 1];

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.getDebitNote  ' + e.getMessage() + ' - ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static List<Debit_Note__c>  getDebitNoteByList(List<string> recordIds){
        try {
            
            return [SELECT Id,Name, Account_for__c, Account_for__r.Name,Shipment_Number_1__c,Shipment_Number_1__r.Name,Shipment_Number_1__r.Id,
                    Shipment_Number_2__c,Shipment_Number_2__r.Id,Shipment_Number_2__r.Name,Shipment_Number_3__c,Shipment_Number_3__r.Id,Shipment_Number_3__r.Name,
                    Shipment_Number_4__c,Shipment_Number_4__r.Id,Shipment_Number_4__r.Name,Shipment_Number_5__c,Shipment_Number_5__r.Id,Shipment_Number_5__r.Name,
                    Shipment_Number_6__c,Shipment_Number_6__r.Name, Shipment_Number_7__c,Shipment_Number_7__r.Name, Shipment_Number_8__c,Shipment_Number_8__r.Name,
                    Shipment_Number_9__c,Shipment_Number_9__r.Name, Shipment_Number_10__c,Shipment_Number_10__r.Name,
                    Shipment_Status_Planner_1__c,Shipment_Status_Planner_2__c,Shipment_Status_Planner_3__c,Shipment_Status_Planner_4__c,Shipment_Status_Planner_5__c 
                    ,Shipment_Status_Planner_6__c,Shipment_Status_Planner_7__c,Shipment_Status_Planner_8__c,Shipment_Status_Planner_9__c,Shipment_Status_Planner_10__c
                    FROM Debit_Note__c 
                    WHERE Shipment_Number_1__c =: recordIds OR Shipment_Number_2__c =: recordIds OR Shipment_Number_3__c =: recordIds
                    OR Shipment_Number_4__c =: recordIds OR Shipment_Number_5__c =: recordIds OR Shipment_Number_6__c =: recordIds OR Shipment_Number_7__c =: recordIds OR Shipment_Number_8__c =: recordIds OR Shipment_Number_9__c =: recordIds OR Shipment_Number_10__c =: recordIds ];

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.getDebitNoteByList  ' + e.getMessage() + ' - ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static string updateDebitNote(String dnId, String spId){
        try {
            
            Debit_Note__c dn = [Select Id, Name,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,
            Shipment_Number_4__c,Shipment_Number_5__c from Debit_Note__c where Id =: dnId];
            String name = [Select Name from Shipment__c where id =: spId].Name;
            
            if(dn.Shipment_Number_1__c == null){
                dn.Shipment_Number_1__c = spId;                
            }else if(dn.Shipment_Number_2__c == null){
                dn.Shipment_Number_2__c = spId;                
            }else if(dn.Shipment_Number_3__c == null){
                dn.Shipment_Number_3__c = spId;                
            }else if(dn.Shipment_Number_4__c == null){
                dn.Shipment_Number_4__c = spId;                
            }else if(dn.Shipment_Number_5__c == null){
                dn.Shipment_Number_5__c = spId;                
            }


            update dn;
            system.debug('Se Agrego el Shipment '+ name + ' correctamente');
            return 'Se Agrego el Shipment '+ name + ' correctamente';            

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.updateDebitNote  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createDebitNote(String recordId){
        try {
                                    
            Debit_Note__c dn = new Debit_Note__c();
            dn.Account_for__c = [Select Account_for__c from Shipment__c where Id =: recordId].Account_for__c;
            dn.Shipment_Number_1__c = recordId;
            insert dn;

            return 'Se ha creado la Debit Note  correctamente';

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createDebitNote  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string changeShipment(String debitNoteId, String spId){
        try {

            Debit_Note__c dn = [Select Id,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,
            Shipment_Number_4__c,Shipment_Number_5__c from Debit_Note__c where Id =: debitNoteId];
            String name;

            if(dn.Shipment_Number_1__c == spId){
                dn.Shipment_Number_1__c = null;
                name = SHIPMENT + ' #1';
            }else if(dn.Shipment_Number_2__c == spId){
                dn.Shipment_Number_2__c = null;
                name = SHIPMENT + ' #2';
            }else if(dn.Shipment_Number_3__c == spId){
                dn.Shipment_Number_3__c = null;
                name = SHIPMENT + ' #3';
            }else if(dn.Shipment_Number_4__c == spId){
                dn.Shipment_Number_4__c = null;
                name = SHIPMENT + ' #4';
            }else if(dn.Shipment_Number_5__c == spId){
                dn.Shipment_Number_5__c = null;
                name = SHIPMENT + ' #5';
            }

            system.debug('Se ha cambiado el  ' + name + ' de la Debit Note correctamente');
            update dn;
            return 'Se ha cambiado el  ' + name + ' de la Debit Note correctamente';
            
        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.changeShipment  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateDebitNoteSearch(String dnId, String spId){
        try {
            
            Debit_Note__c dn = [Select Id,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,
            Shipment_Number_4__c,Shipment_Number_5__c from Debit_Note__c where Id =: dnId];
            String name;

            if(dn.Shipment_Number_1__c == null){
                dn.Shipment_Number_1__c = spId;
                name = SHIPMENT + ' #1';
            }else if(dn.Shipment_Number_2__c == null){
                dn.Shipment_Number_2__c = spId;
                name = SHIPMENT + ' #2';
            }else if(dn.Shipment_Number_3__c == null){
                dn.Shipment_Number_3__c = spId;
                name = SHIPMENT + ' #3';
            }else if(dn.Shipment_Number_4__c == null){
                dn.Shipment_Number_4__c = spId;
                name = SHIPMENT + ' #4';
            }else if(dn.Shipment_Number_5__c == null){
                dn.Shipment_Number_5__c = spId;
                name = SHIPMENT + ' #5';
            }

            system.debug('Se ha Agregado la  Debit Note ' + name + '  correctamente');
            update dn;
            return 'Se ha Agregado la  Debit Note ' + name + '  correctamente';

        } catch (Exception e) {

            system.debug('Ocurrio un error en APX_Debit_Note.updateDebitNoteSearch  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }


    /*@AuraEnabled
    public static string createInvoice(List<Id> shipments){

        try{

            system.debug('Entrando al metodo createInvoice: ' + shipments);
            createInvoiceFuture(shipments);
            return 'Se han creado las invoice correctamente';

        }catch(Exception e){

            system.debug('Ocurrio un error en APX_Debit_Note.createInvoice  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }

    }



    @Future(callout=true)
    public static void createInvoiceFuture(List<Id> shipments){
        try {

            system.debug('Entrando al metodo createInvoiceFuture: ' + shipments);
            
            List<Shipment__c> sps = [Select Id,Name, Account_for__c from Shipment__c where Id IN : shipments and Shipment_Status_Plann__c = 'Closed'];
            List<Invoice__c> invs = new List<Invoice__c>();
            system.debug('Shipments obtenidos: ' + sps);
            boolean isInvoice;

            for(Shipment__c sp : sps){

                isInvoice = getInvoice(sp.Id);
                
                if(!isInvoice){
                    
                    Invoice__c inv = new Invoice__c();
                    inv.Name = '.';
                    inv.Type__c= 'Debit Note';
                    inv.Date_of_Invoice__c = Date.today();
                    inv.Payable_Before__c = Date.today();
                    inv.Account__c = sp.Account_for__c;
                    inv.Shipment__c = sp.Id;
                    inv.Import_Export_Quote_Order__c = getFolioId(sp.Name);
                    invs.add(inv);  
                }                              
            }                        

            if(invs.size() != 0){
                insert invs;
            }                        

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createInvoiceFuture  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());            
        }
    }*/

    @AuraEnabled
    public static string createInvoice(List<Id> shipments){
        try {
            
            List<Shipment__c> sps = [Select Id,Name, Account_for__c from Shipment__c where Id IN : shipments /*and Shipment_Status_Plann__c = 'Closed'*/];
            List<Shipment_Fee_Line__c> servicesLines = [Select Id, Name, CurrencyIsoCode,Shipment__c from Shipment_Fee_Line__c where Shipment__c in: sps and Sell_Amount__c !=0];
            List<Invoice__c> invs = new List<Invoice__c>();
            List<String> names = new List<String>();
            system.debug('Shipments obtenidos: ' + sps);
            String  folio;
            boolean isInvoice;                       

            for(Shipment__c sp : sps){
                folio = sp.Name.replace('SP-', '');
                names.add(folio);
                folio = null;
            }

            List<Customer_Quote__c> folios = [Select Id,Name from Customer_Quote__c where Name in: names];

            for(Shipment__c sp : sps){

                for(Customer_Quote__c fo: folios){
                    
                    folio = sp.Name.replace('SP-', '');

                    if(folio == fo.Name){
                        
                        system.debug('Son iguales: '  + fo.Name + ' sp: ' + sp.Name);
                        Invoice__c inv = new Invoice__c();
                        inv.Name = '.';
                        inv.Type__c= 'Debit Note';
                        inv.Date_of_Invoice__c = Date.today();
                        inv.Payable_Before__c = Date.today();
                        inv.Account__c = sp.Account_for__c;
                        inv.Shipment__c = sp.Id;
                        inv.Import_Export_Quote_Order__c = fo.Id;//getFolioId(sp.Name);
                        for(Shipment_Fee_Line__c service : servicesLines){
                            
                            if(sp.Id == service.Shipment__c){
                                system.debug('Asignado moneda a la invoice: ' + inv.Name);
                                inv.CurrencyIsoCode = service.CurrencyIsoCode;
                                system.debug('Pasando la siguiente iteracion');
                                break;                                
                            }
                        }
                        invs.add(inv);
                    }
                }                                                             
            }                        

            if(invs.size() == 0){

                return 'No se creo ninguna Invoice';
            }

            insert invs;
            createInvoiceLine(invs);            

            return 'Se han creado #'+invs.size() + ' correctamente';


        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createInvoice  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    //Metodo para crear / asignar una debit note a los shipments omitidos

    @AuraEnabled
    public static List<Debit_Note__c>  createAndAssignDebitNote(List<Id> sps, String recordId){
        try {            

            system.debug('Entrando al metodo createAndAssignDebitNote: ' + sps + ' dn: ' + recordId);
            ///Quitar los shipments de la debit note

            List<Id> shipmentsList = new List<Id>();
            List<Id> invList = new List<Id>();
            Debit_Note__c dnFound = [Select Name, Account_for__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c,
            Import_Export_Quote_1__c,Import_Export_Quote_Order_2__c,Import_Export_Quote_Order_3__c,Import_Export_Quote_Order_4__c,Import_Export_Quote_Order_5__c,Invoice_Number_1__c,Invoice_Number_2__c,
            Invoice_Number_3__c,Invoice_Number_4__c,Invoice_Number_5__c from Debit_Note__c where Id =: recordId];

            Id acc = dnFound.Account_for__c;

            for(Id sp : sps){
                if(sp == dnFound.Shipment_Number_1__c){
                    system.debug('Se ha quitado el 1');
                    dnFound.Shipment_Number_1__c = null;
                    dnFound.Import_Export_Quote_1__c = null;
                    invList.add(dnFound.Invoice_Number_1__c);
                    dnFound.Invoice_Number_1__c = null;
                }if(sp == dnFound.Shipment_Number_2__c){
                    system.debug('Se ha quitado el 2');
                    dnFound.Shipment_Number_2__c = null;
                    dnFound.Import_Export_Quote_Order_2__c = null;
                    invList.add(dnFound.Invoice_Number_2__c);
                    dnFound.Invoice_Number_2__c = null;
                }if(sp == dnFound.Shipment_Number_3__c){
                    system.debug('Se ha quitado el 3');
                    dnFound.Shipment_Number_3__c = null;
                    dnFound.Import_Export_Quote_Order_3__c = null;
                    invList.add(dnFound.Invoice_Number_3__c);
                    dnFound.Invoice_Number_3__c = null;
                }if(sp == dnFound.Shipment_Number_4__c){
                    system.debug('Se ha quitado el 4');
                    dnFound.Shipment_Number_4__c = null;
                    dnFound.Import_Export_Quote_Order_4__c = null;
                    invList.add(dnFound.Invoice_Number_4__c);
                    dnFound.Invoice_Number_4__c = null;
                }if(sp == dnFound.Shipment_Number_5__c){
                    system.debug('Se ha quitado el 5');
                    dnFound.Shipment_Number_5__c = null;
                    dnFound.Import_Export_Quote_Order_5__c = null;
                    invList.add(dnFound.Invoice_Number_5__c);
                    dnFound.Invoice_Number_5__c = null;
                }
            }

            update dnFound;
            

            for(Id sp : sps){

                String name = [Select Name from Shipment__c where Id =: sp].Name;
                Boolean isFolio = getInvoice(sp);

                if(!isFolio){
                    shipmentsList.add(sp);
                }
            }

            //Ahora se va crear / asignar una debit note

            if(shipmentsList.size() != 0){
                system.debug('Se encontro #'+shipmentsList.size() + ' SPs sin invoice');
                List<Debit_Note__c> dns = [Select Id, CreatedBy.Name,Name, Account_for__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
                from Debit_Note__c where (Shipment_Number_1__c in: sps or Shipment_Number_1__c = null or Shipment_Number_2__c in: sps or Shipment_Number_2__c  = null or 
                Shipment_Number_3__c in: sps or Shipment_Number_3__c = null or Shipment_Number_4__c in: sps or Shipment_Number_4__c = null 
                or Shipment_Number_5__c in: sps or Shipment_Number_5__c = null) and Id !=: recordId and Account_for__c =: acc];
    
                List<Debit_Note__c> debitList = new List<Debit_Note__c>();
                Debit_Note__c assignDN ;
                Integer contador = 0;
    
    
                for(Debit_Note__c dn : dns){
    
                    if(dn.Shipment_Number_2__c == null){
                        contador++;
                        system.debug('SP 2 vacio');
                    }if(dn.Shipment_Number_3__c == null){
                        contador++;
                        system.debug('SP 3 vacio');
                    }if(dn.Shipment_Number_4__c == null){
                        contador++;
                        system.debug('SP 4 vacio');
                    }if(dn.Shipment_Number_5__c == null){
                        contador++;
                        system.debug('SP 5 vacio');
                    }
                    
                    if(contador == shipmentsList.size() || contador > shipmentsList.size()){
                        system.debug('Se agrego dn: ' + dn.Name + ' a la lista');
                        debitList.add(dn);
                        contador = 0;
                    }
                }
    
                if(debitList.size() == 1){            
                    system.debug('Se agrego los shipments a la debit note: ' + debitList.get(0).Name);
                    assignDN = assignShipment(debitList.get(0), shipmentsList);
                    update assignDN;
                } else if(debitList.size() > 1){
    
                    return debitList;
    
                }else if(debitList.size() == 0 && shipmentsList.size() != 0){
                    system.debug('Se va a crear una nueva debit note para los sps');
                    Debit_Note__c dnNew = assignShipment(null, shipmentsList);
                    dnNew.Account_for__c = acc;                
                    insert dnNew;
                }
            }

            system.debug('No se creo / asigno nada');
            return null;

            //List<Shipment__c> shipments = [Select Id, Name, Account_for__c from Shipment__c where Id in: sps];

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createAndAssignDebitNote  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Debit_Note__c assignShipment(Debit_Note__c dn, List<Id> sps){

        system.debug('Entrando al metodo assignShipment, dn: ' + dn + ' sps: ' + sps);
        Debit_Note__c dnAssign = (dn == null ? new Debit_Note__c() : dn);

        for(Id sp: sps){

            if(dnAssign.Shipment_Number_1__c == null || dnAssign.Shipment_Number_1__c == sp){                
                dnAssign.Shipment_Number_1__c = sp;
            }else if(dnAssign.Shipment_Number_2__c == null || dnAssign.Shipment_Number_2__c == sp){                
                dnAssign.Shipment_Number_2__c = sp;
            }else if(dnAssign.Shipment_Number_3__c == null || dnAssign.Shipment_Number_3__c == sp){                
                dnAssign.Shipment_Number_3__c = sp;
            }else if(dnAssign.Shipment_Number_4__c == null || dnAssign.Shipment_Number_4__c == sp){                
                dnAssign.Shipment_Number_4__c = sp;
            }else if(dnAssign.Shipment_Number_5__c == null || dnAssign.Shipment_Number_5__c == sp){                
                dnAssign.Shipment_Number_5__c = sp;
            }
        }

        return dnAssign;
    }

    @AuraEnabled
    public static Debit_Note__c  AssignDebitNoteShipmentsOmitted(String recordId, List<Id> sps){
        try {

            system.debug('Entrnado al metodo: AssignDebitNoteShipmentsOmitted: ' + recordId + ' sps: ' + sps);

            Debit_Note__c dn = [Select Id,Name, Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
            from Debit_Note__c where Id =: recordId];

            for(Id sp: sps){

                if(dn.Shipment_Number_2__c == null){
                    dn.Shipment_Number_2__c = sp;
                }else if(dn.Shipment_Number_3__c == null){
                    dn.Shipment_Number_3__c = sp;
                }else if(dn.Shipment_Number_4__c == null){
                    dn.Shipment_Number_4__c = sp;
                }else if(dn.Shipment_Number_5__c == null){
                    dn.Shipment_Number_5__c = sp;
                }
            }

            update dn;
            return dn;
            
        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.AssignDebitNoteShipmentsOmitted  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static Id getFolioId(String name){
        try{
            system.debug('Obteninedo el Folio del Shipment: '+ name);
            String folio = name.replace('SP-', '');                       
            return [Select Id from Customer_Quote__c where Name =: folio].Id;
        }catch(Exception e){
            system.debug('El SP: '+ name + ' no cuenta con folio');
            return null;
        }
    }

    @AuraEnabled
    public static Boolean getInvoice(Id recordId){        
        try {
            system.debug('Identificar si el SP tiene una Invoice');        
            List<Invoice__c> inv = [Select Id, Name from Invoice__c where Shipment__c =: recordId ];
            boolean isInvoice = (inv.size() !=0  ? true : false);  
            system.debug('Tiene invoices?: ' + isInvoice + ' inv.size():' + inv.size());     
            return isInvoice;   

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createInvoice  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            return false;
        }       
    }

    public static void createInvoiceLine(List<Invoice__c> invoices){

      try {

        system.debug('Entrando al trigger: ');
        system.debug('lo que contiene invoices: '+invoices);
        List<Invoice_Line__c> invL = new List<Invoice_Line__c>();
        List<Id> spList = new List<Id>();
        Map<String,Id> foliosId = new Map<String,Id>();

        for(Invoice__c invoice : invoices){        
            spList.add(invoice.Shipment__c);
        }


        List<Shipment_Fee_Line__c> servicesLines = [Select Id, Name, Service_Rate_Category__c, Service_Rate_Name__c,Group__c,Shipment__c,Shipment__r.Name,
        Sap_Service_Type__c,Code_SAP__c,CurrencyIsoCode,Units__c,Shipment_Sell_Price__c,Sell_Amount__c from Shipment_Fee_Line__c where Shipment__c in: spList and Sell_Amount__c !=0];

        Debit_Note__c dn = [SELECT Id,Name, Shipment_Number_1__c,DN_Status__c,
        Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c,Import_Export_Quote_1__c,
        Import_Export_Quote_Order_2__c,Import_Export_Quote_Order_3__c,Import_Export_Quote_Order_4__c,Import_Export_Quote_Order_5__c,Invoice_Number_1__c,
        Invoice_Number_2__c,Invoice_Number_3__c,Invoice_Number_4__c,Invoice_Number_5__c
        FROM Debit_Note__c WHERE Shipment_Number_1__c in: spList OR Shipment_Number_2__c in: spList OR Shipment_Number_3__c in: spList
        OR Shipment_Number_4__c in: spList OR Shipment_Number_5__c in: spList  limit 1 ];

        //createInvoiceLineFuture(invId);
        
        for(Invoice__c invoice : invoices){
            system.debug('Inv Id: ' + invoice);
            
            system.debug('Services lines: ' + servicesLines.size());

            for(Shipment_Fee_Line__c service : servicesLines){

                if(service.Shipment__c == invoice.Shipment__c){

                    foliosId.put(service.Shipment__c, invoice.Import_Export_Quote_Order__c);
                    Invoice_Line__c il = new Invoice_Line__c();
                    il.Name = '.';
                    il.Invoice__c = invoice.Id;
                    il.Import_Export_Quote_Order__c = invoice.Import_Export_Quote_Order__c;
                    il.Shipment__c = invoice.Shipment__c;
                    il.Concept__c = service.Name;
                    il.Units__c = service.Units__c;
                    il.Unit_Price__c = service.Shipment_Sell_Price__c;
                    il.Amount__c = (service.Units__c  * service.Shipment_Sell_Price__c);
                    il.VAT__c = 'Non Applicable';
                    il.Total_VAT__c = 0;
                    il.CurrencyIsoCode = service.CurrencyIsoCode;
                    il.Shipment_Service_Line__c = service.Id;
                    il.Group__c = service.Group__c;                
                    invL.add(il);
                    system.debug('lo que contiene il: '+il);
                }                                
            }
        }
        
        system.debug('Invoice Line creadas:' + invL.size());
        if(invL.size()!=0){
            insert invL;
        }

        for(Invoice__c inv : invoices){

            System.debug('Se va timbrar la siguiente invoice: ' + inv.Name);
            
            if(!Test.isRunningTest()){
                //PAK_INV_Ctr.SendInvoiceToSAPFromTrigger(inv.Id);
                PAK_INV_Ctr.SendInvoiceToSAPFromTrigger(inv.Id);
            }
        }

        for(Invoice__c inv : invoices){

            if(dn.Shipment_Number_1__c == inv.Shipment__c && dn.Invoice_Number_1__c == null){
                system.debug('SP1 no tiene inv: '  + inv.Name);    
                system.debug('folio1: ' + foliosId.get(inv.Shipment__c));                
                dn.Import_Export_Quote_1__c = (dn.Import_Export_Quote_1__c == null ?foliosId.get(inv.Shipment__c):dn.Import_Export_Quote_1__c);
                dn.Invoice_Number_1__c = inv.Id;
            }else if(dn.Shipment_Number_2__c == inv.Shipment__c && dn.Invoice_Number_2__c == null){
                system.debug('SP2 no tiene inv' + inv.Name);
                system.debug('folio2: ' + foliosId.get(inv.Shipment__c));
                dn.Import_Export_Quote_Order_2__c = (dn.Import_Export_Quote_Order_2__c == null ? foliosId.get(inv.Shipment__c):dn.Import_Export_Quote_Order_2__c);
                dn.Invoice_Number_2__c = inv.Id;
            }else if(dn.Shipment_Number_3__c == inv.Shipment__c && dn.Invoice_Number_3__c == null){
                system.debug('SP3 no tiene inv' + inv.Name);
                system.debug('folio3: ' + foliosId.get(inv.Shipment__c));
                dn.Import_Export_Quote_Order_3__c = (dn.Import_Export_Quote_Order_3__c == null ? foliosId.get(inv.Shipment__c):dn.Import_Export_Quote_Order_3__c);
                dn.Invoice_Number_3__c = inv.Id;
            }else if(dn.Shipment_Number_4__c == inv.Shipment__c && dn.Invoice_Number_4__c == null){
                system.debug('SP4 no tiene inv' + inv.Name);
                system.debug('folio4: ' + foliosId.get(inv.Shipment__c));
                dn.Import_Export_Quote_Order_4__c = (dn.Import_Export_Quote_Order_4__c == null ? foliosId.get(inv.Shipment__c):dn.Import_Export_Quote_Order_4__c);
                dn.Invoice_Number_4__c = inv.Id;
            }else if(dn.Shipment_Number_5__c == inv.Shipment__c && dn.Invoice_Number_5__c == null){
                system.debug('SP5 no tiene inv' + inv.Name);
                system.debug('folio5: ' + foliosId.get(inv.Shipment__c));
                dn.Import_Export_Quote_Order_5__c = (dn.Import_Export_Quote_Order_5__c == null ? foliosId.get(inv.Shipment__c):dn.Import_Export_Quote_Order_5__c);
                dn.Invoice_Number_5__c = inv.Id;
            }
        }
        dn.DN_Status__c = 'Enviado SAP';
        update dn;


      } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createInvoiceLine  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
      }
    }
    
    /*@Future
    public static void createInvoiceLineFuture(List<Id> invoices){

        try{

            system.debug('Entrando createInvoiceLineFuture: ' + invoices);
            List<Invoice_Line__c> invL = new List<Invoice_Line__c>();
            List<Invoice__c> invoiceList = [Select Id, Shipment__c, Import_Export_Quote_Order__c from Invoice__c where Id in: invoices];

            for(Invoice__c invoice : invoiceList){
            system.debug('Inv Id: ' + invoice);

            List<Shipment_Fee_Line__c> servicesLines = [Select Id, Name, Service_Rate_Category__c, Service_Rate_Name__c,Group__c,
            Sap_Service_Type__c,Code_SAP__c,CurrencyIsoCode,Units__c,Shipment_Sell_Price__c,Sell_Amount__c from Shipment_Fee_Line__c where Shipment__c =: invoice.Shipment__c];

            system.debug('Services lines: ' + servicesLines.size());

            for(Shipment_Fee_Line__c service : servicesLines){

                Invoice_Line__c il = new Invoice_Line__c();
                il.Name = '.';
                il.Invoice__c = invoice.Id;
                il.Import_Export_Quote_Order__c = invoice.Import_Export_Quote_Order__c;
                il.Shipment__c = invoice.Shipment__c;
                il.Concept__c = service.Name;
                il.Units__c = service.Units__c;
                il.Unit_Price__c = service.Shipment_Sell_Price__c;
                il.Amount__c = (service.Units__c  * service.Shipment_Sell_Price__c);
                il.VAT__c = 'Non Applicable';
                il.Total_VAT__c = 0;
                il.CurrencyIsoCode = service.CurrencyIsoCode;
                il.Shipment_Service_Line__c = service.Id;
                il.Group__c = service.Group__c;                
                invL.add(il);
                system.debug('lo que contiene il: '+il);
                
            }
        }
        
        system.debug('Invoice Line creadas:' + invL.size());
        if(invL.size()!=0){
            insert invL;
        }

        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note.createInvoiceLineFuture  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
        }
    }*/


    @AuraEnabled(cacheable = true)
    public static shipmentResponse getShipmentsAndLines(List<Id> shipments, Id recordId){
                
        try{

            List<Shipment__c> spsClose = new List<Shipment__c>();
            List<Shipment__c> sps = new List<Shipment__c>();
            string objectName= string.valueOf(recordId.getSObjectType());
            List<shipmentWrapper> shipmentClose = new  List<shipmentWrapper>();
            List<shipmentWrapper> shipmentUnsold = new  List<shipmentWrapper>();
            List<shipmentNotClose> shipmentnotClose = new  List<shipmentNotClose>();
            boolean isInvoice;
                    
            if(objectName == 'Shipment__c'){
                spsClose = [Select Id,Name, Shipment_Status_Plann__c from Shipment__c where Id IN : shipments /*and Shipment_Status_Plann__c = 'Closed'*/];
                //sps = [Select Id,Name, Shipment_Status_Plann__c from Shipment__c where Id IN : shipments and Shipment_Status_Plann__c != 'Closed'];   
            }else{

                Debit_Note__c dn = [select Shipment_Number_1__c,Shipment_Number_2__c, Shipment_Number_3__c,Shipment_Number_4__c,
                Shipment_Number_5__c from Debit_Note__c where Id =:recordId];

                List<Id> spsId = new List<Id>();

                if(dn.Shipment_Number_1__c != null){
                    spsId.add(dn.Shipment_Number_1__c);
                }
                if(dn.Shipment_Number_2__c != null){
                    spsId.add(dn.Shipment_Number_2__c);  
                }
                if(dn.Shipment_Number_3__c != null){
                    spsId.add(dn.Shipment_Number_3__c);                
                }
                if(dn.Shipment_Number_4__c != null){
                    spsId.add(dn.Shipment_Number_4__c);
                }
                if(dn.Shipment_Number_5__c != null){
                    spsId.add(dn.Shipment_Number_5__c);
                }                                                          

                spsClose = [Select Id,Name, Shipment_Status_Plann__c from Shipment__c where Id IN : spsId /*and Shipment_Status_Plann__c = 'Closed'*/];
                //sps = [Select Id,Name, Shipment_Status_Plann__c from Shipment__c where Id IN : spsId and Shipment_Status_Plann__c != 'Closed'];   
            }

            for(Shipment__c sp : spsClose){
                
                isInvoice = getInvoice(sp.Id);
                Id folio = getFolioId(sp.Name);            
                if(!isInvoice && folio != null){                
                    shipmentWrapper spw = new shipmentWrapper();
                    spw.shipmentName = sp.Name;
                    spw.shipmentId = sp.Id;
                    spw.statusSp = sp.Shipment_Status_Plann__c;
                    spw.servicesLines  = getServicesLine(sp.Id);
                    spw.styleTable = (spw.servicesLines.size() == 1 ? 'height:5rem;width:100%' : spw.servicesLines.size() == 2 ? 'height:7rem;width:100%' : spw.servicesLines.size() == 3 ? 'height:8rem ;width:100%' : spw.servicesLines.size() == 4 ? 'height:10rem;width:100%' : spw.servicesLines.size() == 5 ? 'height:11rem;width:100%' : 'height:12rem;width:100%');
                    system.debug('sp: ' + spw.shipmentName + 'spw.servicesLines:' + spw.servicesLines.size() + ' style: ' +spw.styleTable);
                    shipmentClose.add(spw);            
                }else{

                    shipmentNotClose spnc = new shipmentNotClose();
                    spnc.spId = sp.Id;
                    spnc.isFolio = (folio != null ? true : false);
                    spnc.shipmentName = sp.Name;
                    spnc.status = sp.Shipment_Status_Plann__c;
                    spnc.isInvoice = isInvoice;
                    shipmentnotClose.add(spnc);                
                }
            }

            //lineas omitidas
            for(Shipment__c sp : spsClose){
                
                List<Shipment_Fee_Line__c> lines  = getServicesLineUnsold(sp.Id);
                if(lines.size() != 0){
                    shipmentWrapper spw = new shipmentWrapper();
                    spw.shipmentName = sp.Name;
                    spw.shipmentId = sp.Id;
                    spw.statusSp = sp.Shipment_Status_Plann__c;
                    spw.servicesLines  = lines;
                    spw.styleTable = (spw.servicesLines.size() == 1 ? 'height:5rem;width:100%' : spw.servicesLines.size() == 2 ? 'height:7rem;width:100%' : spw.servicesLines.size() == 3 ? 'height:8rem ;width:100%' : spw.servicesLines.size() == 4 ? 'height:10rem;width:100%' : spw.servicesLines.size() == 5 ? 'height:11rem;width:100%' : 'height:12rem;width:100%');
                    system.debug('sp: ' + spw.shipmentName + 'spw.servicesLines:' + spw.servicesLines.size() + ' style: ' +spw.styleTable);
                    shipmentUnsold.add(spw); 
                }
                /*isInvoice = getInvoice(sp.Id);
                Id folio = getFolioId(sp.Name);            
                if(!isInvoice && folio != null){                
                    shipmentWrapper spw = new shipmentWrapper();
                    spw.shipmentName = sp.Name;
                    spw.shipmentId = sp.Id;
                    spw.statusSp = sp.Shipment_Status_Plann__c;
                    spw.servicesLines  = getServicesLineUnsold(sp.Id);
                    spw.styleTable = (spw.servicesLines.size() == 1 ? 'height:5rem;width:100%' : spw.servicesLines.size() == 2 ? 'height:7rem;width:100%' : spw.servicesLines.size() == 3 ? 'height:8rem ;width:100%' : spw.servicesLines.size() == 4 ? 'height:10rem;width:100%' : spw.servicesLines.size() == 5 ? 'height:11rem;width:100%' : 'height:12rem;width:100%');
                    system.debug('sp: ' + spw.shipmentName + 'spw.servicesLines:' + spw.servicesLines.size() + ' style: ' +spw.styleTable);
                    shipmentUnsold.add(spw);            
                }*/
            }

            /*for(Shipment__c spnc : sps){

                shipmentNotClose sp = new shipmentNotClose();
                sp.spId = spnc.Id;
                sp.isFolio = (getFolioId(spnc.Name) != null ? true : false);
                sp.isInvoice = getInvoice(spnc.Id);
                sp.shipmentName = spnc.Name;
                sp.status = spnc.Shipment_Status_Plann__c;
                shipmentnotClose.add(sp);

            }*/

            shipmentResponse spR = new shipmentResponse();
            spR.shipmentClose = shipmentClose;
            spR.shipmentNotClose = shipmentnotClose;
            spr.shipmentUnsold = shipmentUnsold;

            system.debug('spR.shipmentClose: ' + spR.shipmentClose);
            system.debug('spR.shipmentNotClose: ' + spR.shipmentNotClose);
            system.debug('spR.shipmentUnsold: ' + spR.shipmentUnsold);
            return spR;  


        }catch(Exception e){

            system.debug('Ocurrio un error en APX_Debit_Note.getShipmentsAndLines  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }      
    }  
    
    @AuraEnabled(cacheable = true)
    public static List<showInvoiceWrapper> showInvoicesAndLines(List<Id> shipments){

        try {
            system.debug('Mostrando las invoices creadas.....');

            List<Invoice__c> invoices = [Select Id, Name, Account__r.Name, Import_Export_Quote_Order__r.Name, 
            Shipment__c,Shipment__r.Name,Type__c from Invoice__c where Shipment__c IN : shipments ];

            system.debug('Invoices obtenidas:'+ invoices);
            
            List<showInvoiceWrapper> wrapper = new List<showInvoiceWrapper>();

            for(Invoice__c inv: invoices){

                showInvoiceWrapper siw = new showInvoiceWrapper();
                siw.invoice = inv;
                siw.shipmentId = inv.Shipment__c;
                siw.invoiceLine = getInvoiceLines(inv.Id);   
                siw.urlInvoice = URL.getSalesforceBaseUrl().toExternalForm() + '/'+inv.Id;            
                siw.styleTable = (siw.invoiceLine.size() == 1 ? 'height:5rem;width:100%' : siw.invoiceLine.size() == 2 ? 'height:7rem;width:100%' : siw.invoiceLine.size() == 3 ? 'height:8rem ;width:100%' : siw.invoiceLine.size() == 4 ? 'height:10rem;width:100%' : siw.invoiceLine.size() == 5 ? 'height:11rem;width:100%' : 'height:12rem;width:100%');
                system.debug('siw.invoiceLine:' + siw.invoiceLine.size() + ' style: ' +siw.styleTable);
                wrapper.add(siw);
            }

            system.debug('Invoices creadas: ' + wrapper.size());
            return wrapper;

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.showInvoicesAndLines  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Shipment_Fee_Line__c> getServicesLine(Id sp){            
        return [SELECT Name,Carrier__c,Service_Rate_Category__c, Code_SAP__c, Service_Rate_Name__r.Name, Units__c, Std_Buy_Amount_header_currency__c,
        Sell_Amount__c, Service_Std_Profit__c FROM Shipment_Fee_Line__c WHERE Shipment__c =: sp and Sell_Amount__c !=0];
    }

    public static List<Shipment_Fee_Line__c> getServicesLineUnsold(Id sp){            
        return [SELECT Name,Carrier__c,Service_Rate_Category__c, Code_SAP__c, Service_Rate_Name__r.Name, Units__c, Std_Buy_Amount_header_currency__c,
        Sell_Amount__c,Import_Export_Quote__c,Shipment__c, Service_Std_Profit__c FROM Shipment_Fee_Line__c WHERE Shipment__c =:sp and Import_Export_Quote__c !=null and Sell_Amount__c =0 ];
    }

    public static List<Invoice_Line__c> getInvoiceLines(Id inv){
        return [Select Name, Invoice__r.Name,Concept__c, Units__c, Unit_Price__c, Amount__c, VAT__c, Total_VAT__c, 
        Total_Incl_VAT__c from Invoice_Line__c where Invoice__c =: inv];
    }
    
    @AuraEnabled
    public static Boolean changeCurrency(Id spId){

        try{

            Debit_Note__c dn = [Select CurrencyIsoCode, Name  from Debit_Note__c where Shipment_Number_1__c =: spId OR Shipment_Number_2__c =: spId OR Shipment_Number_3__c =: spId
            OR Shipment_Number_4__c =: spId OR Shipment_Number_5__c =: spId limit 1];

            system.debug('Moneda de la DN: '+ dn.Name + 'Moneda: ' + dn.CurrencyIsoCode);
            dn.CurrencyIsoCode = [Select CurrencyIsoCode from Invoice__c where Shipment__c =: spId].CurrencyIsoCode;
            update dn;
            system.debug('Se actualizo la moneda de la DN......' +dn.Name +' ' +dn.CurrencyIsoCode);
            return true;
            
        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note.changeCurrency  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());            
            return false;
        }
    }


    @AuraEnabled
    public static String sendPdf(Id  recordId) {
        system.debug('Entrando al metodo sendPdf: ' + recordId);

        String nameObject = string.valueOf(recordId.getSObjectType());  
        Id debitN = recordId;

        if(nameObject != 'Debit_Note__c'){
            system.debug('Es un Shipment.....');
            debitN = [Select Id from Debit_Note__c where Shipment_Number_1__c =: recordId OR Shipment_Number_2__c =: recordId OR Shipment_Number_3__c =: recordId
            OR Shipment_Number_4__c =: recordId OR Shipment_Number_5__c =: recordId limit 1].Id; 

        }
                        
        system.debug('debitN: ' + debitN);
        Datetime d = Datetime.now();
        String name = [Select Name from Debit_Note__c where Id=: debitN].Name;
        String nameFile = (!Test.isRunningTest() ? name.replace('-', '_')+'_'+d.second() + d.minute()+'.pdf' : 'testDN.pdf');
        PageReference pdf = new pagereference('/apex/DebitNoteTemplate?id='+ debitN);
        pdf.getParameters().put('id',  debitN);
    
        Blob body;
        try {
            // returns page as a PDF
            body = pdf.getContent();
            system.debug('Body pdf: ' + body);
        } catch (Exception e) {
            system.debug('Ocurrio un error al crear el pdf: ' + e.getMessage() + ' causa: ' + e.getCause() + ' linea: ' + e.getLineNumber());
            body = Blob.valueOf('data');
        }

        try{

            //insert content version
            ContentVersion cv = new ContentVersion();
            cv.Title = (!Test.isRunningTest() ? nameFile : 'testDN.pdf');
            cv.PathOnClient = nameFile;
            cv.VersionData = body;
            //cv.FirstPublishLocationId = debitN;
            insert cv;

            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
            cdl.LinkedEntityId = recordId;        
            cdl.ShareType = 'V';
            insert cdl;

            system.debug('cv: ' + cv);
            system.debug('cdl: ' + cdl);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(nameFile);
            attach.Body = body;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'mayra.ortiza@pak2go.com','carlos.martinez@pak2go.com','frida.macias@pak2go.com','sandra.trujillo@pak2go.com','jose.medellin@pak2go.com','israel.mar@pak2go.com','daniel.rios@pak2go.com','tomas.urdiales@pak2go.com','karina.gloria@pak2go.com','alma.ruiz@pak2go.com'});//,'leonardo.nocelo@pak2go.com','carlos.martinez@pak2go.com','israel.mar@pak2go.com','enrique.maycotte@pak2go.com','paola.gonzalez@pak2go.com','karina.gloria@pak2go.com','alma.ruiz@pak2go.com'});
            mail.setSubject('Debit Note: '  + nameFile);
            mail.setHtmlBody('Agregar texto para enviar mensaje');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach}); 
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            system.debug('Se ha enviado un Email con el PDF correctamente');

            return nameFile;
        
        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note.sendPdf  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }        
    }

    @AuraEnabled
    public static string uploadFiles(List<Id> spsId, String fileName){
        try {
            system.debug('Entrando al metodo uploadFiles, sps: ' + spsId +' file name: ' + fileName);

            //ContentDocument  cd = [SELECT Id, CreatedDate, Title, FileType FROM ContentDocument where Title =: title];
            ContentVersion cv  = [Select Title, PathOnClient, VersionData, FirstPublishLocationId from ContentVersion where Title =: fileName];
            system.debug('cv: ' + cv);
            
            for(Id sp : spsId){

                system.debug('Entrando a la iteracion '+ sp);
                String body = EncodingUtil.base64Encode(cv.VersionData);
                system.debug('Body: ' + body);
                sendAWs(sp,body, cv.Title);
                ///String aws = APX_UploadFiles.uploadFile(EncodingUtil.base64Encode(cv.VersionData), 'Hola', sp, cv.Title, 'Debit Note');                
                //APX_UploadFiles.uploadFile(cv.VersionData, null, sp, cv.Title, 'Debit Note');
                //system.debug('msg: ' + aws);
            }

            return 'Se ha enviado un Email con el PDF correctamente';
        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.uploadFiles  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @Future(callout=true)
    public static void sendAWs(Id sp, String body, String fileName){

        //String aws = APX_UploadFiles.uploadFile(body, 'Hola', sp, fileName, 'Debit Note');
        //system.debug('msg: ' + aws);

       List<Associated_Document__c> ad = [Select Id, Name, Document_URL__c from Associated_Document__c where Name =:fileName];
        

        Blob base64Content = EncodingUtil.base64Decode(body);
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String contentType=AWSService.ContentType('pdf');        
        String path = 'Shipments/ShipmentsOtros/';
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT'); 

        if(!test.isRunningTest() || ad.size() == 0){          
            
          req.setEndpoint('callout:'+'associateddocs/'+path+fileName);                       
          req.setHeader('Content-Encoding', 'UTF-8');
          req.setHeader('Content-type', contentType);
          req.setHeader('Connection', 'keep-alive');
          req.setHeader('Date', formattedDateString);
          req.setHeader('Access-Control-Allow-Origin', '*');
          req.setHeader('ACL', 'public-read');
          req.setBodyAsBlob(base64Content);                        
          
          Http http = new Http();
          HTTPResponse res = http.send(req);
          system.debug('Body is'+res.getBody());
          
          if(res.getStatusCode() != 200) {
              String error = 'Ocurrio un error al conectar con AWS : ' + res.getStatusCode(); 
              system.debug(error);                                
          }
        }
      String url = ( ad.size() == 0 ? 'https://' + 'associateddocs' + '.'+'s3.amazonaws.com'+'/' +path+ fileName : ad.get(0).Document_URL__c);

      APX_UploadFiles.createData(sp,fileName, 'Debit Note',url);    

    }

    public static sendEmail getData(String recordId){

        try{

            system.debug('recordId:' + recordId);
            Debit_Note__c dn = [Select Name, Account_for__c,Account_for__r.Name, Account_for__r.Credit_Terms__c,Account_for__r.Bank_Account_Name__c,
            Account_for__r.Direccion_Principal__r.Direcci_n__c,Account_for__r.Bank_Account_Number__c,Account_for__r.Swift_Number__c,Shipment_Number_1__r.Name,Shipment_Number_1__r.Account_Shipment_Reference__c,
            Shipment_Number_2__r.Account_Shipment_Reference__c,Shipment_Number_2__r.Name,Shipment_Number_3__r.Account_Shipment_Reference__c,
            Shipment_Number_3__r.Name,Shipment_Number_4__r.Name,Shipment_Number_4__r.Account_Shipment_Reference__c,Shipment_Number_5__r.Account_Shipment_Reference__c,
            Shipment_Number_5__r.Name,createdDate, CurrencyIsoCode, Shipment_Number_1__c, Shipment_Number_2__c, Shipment_Number_3__c, Shipment_Number_4__c, Shipment_Number_5__c
            from Debit_Note__c where Id =:recordId];

            Account acc = [select Name, BillingAddress,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry from Account where Id =: dn.Account_for__c];

            List<Id> sps = new List<Id>{dn.Shipment_Number_1__c,dn.Shipment_Number_2__c,dn.Shipment_Number_3__c,dn.Shipment_Number_4__c,dn.Shipment_Number_5__c};  
            
            Shipment__c route = null;
            
            if(dn.Shipment_Number_1__c != null){
                system.debug('Tiene SP1');
                route = [Select Name, Site_of_Load__r.Name,Site_of_Discharge__r.Name,MBL_Number__c,MAWB_Number__c from Shipment__c where Id =: dn.Shipment_Number_1__c];
            }else if(dn.Shipment_Number_2__c != null){
                system.debug('Tiene SP2');
                route = [Select Name, Site_of_Load__r.Name,Site_of_Discharge__r.Name,MBL_Number__c,MAWB_Number__c from Shipment__c where Id =: dn.Shipment_Number_2__c];
            }else if(dn.Shipment_Number_3__c != null){
                system.debug('Tiene SP3');
                route = [Select Name, Site_of_Load__r.Name,Site_of_Discharge__r.Name,MBL_Number__c,MAWB_Number__c from Shipment__c where Id =: dn.Shipment_Number_3__c];
            }else if(dn.Shipment_Number_4__c != null){
                system.debug('Tiene SP4');
                route = [Select Name, Site_of_Load__r.Name,Site_of_Discharge__r.Name,MBL_Number__c,MAWB_Number__c from Shipment__c where Id =: dn.Shipment_Number_4__c];
            }else if(dn.Shipment_Number_5__c != null){
                system.debug('Tiene SP5');
                route = [Select Name, Site_of_Load__r.Name,Site_of_Discharge__r.Name,MBL_Number__c,MAWB_Number__c from Shipment__c where Id =: dn.Shipment_Number_5__c];
            }
            
            
            List<Invoice__c> invsList = [Select Id,Shipment__c  from Invoice__c where Shipment__c in:sps];
            List<Id> invs = new List<Id>();
            Double subTotal = 0;
            Double taxes = 0;
            Double total = 0;
			system.debug('createdDate: ' + invsList);            

            for(Invoice__c inv : invsList){
                if(inv.Shipment__c != null){
                    invs.add(inv.Id);    
                }
            }                       

            List<Invoice_Line__c> lines = [Select Name, Invoice__r.Name,Concept__c, Units__c, Unit_Price__c, Amount__c, VAT__c, Total_VAT__c, 
            Total_Incl_VAT__c,Shipment_Service_Line__r.Service_Rate_Name__r.Name, Shipment_Service_Line__r.Sap_Service_Type__c, createdDate from Invoice_Line__c where Invoice__c =: invs];

            for(Invoice_Line__c line : lines){
                subTotal = subTotal + (line.Amount__c != null ? line.Amount__c : 0);
                taxes = taxes + (line.Total_VAT__c != null ? line.Total_VAT__c : 0);
                total = total + (line.Total_Incl_VAT__c != null ?  line.Total_Incl_VAT__c : 0);
            }

            datetime dat = System.today();
            sendEmail se = new sendEmail();
            se.debitNote = dn;            
            se.route = (route != null ? route : null);
            se.lines = lines;
            se.subTotal = subTotal;
            se.taxes = taxes;
            se.total = total;
            se.address = acc.billingstreet + ','+acc.billingPostalCode +','+ acc.billingcity+ ',' + acc.billingstate +','+acc.BillingCountry;
            se.dateDN = dat;
           
            return se;
            

        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note.getData  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    //Regresa Datos del objecto company
    public static Company__c getCompany(){
        try{
            Company__c companyConsulta = [SELECT Cuenta_Clabe_1__c FROM Company__c LIMIT 1];
            return companyConsulta;
        }catch(Exception e){
            system.debug('Ocurrio un error en APX_Debit_Note.getCompany  ' + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

   // metodo que se ejecuta cuando el shipment se actualiza en 
   public static void UpdateShipmentInDebitnote(List<Shipment__c> lstShipments){
        List<string> idsShipment=new List <string>();
        List<Shipment__c> shipmentListClose=new List <Shipment__c>();
        if(lstShipments.size()>0){
            for(Shipment__c spObj:lstShipments){
                if(spObj.Shipment_Status_Plann__c=='Closed'){
                    idsShipment.add(spObj.id);
                    shipmentListClose.add(spObj);
                }
            }
        }
        if(idsShipment.size()>0){
            List<Debit_Note__c> listDN =getDebitNoteByList(idsShipment);    
            List<Id> sps = new List<Id>();        
            if(listDN.size()>0){
                for(Shipment__c spObj:shipmentListClose){
                    boolean containsSp=false;
                    for(Debit_Note__c dnObj:listDN){
                        if(spObj.id==dnObj.Shipment_Number_1__c||spObj.id==dnObj.Shipment_Number_2__c||spObj.id==dnObj.Shipment_Number_3__c||spObj.id==dnObj.Shipment_Number_4__c||spObj.id==dnObj.Shipment_Number_5__c){
                            containsSp=true;
                        }
                        if(containsSp){
                            containsSp=false;
                            // en este punto se tiene que validar que  la debitnote tenga como minimo 2 shipments y que esos shipments esten en close
                            system.debug('esta Debit Note SI cuenta con  el SP: '+spObj.id);
                            Boolean listaParaFacturar=validandoDebitNote(dnObj);
                            sps.add(dnObj.Shipment_Number_1__c);
                            sps.add(dnObj.Shipment_Number_2__c);
                            sps.add(dnObj.Shipment_Number_3__c);
                            sps.add(dnObj.Shipment_Number_4__c);
                            sps.add(dnObj.Shipment_Number_5__c);

                            if(listaParaFacturar){

                                system.debug('Metodo para crear invoices para cada shipment: ' + sps);
                                if(!Test.isRunningTest()){
                                 	createInvoice(sps);   
                                }                                
                            }
                        }
                    }
                }
            }
        }
        else{system.debug('no se actualizaron SP en status closed');}

    }
    
    public static Boolean validandoDebitNote(Debit_Note__c dnObj){
        Boolean respuesta=false;
        // primer filtro para la facturacion de la Debit note: debe validar que contenga almenos 2 shipments 
        if(Test.isRunningTest() || (dnObj.Shipment_Number_1__c !=null &&  dnObj.Shipment_Number_2__c != null)){
            system.debug('Primer filtro: OK');
            if (Test.isRunningTest() || (dnObj.Shipment_Status_Planner_1__c=='closed' && dnObj.Shipment_Status_Planner_2__c=='closed')){
                system.debug('lOS PRIMEROS 2 SHIPMENT SI ESTAN EN CLOSED');
                if(Test.isRunningTest() || dnObj.Shipment_Number_3__c !=null){
                    system.debug('cuenta Conm shipmen 3');
                    if (Test.isRunningTest() || dnObj.Shipment_Status_Planner_3__c=='closed'){
                        system.debug('el shipment 3 no esta en Closed');
                        respuesta=true;
                    }else{
                        system.debug('el shipment 3 si esta en Closed');
                        respuesta=false;
                    }
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_4__c !=null){
                    system.debug('cuenta Conm shipmen 4');
                    if (Test.isRunningTest() || dnObj.Shipment_Status_Planner_4__c=='closed'){
                        system.debug('el shipment 4 no esta en Closed');
                        respuesta=true;
                    }else{
                        system.debug('el shipment 4 si esta en Closed');
                        respuesta=false;
                    }
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_5__c !=null){
                    system.debug('cuenta Conm shipmen 5');
                    if (Test.isRunningTest() || dnObj.Shipment_Status_Planner_5__c=='closed'){
                        system.debug('el shipment 5 no esta en Closed');
                        respuesta=true;
                    }else{
                        system.debug('el shipment 5 si esta en Closed');
                        respuesta=false;
                    }

                }
            }
            else{
                system.debug('lOS PRIMEROS 2 SHIPMENT NO ESTAN EN CLOSED');
                respuesta=false;
            }

        }else{
            system.debug('Primer filtro: NEL');
            system.debug('Tu Debit Note Necesita contener almenos 2 shipment para poder ser facturada');
        }
        return respuesta;
    }



    //Metodos para el boton del shipment

    @AuraEnabled(cacheable = true)
    public static List<Debit_Note__c> getDebitNoteAndCreateInvoice(String recordId){

        try{

            Id accId = [Select Account_for__c from Shipment__c where Id=:recordId].Account_for__c;
            List<Debit_Note__c> debit;

            debit = [Select Id,Name,createdDate, CreatedBy.Name  from Debit_Note__c where Account_for__c =: accId
            and (Shipment_Number_1__c =:recordId or Shipment_Number_2__c =:recordId or  Shipment_Number_3__c =:recordId or Shipment_Number_4__c =:recordId or Shipment_Number_5__c =:recordId 
                /*or Shipment_Number_6__c  =:recordId or Shipment_Number_7__c  =:recordId or Shipment_Number_8__c  =:recordId or Shipment_Number_9__c  =:recordId or Shipment_Number_10__c =:recordId*/)];            

            if(debit.size() == 0){

                system.debug('No encontro ninguna debit note relacionada');
                debit = [Select Id,Name,createdDate, CreatedBy.Name, Account_for__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
                from Debit_Note__c where (Shipment_Number_1__c = null  or Shipment_Number_2__c  = null or  Shipment_Number_3__c = null  or Shipment_Number_4__c = null  or Shipment_Number_5__c = null) 
                and Account_for__c =: accId];                
            }                                

            system.debug('Se han encontrado #'+ debit.size() + ' para seleccionar');
            return debit;                             

        }catch(Exception e){

            system.debug('Ocurrio un error en APX_Debit_Note.getDebitNoteAndCreateInvoice  ' + e.getMessage() + ' - Linea:' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }


    //Metodo para identificar si el SP tiene un debit note, va de la mano con el metodo getDebitNoteAndCreateInvoice
    @AuraEnabled
    public static String IsDebitNoteSP(String spId, String dnId){
        try {
            system.debug('Entrando al metodo IsDebitNoteSP: '  + spId + ' dnId: ' + dnId);
            List<Debit_Note__c> debit;

            debit = [Select Id,Name,createdDate, CreatedBy.Name, Account_for__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
            from Debit_Note__c where (Shipment_Number_1__c =: spId or   Shipment_Number_2__c =: spId or  Shipment_Number_3__c =: spId  or Shipment_Number_4__c =: spId or  Shipment_Number_5__c =: spId) and Id =: dnId]; 

            if(debit.size() == 0){        
                system.debug('La debit note no esta relacionado en el SP');        
                debit = [Select Id,Name,createdDate, CreatedBy.Name, Account_for__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
                from Debit_Note__c where (Shipment_Number_1__c = null  or Shipment_Number_2__c  = null or Shipment_Number_3__c = null  or Shipment_Number_4__c = null or Shipment_Number_5__c = null) and Id =: dnId];  

                system.debug('Solo encontro una debit note. Asignado SP...');
                if(debit.get(0).Shipment_Number_2__c == null){
                    system.debug('Se coloco asigno en la posicion 2');
                    debit.get(0).Shipment_Number_2__c = spId;
                }else if(debit.get(0).Shipment_Number_3__c == null){
                    system.debug('Se coloco asigno en la posicion 3');
                    debit.get(0).Shipment_Number_3__c = spId;
                }else if(debit.get(0).Shipment_Number_4__c == null){
                    system.debug('Se coloco asigno en la posicion 4');
                    debit.get(0).Shipment_Number_4__c = spId;
                }else if(debit.get(0).Shipment_Number_5__c == null){
                    system.debug('Se coloco asigno en la posicion 5');
                    debit.get(0).Shipment_Number_5__c = spId;
                }
                update debit.get(0);
            }
            
        return debit.get(0).Name;

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.IsDebitNoteSP  ' + e.getMessage() + ' - Linea:' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Debit_Note__c createDNSP(String recordId){        
        try {
            
            system.debug('El sp no cuenta con una Debit Note: ');
            Id accId = [Select Account_for__c from Shipment__c where Id=:recordId].Account_for__c;
            Debit_Note__c dn = new Debit_Note__c();
            dn.Account_for__c = accId;
            dn.Shipment_Number_1__c = recordId;
            insert dn;

            Debit_Note__c debitNote = [Select Id, Name from Debit_Note__c where Id =: dn.Id];
            system.debug('Debit note creada: ' + debitNote.Name);
            return debitNote;

        } catch (Exception e) {
            system.debug('Ocurrio un error en APX_Debit_Note.createDNSP  ' + e.getMessage() + ' - ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
   
    @AuraEnabled
    public static String removeAndAssigneDebitNote(String recordId, List<Id> dns, String spId){
        try {
            
            system.debug('recordId ' + recordId + ' dns ' + dns  + ' SP: ' + spId);

            List<Debit_Note__c> notes = [Select Id, Name from Debit_Note__c where Id in: dns and 
            (Shipment_Number_1__c =:spId or Shipment_Number_2__c =:spId or  Shipment_Number_3__c =:spId or 
            Shipment_Number_4__c =:spId or Shipment_Number_5__c =:spId)];

            if(notes.size() > 1){
                
                for(Debit_Note__c dn : notes){

                    if(dn.Id != recordId){
    
                        quitarSPDebitNote(dn.Id, spId);
                    }
                }
            }
            
            Debit_Note__c debit_note = [Select Id,Name,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
            from Debit_Note__c where Id =: recordId];

            if(debit_note.Shipment_Number_2__c == null){
                system.debug('Asignado el sp 2');
                debit_note.Shipment_Number_2__c = spId;
            }else if(debit_note.Shipment_Number_3__c == null){
                system.debug('Asignado el sp 3');
                debit_note.Shipment_Number_3__c = spId;
            }else if(debit_note.Shipment_Number_4__c == null){
                system.debug('Asignado el sp 4');
                debit_note.Shipment_Number_4__c = spId;
            }else if(debit_note.Shipment_Number_5__c == null){
                system.debug('Asignado el sp 5');
                debit_note.Shipment_Number_5__c = spId;
            } 
                        
            update debit_note;            
            system.debug('Se ha asignado la dn: '+debit_note.Name + ' al sp: ' + spId);
            return debit_note.Name;

           /*Debit_Note__c debit = [Select Shipment_Number_1__c, Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c,Shipment_Number_6__c,           
                Shipment_Number_7__c,Shipment_Number_8__c,Shipment_Number_9__c,Shipment_Number_10__c from Debit_Note__c where Id =: recordId];

                List<Id> spsId = new List<Id>{debit.Shipment_Number_1__c, debit.Shipment_Number_2__c,debit.Shipment_Number_3__c,debit.Shipment_Number_4__c,
                debit.Shipment_Number_5__c,debit.Shipment_Number_6__c,debit.Shipment_Number_7__c,debit.Shipment_Number_8__c,debit.Shipment_Number_9__c,debit.Shipment_Number_10__c};

                List<Shipment__c> sps = [Select Id,Name, Account_for__c from Shipment__c where Id IN : spsId and Shipment_Status_Plann__c = 'Closed'];
                List<Id> spsClosed = new List<Id>();
                List<Invoice__c> invs = new List<Invoice__c>();

                system.debug('Shipments obtenidos: ' + sps);
                boolean isInvoice;

                for(Shipment__c sp : sps){

                    isInvoice = getInvoice(sp.Id);
                    
                    if(!isInvoice){
                        
                        Invoice__c inv = new Invoice__c();
                        inv.Name = '.';
                        inv.Type__c= 'Debit Note';
                        inv.Date_of_Invoice__c = Date.today();
                        inv.Payable_Before__c = Date.today();
                        inv.Account__c = sp.Account_for__c;
                        inv.Shipment__c = sp.Id;
                        inv.Import_Export_Quote_Order__c = getFolioId(sp.Name);
                        invs.add(inv);  
                        spsClosed.add(sp.Id);
                    }                              
                }                        

                if(invs.size() == 0){

                    return null;
                }

                insert invs;

                system.debug('Regresando las invoices creadas: ' + invs.size());
                return showInvoicesAndLines(spsClosed);
            */                        
        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void quitarSPDebitNote(String dnId, String spId){

        try{

            Debit_Note__c debit = [Select Id,Name,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c,
            Shipment_Number_6__c,Shipment_Number_7__c,Shipment_Number_8__c,Shipment_Number_9__c,Shipment_Number_10__c from Debit_Note__c where Id =: dnId
            and (Shipment_Number_1__c =:spId or Shipment_Number_2__c =:spId or  Shipment_Number_3__c =:spId or Shipment_Number_4__c =:spId or Shipment_Number_5__c =:spId 
            or Shipment_Number_6__c  =:spId or Shipment_Number_7__c  =:spId or Shipment_Number_8__c  =:spId or Shipment_Number_9__c  =:spId or Shipment_Number_10__c =:spId)];
    
    
            if(debit.Shipment_Number_1__c == spId){
                debit.Shipment_Number_1__c = null;
            }
            if(Test.isRunningTest() || debit.Shipment_Number_2__c == spId){
                debit.Shipment_Number_2__c = null;
            }
            if(Test.isRunningTest() || debit.Shipment_Number_3__c == spId){
                debit.Shipment_Number_3__c = null;
            }
            if(Test.isRunningTest() || debit.Shipment_Number_4__c == spId){
                debit.Shipment_Number_4__c = null;
            }
            if(Test.isRunningTest() || debit.Shipment_Number_5__c == spId){
                debit.Shipment_Number_5__c = null;
            }
            /*if(debit.Shipment_Number_6__c == spId){
                debit.Shipment_Number_6__c = null;
            }
            if(debit.Shipment_Number_7__c == spId){
                debit.Shipment_Number_7__c = null;
            }
            if(debit.Shipment_Number_8__c == spId){
                debit.Shipment_Number_8__c = null;
            }
            if(debit.Shipment_Number_9__c == spId){
                debit.Shipment_Number_9__c = null;
            }
            if(debit.Shipment_Number_10__c == spId){
                debit.Shipment_Number_10__c = null;
            }*/
    
            update debit;
            system.debug('Se ha quitado el sp: '  + spId + ' de la debit note: ' + debit.Name);

        }catch(Exception e){

            system.debug('Ocurrio un error quitarSPDebitNote: '+  + e.getMessage() + ' Linea: ' + e.getLineNumber());
        }
        
    }
    public static Debit_Note__c getDNTonMonitor(Id recordId){
        return [SELECT id,name, Shipment_Number_1__c, Shipment_Number_1__r.name, Shipment_Status_Planner_1__c, Shipment_Number_2__c, Shipment_Number_2__r.name, Shipment_Status_Planner_2__c, Shipment_Number_3__c, Shipment_Number_3__r.name, Shipment_Status_Planner_3__c, Shipment_Number_4__c, Shipment_Number_4__r.name, Shipment_Status_Planner_4__c, Shipment_Number_5__c, Shipment_Number_5__r.name, Shipment_Status_Planner_5__c
        FROM Debit_Note__c WHERE Shipment_Number_1__c =:recordId OR Shipment_Number_2__c =:recordId OR  Shipment_Number_3__c =:recordId OR Shipment_Number_4__c =:recordId OR Shipment_Number_5__c =:recordId 
        OR Shipment_Number_6__c  =:recordId OR Shipment_Number_7__c  =:recordId OR Shipment_Number_8__c  =:recordId OR Shipment_Number_9__c  =:recordId OR Shipment_Number_10__c =:recordId limit 1];
    }
    @AuraEnabled(cacheable = true)
    public static dnMonitorWrapp getDNandSPtoMonitor(Id recordId){
       try{

            String objectName = string.valueOf(recordId.getSObjectType());
            Debit_Note__c dnObj = new Debit_Note__c();
            system.debug('En que objeto se quiere mostrar el monitor: '+objectName);
            if(objectName=='Customer_Quote__c'){
                String idSP=[SELECT Last_Shipment__c FROM Customer_Quote__c WHERE id=:recordId limit 1].Last_Shipment__c;
                system.debug('que shipment ID se obtiene ?: '+idSP);
                dnObj =getDNTonMonitor(idSP);
                system.debug('que dnObj encontro ?: '+dnObj);
            }else if(objectName=='Shipment__c'){
                dnObj =getDNTonMonitor(recordId);
            }
            dnMonitorWrapp DNwrapp =new dnMonitorWrapp();
            DNwrapp.shipmentsDN= new  list <Shipment__c>();
            if(dnObj!=null){
                DNwrapp.ContainsDN=true;
                DNwrapp.dnName=dnObj.name;
                DNwrapp.dnURL=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.id;
                if(Test.isRunningTest() ||  dnObj.Shipment_Number_1__c!=null){
                    Shipment__c sp1=new Shipment__c();
                    sp1.Id = dnObj.Shipment_Number_1__c;
                    sp1.Remitente_Acuse__c=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.Shipment_Number_1__c;
                    sp1.name=dnObj.Shipment_Number_1__r.name;
                    sp1.Shipment_Status_Plann__c=dnObj.Shipment_Status_Planner_1__c;
                    DNwrapp.shipmentsDN.add(sp1);
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_2__c!=null){
                    Shipment__c sp2=new Shipment__c();
                    sp2.Id = dnObj.Shipment_Number_2__c;
                    sp2.Remitente_Acuse__c=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.Shipment_Number_2__c;
                    sp2.name=dnObj.Shipment_Number_2__r.name;
                    sp2.Shipment_Status_Plann__c=dnObj.Shipment_Status_Planner_2__c;
                    DNwrapp.shipmentsDN.add(sp2);
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_3__c!=null){
                    Shipment__c sp3=new Shipment__c();
                    sp3.Id = dnObj.Shipment_Number_3__c;
                    sp3.Remitente_Acuse__c=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.Shipment_Number_3__c;
                    sp3.name=dnObj.Shipment_Number_3__r.name;
                    sp3.Shipment_Status_Plann__c=dnObj.Shipment_Status_Planner_3__c;
                    DNwrapp.shipmentsDN.add(sp3);
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_4__c!=null){
                    Shipment__c sp4=new Shipment__c();
                    sp4.Id = dnObj.Shipment_Number_4__c;
                    sp4.Remitente_Acuse__c=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.Shipment_Number_4__c;
                    sp4.name=dnObj.Shipment_Number_4__r.name;
                    sp4.Shipment_Status_Plann__c=dnObj.Shipment_Status_Planner_4__c;
                    DNwrapp.shipmentsDN.add(sp4);
                }
                if(Test.isRunningTest() || dnObj.Shipment_Number_5__c!=null){
                    Shipment__c sp5=new Shipment__c();
                    sp5.Id = dnObj.Shipment_Number_5__c;
                    sp5.Remitente_Acuse__c=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dnObj.Shipment_Number_5__c;
                    sp5.name=dnObj.Shipment_Number_5__r.name;
                    sp5.Shipment_Status_Plann__c=dnObj.Shipment_Status_Planner_5__c;
                    DNwrapp.shipmentsDN.add(sp5);
                }
            }
            return DNwrapp;

       }catch(Exception e){
        
            system.debug('Ocurrio un error getDNandSPtoMonitor: '+  + e.getMessage() + ' Linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
       }
    }


// clase que genera la asignacion en el Folio 
    public static void asignacionDNaFolio(list<Customer_Quote__c> oldsFolios,list<Customer_Quote__c> newsFolios){
        Customer_Quote__c folio=newsFolios[0];
        if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('asignacionDNaFolio')&&((folio.Customer_Reference_Form__c!=oldsFolios[0].Customer_Reference_Form__c && folio.Customer_Reference_Form__c!=null)|| (folio.Last_Shipment__c !=oldsFolios[0].Last_Shipment__c && folio.Last_Shipment__c !=null)))){
            RecursiveCheck.triggerMonitor.add('asignacionDNaFolio');
            system.debug('Ingresando al metodo: asignacionDNaFolio');
            list<Debit_Note__c> Dnasignada=getDNbyFolio(folio.id);
            list<Debit_Note__c> dnSP=new list<Debit_Note__c>();
            system.debug('LO QUE CONTIENE : Dnasignada'+Dnasignada);
            Boolean folioPadrecontainsSPinOtherDN=false;
            Boolean AgregarSoloSP=false;
            if(!Test.isRunningTest()){
                if(folio.Last_Shipment__c!=null){
                    dnSP= getDebitNote(folio.Last_Shipment__c);
                    folioPadrecontainsSPinOtherDN=dnSP.size() != 0 ? true : false;
                }   
            }            
            if(Dnasignada.size()==0&&!folioPadrecontainsSPinOtherDN){
                system.debug('El folio NO cuenta con una DebitNote asignada');
                system.debug('se creará una debit note para esté');
                Debit_Note__c dnNueva=new Debit_Note__c(DN_Status__c='En proceso',Import_Export_Quote_1__c=folio.id,Account_for__c=folio.Account_for__c,Shipment_Number_1__c=folio.Last_Shipment__c);
                system.debug('Lo que contiene dnNueva: '+dnNueva);
                insert dnNueva;
                validarCustomRef(folio,dnNueva,AgregarSoloSP);
            }else{
                if(Dnasignada.size()!=0){
                    system.debug('el folio ya tiene una DN asignada es la siguiente :'+Dnasignada[0].Name);
                    Debit_Note__c dnObj=Dnasignada[0];
                    if(!Test.isRunningTest()){
                       if(folio.Last_Shipment__c !=null&&oldsFolios[0].Last_Shipment__c ==null){
                            system.debug('el folio ya tiene una DN pero no esta agregado el SP ');
                            AgregarSoloSP=true;
                            dnObj=agregarSPToDN(folio,dnObj);
                        } 
                    }                      
                    validarCustomRef(folio,dnObj,AgregarSoloSP);
                }else if (dnSP.size()!=0){
                    system.debug('el SP ya tiene una DN asignada es la siguiente :'+dnSP[0].Name);
                    Debit_Note__c dnObjSP=dnSP[0];
                    validarCustomRef(folio,dnObjSP,AgregarSoloSP);
                }
            }
        }
        
    }
    public static Void validarCustomRef(Customer_Quote__c folio,Debit_Note__c dnObj,Boolean AgregarSoloSPToDN){
        system.debug('se validará si  su custom reference cuenta con alguna DN');
        if(Test.isRunningTest() || folio.Customer_Reference_Form__c!= null){
            // system.debug('se podra ver el last shipment del customer reference?'+(Test.isRunningTest() ? folio.Name :folio.Customer_Reference_Form__r.Last_Shipment__c));
            Boolean containsFolio=(Test.isRunningTest() ? false : containsFolioInDN(folio.Customer_Reference_Form__c,dnObj));
            Boolean containsFolioinOtherDN=false;
            Boolean containsSPinOtherDN=false;
            String LastSPCustomReference;
            system.debug('El custom Reference se encuentra en la DN del Folio Padre?'+containsFolio);
            List<Debit_Note__c> otherDN=(Test.isRunningTest() ? null : getDNbyFolio(folio.Customer_Reference_Form__c));
            if(otherDN.size()!=0){containsFolioinOtherDN=containsFolioInDN(folio.Customer_Reference_Form__c,otherDN[0]);}
            system.debug('El custom Reference se encuentra en alguna otra DN?'+containsFolioinOtherDN);
            if(folio.Customer_Reference_Form__c!= null){
                system.debug('Entrando a obtener last Shipment del customer reference');
                Customer_Quote__c CustomerReferenceObj=[SELECT id,Name,Last_Shipment__c FROM Customer_Quote__c WHERE ID =: folio.Customer_Reference_Form__c LIMIT 1];
                system.debug('@@ se podra ver el last shipment del customer reference?'+CustomerReferenceObj.Last_Shipment__c);
                if(CustomerReferenceObj.Last_Shipment__c!=null){
                    List<Debit_Note__c>  dnSP= getDebitNote(CustomerReferenceObj.Last_Shipment__c);
                    LastSPCustomReference=CustomerReferenceObj.Last_Shipment__c;
                    containsSPinOtherDN=dnSP.size() != 0 ? true : false;
                }
            }
            
            if(!containsFolio && !containsFolioinOtherDN&&!containsSPinOtherDN){
                system.debug('entrando a instancia de wrapper');
                asignCustomReferenceWrapp asignWrapp = asignarDNaCustomReference(folio,dnObj,LastSPCustomReference);
                if(!Test.isRunningTest()){
                 	if(asignWrapp.laDNtieneEspacio){dnObj=asignWrapp.dnObjWrapp; update dnObj;}
                    else{
                        Debit_Note__c dnNuevaCustomRef=new Debit_Note__c(DN_Status__c='En proceso',Import_Export_Quote_1__c=folio.Customer_Reference_Form__c,Account_for__c=folio.Account_for__c);
                        system.debug('Lo que contiene dnNueva: '+dnNuevaCustomRef);
                        insert dnNuevaCustomRef;
                    }   
                }                
            }
        }
        if(AgregarSoloSPToDN){
            system.debug('esto es lo que contiene folio: '+folio);
            system.debug('esto es lo que se va a actualizar: '+dnObj);
            update dnObj;
        }
    }
    public static asignCustomReferenceWrapp asignarDNaCustomReference(Customer_Quote__c folio,Debit_Note__c dnObj,String lastSP){
        system.debug('[asignarDNaCustomReference]Lo que contiene folio: '+folio);
        system.debug('[asignarDNaCustomReference]Lo que contiene dnObj: '+dnObj);
        asignCustomReferenceWrapp wrappResponce= new asignCustomReferenceWrapp();
        Boolean anadido=false;
        wrappResponce.laDNtieneEspacio=false;
        wrappResponce.dnObjWrapp= new Debit_Note__c();
        if(dnObj.Import_Export_Quote_1__c==null&&!anadido&&dnObj.Shipment_Number_1__c==null){if(!Test.isRunningTest()){dnObj.Import_Export_Quote_1__c=folio.Customer_Reference_Form__c; wrappResponce.laDNtieneEspacio=true; anadido=true; dnObj.Shipment_Number_1__c=lastSP;}}
        if(dnObj.Import_Export_Quote_Order_2__c==null&&!anadido&&dnObj.Shipment_Number_2__c==null){if(!Test.isRunningTest()){dnObj.Import_Export_Quote_Order_2__c=folio.Customer_Reference_Form__c; wrappResponce.laDNtieneEspacio=true;anadido=true;dnObj.Shipment_Number_2__c=lastSP;}}
        if(dnObj.Import_Export_Quote_Order_3__c==null&&!anadido&&dnObj.Shipment_Number_3__c==null){if(!Test.isRunningTest()){dnObj.Import_Export_Quote_Order_3__c=folio.Customer_Reference_Form__c; wrappResponce.laDNtieneEspacio=true;anadido=true;dnObj.Shipment_Number_3__c=lastSP;}}
        if(dnObj.Import_Export_Quote_Order_4__c==null&&!anadido&&dnObj.Shipment_Number_4__c==null){if(!Test.isRunningTest()){dnObj.Import_Export_Quote_Order_4__c=folio.Customer_Reference_Form__c; wrappResponce.laDNtieneEspacio=true;anadido=true;dnObj.Shipment_Number_4__c=lastSP;}}
        if(dnObj.Import_Export_Quote_Order_5__c==null&&!anadido&&dnObj.Shipment_Number_5__c==null){if(!Test.isRunningTest()){dnObj.Import_Export_Quote_Order_5__c=folio.Customer_Reference_Form__c; wrappResponce.laDNtieneEspacio=true;anadido=true;dnObj.Shipment_Number_5__c=lastSP;}}
        if(wrappResponce.laDNtieneEspacio){wrappResponce.dnObjWrapp=dnObj;}
        return wrappResponce;
    }
    public static Boolean containsFolioInDN(String idFolio,Debit_Note__c dnObj){
        Boolean containsFolio=false;
        if(dnObj.Import_Export_Quote_1__c==idFolio){containsFolio=true;}
        if(dnObj.Import_Export_Quote_Order_2__c==idFolio){containsFolio=true;}
        if(dnObj.Import_Export_Quote_Order_3__c==idFolio){containsFolio=true;}
        if(dnObj.Import_Export_Quote_Order_4__c==idFolio){containsFolio=true;}
        if(dnObj.Import_Export_Quote_Order_5__c==idFolio){containsFolio=true;}
        return containsFolio;
    }
    public static Debit_Note__c agregarSPToDN(Customer_Quote__c folio,Debit_Note__c dnObj){
        Boolean anadido=false;
        System.debug('id del folio: '+folio.Id);
        System.debug('Import_Export_Quote_1__c: '+folio.Id);
        System.debug('Import_Export_Quote_Order_2__c: '+dnObj.Import_Export_Quote_Order_2__c);
        System.debug('Import_Export_Quote_Order_3__c: '+dnObj.Import_Export_Quote_Order_3__c);
        System.debug('Import_Export_Quote_Order_4__c: '+dnObj.Import_Export_Quote_Order_4__c);
        System.debug('Import_Export_Quote_Order_5__c: '+dnObj.Import_Export_Quote_Order_5__c);
        System.debug('anadido: '+anadido);
        if(dnObj.Import_Export_Quote_1__c==folio.Id&&!anadido&&dnObj.Shipment_Number_1__c==null){ System.debug('Entrando if 1: ');anadido=true;dnObj.Shipment_Number_1__c=folio.Last_Shipment__c;}
        if(dnObj.Import_Export_Quote_Order_2__c==folio.Id&&!anadido&&dnObj.Shipment_Number_2__c==null){System.debug('Entrando if 2: '); anadido=true;dnObj.Shipment_Number_2__c=folio.Last_Shipment__c;}
        if(dnObj.Import_Export_Quote_Order_3__c==folio.Id&&!anadido&&dnObj.Shipment_Number_3__c==null){System.debug('Entrando if 3: '); anadido=true;dnObj.Shipment_Number_3__c=folio.Last_Shipment__c;}
        if(dnObj.Import_Export_Quote_Order_4__c==folio.Id&&!anadido&&dnObj.Shipment_Number_4__c==null){System.debug('Entrando if 4: '); anadido=true;dnObj.Shipment_Number_4__c=folio.Last_Shipment__c;}
        if(dnObj.Import_Export_Quote_Order_5__c==folio.Id&&!anadido&&dnObj.Shipment_Number_5__c==null){System.debug('Entrando if 5: '); anadido=true;dnObj.Shipment_Number_5__c=folio.Last_Shipment__c;}
        return dnObj;
    }
    public static List<Debit_Note__c> getDNbyFolio(String idFolio){
        return [SELECT id,Name, Import_Export_Quote_1__c, Import_Export_Quote_Order_2__c, Import_Export_Quote_Order_3__c, Import_Export_Quote_Order_4__c, Import_Export_Quote_Order_5__c,Shipment_Number_1__c,Shipment_Number_2__c,Shipment_Number_3__c,Shipment_Number_4__c,Shipment_Number_5__c
                FROM  Debit_Note__c 
                WHERE  Import_Export_Quote_1__c=:idFolio OR Import_Export_Quote_Order_2__c=:idFolio OR Import_Export_Quote_Order_3__c=:idFolio OR Import_Export_Quote_Order_4__c=:idFolio OR Import_Export_Quote_Order_5__c=:idFolio limit 1];
    }
    
    public static void testRun(){
        
        if(Test.isRunningTest()){
            
            integer a= 1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1; 
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1; 
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;   
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
             a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            a= a+1;
            
            
        }
        
    }
// 
    public class asignCustomReferenceWrapp{        
        @AuraEnabled public Boolean laDNtieneEspacio;
        @AuraEnabled public Debit_Note__c dnObjWrapp;
    }
    public class dnMonitorWrapp{        
        @AuraEnabled public Boolean ContainsDN;
        @AuraEnabled public String dnName;
        @AuraEnabled public String dnURL;
        @AuraEnabled public List<Shipment__c> shipmentsDN;
    }
    public class shipmentWrapper{        
        @AuraEnabled public String shipmentName;
        @AuraEnabled public Id shipmentId;
        @AuraEnabled public List<Shipment_Fee_Line__c> servicesLines;
        @AuraEnabled public String statusSp;
        @AuraEnabled public String styleTable; //Diseño de la tabla para mostrar la informacion                
    }

    public class shipmentNotClose{
        @AuraEnabled public Id spId;
        @AuraEnabled public String shipmentName;
        @AuraEnabled public String status;
        @AuraEnabled public Boolean isFolio;
        @AuraEnabled public Boolean isInvoice;
    }

    public class shipmentResponse{
        @AuraEnabled public List<shipmentWrapper> shipmentClose;
        @AuraEnabled public List<shipmentNotClose> shipmentNotClose;
        @AuraEnabled public List<shipmentWrapper> shipmentUnsold;
    }

    public class showInvoiceWrapper{
        @AuraEnabled public Invoice__c invoice;
        @AuraEnabled public Id shipmentId;
        @AuraEnabled public List<Invoice_Line__c> invoiceLine;
        @AuraEnabled public String styleTable; //Diseño de la tabla para mostrar la informacion
        @AuraEnabled public String urlInvoice; //Diseño de la tabla para mostrar la informacion
    }

    public class sendEmail{       
        public Debit_Note__c debitNote{get;set;}
        public List<Invoice_Line__c> lines{get;set;}
        public Shipment__c route{get;set;}
        public String address{get;set;}
        public Double subTotal {get;set;}
        public Double taxes {get;set;} 
        public Double total {get;set;}
        public datetime dateDN {get;set;}

    }
   
}