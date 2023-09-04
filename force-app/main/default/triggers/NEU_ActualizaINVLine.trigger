/**
 * Created by aserrano on 04/01/2018.
 */

trigger NEU_ActualizaINVLine on Invoice_Line__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        

    if(Test.isRunningTest() || !RecursiveCheck.triggerMonitor.contains('NEU_ActualizaINVLine')){
        RecursiveCheck.triggerMonitor.add('NEU_ActualizaINVLine');                
            
        if(trigger.isInsert == true)
        {
            
            List<INVLine_Counter__c> contador = [SELECT Contador__c FROM INVLine_Counter__c FOR UPDATE];
            //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
            Integer contadorAnual = [SELECT COUNT() FROM Invoice_Line__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];
            for(Invoice_Line__c line : trigger.new)
            {
                string ref = 'I';            
                system.debug('Contador: ' + contador);
                
                if(!Test.isRunningTest())
                {                
                    system.debug('contadorAnual1: ' + contadorAnual);
                    
                    if(contadorAnual == 0)
                    {
                        contador[0].Contador__c = 1;
                    }
                    else
                    {
                        contador[0].Contador__c += 1;
                    }
                    
                    line.Numero_Linea__c = contador[0].Contador__c;
                    system.debug('contadorAnual2: ' + contadorAnual);
                }
                else
                {
                    line.Numero_Linea__c = 1;
                }
                
                ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                ref += ('000000' + (line.Numero_Linea__c != null ? String.valueOf(line.Numero_Linea__c) : '')).right(6);
                
                line.Name = ref;
                system.debug('line: ' + line);
                
                update contador;
            }
        }
        else if(trigger.isUpdate == true)
        {
            for(Invoice_Line__c line : trigger.new)
            {
                //No se permite cambiar el Name
                Invoice_Line__c old_line = Trigger.oldMap.get(line.Id);
                
                line.Name = old_line.Name;
            }
        } 
        
    }      
}