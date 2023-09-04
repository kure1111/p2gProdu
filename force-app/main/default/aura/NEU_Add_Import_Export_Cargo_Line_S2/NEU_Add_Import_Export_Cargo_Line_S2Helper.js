({
	recalcular_volume: function(component) 
    {
        var length = component.find("lcm").get("v.value");
        var width = component.find("wcm").get("v.value");
        var height = component.find("hcm").get("v.value");
        var weight = component.find("wkg").get("v.value");
        var units = component.find("cargo_line_Units").get("v.value");
        
        var total_volume_linea = (length * width * height) / 1000000;
        console.log(total_volume_linea.toFixed(2));
        component.find("vm").set("v.value", total_volume_linea.toFixed(2)); 
        
        var total_volume = (total_volume_linea*units); 
        console.log(total_volume.toFixed(2));
        component.find("vmt").set("v.value", total_volume.toFixed(2));   
	},
    recalcular_amount: function(component)
    {
        var price = component.find("item_Price").get("v.value");
        if(price == null)
        {
			price = 0;
			component.find("item_Price").set("v.value", price);            
        }
            
        var units = component.find("cargo_line_Units").get("v.value");
        if(units == null)
        {
        	units = 0;
            component.find("cargo_line_Units").set("v.value", units);
        }       
        
        var total_amount = (price*units).toFixed(2);    
        component.find("total_amount").set("v.value", total_amount);
	}
})