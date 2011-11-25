package;
  using ClassVarTest;


class ClassVarTest
{
    public static function main ()
    {
        var list:FastArray<String> = FastArrayUtil.create();
        var a = "test";
        list.push(a);
        list.removeItem(a);
    }
}


typedef FastArray<T> =
    #if flash10     flash.Vector<T>
    #else           Array<T>;
    #end


#if flash10 extern #end class FastArrayUtil
{
    static public inline function create<T>(?size:Int = 0, ?fixed:Bool = false) : FastArray<T>
    {
#if flash10
        return new flash.Vector<T>(size, fixed);
#elseif flash
        return untyped __new__(Array, size);
#elseif neko
        return untyped Array.new1(neko.NativeArray.alloc(size), size);
#elseif js
        // if size is the constant value 0, only [] will be inlined at the call site.
        return if (size == 0) [] else (untyped Array)(size);
#end
    }


    static public inline function removeItem<T> (list:FastArray<T>, item:T, oldPos:Int = -1) : Bool {
        if (oldPos == -1)
            oldPos = list.indexOf(item);
        return removeAt(list, oldPos);
    }

    
    static public inline function removeAt<T> (list:FastArray<T>, pos:Int) : Bool {
        if (pos >= 0)
        {
            if      (pos == 0)                      list.shift();
            else if (pos == (list.length - 1))      list.pop();
            else                                    list.splice(pos, 1);
        }
        return pos >= 0;
    }
}
