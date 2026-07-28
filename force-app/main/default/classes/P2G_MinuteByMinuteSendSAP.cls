public class P2G_MinuteByMinuteSendSAP implements Queueable {
    
    private List<Id> pendingIds;
    private Integer currentIndex;
    private static final Integer PAUSE_SECONDS = 60; // 1 minuto
    
    // Llevar registro de errores (opcional)
    private List<String> errors;
    
    public P2G_MinuteByMinuteSendSAP(List<Id> ids) {
        this.pendingIds = ids;
        this.currentIndex = 0;
        this.errors = new List<String>();
    }
    
    private P2G_MinuteByMinuteSendSAP(List<Id> ids, Integer startIndex, List<String> errors) {
        this.pendingIds = ids;
        this.currentIndex = startIndex;
        this.errors = errors;
    }
    
    public void execute(QueueableContext context) {
        // Verificar si ya terminamos
        if (currentIndex >= pendingIds.size()) {
            finalizarProceso();
            return;
        }
        
        Id currentId = pendingIds[currentIndex];
        
        System.debug(' Procesando ' + (currentIndex + 1) + '/' + pendingIds.size() + ' - ID: ' + currentId);
        
        Boolean exito = false;
        
        try {
            PAK_SendToOrder sendToOrder = new PAK_SendToOrder(
                new ApexPages.StandardController(new Shipment__c(Id = currentId))
            );
            sendToOrder.IdShipment = currentId;
            sendToOrder.SendWS();
            
            System.debug('Éxito: ' + currentId);
            exito = true;
            
        } catch (Exception e) {
            String errorMsg = 'Error en ID ' + currentId + ': ' + e.getMessage();
            System.debug(errorMsg);
            errors.add(errorMsg);
            exito = false;
        }
        
        // CRUCIAL: SIEMPRE programar el siguiente, sin importar si falló o no
        if (currentIndex + 1 < pendingIds.size()) {
            scheduleNext(currentIndex + 1);
        } else {
            // Si es el último, finalizar
            finalizarProceso();
        }
    }
    
    private void scheduleNext(Integer nextIndex) {
        String jobName = 'MinuteProcessor_' + DateTime.now().getTime();
        DateTime nextRun = DateTime.now().addSeconds(PAUSE_SECONDS);
        
        String cronExpression = String.format(
            '{0} {1} {2} {3} {4} ? {5}',
            new List<String>{
                String.valueOf(nextRun.second()),
                String.valueOf(nextRun.minute()),
                String.valueOf(nextRun.hour()),
                String.valueOf(nextRun.day()),
                String.valueOf(nextRun.month()),
                String.valueOf(nextRun.year())
            }
        );
        
        System.schedule(jobName, cronExpression, new QueueableSchedulerWrapper(pendingIds, nextIndex, errors));
    }
    
    private void finalizarProceso() {
        System.debug('PROCESO COMPLETADO');
        System.debug('Total IDs: ' + pendingIds.size());
        System.debug('Exitosos: ' + (pendingIds.size() - errors.size()));
        System.debug('Errores: ' + errors.size());
        
        if (!errors.isEmpty()) {
            System.debug('LISTA DE ERRORES:');
            for (String error : errors) {
                System.debug('   - ' + error);
            }
        }
    }
    
    private class QueueableSchedulerWrapper implements Schedulable {
        private List<Id> ids;
        private Integer startIndex;
        private List<String> errors;
        
        public QueueableSchedulerWrapper(List<Id> ids, Integer startIndex, List<String> errors) {
            this.ids = ids;
            this.startIndex = startIndex;
            this.errors = errors;
        }
        
        public void execute(SchedulableContext sc) {
            System.enqueueJob(new P2G_MinuteByMinuteSendSAP(ids, startIndex, errors));
        }
    }
}