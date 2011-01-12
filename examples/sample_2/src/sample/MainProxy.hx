package sample;


import primevc.mvc.Proxy;
import primevc.core.Bindable;

/**
 * Provides access to data and handles data logic.
 */
class MainProxy extends Proxy<Bindable<String>, {}>
{
    public function new(events)
    {
        super(events);
        
    //  vo = new Bindable<String>("http://www.bentours.com.au/images/product/extra_image/st_basils_cathedral_moscow.jpg");		//there's no crossdomain.xml file for this image...
        vo = new Bindable<String>("http://farm1.static.flickr.com/159/345009210_1f826cd5a1_b.jpg");
    }
}