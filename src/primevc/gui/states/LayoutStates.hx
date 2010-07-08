package primevc.gui.states;
 

/**
 * enum with the states of a layout client
 * 
 * @creation-date	Jun 22, 2010
 * @author			Ruben Weijers
 */
enum LayoutStates {
	invalidated;
	parent_invalidated;
	measuring;
	validating;
	validated;
}