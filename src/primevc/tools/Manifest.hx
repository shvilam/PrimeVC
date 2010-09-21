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
package primevc.tools;
 import haxe.xml.Fast;
 import primevc.core.IDisposable;
  using Xml;


/**
 * Manifest contains a map of Class strings, their complete package names and
 * their parent classes.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 21, 2010
 */
class Manifest implements IDisposable
{
	/**
	 * Hash containing references from single class names to their full names 
	 * including the package.
	 * I.e. [ "Label" => "primevc.gui.components.Label" ]
	 */
	private var classPackageMap		: Hash < String >;
	
	/**
	 * Hash containing references from classes to their parent classes.
	 * I.e. [ "primevc.gui.components.Label" => "primevc.gui.core.UIDataComponent" ]
	 */
	private var classParentMap		: Hash < String >;
	
	
	public function new (file:String)
	{
		classPackageMap	= new Hash<String>();
		classParentMap	= new Hash<String>();
		addFile( file );
	}
	
	
	public function dispose ()
	{
		classPackageMap	= null;
		classParentMap	= null;
	}
	
	
	public function addFile (file:String) : Void
	{
#if neko
		var content	= new Fast( neko.io.File.getContent( file ).parse().firstElement() );
		
		for (item in content.nodes.component)
		{
			try {
				classPackageMap.set( item.att.id, item.att.fullname );
				classParentMap.set( item.att.fullname, item.att.parent );
			}
			catch (e:Dynamic)
				trace("node " + item + " not matched. "+e);
		}
#end
	}
	
	
	public function getFullName (className:String) : String
	{
		if (classPackageMap.exists(className))
			return classPackageMap.get( className );
		else
			return className;
	}


	public function getParentName (fullClassName:String) : String
	{
		if (classParentMap.exists( fullClassName ))
			return classParentMap.get( fullClassName );
		else
			return null;
	}
}