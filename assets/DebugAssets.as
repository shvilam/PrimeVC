/**
 * Used by MXMLC to compile AS3 libraries and embed images 
 * into a single swf file for "haXe -swf-lib"
 * 
 * @author Danny Wilson
 */

package 
{
	import com.hexagonstar.util.debug.Debug;
	import com.demonsters.debugger.MonsterDebugger;
	import nl.demonsters.debugger.MonsterDebugger;
	
	
	public class DebugAssets extends Assets
	{
		// Force embedding
		private var monsterDebugger2	: nl.demonsters.debugger.MonsterDebugger;
		private var monsterDebugger3	: com.demonsters.debugger.MonsterDebugger;
		private var alconDebugger		: com.hexagonstar.util.debug.Debug;
	}
}