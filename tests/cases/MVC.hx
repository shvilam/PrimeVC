package cases;

import primevc.core.dispatcher.ISender1;
import primevc.core.dispatcher.INotifier;
import primevc.core.dispatcher.Signal1;
import primevc.core.dispatcher.Signals;

import primevc.mvc.Facade;
import primevc.mvc.Model;
import primevc.mvc.Mediator;
import primevc.mvc.View;
import primevc.mvc.Proxy;
import primevc.mvc.EditProxy;

import primevc.mvc.traits.IValueObject;
import primevc.mvc.traits.IEditableValueObject;
import primevc.mvc.traits.IEditEnabledValueObject;

interface IUserVO implements IValueObject
{
	var name (default,null) : String;
}

interface IUserEVO implements IEditEnabledValueObject
{
	public var name (default,default) : String;
}

class UserVO implements IUserVO, implements IUserEVO, implements IEditableValueObject<IUserEVO>
{ // normaal gesproken gegenereerd.
	public var name (default,default) : String;
	
	public function asEditable() : IUserEVO {return this;}
	public function commitEdit() : Void;
	public function cancelEdit() : Void;
}



typedef UserProxyEvents = {
	var loggedIn (default,null) : ISender1<UserVO>;
}

class UserSignals extends Signals
{
	var loggedIn : Signal1<UserVO>;
}

class UserProxy extends EditProxy<IUserVO, UserVO, IUserEVO, UserProxyEvents>
{
	
	public function login(name:String, pass:String) {
		events.loggedIn.send( null );
	}
}

typedef UserMediatorEvents = {//>Signals,  stupid whining haxe-compiler
	var user (default,null) : {//>Signals,
		var loggedIn (default,null) : INotifier<UserVO->Void>;
	};
}

typedef UserMediatorModel = {//>Model,
	var userProxy (default,null) : UserProxy;
}

class UserMediator extends Mediator<UserMediatorEvents, UserMediatorModel>
{
	
}

class EditorView extends View
{
	var user : UserMediator;
	
/*	override*/ function setupMediators(facade:EditorFacade)
	{
		user = new UserMediator(facade);
	}
}

class EditorFacade extends Facade<EditorEvents, EditorModel, EditorView> {
	override function setupModel()	model = new EditorModel(this)
	override function setupView()	view  = new EditorView(null)
	
}

class EditorEvents extends Signals
{
	var user : UserSignals;
}

class EditorModel extends Model
{
	var userProxy (default, null) : UserProxy;
	
	public function new(facade:EditorFacade)
	{
		userProxy = new UserProxy(facade.events.user);
	}
}

class MVC
{
	static function main() trace("MVC framework compiled with no errors. yay.")
}