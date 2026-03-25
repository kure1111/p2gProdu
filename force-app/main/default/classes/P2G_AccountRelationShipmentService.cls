public class P2G_AccountRelationShipmentService {
    
    public void main(List<Account> listAccount) {
        List<Account> listNewAccount = new List<Account>();
        List<Account> listRecurrentAccount = new List<Account>();
        Set<Id> recurrentAccountIds = new Set<Id>(); // Cambiado a Set<Id>
        
        Date oneMonthAgo = Date.today().addMonths(-1);
                
        for(Account acc : listAccount) {            
            if(acc.CreatedDate.date() >= oneMonthAgo) {            
                System.debug('Cuenta creada en el último mes: ' + acc.Name + ' fecha de creacion: ' + acc.CreatedDate);
                listNewAccount.add(acc);
            } else {                
                recurrentAccountIds.add(acc.Id);                 
            }
        }
        
        
        if(!recurrentAccountIds.isEmpty()) {
            Map<Id, Integer> mapAccCountByShipment = getCountByShipment(recurrentAccountIds);
                        
            Map<Id, Account> accountMap = new Map<Id, Account>(listAccount);
            
            for(Id accId : recurrentAccountIds) {
                Account acc = accountMap.get(accId);
                if(acc != null) {
                    Integer shipmentCount = mapAccCountByShipment.containsKey(accId) ? 
                                           mapAccCountByShipment.get(accId) : 0;
                    
                    if(shipmentCount > 0) {
                        acc.Estatus_cuenta__c = 'Recurrente';
                        listRecurrentAccount.add(acc);
                    } else {                        
                        acc.Estatus_cuenta__c = 'Nuevo';
                        listNewAccount.add(acc);
                    }
                }
            }
        }
        
        // Actualizar todas las cuentas
        updateAllAccounts(listNewAccount, listRecurrentAccount);
        
        // Log de resumen
        System.debug('Resumen de procesamiento:');
        System.debug('Cuentas nuevas: ' + listNewAccount.size());
        System.debug('Cuentas recurrentes: ' + listRecurrentAccount.size());
    }
    
    public static Map<Id, Integer> getCountByShipment(Set<Id> recurrentsAccountIds) {
        Map<Id, Integer> mapCountAccbySP = new Map<Id, Integer>();
        
        if(recurrentsAccountIds.isEmpty()) {
            return mapCountAccbySP;
        }
        
        try {
            List<AggregateResult> listResult = [
                SELECT Account_for__c, COUNT(Id) total 
                FROM Shipment__c 
                WHERE Account_for__c IN :recurrentsAccountIds 
                AND CreatedDate = LAST_N_MONTHS:12 
                AND Shipment_Status_Plann__c != 'Cancel'
                GROUP BY Account_for__c
            ];
            
            for(AggregateResult result : listResult) {
                Id accountId = (Id) result.get('Account_for__c');
                Integer totalCount = (Integer) result.get('total');    
                mapCountAccbySP.put(accountId, totalCount);
            }
        } catch(Exception e) {
            System.debug('Error en getCountByShipment: ' + e.getMessage());
        }
        
        return mapCountAccbySP;
    }
    
    private static void updateAllAccounts(List<Account> listNewAccount, List<Account> listRecurrentAccount) {
        List<Account> allAccountsToUpdate = new List<Account>();
        
        
        if(!listNewAccount.isEmpty()) {
            for(Account acc : listNewAccount) {
                if(acc.Estatus_cuenta__c != 'Nuevo') {
                    acc.Estatus_cuenta__c = 'Nuevo';
                }
            }
            allAccountsToUpdate.addAll(listNewAccount);
        }
                
        if(!listRecurrentAccount.isEmpty()) {
            for(Account acc : listRecurrentAccount) {
                if(acc.Estatus_cuenta__c != 'Recurrente') {
                    acc.Estatus_cuenta__c = 'Recurrente';
                }
            }
            allAccountsToUpdate.addAll(listRecurrentAccount);
        }
                
        if(!allAccountsToUpdate.isEmpty()) {
            try {
                Database.SaveResult[] saveResults = Database.update(allAccountsToUpdate, false);
                                
                for(Integer i = 0; i < saveResults.size(); i++) {
                    if(!saveResults[i].isSuccess()) {
                        Account failedAccount = allAccountsToUpdate[i];
                        for(Database.Error error : saveResults[i].getErrors()) {
                            System.debug('Error actualizando cuenta ' + failedAccount.Id + 
                                       ': ' + error.getMessage());
                        }
                    }
                }
            } catch(Exception e) {
                System.debug('Error en update masivo: ' + e.getMessage());
            }
        }
    }
}