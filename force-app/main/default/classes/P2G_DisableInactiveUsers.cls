public class P2G_DisableInactiveUsers implements Schedulable {
    //System.schedule('P2G_DisableInactiveUsers', '0 0 4 * * ? *', new P2G_DisableInactiveUsers());
    //todos los dias 4 am
    public void execute(SchedulableContext sc) {
        DateTime fechaLimite = System.now().addDays(-30);
        
        List<User> usuariosADesactivar = [
            SELECT Id
            FROM User 
            WHERE IsActive = true 
            AND LastLoginDate < :fechaLimite 
            AND Profile.Name NOT IN ('System Administrator', 'Integration User')
            AND Id != :UserInfo.getUserId()
            AND Id != '0054T0000025ew3QAA'
        ];
        
        if(!usuariosADesactivar.isEmpty()) {
            List<User> usuariosUpdate = new List<User>();
            for(User u : usuariosADesactivar) {
                usuariosUpdate.add(new User(Id = u.Id, IsActive = false));
            }
            
            try {
                update usuariosUpdate;
                System.debug('Desactivados: ' + usuariosUpdate.size());
            } catch(Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
}