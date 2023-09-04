({
    
    
    recalcular_units: function(component, event, helper) 
    {
    	helper.recalcular_amount(component); 
        helper.recalcular_volume(component);
    },
	recalcular_dimensiones: function(component, event, helper) 
    {
        var equivalence = 0;
        var uom = component.find("uom_dim").get("v.value");
        
        if(uom == "none")
        {
        	return;    
        }
        else if(uom == "mm")
        {
        	equivalence = 0.1;    
        }
        else if(uom == "pul")
        {
            equivalence = 2.54;
        } 
        else if(uom == "m")
        {
            equivalence = 100;
        }
        else
        {
           equivalence = 1; 
        }
        
        var length = component.find("lcmo").get("v.value");
        if(length == null)
        {
            length = 0;
			component.find("lcm").set("v.value", length);            
        }
        else
        {
        	component.find("lcm").set("v.value", length*equivalence);    
        }
        
        var width = component.find("wcmo").get("v.value");
        if(width == null)
        {
           	width = 0;
			component.find("wcm").set("v.value", width);            
        }
        else
        {
            component.find("wcm").set("v.value", width*equivalence);  
        }
        
        var height = component.find("hcmo").get("v.value");
        if(height == null)
        {
            height = 0;
            component.find("hcm").set("v.value", height);
        }
        else
        {
            component.find("hcm").set("v.value", height*equivalence);
        }
        
        helper.recalcular_volume(component);
	},
	recalcular_pesos: function(component, event, helper) 
    {
        var equivalence = 0;
        
        var uom = component.find("uom_wei").get("v.value");
        
        if(uom == "none")
        {
        	return;    
        }
        else if(uom == "lb")
        {
        	equivalence = 0.453592;    
        }
        else if(uom == "tons")
        {
            equivalence = 1000;
        } 
        else
        {
           equivalence = 1; 
        }
        
        var pw = component.find("pw").get("v.value");
        if(pw == null)
        {
            pw = 0;
			component.find("wkg").set("v.value", pw);            
        }
        else
        {
        	component.find("wkg").set("v.value", pw*equivalence);    
        }
        
        var weight = component.find("wkg").get("v.value");
        if(weight == null)
        {
			weight = 0;
			component.find("wkg").set("v.value", weight);            
        }
            
        var units = component.find("cargo_line_Units").get("v.value");
        if(units == null)
        {
        	units = 0;
            component.find("cargo_line_Units").set("v.value", units);
        }       
        
        component.find("tw").set("v.value", (pw*units).toFixed(2));
        component.find("tsw").set("v.value", (weight*units).toFixed(2));
	},     
    recalcular_amount: function(component, event, helper) 
    {
		helper.recalcular_amount(component);      
    }      
})