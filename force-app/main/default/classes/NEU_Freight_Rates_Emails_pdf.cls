public with sharing class NEU_Freight_Rates_Emails_pdf
{
	public string contenedor_pdf {get;set;}
	StaticResource query_logo;
	Fee__c basefee;
	public String documentName;
	public List<NEU_Freight_Rates_Emails_save_pdf.customFees_s> RatesSelection {get;set;}
	public String rt_ty {get; set;}
	public Integer rt_ct {get;set;}
	public class fee_s
	{
		public String name;
		public List<Fee__c>fees= null;

		public fee_s(String name, List<Fee__c>fees)
		{
			this.name = name;
			this.fees = fees;
		}
	}
	public class ServiceRateContainer_s
	{
		public Fee__c fee0{get;set;}
		public Fee__c fee1{get;set;}
		public Fee__c fee2{get;set;}
		public Fee__c fee3{get;set;}
		public Fee__c fee4{get;set;}
		public Fee__c fee5{get;set;}
		public Fee__c fee6{get;set;}
		public Id Port_Airport_of_Load
		{
			get
				{
					return fee0.Route__r.Port_Airport_of_Load__c;
				}
			set
				{
					if(fee0.Route__r.Port_Airport_of_Load__c!=value)
						fee0.Route__r.Port_Airport_of_Load__c=value;
				}
		}
		public Id Port_Airport_of_Discharge
		{
			get
				{
					return fee0.Route__r.Port_Airport_of_Discharge__c;
				}
			set
				{
					if(fee0.Route__r.Port_Airport_of_Discharge__c!=value)
						fee0.Route__r.Port_Airport_of_Discharge__c=value;
				}
		}

		public ServiceRateContainer_s(Fee__c fee)
			{
				fee0=fee;
				fee1=new Fee__c();
				fee2=new Fee__c();
				fee3=new Fee__c();
				fee4=new Fee__c();
				fee5=new Fee__c();
				fee6=new Fee__c();
			}
	}

	public String[] containerNames
	{
		get
			{
				if(containerNames==null)
					containerNames=new String[]{'20" DV','40" DV','40" HC'};
				return containerNames;
			}
		set;
	}

	public Id[] containers
	{
		get
			{
				if(containers==null)
				{
					containers=new Id[3];
					List<Container_Type__c>cs=[select Id,Name from Container_Type__c where Name IN: containerNames];
					for(Container_Type__c c:cs)
						{
							if(c.Name==containerNames[0])
								containers[0]=c.Id;
							else if(c.Name==containerNames[1])
								containers[1]=c.Id;
							else if(c.Name==containerNames[2])
								containers[2]=c.Id;
						}
				}
				return containers;
			}
		set;
	}

	private void showHeader(boolean pagebreak)
		{
			if(pagebreak)
				contenedor_pdf +='<div style="page-break-before:always;">';
			else
				contenedor_pdf +='<div>';
			contenedor_pdf +='		<div style="display:table-cell;vertical-align:top"><img style="width:185px" src="/resource/'+query_logo.SystemModStamp.getTime()+ '/'+(String.IsNotEmpty(query_logo.NamespacePrefix)?query_logo.NamespacePrefix+'__':'')+query_logo.Name+'"/></div>';
			contenedor_pdf +='		<div style="display:table-cell;width:100%"><div style="font-weight:bold;font-size:1.5em;padding-top:1em;text-align:right">'+NEU_Utils.safeString(documentName)+'</div>';
			contenedor_pdf +='  </div>';
		}

	private void showTable()
		{
			contenedor_pdf +='<div id="mid">';

			contenedor_pdf +='<hr/>';

			contenedor_pdf +='<table border="0" cellspacing="3" cellpadding="5" class="table_lines">';
			contenedor_pdf += '<tr>';
			contenedor_pdf += '  <th style="width:10%">Rate Name</th>';
			contenedor_pdf += '  <th>Country&nbsp;of<br/>Loading</th>';
			contenedor_pdf += '  <th>Port</th>';
			contenedor_pdf += '  <th>Country&nbsp;of<br/>Discharge</th>';
			contenedor_pdf += '  <th>Port</th>';

			if(rt_ct==1)
			{
				contenedor_pdf += '  <th>Buy Rate</th>';
			}
			else if(rt_ct == 2)
			{
				contenedor_pdf += '  <th>Sell Rate</th>';
			}
			else
			{
				contenedor_pdf += '  <th>Buy Rate</th>';
				contenedor_pdf += '  <th>Sell Rate</th>';
			}
			contenedor_pdf += '  <th>Basis</th>';

			if(rt_ty.contains('Per Container'))
				contenedor_pdf += '  <th>Container Type</th>';

			contenedor_pdf += '  <th>Vol Factor</th>';
			contenedor_pdf += '  <th>MIN</th>';
			contenedor_pdf += '  <th>TT</th>';
			contenedor_pdf += '  <th>Valid From</th>';
			contenedor_pdf += '  <th>Valid Until</th>';
			contenedor_pdf += '  <th style="width:70%">Comments</th>';
			contenedor_pdf += '  </tr>';
		}

	private void showTable_PerContainer()
		{
			contenedor_pdf +='<div id="mid">';
			contenedor_pdf +='<hr/>';
			contenedor_pdf +='<table border="0" cellspacing="3" cellpadding="5" class="table_lines">';
			contenedor_pdf += '<tr>';
			contenedor_pdf += '  <th style="width:10%">Rate Name</th>';
			contenedor_pdf += '  <th>Country&nbsp;of<br/>Loading</th>';
			contenedor_pdf += '  <th>Port</th>';
			contenedor_pdf += '  <th>Country&nbsp;of<br/>Discharge</th>';
			contenedor_pdf += '  <th>Port</th>';

			//Per Container

			if(rt_ct==1)
			{
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[0] +'</th>';
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[1] +'</th>';
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[2] +'</th>';
			}
			else if(rt_ct == 2)
			{
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[0] +'</th>';
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[1] +'</th>';
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[2] +'</th>';
			}
			else//All
			{
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[0] +'</th>';
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[1] +'</th>';
				contenedor_pdf += '  <th>Buy Rate '+ containerNames[2] +'</th>';
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[0] +'</th>';
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[1] +'</th>';
				contenedor_pdf += '  <th>Sell Rate '+ containerNames[2] +'</th>';
			}

			//contenedor_pdf += '  <th>Vol Factor</th>';
			contenedor_pdf += '  <th>MIN</th>';
			contenedor_pdf += '  <th>TT</th>';
			contenedor_pdf += '  <th>Valid From</th>';
			contenedor_pdf += '  <th>Valid Until</th>';
			contenedor_pdf += '  <th style="width:70%">Comments</th>';
			contenedor_pdf += '  </tr>';
		}



	private void closeTable()
	{
		contenedor_pdf += '  </table>';
		contenedor_pdf +='<hr/>';
		contenedor_pdf += '</div>';
	}

	public NEU_Freight_Rates_Emails_pdf()
	{
			contenedor_pdf = '';
			query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo'];
			String objetocustom = '';
			try
			{
				objetocustom = (String)Cache.Session.get('RatesSelection');
			}catch (Exception e)
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'GET PDF:'+e));
			}

			if(String.isNotEmpty(objetocustom))
			{
				RatesSelection = (List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>)System.JSON.deserialize(objetocustom, List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>.class);
			}

			/*if(RatesSelection != null)//Comments
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'SIZE: '+RatesSelection.size()));
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'JSON OBJECT: '+objetocustom));
			}*/

			String id_af = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('id_af'));//Account for
			rt_ct=NEU_Utils.safeInteger(ApexPages.currentPage().getParameters().get('rt_ct'));//Show Rates (BuySell) (XX)
			String isoc  = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('isoc'));//Currency
			String dp_mi = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('dp_mi'));//Show Breakpoints (Display Min)
			rt_ty = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('rt_ty'));//Rate Type
			String dp_co = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('dp_co'));//Display concepts when Rate Type == Container(XX)
			String id_ca = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('id_ca'));//Id Carrier;
			String va_fr = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('va_fr'));//Valid From;
			String va_un = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('va_un'));//Valid Until;
			String re_lo = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('re_lo'));//Region of Load
			String re_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('re_dc'));//Region of Discharge
			String co_lo = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('co_lo'));//Country of Load
			String co_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('co_dc'));//Country of Discharge
			String st_ld = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('st_ld'));//Site of Load
			String st_dc = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('st_dc'));//Site of Discharge
			documentName = NEU_Utils.safeString(ApexPages.currentPage().getParameters().get('name'));//Document Name

			List<Account> customers = [Select Id, Name, Remarks_Freight_Rates__c from Account where Id =: id_af limit 1];

			try{
				basefee.Account_for__c=id_af;
			}catch(Exception e){}


			//Filters
			String query_fee = 'select Id,Name,Fee_Category__c, Fee_Rate__c,Buy_Rate__c,Rate_Type__c,Volumetric_Factor__c,Min__c,TT_Days__c,Fee_Description__c'+NEU_CurrencyUtils.CurrencyISOCode()+',Route__r.Country_of_Load__r.Name';
			query_fee += ',Route__r.Port_Airport_of_Load__r.Name,Route__r.Country_of_Discharge__r.Name,Route__r.Port_Airport_of_Discharge__r.Name,Valid_From__c,Valid_Until__c,Comments__c, Max_M3__c,Max_Kgs__c, Container_Type__r.Name, Carrier_Account__c, Account_for__c ';

			String query_filters_generic = '';

			query_filters_generic += ' from Fee__c';
			query_filters_generic += ' where Id != null';
			query_filters_generic += ' AND Active__c = true';
			query_filters_generic += (String.IsNotEmpty(id_af) ? ' AND Account_for__c = :id_af' : '');
			query_filters_generic += (UserInfo.isMultiCurrencyOrganization() && String.IsNotEmpty(isoc) ? ' AND CurrencyISOCode =:isoc' : '');
			query_filters_generic += (String.IsNotEmpty(rt_ty) ? ' AND Rate_Type__c = :rt_ty' : '');
			query_filters_generic += (String.IsNotEmpty(id_ca) ? ' AND Carrier_Account__c = :id_ca' : '');
			Date ValidFrom = null;
			Date ValidUntil= null;
			if(String.IsNotEmpty(va_fr))
				ValidFrom = date.parse(va_fr);
			if(String.IsNotEmpty(va_un))
				ValidUntil= date.parse(va_un);

			if(ValidFrom!=null)
				query_filters_generic+=' and (Valid_Until__c=null or Valid_Until__c>=:ValidFrom)';
			if(ValidUntil!=null)
				query_filters_generic+=' and (Valid_From__c=null or Valid_From__c<=:ValidUntil)';

			query_filters_generic += (String.IsNotEmpty(re_lo) ? ' AND Route__r.Country_of_Load__r.Region__c = :re_lo' : '');
			query_filters_generic += (String.IsNotEmpty(re_dc) ? ' AND Route__r.Country_of_Discharge__r.Region__c = :re_dc' : '');
			query_filters_generic += (String.IsNotEmpty(co_lo) ? ' AND Route__r.Country_of_Load__c =:co_lo' : '');
			query_filters_generic += (String.IsNotEmpty(co_dc) ? ' AND Route__r.Country_of_Discharge__c =: co_dc' : '');
			query_filters_generic += (String.IsNotEmpty(st_ld) ? ' AND Route__r.Port_Airport_of_Load__c =: st_ld' : '');
			query_filters_generic += (String.IsNotEmpty(st_dc) ? ' AND Route__r.Port_Airport_of_Discharge__c =: st_dc' : '');

			if(rt_ct==1) //Buy Rate
			{
				query_filters_generic += ' AND Buy_Rate__c != null';
				query_filters_generic += ' AND Buy_Rate__c != 0';
			}else if(rt_ct==2){//Sell Rate
				query_filters_generic += ' AND Fee_rate__c != null';
				query_filters_generic += ' AND Fee_rate__c != 0';
			}else{//Both(Sell and Rate)
				/*query_filters_generic += ' AND Buy_Rate__c != null';
				query_filters_generic += ' AND Buy_Rate__c != 0';
				query_filters_generic += ' AND Fee_rate__c != null';
				query_filters_generic += ' AND Fee_rate__c != 0';*/
			}

			query_fee += query_filters_generic;

			List<fee_s> feesSelection = null;
			Boolean limits_exceeded = false;//Control Errors Display
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//QUERYS
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if(RatesSelection != null && RatesSelection.size()>0 && String.isNotEmpty(objetocustom))
			{
				feesSelection = new List<fee_s>();
				for(NEU_Freight_Rates_Emails_save_pdf.customFees_s cfs: RatesSelection)
				{
					if(cfs.selectedFee)
					{
						String query_specific_filters = '';
						query_specific_filters += query_fee;
						String nameFee = cfs.NameFee;
						query_specific_filters += (String.IsNotEmpty(cfs.NameFee) ? ' AND Fee_Category__c =:nameFee' : '');
						query_specific_filters += ' limit 200';

						try{

						}catch (Exception e)
						{
							contenedor_pdf +='<div class="alert-filters">';
							contenedor_pdf +='<p class="message_limit">'+ e +'</p>';
							contenedor_pdf +='</div>';
							limits_exceeded = true;
						}

						List<Fee__c> service = (List<Fee__c>)DataBase.query(query_specific_filters);

						feesSelection.add(new fee_s(cfs.NameFee, service));
					}
				}

			}

			//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'QUERY 1: '+query_count_POL));

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if(!limits_exceeded && feesSelection != null && feesSelection.size()>0)//If we have exceeded some limit we show the errors in the PDF
			{
				Integer contadorFeec = 0;
				for(fee_s feec : feesSelection)
				{

					if(feec.fees != null && feec.fees.size()>0)
					{

						List<ServiceRateContainer_s> myList = null;
						Map<String,ServiceRateContainer_s>feeSearch=null;
						//Per Container Freights
						if(rt_ty.contains('Per Container') && feec.name.contains('Freights'))//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						{
							feeSearch=new Map<String,ServiceRateContainer_s>();
							myList = new List<ServiceRateContainer_s>();
							for(Fee__c fee :feec.fees)
								{

									if(feeSearch!=null)
									{
										String feeKey=NEU_Utils.safeString(fee.Name)+'_|_'+NEU_Utils.safeString(fee.Fee_Category__c)+'_|_'+NEU_Utils.safeString(fee.Route__c)+'_|_'+NEU_Utils.safeString(fee.Carrier_Account__c)+'_|_'+NEU_Utils.safeString(fee.TT_Days__c)+'_|_'+NEU_Utils.safeString(fee.Valid_From__c)+'_|_'+NEU_Utils.safeString(fee.Valid_Until__c)+'_|_'+NEU_Utils.safeString(fee.Account_for__c);
										ServiceRateContainer_s mySR=feeSearch.get(feeKey);
										Boolean newSR=false;
										if(mySR==null)
										{
											mySR=new ServiceRateContainer_s(fee);
											newSR=true;
										}

										if(fee.Container_Type__c==containers[0])
											mySR.fee1=fee;
										else if(fee.Container_Type__c==containers[1])
											mySR.fee2=fee;
										else if(fee.Container_Type__c==containers[2])
											mySR.fee3=fee;

										feeSearch.put(feeKey,mySR);
									}
								}
							if(feeSearch!=null)
								myList=feeSearch.values();


							//SHOW in PDF
							if(myList != null && myList.size()>0)
							{
								if(contadorFeec == 0)
									showHeader(false);
								else
									showHeader(true);

								String title_contenedor = '';
								title_contenedor +='<div>';
								title_contenedor +='<div style="display:table-cell;width:100%"><div style="font-weight:bold;font-size:1.5em;padding-top:1em;text-align:left">'+ feec.name +'</div>';
								title_contenedor +='</div>';
								contenedor_pdf += title_contenedor;

								integer contador_items = 0;
								integer contador_global = 0;
								showTable_PerContainer();


								for(ServiceRateContainer_s f: myList)
								{
									if((contador_items>12) || Test.isRunningTest())
									{
										closeTable();
										showHeader(true);
										contenedor_pdf += title_contenedor;
										showTable_PerContainer();
										contador_items =0;
									}

									contenedor_pdf += '  <tr>';
									contenedor_pdf += '    <td align="left" style="width:10%">'+NEU_Utils.safeString(f.fee0.Name)+'</td>';
									contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.fee0.Route__r.Country_of_Load__r.Name)+'</td>';
									contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.fee0.Route__r.Port_Airport_of_Load__r.Name)+'</td>';
									contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.fee0.Route__r.Country_of_Discharge__r.Name)+'</td>';
									contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.fee0.Route__r.Port_Airport_of_Discharge__r.Name)+'</td>';
									if(rt_ct==1)//Buy Rate
									{
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee1.Buy_Rate__c) + (f.fee1.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee1) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee2.Buy_Rate__c) + (f.fee2.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee2) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee3.Buy_Rate__c) + (f.fee3.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee3) + ')' : '') +'</td>';
									}
									else if(rt_ct == 2)//Sell Rate
									{
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee1.Fee_rate__c) + (f.fee1.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee1) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee2.Fee_rate__c) + (f.fee2.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee2) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee3.Fee_rate__c) + (f.fee3.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee3) + ')' : '') +'</td>';
									}else//All
									{
										//Buy Rate
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee1.Buy_Rate__c) + (f.fee1.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee1) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee2.Buy_Rate__c) + (f.fee2.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee2) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee3.Buy_Rate__c) + (f.fee3.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee3) + ')' : '') +'</td>';
										//Sell Rate
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee1.Fee_rate__c) + (f.fee1.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee1) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee2.Fee_rate__c) + (f.fee2.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee2) + ')' : '') +'</td>';
										contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee3.Fee_rate__c) + (f.fee3.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee3) + ')' : '') +'</td>';
									}

									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee0.Min__c) + (f.fee0.Min__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f.fee0) + ')' : '') +'</td>';
									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.fee0.TT_Days__c)+'</td>';
									contenedor_pdf += '    <td>'+NEU_Utils.safeString(f.fee0.Valid_From__c)+'</td>';
									contenedor_pdf += '    <td>'+NEU_Utils.safeString(f.fee0.Valid_Until__c)+'</td>';
									contenedor_pdf += '    <td align="left" style="width:70%">'+NEU_Utils.safeString(f.fee0.Comments__c)+'</td>';
									contenedor_pdf += '  </tr>';
									contador_items ++;
									contador_global ++;
								}

								if(contador_global == myList.size())
									closeTable();

							}

						}else
						{
							if(contadorFeec == 0)
								showHeader(false);
							else
								showHeader(true);

							String title_contenedor = '';
							title_contenedor +='<div>';
							title_contenedor +='<div style="display:table-cell;width:100%"><div style="font-weight:bold;font-size:1.5em;padding-top:1em;text-align:left">'+ feec.name +'</div>';
							title_contenedor +='</div>';

							contenedor_pdf += title_contenedor;
							integer contador_items = 0;
							integer contador_global = 0;
							showTable();

							for(Fee__c f :feec.fees)
							{
								if((contador_items>12) || Test.isRunningTest())
								{
									closeTable();
									showHeader(true);
									contenedor_pdf += title_contenedor;
									showTable();
									contador_items =0;
								}

								contenedor_pdf += '  <tr>';
								contenedor_pdf += '    <td align="left" style="width:10%">'+NEU_Utils.safeString(f.Name)+'</td>';
								contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.Route__r.Country_of_Load__r.Name)+'</td>';
								contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.Route__r.Port_Airport_of_Load__r.Name)+'</td>';
								contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.Route__r.Country_of_Discharge__r.Name)+'</td>';
								contenedor_pdf += '    <td align="left">'+NEU_Utils.safeString(f.Route__r.Port_Airport_of_Discharge__r.Name)+'</td>';

								if(rt_ct==1)
								{
									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Buy_Rate__c) + (f.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f) + ')' : '') +'</td>';
								}
								else if(rt_ct == 2)
								{
									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Fee_rate__c) + (f.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f) + ')' : '') +'</td>';
								}else
								{
									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Buy_Rate__c) + (f.Buy_Rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f) + ')' : '') +'</td>';
									contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Fee_rate__c) + (f.Fee_rate__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f) + ')' : '') +'</td>';
								}

								contenedor_pdf += '    <td align="center">'+NEU_Utils.safeString(f.Rate_Type__c)+'</td>';
								if(rt_ty.contains('Per Container'))
									contenedor_pdf += '    <td align="center">'+NEU_Utils.safeString(f.Container_Type__r.Name)+'</td>';

								contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Volumetric_Factor__c)+'</td>';
								contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.Min__c) + (f.Min__c != null ? ' ('+ NEU_CurrencyUtils.getCurrencyIsoCode(f) + ')' : '') +'</td>';
								contenedor_pdf += '    <td align="right">'+NEU_Utils.safeString(f.TT_Days__c)+'</td>';
								contenedor_pdf += '    <td>'+NEU_Utils.safeString(f.Valid_From__c)+'</td>';
								contenedor_pdf += '    <td>'+NEU_Utils.safeString(f.Valid_Until__c)+'</td>';
								contenedor_pdf += '    <td align="left" style="width:70%">'+NEU_Utils.safeString(f.Comments__c)+'</td>';
								contenedor_pdf += '  </tr>';
								contador_items ++;
								contador_global ++;

							}

							if(contador_global == feec.fees.size())
								closeTable();

						}
					}
					contadorFeec++;
				}

			}


			//REMARKS FOR FREIGHTS
			if(customers!=null && customers.size()>0 && String.isNotEmpty(customers[0].Remarks_Freight_Rates__c))
			{
				showHeader(true);

				contenedor_pdf +='<div>';
				contenedor_pdf +='		<div style="display:table-cell;width:100%"><div style="font-weight:bold;font-size:1.5em;padding-top:1em;text-align:left">GENERAL RULES OF USING OUR SERVICES</div>';
				contenedor_pdf +='  </div>';
				contenedor_pdf +='<div class="rulesRates">';
				contenedor_pdf += '<p class="text_service">'+customers[0].Remarks_Freight_Rates__c+'</p>';
				contenedor_pdf +='</div>';

				closeTable();
			}

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//ÚLTIMA PÁGINA
			contenedor_pdf += '</div>';
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			//Dowload previous Document
			if(String.isEmpty(documentName))
				documentName = 'NEU_Freight_Rates_Emails_save_pdf';

			Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+documentName+'.pdf');
	}
}