package sample;


import primevc.gui.display.Window;
import primevc.mvc.core.IView;
import primevc.mvc.core.MVCCore;


/**
 * Defines and groups together and couples 
 * mediators and application windows.
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
        buttonMediator = new ButtonMediator(cast facade.events, cast facade.model, cast facade.view, window.loadButton);
        imageLoaderMediator = new ImageLoaderMediator(cast facade.events, cast facade.model, cast facade.view, window.imageLoader);
        
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