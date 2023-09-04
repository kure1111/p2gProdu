trigger PAK_CargoLines on Quote_Item_Line__c (after insert, after update, after delete) {
    /*if(NEU_StaticVariableHelper.getBoolean1())
    return;
    System.debug('PAK_CargoLines ***');
    Set<Id> linesIds = new Set<Id>();
    
    List<Quote_Item_Line__c> lstCl = [SELECT Id, Import_Export_Quote__r.IMPAK__c 
                                      FROM Quote_Item_Line__c 
                                      WHERE Id IN:Trigger.isDelete ? Trigger.Old : Trigger.New ALL ROWS];
    
    for(Quote_Item_Line__c cl : lstCl){
        System.debug('LineId: ' + cl.Id + ' - Impak: ' + cl.Import_Export_Quote__r.IMPAK__c);
        if(!linesIds.contains(cl.Id) && cl.Import_Export_Quote__r.IMPAK__c == 'Si'){
            linesIds.add(cl.Id);                
        }
    }
    System.debug('PAK_CargoLines Lines: ' + linesIds);
    
    if(Trigger.isInsert){
        if(linesIds.size()>0 && PAK_SendCargoLines.firstRun){  
            PAK_SendCargoLines.firstRun = false;
            PAK_SendCargoLines.send(linesIds, 1);
        }
    }    
    if(Trigger.isUpdate){
        if(linesIds.size()>0 && PAK_SendCargoLines.firstRun){  
            PAK_SendCargoLines.firstRun = false;
            PAK_SendCargoLines.send(linesIds, 2);
        }
    }    
    if(Trigger.isDelete){
        if(linesIds.size()>0 && PAK_SendCargoLines.firstRun){  
            PAK_SendCargoLines.firstRun = false;
            PAK_SendCargoLines.send(linesIds, 3);
        }
    }*/
}