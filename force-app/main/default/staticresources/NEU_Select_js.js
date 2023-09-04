/**
 * jQuery Editable Select
 * by Indri Muska <indrimuska@gmail.com>
 *
 * Source on GitHub @ https://github.com/indrimuska/jquery-editable-select
 *
 * File: jquery.editable-select.js
 */
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
			input.on('blur',function(){NEUselectBlur.call(this);});
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
				if(select.attr('relatedToMaster'))
					input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text()).removeClass('NEUerror');
				else
					input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text()).removeClass('NEUerror');
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
				if(select.attr('relatedToMaster'))
					input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text()).removeClass('NEUerror');
				else
					input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text()).removeClass('NEUerror');
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
    $.fn.NEUselectChanged = (function() {
    	this.each(function(){
    		var input=$(this);
			$(input.attr('NEUlist')).remove();
			input.attr('NEUlist','');
			input.NEUselectResalt();
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
				input.removeClass('NEUerror');
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
					input.removeClass('NEUerror');
				else if(bestValue!=null)
				{
					select.val(bestValue);
					input.removeClass('NEUerror');
					if(select.attr('updateMaster'))
					{
						var detailselect=select.closest('tr').find(select.attr('updateMaster'));
						detailselect.attr('relatedToMaster',select.val());
						detailselect.parent().children('input.es-input').NEUselectChanged();
					}
				}
				else
				{
					select.val('');
					input.addClass('NEUerror');
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
    $.fn.NEUselectResalt = (function() {
    	this.each(function(){
    		var input=$(this);
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
				input.removeClass('NEUerror');
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
					input.removeClass('NEUerror');
				else if(bestValue!=null)
				{
					select.val(bestValue);
					input.removeClass('NEUerror');
					if(select.attr('updateMaster'))
					{
						var detailselect=select.closest('tr').find(select.attr('updateMaster'));
						detailselect.attr('relatedToMaster',select.val());
						detailselect.parent().children('input.es-input').NEUselectChanged();
					}
				}
				else
				{
					select.val('');
					input.addClass('NEUerror');
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
function NEUselectBlur()
{
	var input=$(this);
	if(!input.is('.NEUerror'))
	{
		var select=$(input.attr('NEUselect'));
		if(select.is('select'))
			input.val($('option:selected',select).text());
		else if(select.attr('relatedToMaster'))
			input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo')+' [master=\''+select.attr('relatedToMaster')+'\']')).text());
		else
			input.val($('option[value=\''+select.val()+'\']',$(select.attr('relatedTo'))).text());
	}
}
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
		input.removeClass('NEUerror');
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
			input.removeClass('NEUerror');
		else if(bestValue!=null)
		{
			select.val(bestValue);
			input.removeClass('NEUerror');
			if(select.attr('updateMaster'))
			{
				var detailselect=select.closest('tr').find(select.attr('updateMaster'));
				detailselect.attr('relatedToMaster',select.val());
				detailselect.parent().children('input.es-input').NEUselectChanged();
			}
		}
		else
		{
			select.val('');
			input.addClass('NEUerror');
			if(select.attr('updateMaster'))
			{
				var detailselect=select.closest('tr').find(select.attr('updateMaster'));
				detailselect.attr('relatedToMaster',select.val());
				detailselect.parent().children('input.es-input').NEUselectChanged();
			}
		}
	}
}
(function ($) {
	$.extend($.expr[':'], {
		nic: function (elem, i, match, array) {
			return !((elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0);
		}
	});
	$.fn.editableSelect = function (options) {
		var orig=$(this);
		var defaults = { always: true, filter: true, effect: 'default', duration: 'fast', onCreate: null, onShow: null, onHide: null, onSelect: null };
		var select = this.clone();
		var input = $('<input type="text">');
		var list = $('<ul class="es-list">');
		options = $.extend({}, defaults, options);
		switch (options.effects) {
			case 'default': case 'fade': case 'slide': break;
			default: options.effects = 'default';
		}
		if (isNaN(options.duration) || options.duration != 'fast' || options.duration != 'slow') options.duration = 'fast';
		this.hide();
		this.parent().append(input);
		var EditableSelect = {
			init: function () {
				var es = this;
				es.copyAttributes(select, input);
				input.addClass('es-input');
				input.parent().append(list);
				select.find('option').each(function () {
					var li = $('<li>'), option = $(this);
					li.data('value', option.val());
					li.html(option.text());
					es.copyAttributes(this, li);
					list.append(li);
					if ($(this).attr('selected')) input.val(option.text());
				});
				input.on('focus input click', es.show);
				input.on('blur', es.setDefault);
				$(document).on('click', function (event) {
					if (!$(event.target).is(input) && !$(event.target).is(list)) es.hide();
				});
				es.initializeList();
				es.initializeEvents();
				if (options.onCreate) options.onCreate.call(this, input);
			},
			initializeList: function () {
				var es = this;
				list.find('li').each(function () {
					$(this).on('mousemove', function () {
						list.find('.selected').removeClass('selected');
						$(this).addClass('selected');
					});
					$(this).on('click', function () { es.setField.call(this, es); });
				});
				list.mouseenter(function () {
					list.find('li.selected').removeClass('selected');
				});
			},
			initializeEvents: function () {
				var es = this;
				input.bind('input keydown', function (event) {
					switch (event.keyCode) {
						case 40: // Down
							es.show();
							var visibles = list.find('li:visible'), selected = visibles.filter('li.selected');
							if(selected.size()==0)
								selected=list.find('li:visible:first');
							else
							{
								selected.removeClass('selected');
								var i=visibles.index(selected);
								if(i<visibles.size()-1)
									selected=visibles.eq(i+1);
							}
							selected.addClass('selected');
							es.scroll(selected, true);
							break;
						case 38: // Up
							es.show();
							var visibles = list.find('li:visible'), selected = visibles.filter('li.selected');
							if(selected.size()==0)
								selected=list.find('li:visible:first');
							else
							{
								selected.removeClass('selected');
								var i=visibles.index(selected);
								if(i>0)
									selected=visibles.eq(i-1);
							}
							selected.addClass('selected');
							es.scroll(selected, false);
							break;
						case 13: // Enter
							if (list.is(':visible')) {
								es.setField.call(list.find('li.selected'), es);
								event.preventDefault();
							}
						case 9:  // Tab
						case 27: // Esc
							es.hide();
							break;
						default:
							es.show();
							break;
					}
				});
			},
			show: function () {
				var lis=list.find('li').show();
				list.css({width:input.innerWidth()});
				var num=0;
				if(options.filter)
				{
					var text=input.val().toLowerCase();
					lis.each(function(){if($(this).text().toLowerCase().indexOf(text)<0)$(this).hide();else num++;});
				}
				if(num<1)
					list.hide();
				else
					switch (options.effects) {
						case 'fade':   list.fadeIn(options.duration); break;
						case 'slide':  list.slideDown(options.duration); break;
						default:       list.show(options.duration); break;
					}
				if (options.onShow) options.onShow.call(this, input);
			},
			hide: function () {
				switch (options.effects) {
					case 'fade':   list.fadeOut(options.duration); break;
					case 'slide':  list.slideUp(options.duration); break;
					default:       list.hide(options.duration); break;
				}
				if (options.onHide) options.onHide.call(this, input);
			},
			scroll: function (selected, up) {
				var height = 0, index = list.find('li:visible').index(selected);
				list.find('li:visible').each(function (i, element) { if (i < index) height += $(element).outerHeight(); });
				if (height + selected.outerHeight() >= list.scrollTop() + list.outerHeight() || height <= list.scrollTop()) {
					if (up) list.scrollTop(height + selected.outerHeight() - list.outerHeight());
					else list.scrollTop(height);
				}
			},
			copyAttributes: function (from, to) {
				var attrs = $(from)[0].attributes;
				for (var i in attrs) if(attrs[i].nodeName!='size')$(to).attr(attrs[i].nodeName, attrs[i].nodeValue);
			},
			setDefault: function () {
				if(options.always)
				{
					var selected = list.find('li.selected:visible');
					if(selected.size()==0) selected=list.find('li:visible:first');
					if(selected.size()==0) selected=list.find('li:first');
					input.val($(selected).text());
					orig.val($(selected).data('value'));
					if (options.onSelect) options.onSelect.call(orig);
				}
			},
			setField: function (es) {
				if (!$(this).is('li:visible')) return false;
				input.val($(this).text());
				orig.val($(this).data('value'));
				es.hide();
				if (options.onSelect) options.onSelect.call(orig);
			}
		};
		EditableSelect.init();
		return input;
	}
}) (jQuery);