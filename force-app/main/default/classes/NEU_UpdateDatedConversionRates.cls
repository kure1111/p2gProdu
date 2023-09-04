global class NEU_UpdateDatedConversionRates implements Schedulable
{
	global void execute(SchedulableContext ctx)
    {
		if(UserInfo.isMultiCurrencyOrganization())
			NEU_DatedConversionRates.update_data();
    }
}