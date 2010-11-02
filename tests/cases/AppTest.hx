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
package cases;
 import primevc.core.collections.ArrayList;
 import primevc.core.Application;
 import primevc.core.Bindable;
 import primevc.gui.components.ApplicationView;
 import primevc.gui.components.Button;
 import primevc.gui.components.Label;
 import primevc.gui.components.ListView;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.core.UIWindow;



/**
 * @author Ruben Weijers
 * @creation-date Aug 30, 2010
 */
class AppTest extends UIWindow
{
	public static function main () { Application.startup( AppTest ); }
	
	override private function createChildren ()
	{
		children.add( new EditorView("editorView") );
	}
}


class EditorView extends ApplicationView
{
	private var applicationBar	: ApplicationMainBar;
	private var framesToolBar	: FramesToolBar;
	
	
	override private function createChildren ()
	{
		children.add( applicationBar	= new ApplicationMainBar("applicationMainBar") );
		children.add( framesToolBar		= new FramesToolBar("framesList") );
	}
}



class ApplicationMainBar extends UIContainer {}



class FramesToolBar extends ListView < FrameTypesSectionVO >
{
	public function new (id:String = null)
	{
		var frames = new ArrayList<FrameTypeVO>();
		frames.add( new FrameTypeVO( "externalLinkFrame", "Externe Link", null ) );
		frames.add( new FrameTypeVO( "internalLinkFrame", "Interne Link", null ) );
		frames.add( new FrameTypeVO( "webshopFrame", "Webshop Kader", null ) );
		
		var media = new ArrayList<FrameTypeVO>();
		media.add( new FrameTypeVO( "pictureFrame", "Afbeeldingen", null ) );
		media.add( new FrameTypeVO( "videoFrame", "Video", null ) );
		media.add( new FrameTypeVO( "flashFrame", "Flash", null ) );
		
		var elements = new ArrayList<FrameTypeVO>();
		elements.add( new FrameTypeVO( "shapeFrame", "Vormen", null ) );
		elements.add( new FrameTypeVO( "textFrame", "Tekst", null ) );
		
		var list = new FrameTypesList();
		list.add( new FrameTypesSectionVO( "linkFrames", "kaders", frames ) );
		list.add( new FrameTypesSectionVO( "mediaFrames", "media", media ) );
		list.add( new FrameTypesSectionVO( "elementFrames", "elementen", elements ) );
		super(id, list);
	}
	
	
	override private function createItemRenderer (dataItem:FrameTypesSectionVO, pos:Int)
	{
		return cast new FrameTypesBar( dataItem.name+"Bar", dataItem );
	}
}



class FrameTypesBar extends UIDataContainer < FrameTypesSectionVO >
{
	private var titleField	: Label;
	private var framesList	: FrameTypesBarList;
	
	
	override private function createChildren ()
	{
		titleField	= new Label(id+"TitleField");
		framesList	= new FrameTypesBarList(id+"List");
		
		titleField.styleClasses.add("title");
		
		layoutContainer.children.add( titleField.layout );
		layoutContainer.children.add( framesList.layout );
		children.add( framesList );
		children.add( titleField );
	}
	
	
	override private function initData ()
	{
		titleField.data.bind( value.label );
		framesList.value = cast value.frames;
	}
}



class FrameTypesBarList extends ListView < FrameTypeVO >
{
	override private function createItemRenderer (dataItem:FrameTypeVO, pos:Int)
	{
		var button = new FrameButton( dataItem );
		if		(pos == 0)					button.styleClasses.add("first");
		else if (pos == (value.length - 1))	button.styleClasses.add("last");
		return cast button;
	}
}



class FrameButton extends Button
{
	public var vo : FrameTypeVO;
	
	
	public function new (vo:FrameTypeVO)
	{
		super(vo.name+"Button");
		data.bind( vo.label );
		this.vo = vo;
	}
	
	
	override public function dispose ()
	{
		vo = null;
		super.dispose();
	}
}





/**
 * Data classes
 */

typedef FrameTypesList		= ArrayList < FrameTypesSectionVO >;


class FrameTypesSectionVO
{	
	public var name		: String;
	public var frames	: ArrayList < FrameTypeVO >;
	public var label	: Bindable < String >;
	
	
	public function new (name:String, label:String, frames:ArrayList < FrameTypeVO > )
	{
		this.name	= name;
		this.label	= new Bindable<String>(label);
		this.frames	= frames;
	}
}


class FrameTypeVO
{
	/**
	 * Property is used as ID for the itemViewer
	 */
	public var name			: String;
	public var label		: Bindable < String >;
	public var frameClass	: Class < Dynamic >;
	
	
	public function new (name:String, label:String, frameClass:Class < Dynamic >)
	{
		this.name		= name;
		this.label		= new Bindable<String>(label);
		this.frameClass	= frameClass;
	}
}

