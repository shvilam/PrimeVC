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
package primevc.tools.generator;


/**
 * @author Ruben Weijers
 * @creation-date Sep 13, 2010
 */
interface ICodeGenerator
{
	public function createFactory (obj:ICodeFormattable, classRef:String, params:Array<Dynamic>, ?args:Array<String>)	: ValueType;
	public function construct (obj:ICodeFormattable, ?args:Array<Dynamic>, ?alternativeType:Class<Dynamic>)				: ValueType;
	public function constructFromFactory (obj:ICodeFormattable, factoryMethod:String, ?args:Array<Dynamic>)				: ValueType;
	
	public function setProp (obj:ICodeFormattable, name:String, value:Dynamic, ignoreIfEmpty:Bool = false)				: Void;
	public function setAction (obj:ICodeFormattable, name:String, ?args:Array<Dynamic>, onlyWithParams:Bool = false)	: Void;
	
	public function createClassNameConstructor (name:String, ?args:Array<Dynamic>)			: ValueType;
	
	
	private function formatParams (args:Array<Dynamic>)										: Array<ValueType>;
	private function formatValue (value:Dynamic)											: ValueType;
	
	public function hasObject (obj:ICodeFormattable)										: Bool;
	public function getObject (obj:ICodeFormattable)										: ValueType;
	public function hasArray (arr:Array<Dynamic>)											: Bool;
	public function getArray (arr:Array<Dynamic>)											: ValueType;
}