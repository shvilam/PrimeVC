/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.styling;
 import primevc.core.traits.IInvalidatable;


/**
 * Base class for each property group (fonts, layout, graphics, etc.).
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class StyleSubBlock extends StyleBlockBase
{
	public var owner (default, setOwner)	: StyleBlock;
	
	
	override public function dispose ()
	{
		owner = null;
		super.dispose();
	}
	
	
	private function setOwner (v)
	{
		if (owner != v)
		{
			if (owner != null)
				owner.listeners.remove(this);
			
			owner = v;
			updateOwnerReferences( StyleFlags.EXTENDED_STYLE | StyleFlags.SUPER_STYLE | StyleFlags.NESTING_STYLE | StyleFlags.PARENT_STYLE );
			updateAllFilledPropertiesFlag();
			
			if (owner != null)
				owner.listeners.add(this);
		}
		return v;
	}
	
	
	/**
	 * Method is called when the extended, super, nested or inherited style of
	 * the owner has changed. Each styleproperty-group has to check if the new
	 * reference has any properties that this object doesn't have.
	 * If so, it must send a invalidate request since properties of the object
	 * have changed.
	 */
	private function updateOwnerReferences (changedReference:Int) : Void
	{
		Assert.abstract();
	}
	
	
	private function isPropAnStyleReference ( property:Int )
	{
		return property == StyleFlags.EXTENDED_STYLE || property == StyleFlags.SUPER_STYLE;
	}
	
	
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		if (sender == owner)
		{
			if (isPropAnStyleReference( changeFromOther )) {
				updateOwnerReferences ( changeFromOther );
				updateAllFilledPropertiesFlag();
			}
		}
		else
			super.invalidateCall(changeFromOther, sender);
	}


	private inline function getExtended ()		{ return owner != null ? owner.extendedStyle : null; }
	private inline function getNesting ()		{ return owner != null ? owner.nestingInherited : null; }
	private inline function getSuper ()			{ return owner != null ? owner.superStyle : null; }
	private inline function getParent ()		{ return owner != null ? owner.parentStyle : null; }


#if (debug && !neko)
	override public function toString ()		{ return super.toString() + "; owner: "+owner; }
#end
}