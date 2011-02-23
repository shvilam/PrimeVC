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
 import primevc.core.traits.IDisposable;
 import primevc.types.SimpleDictionary;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
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
	public var classPackageMap		(default, null) : SimpleDictionary < String, String >;
	
	/**
	 * Hash containing references from classes to their super classes.
	 * I.e. [ "primevc.gui.components.Label" => "primevc.gui.core.UIDataComponent" ]
	 */
	public var superClassMap		(default, null) : SimpleDictionary < String, String >;
	
	/**
	 * Dictionary with lists for each class and it's sub classes
	 */
	public var subClassMap			(default, null)	: SimpleDictionary < String, FastArray < String > >;
	
	
	public function new (file:String = null)
	{
		classPackageMap	= new SimpleDictionary < String, String>();
		superClassMap	= new SimpleDictionary < String, String>();
		subClassMap		= new SimpleDictionary < String, FastArray < String > >();
		
		if (file != null)
			addFile( file );
	}
	
	
	public function dispose ()
	{
		classPackageMap.dispose();
		superClassMap.dispose();
		subClassMap.dispose();
		classPackageMap	= null;
		superClassMap	= null;
		subClassMap		= null;
	}
	
	
	public function addFile (file:String) : Void
	{
#if neko
		var content	= new Fast( neko.io.File.getContent( file ).parse().firstElement() );
		
		for (item in content.nodes.component)
		{
			try {
				classPackageMap.set( item.att.id, item.att.fullname );
				superClassMap.set( item.att.fullname, item.att.superClass );
				
				//create list for new class
				if (!subClassMap.exists( item.att.fullname ))
					subClassMap.set( item.att.fullname, FastArrayUtil.create() );
			}
			catch (e:Dynamic)
				trace("node " + item + " not matched. "+e);
		}
		
		
		//create subClassMap
		var classNames = superClassMap.keys();
		for (className in classNames)
		{
			var superClassName = getFullSuperClassName( className );
			while (superClassName != null && superClassName != "")
			{
				var list = subClassMap.get( superClassName );
				if (list == null)
					list = subClassMap.set( superClassName, FastArrayUtil.create() );
				
				if (list.indexOf(className) == -1)
					list.push( className );
				
				superClassName = getFullSuperClassName( superClassName );
			}
		}
#end
	}
	
	
	public function getFullName (className:String) : String
	{
		if (className == null)
			return null;
		if (classPackageMap.exists(className))
			return classPackageMap.get( className );
		
		return className;
	}


	public function getSuperClassName (fullClassName:String) : String
	{
		if (superClassMap.exists( fullClassName ))
			return superClassMap.get( fullClassName );
		
		return null;
	}
	
	
	
	/**
	 * Method will check if there are any classes defined who extend the given
	 * classname.
	 */
	public function hasSubClasses (fullClassName:String) : Bool
	{
		return subClassMap.get( fullClassName ) != null && subClassMap.get( fullClassName ).length > 0;  //superClassMap.hasValue( fullClassName );
	}
	
	
	public inline function getFullSuperClassName (className:String) : String
	{
		return getFullName( getSuperClassName( className ) );
	}
}