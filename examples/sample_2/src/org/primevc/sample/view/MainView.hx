package org.primevc.sample.view;
 import primevc.gui.display.Window;
 import primevc.mvc.MVCActor;
 import primevc.mvc.IMVCCoreActor;


/**
 * Defines and groups together and couples 
 * mediators and application windows.
 */
class MainView extends MVCActor<MainFacade>, implements IMVCCoreActor
{
    private var window:MainWindow;
    public var buttonMediator(default, null):ButtonMediator;
    public var imageLoaderMediator(default, null):ImageLoaderMediator;

    public function new (facade:MainFacade)
    {
        super(facade);
        window				= Window.startup( function(stage) return new MainWindow(stage) );
		buttonMediator		= new ButtonMediator(facade, true, window.button);
        imageLoaderMediator = new ImageLoaderMediator(facade, true, window.image);
    }
	
	
    override public function dispose ()
    {
		if (isDisposed())
			return;
		
        buttonMediator.dispose();
        imageLoaderMediator.dispose();
        window.dispose();
        
        buttonMediator = null;
        imageLoaderMediator = null;
        window = null;
        
        super.dispose();
    }
	
	
    override public function startListening ()
    {
        if (isListening())
			return;
        
        buttonMediator.startListening();
        imageLoaderMediator.startListening();
		super.startListening();
    }
	
	
	override public function stopListening ()
    {
        if (!isListening())
			return;
        
		super.stopListening();
        buttonMediator.stopListening();
        imageLoaderMediator.stopListening();
    }
}