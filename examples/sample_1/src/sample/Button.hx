package sample;

import flash.Lib;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


/**
 * A simple button
 */
class Button extends Sprite
{
    public static inline var BTN_WIDTH:Int = 100;
    public static inline var BTN_HEIGHT:Int = 20;

    public function new(label:String) 
    {
        super();
        
        this.graphics.beginFill(0x0000ff, 1);
        this.graphics.drawRoundRect(0, 0, BTN_WIDTH, BTN_HEIGHT, 3, 3);
        
        var format:TextFormat = new TextFormat();
        format.size = 12;
        format.color = 0xffffff;
        format.font = "_sans";
        
        var tf:TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.defaultTextFormat = format;
        
        tf.text = label;
        this.addChild(tf);
        
        tf.x = (BTN_WIDTH - tf.width) / 2;
        tf.y = (BTN_HEIGHT - tf.height) / 2;
    }
}