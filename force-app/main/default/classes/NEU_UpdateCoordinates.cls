global class NEU_UpdateCoordinates implements Schedulable
{
  	global void execute(SchedulableContext ctx)
    {
    	NEU_Coordinates.update_data();
    }
}