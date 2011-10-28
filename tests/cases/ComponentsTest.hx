package cases;
 import primevc.core.Bindable;
 import primevc.core.collections.ArrayList;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.gui.core.IUIElement;
 import primevc.gui.components.Button;
 import primevc.gui.components.ComboBox;
 import primevc.gui.components.Form;
 import primevc.gui.components.Image;
 import primevc.gui.components.InputField;
 import primevc.gui.components.Label;
 import primevc.gui.components.ProgressBar;
 import primevc.gui.components.Slider;
 import primevc.gui.components.TextArea;
 import primevc.gui.core.UIWindow;
 import primevc.gui.display.Window;
 import primevc.types.Asset;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsTest extends UIWindow
{
	public static function main () { Window.startup( function (s) return new ComponentsTest(s) ); }
	
	
	private var fixedLabel		: Label;
	private var fixedInput		: InputField<String>;
	private var fixedButton		: Button;
	private var fixedTxtArea1	: TextArea<String>;
	private var fixedTxtArea2	: TextArea<String>;
	private var fixedTxtArea3	: TextArea<String>;

	private var dynLabel		: Label;
	private var dynInput		: InputField<String>;
	private var dynButton		: Button;
	private var dynTxtArea		: TextArea<String>;

	private var image			: Image;
	private var slider			: Slider;
	private var slider2			: Slider;
	private var progress		: ProgressBar;
	private var combo			: ComboBox<Bindable<String>>;
	
	
	override private function createChildren ()
	{
		var listData = new ArrayList<Bindable<String>>();
		for (i in 1...6)
			listData.add( createTestVO(i) );
		
		var row = Form.createHorizontalRow( Horizontal.center );
		fixedButton		= new Button("fixedButton", "add some text 1" );
		fixedInput		= new InputField("fixedInput", "fixed-input");
		fixedLabel		= new Label("fixedLabel");
		row.attach( fixedButton.layout ).attach( fixedInput.layout ).attach( fixedLabel.layout );
		attachDisplay( fixedButton ).attachDisplay( fixedInput ).attachDisplay( fixedLabel ).attachLayout( row );

		var row = Form.createHorizontalRow( Horizontal.center );
		fixedTxtArea1	= new TextArea("fixedTextArea1", "fixed size");
		fixedTxtArea2	= new TextArea("fixedTextArea2", "fixed height");
		fixedTxtArea3	= new TextArea("fixedTextArea3", "fixed width");
		row.attach( fixedTxtArea1.layout ).attach( fixedTxtArea2.layout ).attach( fixedTxtArea3.layout );
		attachDisplay( fixedTxtArea1 ).attachDisplay( fixedTxtArea2 ).attachDisplay( fixedTxtArea3 ).attachLayout( row );

	//	attach( image			= new Image("testImage", Asset.fromString("http://www.google.com/images/logos/ps_logo.png")) );
		attach( slider			= new Slider("testSlider", 5, 4, 6) );
		attach( slider2			= new Slider("sliderCopy", 5, 4, 6, Direction.vertical) );

		attach( dynButton		= new Button("dynButton",    "add some text 2" ) );
		attach( dynInput		= new InputField("dynInput", "dyn-input") );
		attach( dynLabel		= new Label("dynLabel") );
		attach( dynTxtArea		= new TextArea("dynTextArea", "dyn-text") );

	//	attach( progress		= new ProgressBar("testProgress", 2000) );
		combo					= new ComboBox("testCombo", null, null, listData.getItemAt(1), listData);
		combo.getLabelForVO		= Std.string;
		combo.attachLayoutTo(layoutContainer).attachDisplayTo(this);
		addTestVO.on( window.userEvents.mouse.doubleClick, this );


		fixedInput 	.updateVO  = updateDynInput;
		dynInput  	.updateVO  = updateFixedInput;
		fixedTxtArea1.updateVO = function () { fixedTxtArea1.vo.value = fixedTxtArea1.data.value;};
		fixedTxtArea2.updateVO = function () { fixedTxtArea2.vo.value = fixedTxtArea2.data.value;};
		fixedTxtArea3.updateVO = function () { fixedTxtArea3.vo.value = fixedTxtArea3.data.value;};
		dynTxtArea.updateVO    = function () { dynTxtArea.vo.value = dynTxtArea.data.value;};
		fixedLabel 	.data.bind( fixedInput.data );
		dynLabel  	.data.bind( fixedInput.data );

	//	slider2.data.pair( slider.data );
		
		changeLabel.on( dynButton  .userEvents.mouse.down, this );
		changeLabel.on( fixedButton.userEvents.mouse.down, this );
		
	//	progress.start();
	//	loadTimer = new haxe.Timer(10);
	//	loadTimer.run = fakeLoadEvent;
	}
	
	
	private function changeLabel ()
	{
		fixedButton.data.value 	+= " test"; 
		dynButton.data.value 	+= " test";
		fixedInput.vo.value 	+= " test";
		dynInput.vo.value 		+= " test";
		combo.list.selected.value.value = dynInput.vo.value;
	}
	
	
	override private function createBehaviours ()
	{
	//	haxe.Log.clear.on( mouse.events.doubleClick, this );
		super.createBehaviours();
	}
	
	
	private var loadTimer : haxe.Timer;
	
	private function fakeLoadEvent ()
	{
		progress.data.value += 1;
		
		if (progress.data.percentage == 1) {
			progress.finish();
			loadTimer.stop();
		} else {
			progress.progress();
		}
	}
	
	
	private function addTestVO ()					{ trace("add "+combo.listData.length); untyped combo.listData.add( createTestVO( combo.listData.length ) ); }
	private inline function createTestVO (l:Int)	{ l *= 2; return new Bindable<String>(primevc.utils.StringUtil.randomString(l) + " " + (l)); }
	private function updateFixedInput () 			{ fixedInput.vo.value = dynInput.vo.value = dynInput.data.value; }
	private function updateDynInput () 				{ fixedInput.vo.value = dynInput.vo.value = fixedInput.data.value; }
}