/**
 * Created by aserrano on 04/01/2018.
 */

trigger NEU_ActualizaFolioINV on Invoice__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
        
    if(!RecursiveCheck.triggerMonitor.contains('NEU_ActualizaFolioINV')){
        RecursiveCheck.triggerMonitor.add('NEU_ActualizaFolioINV');
        if(trigger.isInsert == true)
        {
            for(Invoice__c inv : trigger.new)
            {
                string ref = 'INV';

                List<INV_Counter__c> contador = [SELECT Contador__c FROM INV_Counter__c FOR UPDATE];

                if(!Test.isRunningTest())
                {
                    //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
                    Integer contadorAnual = [SELECT COUNT() FROM Invoice__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];

                    if(contadorAnual == 0)
                    {
                        contador[0].Contador__c = 1;
                    }
                    else
                    {
                        contador[0].Contador__c += 1;
                    }

                    inv.Numero_Folio__c = contador[0].Contador__c;
                }
                else
                {
                    inv.Numero_Folio__c = 1;
                }

                ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                ref += ('000000' + (inv.Numero_Folio__c != null ? String.valueOf(inv.Numero_Folio__c) : '')).right(6);

                inv.Name = ref;

                update contador;
            }
        }
        else if(trigger.isUpdate == true)
        {
            for(Invoice__c inv : trigger.new)
            {
                //No se permite cambiar el Name
                Invoice__c old_inv = Trigger.oldMap.get(inv.Id);

                inv.Name = old_inv.Name;
            }
        }
    }
}