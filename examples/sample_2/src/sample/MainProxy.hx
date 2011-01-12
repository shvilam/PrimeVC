package sample;


import primevc.mvc.Proxy;
import primevc.core.Bindable;

/**
 * MainProxy corresponds to a proxy in the MVC model. 
 * It retrieves data and passes it to the model. 
 * In this example MainProxy is the only proxy. 
 * It retrieves a single piece of data which is the 
 * URL of the image to be loaded.
 */
 class MainProxy extends Proxy<Bindable<String>, {}>
{
    public function new(events)
    {
        super(events);
		
        // Assign to the Proxy's public variable vo the value of a Bindable of the type String.
        // In this case the URL of the image to be loaded.
        vo = new Bindable<String>("http://www.bentours.com.au/images/product/extra_image/st_basils_cathedral_moscow.jpg");
    }
}