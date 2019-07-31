package fl.motion;

import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.utils.Dictionary;

/**
 * The AnimatorFactoryUniversal class provides ActionScript-based support to associate one Motion object with multiple
 * display objects. AnimatorFactoryUniversal supports both traditional and three-dimensional animation.
 * <p>Use the AnimatorFactoryUniversal constructor to create an AnimatorFactoryUniversal instance. Then,
 * use the methods inherited from the
 * AnimatorFactoryBase class to associate the desired properties with display objects.</p>
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @see fl.motion.AnimatorUniversal
 * @see fl.motion.AnimatorFactoryBase
 * @see fl.motion.Motion
 * @see fl.motion.MotionBase
 */
class AnimatorFactoryUniversal extends AnimatorFactoryBase {
	/**
	 * Creates an AnimatorFactory instance you can use to assign the properties of
	 * a MotionBase object to display objects.
	 * @param motion The MotionBase object containing the desired motion properties.
	 * .
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @see fl.motion.Animator
	 * @see fl.motion.AnimatorFactoryBase
	 * @see fl.motion.Motion
	 * @see fl.motion.MotionBase
	 */
	public function new(motion:MotionBase, motionArray:Array<Dynamic>) {
		super(motion, motionArray);
	}

	/**
	 * @private
	 */
	override private function getNewAnimator():AnimatorBase {
		return new AnimatorUniversal();
	}
}
