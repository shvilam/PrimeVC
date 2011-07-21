package cases;
 import flash.display.BitmapData;
 import flash.display.Bitmap;
 import flash.geom.Point;
 import flash.geom.Rectangle;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.net.URLLoader;
 import primevc.utils.FastArray;
 import primevc.utils.TimerUtil;
  using primevc.utils.FastArray;
  using primevc.utils.TypeUtil;
  using primevc.utils.Bind;


private typedef FlashLoader = flash.display.Loader;
private typedef PrimeLoader = primevc.gui.display.Loader;


class JPEGDecoderBenchmark
{
    public static function main ()
    {
        var testUrl = '../../../assets/spread3.jpg';
        var test1   = new JPEGLoaderFlash(testUrl);
        var test2   = new JPEGLoaderFlash(testUrl);
        var test3   = new JPEGLoaderFlash(testUrl);

        var test4   = new JPEGLoaderPrime(testUrl);
        var test5   = new JPEGLoaderPrime(testUrl);
        var test6   = new JPEGLoaderPrime(testUrl);

        var test7   = new JPEGURLLoaderManual(testUrl);
        var test8   = new JPEGURLLoaderManual(testUrl);
        var test9   = new JPEGURLLoaderManual(testUrl);

        test2.load.onceOn(test1.completed, test2);
        test3.load.onceOn(test2.completed, test3);
        test4.load.onceOn(test3.completed, test4);
        test5.load.onceOn(test4.completed, test5);
        test6.load.onceOn(test5.completed, test6);
        test7.load.onceOn(test6.completed, test7);
        test8.load.onceOn(test7.completed, test8);
        test9.load.onceOn(test8.completed, test9);
        test1.load();
    }
}


class LoaderTestBase
{
    private var times       : FastArray<Int>;
    public  var completed   : Signal0;
    private var bitmapData  : BitmapData;
    private var url         : String;


    public function new (url:String)
    {
        this.url    = url;
        completed   = new Signal0();
        times       = FastArrayUtil.create();
        bitmapData  = new BitmapData(900, 450);
    }


    private inline function stamp ()    { times.push( TimerUtil.stamp() ); }
    public function toString ()         { return "total: "+(times[2] - times[0])+" ms; loading: "+(times[1] - times[0])+" ms; drawing: "+(times[2] - times[1])+" ms"; }
}




class JPEGLoaderFlash extends LoaderTestBase
{
    private var loader      : FlashLoader;


    public function new (testUrl)
    {
        super(testUrl);
        loader = new FlashLoader();
        loader.contentLoaderInfo.addEventListener( "complete", drawLoader );
    }


    public function load ()
    {
        stamp();
        loader.load(new flash.net.URLRequest(url));
    }


    private function drawLoader (event:Dynamic)
    {
        stamp();
        loader.contentLoaderInfo.removeEventListener( "complete", drawLoader );
        var bmp = loader.content.as(Bitmap).bitmapData;
        bitmapData.copyPixels( bmp, new Rectangle(0,0,900,450), new Point(0,0) );
        stamp();
        trace(this);
        completed.send();
    }


    override public function toString ()    { return "JPEGLoaderFlash:\t\t\t"+super.toString(); }
}


class JPEGLoaderPrime extends LoaderTestBase
{
    private var loader      : PrimeLoader;


    public function new (testUrl)
    {
        super(testUrl);
        loader = new PrimeLoader();
        drawLoader.onceOn( loader.events.load.completed, this );
    }


    public function load ()
    {
        stamp();
        loader.load(new primevc.types.URI(url));
    }


    private function drawLoader ()
    {
        stamp();
        var bmp = loader.content.as(Bitmap).bitmapData;
        bitmapData.copyPixels( bmp, new Rectangle(0,0,900,450), new Point(0,0) );
        stamp();
        trace(this);
        completed.send();
    }


    override public function toString ()    { return "JPEGLoaderPrime:\t\t\t"+super.toString(); }
}



class JPEGURLLoaderManual extends LoaderTestBase
{
    private var urlLoader   : URLLoader;
    private var loader      : PrimeLoader;


    public function new (testUrl)
    {
        super(testUrl);
        urlLoader   = new URLLoader();
        loader      = new PrimeLoader();
        urlLoader.setBinary();
        loadBytes .onceOn( urlLoader.events.load.completed, this );
        drawLoader.onceOn( loader   .events.load.completed, this );
    }


    public function load ()
    {
        stamp();
        urlLoader.load(new primevc.types.URI(url));
    }


    private function loadBytes ()
    {
        stamp();
        loader.loadBytes(urlLoader.data);
    }


    private function drawLoader ()
    {
        stamp();
        var bmp = loader.content.as(Bitmap).bitmapData;
        bitmapData.copyPixels( bmp, new Rectangle(0,0,900,450), new Point(0,0) );
        stamp();
        trace(this);
        completed.send();
    }


    override public function toString ()    { return "JPEGURLLoaderManual:\ttotal: "+(times[3] - times[0])+" ms; loading: "+(times[1] - times[0])+" ms; drawing: "+(times[3] - times[2])+" ms; loadBytes: "+(times[2] - times[1])+" ms"; }
}

