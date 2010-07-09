package primevc.gui.layout;
import primevc.core.Number;
 

/**
 * Description
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class AdvancedLayoutClient extends LayoutClient, implements IAdvancedLayoutClient
{
	public function new (validateOnPropertyChange = false)
	{
		super(validateOnPropertyChange);
		explicitWidth	= Number.NOT_SET;
		explicitHeight	= Number.NOT_SET;
	}
	
	
	override private function resetProperties () : Void
	{
		explicitWidth	= Number.NOT_SET;
		explicitHeight	= Number.NOT_SET;
		measuredWidth	= 0;
		measuredHeight	= 0;
		
		super.resetProperties();
	}
	
	
	
	public var scrollX			: Int;
	public var scrollY			: Int;
	
	
	
	//
	// SIZE PROPERTIES
	//
	
	public var explicitWidth	(default, setExplicitWidth)		: Int;
	public var explicitHeight	(default, setExplicitHeight)	: Int;
	
	public var measuredWidth	(default, setMeasuredWidth) 	: Int;
	public var measuredHeight	(default, setMeasuredHeight)	: Int;
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setExplicitWidth (v:Int) {
		if (explicitWidth != v) {
			trace("setExplicitWidth "+v);
			explicitWidth = v;
			if (v != Number.NOT_SET)
				explicitWidth = width = v;		//setWidth can trigger a size constraint..
		}
		return explicitWidth;
	}
	
	
	private inline function setExplicitHeight (v:Int) {
		if (explicitHeight != v) {
			trace("setExplicitHeight "+v);
			explicitHeight = v;
			if (v != Number.NOT_SET)
				explicitHeight = height = v;	//setHeight can trigger a size constraint
		}
		return explicitHeight;
	}
	
	
	private inline function setMeasuredWidth (v:Int) {
		if (measuredWidth != v) {
			trace("setMeasuredWidth " + measuredWidth +" -> " + v);
			measuredWidth = v;
			if (explicitWidth == Number.NOT_SET)
				measuredWidth = width = v;		//setWidth can trigger a size constraint..
		}
		return measuredWidth;
	}
	
	
	private inline function setMeasuredHeight (v:Int) {
		if (measuredHeight != v) {
			trace("setMeasuredHeight " + measuredHeight +" -> " + v);
			measuredHeight = v;
			if (explicitHeight == Number.NOT_SET)
				measuredHeight = height = v;	//setHeight can trigger a size constraint
		}
		return measuredHeight;
	}
	
	
	override private function setWidth (v:Int) {
		var newV = super.setWidth(v);
		
		//set the explicitWidth property if height is set directly and there's no measuredWidth
		if (measuredWidth != v && explicitWidth != v)
			explicitWidth = newV;
		
		return newV;
	}
	
	
	override private function setHeight (v:Int) {
		var newV = super.setHeight(v);
		
		//set the explicitHeight property if height is set directly and there's no measuredHeight
		if (measuredHeight != v && explicitHeight != v)
			explicitHeight = newV;
		
		return newV;
	}
}