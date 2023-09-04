/**
 * Created by aserrano on 12/01/2018.
 */

trigger NEU_ActualizaFolioDIS on Shipment_Disbursement__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    if(trigger.isInsert == true)
    {
        for(Shipment_Disbursement__c dis : trigger.new)
        {
            string ref = 'PRO';

            List<DIS_Counter__c> contador = [SELECT Contador__c FROM DIS_Counter__c FOR UPDATE];

            if(!Test.isRunningTest())
            {
                //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
                Integer contadorAnual = [SELECT COUNT() FROM Shipment_Disbursement__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];

                if(contadorAnual == 0)
                {
                    contador[0].Contador__c = 1;
                }
                else
                {
                    contador[0].Contador__c += 1;
                }

                dis.Numero_Folio__c = contador[0].Contador__c;
            }
            else
            {
                dis.Numero_Folio__c = 1;
            }

            ref += '-'+string.valueof(system.today().year()).right(2)+'-';
            ref += ('000000' + (dis.Numero_Folio__c != null ? String.valueOf(dis.Numero_Folio__c) : '')).right(6);

            dis.Name = ref;

            update contador;
        }
    }
    else if(trigger.isUpdate == true)
    {
        for(Shipment_Disbursement__c dis : trigger.new)
        {
            //No se permite cambiar el Name
            Shipment_Disbursement__c old_dis = Trigger.oldMap.get(dis.Id);

            dis.Name = old_dis.Name;
        }
    }
}