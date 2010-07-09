package primevc.gui.layout;
 

/**
 * Collection of change flags for the layout-objects.
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutFlags 
{
	public static inline var WIDTH_CHANGED				= 1;
	public static inline var HEIGHT_CHANGED				= 2;
	public static inline var X_CHANGED					= 4;
	public static inline var Y_CHANGED					= 8;
	/**
	 * Flag indicating the includeInLayout property has changed
	 */
	public static inline var INCLUDE_CHANGED			= 16;
	/**
	 * The relative property or properties of the relative object are changed.
	 */
	public static inline var RELATIVE_CHANGED			= 32;
	/**
	 * Flag indicating that when the list with children of a layoutgroup have 
	 * changed.
	 */
	public static inline var LIST_CHANGED				= 64;
	/**
	 * Flag indicating that the children of the layout algorithm have changed.
	 */
	public static inline var CHILDREN_INVALIDATED		= 128;
	/**
	 * Flag indicating that a property of the layout algorithm is changed and
	 * the layout needs to be validated again.
	 */
	public static inline var ALGORITHM_CHANGED			= 256;
	/**
	 * Flag indicating that the size-constraint of the layout-client is changed
	 */
	public static inline var SIZE_CONSTRAINT_CHANGED	= 512;
}