package sample;
 import primevc.gui.display.Window;
 import primevc.mvc.MVCActor;


/**
 * Defines and groups together and couples 
 * mediators and application windows.
 */
class MainView extends MVCActor<MainFacade>
{
    private var window:MainWindow;
    public var buttonMediator(default, null):ButtonMediator;
    public var imageLoaderMediator(default, null):ImageLoaderMediator;

    public function new (facade:MainFacade)
    {
        super(facade);
        window				= Window.startup( MainWindow );
		buttonMediator		= new ButtonMediator(facade, window.loadButton);
        imageLoaderMediator = new ImageLoaderMediator(facade, window.imageLoader);
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