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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.avm2.net;
 import primevc.gui.events.SelectEvents;
 import primevc.core.net.FileFilter;
 import primevc.core.net.FileReference;
 import primevc.core.net.IFileReference;


private typedef FlashFileReferenceList = flash.net.FileReferenceList;


/**
 * AVM2 file reference list implementation
 * 
 * @author Ruben Weijers
 * @creation-date Mar 30, 2011
 */
class FileReferenceList extends SelectEvents, implements IFileReference
{
	private var target	: FlashFileReferenceList;
	public var list		(getList, null)	: Array<FileReference>;
	
	
	public function new (target:FlashFileReferenceList = null)
	{
		if (target == null)
			target = new FlashFileReferenceList();
		
		this.target = target;
		super(target);
	}
	
	
	override public function dispose ()
	{
		target = null;
		super.dispose();
	}
	
	
	public inline function browse (?types:Array<FileFilter>)
	{
		return target.browse(types);
	}
	
	
	private function getList () : Array<FileReference>
	{
		if (list != null)
			return list;
		
		list		= new Array();
		var oldList = target.fileList;
		for (i in 0...oldList.length)
			list[i] = new FileReference(oldList[i]);
		
		return list;
	}
}