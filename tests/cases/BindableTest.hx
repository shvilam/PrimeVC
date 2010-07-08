package cases;
import primevc.core.Bindable;

class BindableTest
{
	static function main() {
		var a = new Bindable<Int>(1000);
		var b = new Bindable<Int>(1000);
		
		b.pair(a);
		
		Assert.that(a.value == b.value);
		a.value = 123;
		Assert.that(a.value == b.value);
		b.value = 456;
		Assert.that(a.value == b.value);
		
		a.unbind(b);
		a.value = 1337;
		Assert.that(a.value == 1337);
		Assert.that(b.value == 456);
		
		b.value = 1000;
		Assert.that(a.value == 1337);
		Assert.that(b.value == 1000);
		
		var changeCount = 0;
		a.change.bind(BindableTest, function(v){ changeCount++; });
		
		a.pair(b);
		a.pair(b);
		a.pair(b);
		
		Assert.that(changeCount == 1);
		
		b.value = 987;
		Assert.that(a.value == 987);
		Assert.that(b.value == 987);
		
		Assert.that(changeCount == 2);
		
		a.dispose();
		b.value = 765;
		Assert.that(a.value == 0);
		Assert.that(b.value == 765);
		
		trace("Ok!");
	}
}