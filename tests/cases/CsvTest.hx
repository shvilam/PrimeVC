package cases;
 import primevc.utils.Csv;
 import primevc.utils.FastArray;
 import primevc.utils.TimerUtil;


class CsvTest extends haxe.unit.TestCase
{
	public static function main ()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new CsvTest());
		r.run();
	}


	private  function checkNormalValues (o:FastArray<FastArray<String>>, hasHeader:Bool)
	{
		if (hasHeader)
		{
			assertEquals( 5, o.length );
			
			for (i in 1...o.length)
			{
				var row = o[i];
				assertEquals( 5, row.length );
				for (j in 0...row.length)
					assertEquals("row"+i+"Val"+(j+1), row[j]);
			}
		}
		else
		{
			assertEquals( 4, o.length );
			
			for (i in 0...o.length)
			{
				var row = o[i];
				assertEquals( 5, row.length );
				for (j in 0...row.length)
					assertEquals("row"+(i+1)+"Val"+(j+1), row[j]);
			}
		}
	}


	public function testNormalCsvHeader ()
	{
		checkNormalValues(Csv.read(NORMAL_CSV_HEADER + NORMAL_CSV_VALUES, true), true);
	}


	public function testNormalCsvNoHeader ()
	{
		checkNormalValues(Csv.read(NORMAL_CSV_VALUES, false), false);
	}


	public function testWindowsCsv ()
	{
		checkNormalValues(Csv.read(NORMAL_CSV_HEADER + WINDOWS_CSV_VALUES, true), true);
		checkNormalValues(Csv.read(WINDOWS_CSV_VALUES, false), false);
	}


	public function testQuotes ()
	{
		var o = Csv.read(QUOTES_CSV_VALUES, false);
		assertEquals(4, o.length);
		assertEquals(5, o[0].length);
		assertEquals(5, o[1].length);
		assertEquals(5, o[2].length);
		assertEquals(5, o[3].length);
		assertEquals('row1Val3', o[0][2]);
		assertEquals('row1Val4 sdf ,aaaaasd asda asd', o[0][3]);
		assertEquals('\nrow2Val2\nsdf sdf,\nsfdfsdfs', o[1][1]);
		assertEquals('row "3Val3"', o[2][2]);
	}
	

	public function testAlternativeDelimiter ()
	{
		checkNormalValues(Csv.read(ALT_CSV_HEADER + ALT_CSV_VALUES, true), true);
		var o = Csv.read(ALT_CSV_HEADER + ALT_CSV_QUOTES, true);
		assertEquals(5, o.length);
		assertEquals("row1Val1", 		o[1][0]);
		assertEquals("row1Val2;aap", 	o[1][1]);
		assertEquals("row1Val3", 		o[1][2]);
		assertEquals("row1Val4,row5", 	o[1][3]);
	}


	private static inline var NORMAL_CSV_HEADER  = 'col1,col2,col3,col4,col5\n';
	private static inline var NORMAL_CSV_VALUES  = 'row1Val1,row1Val2,row1Val3,row1Val4,row1Val5\nrow2Val1,row2Val2,row2Val3,row2Val4,row2Val5\nrow3Val1,row3Val2,row3Val3,row3Val4,row3Val5\nrow4Val1,row4Val2,row4Val3,row4Val4,row4Val5';
	private static inline var ALT_CSV_HEADER	 = 'col1;col2;col3;col4;col5\n';
	private static inline var ALT_CSV_VALUES	 = 'row1Val1;row1Val2;row1Val3;row1Val4;row1Val5\nrow2Val1;row2Val2;row2Val3;row2Val4;row2Val5\nrow3Val1;row3Val2;row3Val3;row3Val4;row3Val5\nrow4Val1;row4Val2;row4Val3;row4Val4;row4Val5';
	private static inline var ALT_CSV_QUOTES	 = 'row1Val1;"row1Val2;aap";row1Val3;row1Val4,row5;row1Val5\nrow2Val1;row2Val2;row2Val3;row2Val4;row2Val5\nrow3Val1;row3Val2;row3Val3;row3Val4;row3Val5\nrow4Val1;row4Val2;row4Val3;row4Val4;row4Val5';
	private static inline var WINDOWS_CSV_VALUES = 'row1Val1,row1Val2,row1Val3,row1Val4,row1Val5\r\nrow2Val1,row2Val2,row2Val3,row2Val4,row2Val5\r\nrow3Val1,row3Val2,row3Val3,row3Val4,row3Val5\r\nrow4Val1,row4Val2,row4Val3,row4Val4,row4Val5';
	private static inline var QUOTES_CSV_VALUES  = 'row1Val1,row1Val2,row1Val3,"row1Val4 sdf ,aaaaasd asda asd",row1Val5\nrow2Val1,"
row2Val2
sdf sdf,
sfdfsdfs",row2Val3,row2Val4,row2Val5\nrow3Val1,row3Val2,"row ""3Val3""",row3Val4,row3Val5\nrow4Val1,row4Val2,row4Val3,row4Val4,row4Val5';
}