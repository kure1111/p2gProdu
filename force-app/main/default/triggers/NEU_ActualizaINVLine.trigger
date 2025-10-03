trigger NEU_ActualizaINVLine on Invoice_Line__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        

    if(Test.isRunningTest() || !RecursiveCheck.triggerMonitor.contains('NEU_ActualizaINVLine')){
        RecursiveCheck.triggerMonitor.add('NEU_ActualizaINVLine');                
            
        if(trigger.isInsert == true)
        {
            P2G_InvoiceLineTriggerHandler.beforeInsert(Trigger.new);
            List<INVLine_Counter__c> contador = [SELECT Contador__c FROM INVLine_Counter__c FOR UPDATE];
            //Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos
            Integer contadorAnual = [SELECT COUNT() FROM Invoice_Line__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];
            for(Invoice_Line__c line : trigger.new)
            {
                string ref = 'I';            
                if(true)
                {                
                    if(contadorAnual == 0)
                    {contador[0].Contador__c = 1;}
                    else
                    {contador[0].Contador__c += 1;}
                    line.Numero_Linea__c = contador[0].Contador__c;
                }
                else
                {line.Numero_Linea__c = 1;}
                ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                ref += ('000000' + (line.Numero_Linea__c != null ? String.valueOf(line.Numero_Linea__c) : '')).right(6);
                
                line.Name = ref;
                update contador;
            }
        }
        else if(trigger.isUpdate == true)
        {
            //No se permite cambiar el Name
            for(Invoice_Line__c line : trigger.new)
            {Invoice_Line__c old_line = Trigger.oldMap.get(line.Id); line.Name = old_line.Name;}}    
    }      
}