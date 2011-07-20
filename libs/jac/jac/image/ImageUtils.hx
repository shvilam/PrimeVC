////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Jacob Wright
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
package jac.image;
#if flash9
 import flash.display.BitmapData;
 import flash.display.DisplayObject;
 import flash.display.IBitmapDrawable;
 import flash.geom.Matrix;
 import primevc.core.geom.Point;
 import primevc.core.geom.Rectangle;
 import primevc.types.Number;
  using jac.image.ImageUtils;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = ResizeStyle;

/**
 * Image utilities that help to resize images, take snapshots of display
 * objects, and other various helpers which are useful when working with
 * images.
 *
 * @author Jac Write
 * @since Aug 23, 2009
 * @haxe-port-author Ruben Weijers
 * @haxe-port-since Jul 5, 2011
 */
class ImageUtils
{
    private static inline var IDEAL_RESIZE_PERCENT  = .5;
    private static inline var MAX_PIXELS            = 16777215;
    private static inline var MAX_WIDTH             = 8191;
    private static inline var MAX_HEIGHT            = 8191;


    public static function hasValidBitmapSize (source:DisplayObject) : Bool
    {
        return source.width <= MAX_WIDTH && source.height <= MAX_HEIGHT && (source.width * source.height) <= MAX_PIXELS;
    }



    /**
     * Takes a snapshot of a display object or bitmap data object. The
     * snapshot may be a subsection of the whole as defined by
     * <code>area</code> and may be resized.
     *
     * @param The display object or bitmap data object to take a snapshot of.
     * @param The area which will be snapshotted. If null the entire object
     * will be used as the area.
     * @param The size of the snapshot to be returned. If null then the
     * original size will be used.
     * @param Whether the snapshot should keep proportions when resizing or
     * resize to fit the size exactly.
     */
    public static function takeSnapshot(source:IBitmapDrawable, bmp:BitmapData, requiredW:Int = Number.INT_NOT_SET, requiredH:Int = Number.INT_NOT_SET, resizeStyle:Int = Flags.CONSTRAIN, area:Rectangle = null):BitmapData
    {
        var bitmapData:BitmapData = bmp;

        var realW:Int   = (area != null ? area.width  : source.as(DisplayObject).width) .ceilFloat();
        var realH:Int   = (area != null ? area.height : source.as(DisplayObject).height).ceilFloat();
        var isSet       = bitmapData != null;
        var validSize   = isSet && bitmapData.width == realW && bitmapData.height == realH;
        
#if debug
        Assert.that( (realW * realH) <= MAX_PIXELS, "Maximum number of pixels exeeded: " + (realW * realH)+" instead of the max of "+MAX_PIXELS );
        Assert.that( realW <= MAX_WIDTH,  "Maximum bitmapdata width  exeeded: "+realW+" instead of "+MAX_WIDTH );
        Assert.that( realH <= MAX_HEIGHT, "Maximum bitmapdata height exeeded: "+realH+" instead of "+MAX_HEIGHT );

        var start = haxe.Timer.stamp();
#end

        if (isSet && !validSize)    bitmapData.dispose();
        if (!isSet || !validSize)   bitmapData = new BitmapData(realW, realH, true, 0x00);

        try {
            if (area != null)  bitmapData.draw(source, new Matrix(1, 0, 0, 1, -area.x, -area.y));
            else               bitmapData.draw(source);
        } catch(e:Dynamic) {
            trace("error with drawing "+source+"; error: "+e);
            bitmapData.floodFill(0,0,0xffffffff);
        }
        
        if ((requiredW.isSet() && requiredW != realW) || (requiredH.isSet() && requiredH != realH))
        {
            var temp = bitmapData;
            bitmapData = temp.resize(requiredW, requiredH, resizeStyle);
            if (temp != source)
                temp.dispose();
        }

#if debug
        trace("duration: "+(haxe.Timer.stamp() - start));
#end
        return bitmapData;
    }




    /**
     * Return a new bitmap data object resized to the provided size.
     *
     * @param The source bitmap data object to resize.
     * @param The size the bitmap data object needs to be or needs to fit
     * within.
     * @param Whether to keep the proportions of the image or allow it to
     * squish into the size.
     *
     * @return A resized bitmap data object.
     */
    public static function resize(source:BitmapData, width:Int, height:Int, style:Int = Flags.CONSTRAIN):BitmapData
    {
        // Find the scale to reach the final size
        var scaleX = width  / source.width;
        var scaleY = height / source.height;
    
        if (width.notSet() && height.notSet()) {
            scaleX    = scaleY = 1;
            width     = source.width;
            height    = source.height;
        } else if (width.notSet()) {
            scaleX    = scaleY;
            width     = (scaleX * source.width).roundFloat();
        } else if (height.notSet()) {
            scaleY    = scaleX;
            height    = (scaleY * source.height).roundFloat();
        }
    
        if (style.has(Flags.CROPPING))
            if (scaleX < scaleY)  scaleX = scaleY;
            else                  scaleY = scaleX;
    
        else if (style.has(Flags.CONSTRAINING))
            if (scaleX > scaleY)  scaleX = scaleY;
            else                  scaleY = scaleX;
    
        var originalWidth   = source.width;
        var originalHeight  = source.height;
        var originalX       = 0;
        var originalY       = 0;
        var finalWidth      = (source.width  * scaleX).roundFloat();
        var finalHeight     = (source.height * scaleY).roundFloat();
    
        if (style.has(Flags.FILLING))
        {
            originalWidth   = (width  / scaleX).roundFloat();
            originalHeight  = (height / scaleY).roundFloat();
            originalX       = (originalWidth  - source.width)  >> 1; //* .5).roundFloat();
            originalY       = (originalHeight - source.height) >> 1; //* .5).roundFloat();
            finalWidth      = width;
            finalHeight     = height;
        }
    
        //
        // CREATE THE BITMAPDATA TO RETURN
        //
        var data:BitmapData = null;
        try {
            data = new BitmapData(finalWidth, finalHeight, true, 0);
        } catch (error:Dynamic) {
            error.message += " Invalid width and height: " + finalWidth + "x" + finalHeight + ".";
            throw error;
        }

        if (scaleX >= 1 && scaleY >= 1)
        {
            data.draw(source, new Matrix(scaleX, 0, 0, scaleY, originalX * scaleX, originalY * scaleY), null, null, null, true);
            return data;
        }

        //
        // scale it by the IDEAL for best quality
        //
        var nextScaleX = scaleX;
        var nextScaleY = scaleY;
        while (nextScaleX < 1)             nextScaleX /= IDEAL_RESIZE_PERCENT;
        while (nextScaleY < 1)             nextScaleY /= IDEAL_RESIZE_PERCENT;
        if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
        if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;

        var tmp1 = new BitmapData((originalWidth * nextScaleX).roundFloat(), (originalHeight * nextScaleY).roundFloat(), true, 0);
        var tmp2 = tmp1.clone();
        var m    = new Matrix(nextScaleX, 0, 0, nextScaleY, originalX * nextScaleX, originalY * nextScaleY);
        tmp1.draw(source, m, null, null, null, true);

        nextScaleX *= IDEAL_RESIZE_PERCENT;
        nextScaleY *= IDEAL_RESIZE_PERCENT;

        while (nextScaleX >= scaleX || nextScaleY >= scaleY)
        {
            var actualScaleX      = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
            var actualScaleY      = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
    //        var temp:BitmapData   = new BitmapData((bitmapData.width * actualScaleX).roundFloat(), (bitmapData.height * actualScaleY).roundFloat(), true, 0);

    //        temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
    //        bitmapData.dispose();
            m.identity();
            m.scale(actualScaleX, actualScaleY);
            tmp2.draw(tmp1, m, null, null, null, true);
            
            nextScaleX *= IDEAL_RESIZE_PERCENT;
            nextScaleY *= IDEAL_RESIZE_PERCENT;
            var tmp     = tmp1;
            tmp1        = tmp2;   //tmp1 is should always hold the last scaled bitmapdata
            tmp2        = tmp;    //tmp2 is used to draw the next scaled bitmapdata in
        }
        
        //draw final scaled image to data
        data.copyPixels(tmp1, new Rectangle(0,0,finalWidth,finalHeight), new Point(0,0));
        tmp1.dispose();
        tmp2.dispose();
        tmp1 = tmp2 = null;

        return data;
    }
}
#end