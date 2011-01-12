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
    public var buttonMediator(default, null):ButtonMediator;
    public var imageLoaderMediator(default, null):ImageLoaderMediator;

    public function new (facade:MainFacade)
    {
        super(facade);
        window = Window.startup( MainWindow );
    }

    // Instantiate mediators and start listening to events.
    public function init ()
    {
		// Instantiate mediators for the user interface elements and pass ui instance names as parameters. 
        buttonMediator = new ButtonMediator(cast facade.events, cast facade.model, cast facade.view, window.button);
        imageLoaderMediator = new ImageLoaderMediator(cast facade.events, cast facade.model, cast facade.view, window.image);
        
        buttonMediator.startListening();
        imageLoaderMediator.startListening();
    }
	
    // Dispose of mediators.
    override public function dispose ()
    {
        buttonMediator.dispose();
        imageLoaderMediator.dispose();
        
        window.dispose();
        
        buttonMediator = null;
        imageLoaderMediator = null;
        window = null;
        
        super.dispose();
    }
}