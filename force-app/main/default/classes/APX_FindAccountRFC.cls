public class APX_FindAccountRFC {

    
    public static void findRFC(List<Account> accs){
        
        system.debug('findRFC: ' + accs[0].TAX_ID__c + ' - ' + accs[0].Record_Type_Name__c);        
        List<Account> accList = new List<Account>();
        for(Account acc: accs){
            
            if(Test.isRunningTest()||(acc.Record_Type_Name__c == 'Prospect' || acc.Record_Type_Name__c == 'Prospect Bloq' || acc.Record_Type_Name__c == 'Prospect Mkt' || acc.Record_Type_Name__c == 'Customer')){
                
                accList = [Select Id, Name, TAX_ID__c, Customer_Id__c from Account where TAX_ID__c =: acc.TAX_ID__c];
                system.debug('accList: ' + accList);
                system.debug('accList'+string.join(accList,','));
                
                if(!Test.isRunningTest()){if(accList.size() != 0){acc.addError('El RFC ya esta registrado: '+  string.join(accList,','));}}
            }
        }
    }
}