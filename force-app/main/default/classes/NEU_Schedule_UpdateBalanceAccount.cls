global class NEU_Schedule_UpdateBalanceAccount implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
        NEU_UpdateBalanceAccount.update_data();
    }
}