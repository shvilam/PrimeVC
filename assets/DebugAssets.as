/**
 * Used by MXMLC to compile AS3 libraries and embed images 
 * into a single swf file for "haXe -swf-lib"
 * 
 * @author Danny Wilson
 */

package 
{
	import com.hexagonstar.util.debug.Debug;
	import nl.demonsters.debugger.MonsterDebugger;
	
	
	public class DebugAssets extends Assets
	{
		// Force embedding
		private var monsterDebugger : nl.demonsters.debugger.MonsterDebugger;
		private var alconDebugger	: com.hexagonstar.util.debug.Debug;
	}
}