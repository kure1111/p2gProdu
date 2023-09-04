global class P2G_cargaMasivaFolios implements Database.Batchable<sObject>, Database.Stateful{
    List<Customer_Quote__c> listQuotes = new List<Customer_Quote__c>();
    List<P2G_CreacionFoliosWrapper.cargoLine> ListCargo = new List<P2G_CreacionFoliosWrapper.cargoLine>();
    List<String> failRecords = new List<String>();
    List<String> ListIdQuote = new List<String>();
    List<Integer> listaNoValido = new  List<Integer>();
    Integer cont = 0;
    
    global P2G_cargaMasivaFolios(List<Customer_Quote__c> ListQuote,List<P2G_CreacionFoliosWrapper.cargoLine> ListCargo){
        this.listQuotes = ListQuote;
        this.ListCargo = ListCargo;
    }
    global List<Customer_Quote__c> start(Database.BatchableContext bc){
        return this.listQuotes;
    }
    
    global void execute(Database.BatchableContext bc, List<Customer_Quote__c> scope){
        System.debug('Batch Actual: '+cont);
        List<P2G_CreacionFoliosWrapper.cargoLine> listCargoLocal= new List<P2G_CreacionFoliosWrapper.cargoLine>();
        try{
            for(Integer i = 0; i<scope.size(); i++){
                listCargoLocal.add(ListCargo[i+(cont*5)]);      
            }
            Database.SaveResult[] listaErrores = Database.insert(scope,false);
            for(Database.SaveResult item:listaErrores){
                if(!item.isSuccess()){
                    for(Database.Error err: item.getErrors()){
                        failRecords.add(err.getMessage());    
                    }
                    listaNoValido.add(cont);
                }
            }
            list<Quote_Item_Line__c> creo = P2G_CargaMasivaMetodos.creaCargo(scope,listCargoLocal);
        }catch(Exception e){
            System.debug('Error en batch cargaMAsiva '+e.getMessage());
        }
        cont++;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Batch Terminado Total: '+cont);
        System.debug('Quote insertados: '+listQuotes);
        //for(Integer indexDelete: listaNoValido){
         //   ListCargo.remove(indexDelete);
        //} 
    }
}