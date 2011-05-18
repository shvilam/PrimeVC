package sample;


import primevc.gui.display.Window;
import primevc.mvc.core.IView;
import primevc.mvc.core.MVCCore;


/**
 * MainView corresponds to the view of the MVC model. 
 * It defines, groups together and couples mediators 
 * and UI elements. This separates event handling from
 * UI and allows different UI elements to have their 
 * own event handlers. 
 */
class MainView extends MVCCore<MainFacade>, implements IView
{
    private var window:MainWindow;
    
    public function new (facade:MainFacade)
    {
        super(facade);
        window = Window.startup( MainWindow );
    }

    // Instantiate mediators and start listening to events.
    public function init ()
    {
		// Instantiate mediators for the user interface elements and pass ui instance names as parameters. 
    }
	
    // Dispose of mediators.
    override public function dispose ()
    {
        window.dispose();
        window = null;
        
        super.dispose();
    }
}