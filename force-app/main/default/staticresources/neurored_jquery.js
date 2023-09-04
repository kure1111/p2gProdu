(function($) {
    $.fn.getString=(function() {
    	var res='';
    	this.each(function(){
    		if($(this).is('input:checkbox,input:radio'))
    			if(!$(this).prop("checked"))
    				return;
    		var myres=$(this).is('span')?$(this).html():$(this).val();
    		if(myres!=null)
	    		if(res=='')
	    			res=myres;
	    		else
	    			res+=','+myres;
    	});
    	return res;
    });
})(jQuery);
(function($) {
    $.fn.getInt = (function() {
    	var res=0;
    	this.each(function(){
    		if($(this).is('input:checkbox,input:radio'))
    			if(!$(this).prop("checked"))
    				return;
    		var myres=parseInt($(this).is('span')?$(this).html():$(this).val());
    		res+=isNaN(myres)?0:myres;
    	});
    	return res;
    });
})(jQuery);
(function($) {
    $.fn.getFloat = (function() {
    	var res=0.0;
    	this.each(function(){
    		if($(this).is('input:checkbox,input:radio'))
    			if(!$(this).prop("checked"))
    				return;
    		var myres=parseFloat($(this).is('span')?$(this).html():$(this).val());
    		res+=isNaN(myres)?0.0:myres;
    	});
    	return res;
    });
})(jQuery);
(function($) {
    $.fn.fromIdArray = (function(array) {
    	this.each(function(){
    		var element=this;
    		$.each(array,function(i,v){
    			$(element).append($('<option></option>').val(v.Id).html(v.label));
			});
    	});
    });
})(jQuery);
(function($) {
    $.fn.multiline = (function(behind) {
    	this.each(function(){
    		$(this).html($(this).html().replace(new RegExp(behind.replace(/[-\/\\^$*+?.()|[\]{}]/g,'\\$&'),'g'),'$&<br/>'));
			});
    });
})(jQuery);
var regDecimalSep=null;
var charDecimalSep=null;
var charThousandSep=null;
var regThousandSep=null;
function setDecimalSep(a,b)
{
	if(a!='.')
	{
		regDecimalSep=new RegExp(a.replace(/[-\/\\^$*+?.()|[\]{}]/g,'\\$&'),'g');
		charDecimalSep=a;
	}
	else
	{
		regDecimalSep=null;
		charDecimalSep=null;
	}
	if(b)
	{
		charThousandSep=b;
		regThousandSep=new RegExp(b.replace(/[-\/\\^$*+?.()|[\]{}]/g,'\\$&').replace(/&nbsp;| |\u00A0/g,'&nbsp;| |\u00A0'),'g');
	}
}
function parseFloatSep(a)
{
	if(regThousandSep)
		a=a.replace(regThousandSep,'');
	if(regDecimalSep)
	{
		a=a.replace(regDecimalSep,'.');
		if(a.length>1)
			if(a.substr(0,1)=='0')
				if(a.substr(1,1)!='.')
					return NaN;
	}
	return parseFloat(a);
}
function formatFloatSep(a)
{
	if(charDecimalSep)
	{
		if(charThousandSep)
		{
			var parts=a.toString().split(".");
	        parts[0]=parts[0].replace(/\B(?=(\d{3})+(?!\d))/g,charThousandSep);
	        return parts.join(charDecimalSep);
        }
		return a.toString().split(".").join(charDecimalSep);
	}
	if(charThousandSep)
	{
		var parts=a.toString().split(".");
        parts[0]=parts[0].replace(/\B(?=(\d{3})+(?!\d))/g,charThousandSep);
        return parts.join(".");
    }
	return a.toString();
}
(function($) {
    $.fn.getFloatSep = (function() {
    	var res=0.0;
    	this.each(function(){
    		if($(this).is('input:checkbox,input:radio'))
    			if(!$(this).prop("checked"))
    				return;
    		var myres=parseFloatSep($(this).is('span')?$(this).html():$(this).val());
    		res+=isNaN(myres)?0.0:myres;
    	});
    	return res;
    });
})(jQuery);
(function($) {
    $.fn.setFloatSep = (function(a) {
    	a=formatFloatSep(a);
    	this.each(function(){
    		if($(this).is('span'))
    			$(this).html(a);
    		else
    			$(this).val(a);
    	});
    });
})(jQuery);
(function($) {
    $.sfId = (function(sfId) {
	   return '#'+sfId.replace(/(:|\.)/g,'\\$1');
    });
})(jQuery);
(function($) {
    $.sfName = (function(sfName) {
	   return sfName.replace(/(:|\.)/g,'\\$1');
    });
})(jQuery);
var neu_getIdVar=0;
function neu_getId(element)
{
	element=$(element);
	var ret=element.attr('id');
	if(!ret)
	{
		ret='new_id_'+(++neu_getIdVar);
		element.attr('id',ret);
	}
	return ret;	
}
function neu_sf1()
{
	return ((typeof sforce!='undefined')&&(sforce!=null));
}
function neu_navigateTop(url,urlm)
{
	if(neu_sf1())
		if(urlm)
			sforce.one.navigateToURL(urlm);
		else
			sforce.one.navigateToURL(url);
	else
		window.top.location.href=url;
}
