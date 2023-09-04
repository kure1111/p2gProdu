(function($) {
    $.fn.NEUselect = (function(options) {
    	$(document).on('click',function(event){
    		var obj=$(event.target);
    		if(obj.is('input.es-input'))
    			$('ul.es-list').not(obj.attr('NEUlist')).hide();
    		else if(!obj.is('ul.es-list'))
    			$('ul.es-list').hide();
    		});
    	this.each(function(){
    		var select=$(this);
    		$('option:contains(\'--None--\')',select).text('');
    		var input = $('<input type="text" class="es-input">');
    		if(select.attr('onpaste'))
    			input.attr('onpaste',select.attr('onpaste'));
    		if(select.attr('copystyle'))
    			input.attr('style',select.attr('copystyle'));
    		if(select.attr('copyclass'))
    			input.addClass(select.attr('copyclass'));
			input.attr('NEUselect','#'+neu_getId(select).replace(/(:|\.)/g,'\\$1'));
			input.on('focus click',function(){NEUselectFocus.call(this);});
			input.on('input keydown',function(event){
					switch(event.keyCode) {
						case 40: // Down
							NEUselectFocus.call(this);
							var list=$(input.attr('NEUlist'));
							var lis=$('li.NEUselected',list).removeClass('NEUselected').nextAll('li:visible').first().addClass('NEUselected');
							if(lis.size()==0)
								lis=list.children('li:visible').first().addClass('NEUselected');
							if(lis.size()>0)
							{
								lis=$(lis[0]);
								var height = 0,index=list.find('li:visible').index(lis);
								list.find('li:visible').each(function(i, element){
									if(i<index)
										height+=$(element).outerHeight();
									});
								if((height+lis.outerHeight()>=list.scrollTop()+list.outerHeight())||(height<=list.scrollTop()))
									list.scrollTop(height+lis.outerHeight()-list.outerHeight());
							}
							return false;
						case 38: // Up
							NEUselectFocus.call(this);
							var list=$(input.attr('NEUlist'));
							var lis=$('li.NEUselected',list).removeClass('NEUselected').prevAll('li:visible').first().addClass('NEUselected');
							if(lis.size()==0)
								lis=list.children('li:visible').last().addClass('NEUselected');
							if(lis.size()>0)
							{
								lis=$(lis[0]);
								var height = 0,index=list.find('li:visible').index(lis);
								list.find('li:visible').each(function(i, element){
									if(i<index)
										height+=$(element).outerHeight();
									});
								if((height+lis.outerHeight()>=list.scrollTop()+list.outerHeight())||(height<=list.scrollTop()))
									list.scrollTop(height);
							}
							return false;
						case 9:  // Tab
						case 13: // Enter
							$('li.NEUselected',$(input.attr('NEUlist'))).click();
						case 27: // Esc
							$('li.NEUselected',$(input.attr('NEUlist'))).removeClass('NEUselected')
							$(input.attr('NEUlist')).hide();
							break;
						default:
							NEUselectFocus.call(this);
							break;
					}
				});
			if(select.is('select'))
				input.val($('option:selected',select).text()).removeClass('NEUerror');
			else if(select.attr('relatedTo'))
			{
				var option;
				if(select.attr('relatedToMaster'))
					option=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']'));
				else
					option=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')));
				if(option.size()>0)
					input.val(option.text()).removeClass('NEUerror NEUvalid');
				else if(select.attr('newvalue'))
					input.val(select.val()).addClass('NEUvalid');
				else
					input.val(select.val()).addClass('NEUerror');
			}
			else
				input.val(select.val()).removeClass('NEUerror');
    		select.hide();
    		select.parent().append(input);
    	});
    });
})(jQuery);
(function($) {
    $.fn.NEUselectSetValue = (function(value) {
    	this.each(function(){
    		var input=$(this);
			var select=$(input.attr('NEUselect'));
			select.val(value);
			if(select.is('select'))
				input.val($('option:selected',select).text()).removeClass('NEUerror');
			else if(select.attr('relatedTo'))
			{
				var option;
				if(select.attr('relatedToMaster'))
					option=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']'));
				else
					option=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')));
				if(option.size()>0)
					input.val(option.text()).removeClass('NEUerror NEUvalid');
				else if(select.attr('newvalue'))
					input.val(select.val()).addClass('NEUvalid');
				else
					input.val(select.val()).addClass('NEUerror');
			}
			else
				input.val(select.val()).removeClass('NEUerror');
			if(select.attr('updateMaster'))
			{
				var detailselect=select.closest('tr').find(select.attr('updateMaster'));
				detailselect.attr('relatedToMaster',select.val());
				detailselect.parent().children('input.es-input').NEUselectChanged();
			}
    	});
    });
})(jQuery);
(function($) {
    $.fn.NEUselectSetText = (function(newtext) {
    	this.each(function(){
    		var input=$(this);
    		input.val(newtext);
    		var select=$(input.attr('NEUselect'));
			var text=input.val().toLowerCase();
			var selectText;
			if(select.is('select'))
				selectText=$('option:selected',select).text().toLowerCase();
			else if(select.attr('relatedTo'))
			{
				if(select.attr('relatedToMaster'))
					selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text().toLowerCase();
				else
					selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text().toLowerCase();
			}
			else
				selectText=select.val().toLowerCase();
			if(text==selectText)
			{
				input.removeClass('NEUerror NEUvalid');
				if(!selectText)
					select.val('');
			}
			else
			{
				var value=select.val();
				var exactLine=false;
				var bestValue=null;
				var options;
				if(select.is('select'))
					options=$('option',select);
				else if(select.attr('relatedToMaster'))
					options=$('option',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']'));
				else
					options=$('option',$(select.attr('relatedTo')));
				options.each(function (){
					if(text==$(this).text().toLowerCase())
					{
						var myvalue=$(this).val();
						if(value==myvalue)
						{
							exactLine=true;
							return false;
						}
						else if(bestValue==null)
							bestValue=myvalue;
					}
				});
				if(exactLine)
					input.removeClass('NEUerror NEUvalid');
				else if(bestValue!=null)
				{
					select.val(bestValue);
					input.removeClass('NEUerror NEUvalid');
					if(select.attr('updateMaster'))
					{
						var detailselect=select.closest('tr').find(select.attr('updateMaster'));
						detailselect.attr('relatedToMaster',select.val());
						detailselect.parent().children('input.es-input').NEUselectChanged();
					}
				}
				else
				{
					if(select.attr('newvalue'))
					{
						select.val(input.val());
						input.addClass('NEUvalid');
					}
					else
					{
						select.val('');
						input.addClass('NEUerror');
					}
					if(select.attr('updateMaster'))
					{
						var detailselect=select.closest('tr').find(select.attr('updateMaster'));
						detailselect.attr('relatedToMaster',select.val());
						detailselect.parent().children('input.es-input').NEUselectChanged();
					}
				}
			}
    	});
    });
})(jQuery);
(function($) {
    $.fn.NEUselectChanged = (function() {
    	this.each(function(){
    		var input=$(this);
			$(input.attr('NEUlist')).remove();
			input.attr('NEUlist','');
    		var select=$(input.attr('NEUselect'));
			var selectText;
			if(select.is('select'))
				selectText=$('option:selected',select).text().toLowerCase();
			else if(select.attr('relatedTo'))
			{
				if(select.attr('relatedToMaster'))
					selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text().toLowerCase();
				else
					selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text().toLowerCase();
			}
			else
				selectText=select.val().toLowerCase();
			if(input.val().toLowerCase()==selectText)
				input.removeClass('NEUerror NEUvalid');
			else if(select.attr('newvalue'))
				input.addClass('NEUvalid');
			else
				input.addClass('NEUerror');
    	});
    });
})(jQuery);
function NEUselectFocus()
{
	var input=$(this);
	var select=$(input.attr('NEUselect'));
	var list=$(input.attr('NEUlist'));
	if(list.size()==0)
	{
		list=$('<ul class="es-list">');
		input.attr('NEUlist','#'+neu_getId(list));
		input.parent().append(list);
		var options;
		if(select.is('select'))
			options=$('option',select);
		else if(select.attr('relatedToMaster'))
			options=$('option',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']'));
		else
			options=$('option',$(select.attr('relatedTo')));
		options.each(function (){
			var li = $('<li>');
			var option = $(this);
			var value=option.val();
			li.html(option.text());
			list.append(li);
			li.on('click',function(){input.NEUselectSetValue(value);list.hide();});
		});
	}
	list.css('width',input.innerWidth());
	var text=input.val().toLowerCase();
	$('li',list).each(function(){
		if($(this).text().toLowerCase().indexOf(text)>=0)
			$(this).show();
		else
			$(this).hide().removeClass('NEUselected');
	});
	list.show();
	var selectText;
	if(select.is('select'))
		selectText=$('option:selected',select).text().toLowerCase();
	else if(select.attr('relatedTo'))
	{
		if(select.attr('relatedToMaster'))
			selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text().toLowerCase();
		else
			selectText=$('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text().toLowerCase();
	}
	else
		selectText=select.val().toLowerCase();
	if(text==selectText)
	{
		input.removeClass('NEUerror NEUvalid');
		if(!selectText)
			select.val('');
	}
	else
	{
		var value=select.val();
		var exactLine=false;
		var bestValue=null;
		var options;
		if(select.is('select'))
			options=$('option',select);
		else if(select.attr('relatedToMaster'))
			options=$('option',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']'));
		else
			options=$('option',$(select.attr('relatedTo')));
		options.each(function (){
			if(text==$(this).text().toLowerCase())
			{
				var myvalue=$(this).val();
				if(value==myvalue)
				{
					exactLine=true;
					return false;
				}
				else if(bestValue==null)
					bestValue=myvalue;
			}
		});
		if(exactLine)
			input.removeClass('NEUerror NEUvalid');
		else if(bestValue!=null)
		{
			select.val(bestValue);
			input.removeClass('NEUerror NEUvalid');
			if(select.attr('updateMaster'))
			{
				var detailselect=select.closest('tr').find(select.attr('updateMaster'));
				detailselect.attr('relatedToMaster',select.val());
				detailselect.parent().children('input.es-input').NEUselectChanged();
			}
		}
		else
		{
			if(select.attr('newvalue'))
			{
				select.val(input.val());
				input.addClass('NEUvalid');
			}
			else
			{
				select.val('');
				input.addClass('NEUerror');
			}
			if(select.attr('updateMaster'))
			{
				var detailselect=select.closest('tr').find(select.attr('updateMaster'));
				detailselect.attr('relatedToMaster',select.val());
				detailselect.parent().children('input.es-input').NEUselectChanged();
			}
		}
	}
}
