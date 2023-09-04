@isTest
public class OpportunityLineItemTest {            
    /**
    * @author		Brandom Gonzalez
    * @version 		1.0
    * @date 		20/07/22
    * @description	Clase TEST para los triggers: PrecioSugerido, CountBuyPrice".
    */

    @testSetup static void createObjects(){
                                 
        Rol_Margen__c margen = new Rol_Margen__c();
        
        margen.Name = 'Asesor Comercial';
        margen.FN_Margen_Operativo__c = 1;
        margen.FI_Margen_Operativo__c  = 1;
        margen.FI_LTL_Margen_Operativo__c = 1;
        margen.PTO_Margen_Operativo__c = 5;
        margen.M_FCL_Margen_Operativo__c = 1;
        margen.M_LCL_Margen_Operativo__c = 1;
        margen.A_Margen_Operativo__c = 1;
        margen.A_Paq_Margen_Operativo__c = 1;
        margen.W_WCA_Margen_Operativo__c = 1;
        margen.AW_WCA_Margen_Operativo__c = 1;
        margen.R_Margen_Operativo__c = 1;
        margen.T_Margen_Operativo__c = 1;
        margen.PQ_Margen_Operativo__c = 1;
        insert margen;
                       
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Account acc = new Account(Name='TestAccount');
        insert acc;
                
        
        Opportunity oppPaq = createOpp('TestPaq', 'PAQUETERIA', acc, customPB);            
        insert oppPaq;
                               
        OpportunityLineItem oliPaq = createProd(oppPaq, customPrice);
        insert oliPaq;
        
        
        Opportunity oppFN = createOpp('TestFN', 'FN', acc, customPB);            
        insert oppFN;
                               
        OpportunityLineItem oliFN = createProd(oppFN, customPrice);
        insert oliFN;
        
        Opportunity oppFI = createOpp('TestFI', 'FI', acc, customPB);            
        insert oppFI;
                               
        OpportunityLineItem oliFI = createProd(oppFI, customPrice);
        insert oliFI;
        
        Opportunity oppPTO = createOpp('TestPTO', 'PTO', acc, customPB);            
        insert oppPTO;
                               
        OpportunityLineItem oliPTO = createProd(oppPTO, customPrice);
        insert oliPTO;
        
        Opportunity oppM = createOpp('TestM', 'M', acc, customPB);            
        insert oppM;
                               
        OpportunityLineItem oliM = createProd(oppM, customPrice);
        insert oliM;
        
        
        Opportunity oppT = createOpp('TestT', 'T', acc, customPB);            
        insert oppT;
                               
        OpportunityLineItem oliT = createProd(oppT, customPrice);
        insert oliT;
        
        
    }

    
    private static Opportunity createOpp(String name, String service, Account acc,Pricebook2 customPB) {
        
        Opportunity opp = new Opportunity(Name=name, AccountId=acc.Id, CloseDate=Date.Today(), StageName='Suspect', Pricebook2Id=customPB.Id, 
                                          PROJ_Service_Mode__c = service);
        return opp;
    }
    
    private static OpportunityLineItem createProd(Opportunity opp, PricebookEntry customPrice){
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, 
                                                          Quantity = 5, 
                                                          PricebookEntryId = customPrice.Id, 
                                                          TotalPrice = 500,
                                                          Precio_Sugerido3__c = 100);
        return oli;
    }
    
    
    
    
    @isTest
    public static void updateOpp(){
        
       
        Account acc = [select id from Account where name = 'TestAccount'];
        List<Opportunity> opps = [Select id,PROJ_Service_Mode__c from Opportunity where AccountId =: acc.Id];        
        
        test.startTest();
            for(Opportunity opp : opps){
                
                OpportunityLineItem oli = [select id from OpportunityLineItem  where  OpportunityId=:opp.Id];
                            
                    oli.PROJ_Peso_de_carga__c = 12;            
                
            }
        test.stopTest();
        
        
        
        
    }
}