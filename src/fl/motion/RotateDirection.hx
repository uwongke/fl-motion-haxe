// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

/**
 * The RotateDirection class provides constant values for rotation behavior during a tween.
 * Used by the <code>rotateDirection</code> property of the fl.motion.Keyframe class.
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword RotateDirection, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 * @see fl.motion.Keyframe#rotateDirection
 */
class RotateDirection {
	/**
	 * Chooses a direction of rotation that requires the least amount of turning.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword RotateDirection, Copy Motion as ActionScript
	 */
	public static inline var AUTO:String = "auto";

	/**
	 * Prevents the object from rotating during a tween until the next keyframe is reached.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword RotateDirection, Copy Motion as ActionScript
	 */
	public static inline var NONE:String = "none";

	/**
	 * Ensures that the object rotates clockwise during a tween
	 * to match the rotation of the object in the following keyframe.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword RotateDirection, Copy Motion as ActionScript
	 */
	public static inline var CW:String = "cw";

	/**
	 * Ensures that the object rotates counterclockwise during a tween
	 * to match the rotation of the object in the following keyframe.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword RotateDirection, Copy Motion as ActionScript
	 */
	public static inline var CCW:String = "ccw";

	public function new() {}
}
