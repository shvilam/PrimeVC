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
package primevc.gui.styling.declarations;
 import primevc.core.IDisposable;


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
interface IStyleDeclaration <DeclarationType> implements IDisposable
{
	
	/**
	 * Reference to style of which this style is inheriting when the requested
	 * property is not in this declaration.
	 * 
	 * The 'nestingInherited' property is a reference to the style of the 
	 * container in which the IStylable object is placed
	 * 
	 * @example
	 * class SomeStyle implements IStyleDeclaration {
	 * 		public var font (getFont, default)	: String;
	 * 
	 * 		...
	 * 
	 * 		private function getFont () {
	 * 			if 		(font != null)					return font;
	 * 			else if (nestingInherited != null)		return nestingInherited.font;
	 * 			else 									return null;
	 * 		}
	 * }
	 * 
	 * 
	 * var styleA = new SomeStyle( "Arial" );
	 * var styleB = new SomeStyle();
	 * 
	 * trace(a.font);		//output: "Arial"
	 * trace(b.font);		//output: ""
	 * 
	 * var objA = new Component( styleA );
	 * var objB = new Component( styleB );
	 * objA.children.add( objB );
	 * 
	 * trace(a.font);		//output: "Arial"
	 * trace(b.font);		//output: "Arial"
	 * 
	 */
	public var nestingInherited		(default, null)		: DeclarationType;
	
	
	/**
	 * Reference to other style-object of whom this style is inheriting when
	 * the requested property is not in this declaration.
	 * 
	 * The 'superInherited' property is used to get style-information of a 
	 * super-class of the described class.
	 * 
	 * @example
	 * var styleA = new StyleDeclaration( package.A, new SomeStyle( new SolidFill( 0xfff000 ) ) );
	 * var styleB = new StyleDeclaration( package.B, new SomeStyle() );
	 * 
	 * class A extends StyleInjector {}
	 * class B extends A {}
	 * 
	 * var objA = new A();
	 * var objB = new B();
	 * 
	 * trace( objA.style.fill );	//output:	SolidFill( 0xfff000 );
	 * trace( objB.style.fill );	//output:	SolidFill( 0xfff000 );
	 */
	public var superInherited		(default, null)		: DeclarationType;
}