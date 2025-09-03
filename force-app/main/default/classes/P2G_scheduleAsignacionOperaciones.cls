global class P2G_scheduleAsignacionOperaciones implements Schedulable {
    global void execute(SchedulableContext ctx) {
        //String cronExp = '0 0 0/1 1/1 * ? *'; // Ejecutar cada media hora
		//System.schedule('ScheduledAsignacionOperacionesJob', cronExp, new P2G_scheduleAsignacionOperaciones());
        P2G_AsignacionOperaciones.actualizarRegistros();
    }
}