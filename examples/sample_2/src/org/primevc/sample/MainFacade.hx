package org.primevc.sample;


import org.primevc.sample.view.MainView;
import primevc.mvc.Facade;
import primevc.core.traits.IDisposable;
import org.primevc.sample.controller.MainController;
import org.primevc.sample.model.MainModel;
import org.primevc.sample.events.MainEvents;




/**
 * MainFacade is the core class of the application. 
 * It corresponds to the facade of the MVC model. 
 * MainFacade initializes the main parts of the application 
 * (model, view, controller) and provides a main access point for them.
 * Acting as a binding component it allows to separate the model from
 * the view, thus separating data from UI elements respectively. 
 */
class MainFacade extends Facade<MainEvents, MainModel, IDisposable, MainController, MainView>
{
	// Initialize the application and create and instance of MainFacade.
    public static function main ()	{ new MainFacade(); }
    private function new ()			{ super(); }
	
	// Initialize the core singletons model, view, controller and events.
    override private function setupModel ()			{ model			= new MainModel(); } 
    override private function setupEvents ()		{ events		= new MainEvents(); } 
    override private function setupView ()			{ view			= new MainView(this); }
    override private function setupController ()	{ controller	= new MainController(this); }
}