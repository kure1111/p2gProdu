public class UploadAccountController {
    static String sRecordTypeProspect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
 public class csv{
        public string Code {get;set;}
        public string ACCOUNT_NAME {get;set;}
        public string ACCOUNT_OWNER {get;set;}
        public string Potencializacion {get;set;}
        public string Tax_Id {get;set;}
     	public string Correo {get;set;}
     	public string Telefono {get;set;}
     	public string Direccion {get;set;}
     	public string Recuperado {get;set;}
        public string Prospeccion {get;set;}
        public string TagDesarrolloComercial {get;set;}
     	
     	
    }
    
    @AuraEnabled
    public static string createLines(String jsn){
        try{
            //OwnerId
            System.debug('JSON from CSV: ' + jsn);
            List<csv> lines = (List<csv>)JSON.deserialize(jsn, List<csv>.class);
            list<Account> lstAccounts = new list<Account>();
            Integer linesCount = lines.size();
            System.debug('No. Lines: ' + linesCount);
            for(csv l : lines)
            {
                 System.debug('l.Correo: ' + l.Correo);
                 System.debug('l.ACCOUNT_OWNER: ' + l.ACCOUNT_OWNER);
                if(l.code != '')
                {
                    lstAccounts.add(new Account(
                    						id = l.code,
                    						Name = l.ACCOUNT_NAME,
                    						Potencializacion__c = l.Potencializacion == ''?false : boolean.valueOf(l.Potencializacion),
                    						TAX_ID__c = l.Tax_Id,
                    						NEU_Email__c = l.Correo== null?'' : l.Correo,
                    						Phone = l.Telefono,
                    						BillingStreet = l.Direccion,
                    						Recuperado__c = l.Recuperado == ''?false : boolean.valueOf(l.Recuperado),
                        					ownerId= l.ACCOUNT_OWNER,
                        					Estatus_Recuperado__c = null,
                        					Prospeccion__c = l.Prospeccion == ''?false : boolean.valueOf(l.Prospeccion),
                        					Tag_Desarrollo_Comercial__c = l.TagDesarrolloComercial
                							));
                }
                else
                {
                    lstAccounts.add(new Account(
                    						
                    						Name = l.ACCOUNT_NAME,
                    						Potencializacion__c = l.Potencializacion == ''?false : boolean.valueOf(l.Potencializacion),
                    						TAX_ID__c = l.Tax_Id,
                    						NEU_Email__c = l.Correo== null?'' : l.Correo,
                    						Phone = l.Telefono,
                    						BillingStreet = l.Direccion,
                    						Recuperado__c = l.Recuperado == ''?false : boolean.valueOf(l.Recuperado),
                        					ownerId= l.ACCOUNT_OWNER,
                        					RecordTypeId = sRecordTypeProspect,
                        					Prospeccion__c = true,
                        					Tag_Desarrollo_Comercial__c = l.TagDesarrolloComercial
                							));
                }
                
            }
            upsert lstAccounts;
            return 'ok';
            
        }catch(Exception e){
            return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();
        }
    }
}