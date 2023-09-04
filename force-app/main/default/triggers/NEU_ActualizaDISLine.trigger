/**
 * Created by aserrano on 12/01/2018.
 */

trigger NEU_ActualizaDISLine on Disbursement_Line__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    if(trigger.isInsert == true)
    {
        for(Disbursement_Line__c line : trigger.new)
        {
            string ref = 'P';

            List<DISLine_Counter__c> contador = [SELECT Contador__c FROM DISLine_Counter__c FOR UPDATE];

            if(!Test.isRunningTest())
            {
                //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
                Integer contadorAnual = [SELECT COUNT() FROM Disbursement_Line__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];

                if(contadorAnual == 0)
                {
                    contador[0].Contador__c = 1;
                }
                else
                {
                    contador[0].Contador__c += 1;
                }

                line.Numero_Linea__c = contador[0].Contador__c;
            }
            else
            {
                line.Numero_Linea__c = 1;
            }

            ref += '-'+string.valueof(system.today().year()).right(2)+'-';
            ref += ('000000' + (line.Numero_Linea__c != null ? String.valueOf(line.Numero_Linea__c) : '')).right(6);

            line.Name = ref;

            update contador;
        }
    }
    else if(trigger.isUpdate == true)
    {
        for(Disbursement_Line__c line : trigger.new)
        {
            //No se permite cambiar el Name
            Disbursement_Line__c old_line = Trigger.oldMap.get(line.Id);

            line.Name = old_line.Name;
        }
    }
}