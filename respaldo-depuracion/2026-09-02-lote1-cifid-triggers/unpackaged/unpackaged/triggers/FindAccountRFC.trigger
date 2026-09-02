trigger FindAccountRFC on Account (before insert, before update) {

    // Verficiar antes de registrar y actualizar una cuenta si tienen el RFC repetido
    
    /*if(Trigger.isBefore){
               
        if(Trigger.isInsert){            
            APX_FindAccountRFC.findRFC(Trigger.new, Trigger.Old);
        }
        
        else if(Trigger.isUpdate){
            APX_FindAccountRFC.findRFC(Trigger.new, Trigger.old);
        }
        
    }*/
    
}