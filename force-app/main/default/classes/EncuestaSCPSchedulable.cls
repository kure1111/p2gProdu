global class EncuestaSCPSchedulable implements Schedulable{

    global void execute(SchedulableContext sc) {
        batchEncuestaClienteSCP b = new batchEncuestaClienteSCP(); 
        database.executebatch(b);
    }
}