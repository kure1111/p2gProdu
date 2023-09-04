global class Pak_ShipmentClosedBatch implements Schedulable{

    global void execute(SchedulableContext sc) {
        Pak_ShipmentClosedShedule b = new Pak_ShipmentClosedShedule(); 
        database.executebatch(b);
    }
}