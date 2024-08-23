trigger P2G_altaProveedores on Account (before insert, before update) {
    String idUsuarioAutorizado = '005RQ000001fhRpYAI';
    String idRecordType = '0124T000000PTuSQAW';//uat 0124T000000PTuSQAW produ
    String idUsuarioActual = UserInfo.getUserId();
    Boolean autorizado = true;
    if(Test.isRunningTest()){
        idUsuarioAutorizado = idUsuarioActual;
    }
	for(Account account : trigger.new){
        if(account.RecordTypeId == idRecordType){
            if(UserInfo.getProfileId() == '00e4T000000zD9CQAU'){
                autorizado = true;
            }else {
                if(idUsuarioAutorizado == idUsuarioActual){
                    autorizado = true;
            	}
            }
        }
        if(autorizado == false){
            account.addError('No se puede actualizar esta cuenta debido a restricciones de permisos.');
        }
    }
}