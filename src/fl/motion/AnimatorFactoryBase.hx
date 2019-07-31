package fl.motion;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.utils.Dictionary;
import openfl.display.SimpleButton;

/**
 * The AnimatorFactoryBase class provides ActionScript-based support to display and tween multiple targeted objects with one Motion dynamically at runtime.
 * AnimatorFactoryBase uses the AnimatorBase class to assign one Motion (derived from MotionBase)
 * to multiple tween instances (targeted objects)
 * whereas the AnimatorBase class associates a single Motion instance with a single targeted tween object.
 * The AnimatorFactoryBase class should not be used on its own. Use its subclasses: AnimatorFactory or AnimatorFactory3D, instead.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 * @see fl.motion.Animator
 * @see fl.motion.AnimatorFactory
 */
class AnimatorFactoryBase {
	public var motion(get, never):MotionBase;
	public var transformationPoint(never, set):Point;
	public var transformationPointZ(never, set):Int;
	public var sceneName(never, set):String;

	private var _motion:MotionBase;
	private var _motionArray:Array<Dynamic>;
	private var _animators:Dictionary;

	/**
	 * @private
	 */
	private var _transformationPoint:Point;

	/**
	 * @private
	 */
	private var _transformationPointZ:Int;

	/**
	 * @private
	 */
	private var _is3D:Bool;

	/**
	 * @private
	 */
	private var _sceneName:String;

	/**
	 	 * Creates an instance of the <code>AnimatorFactoryBase</code> class.
	 		 *
	 		 * @param motion The associated MotionBase instance.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 */
	public function new(motion:MotionBase, motionArray:Array<Dynamic> = null) {
		_motion = motion;
		_motionArray = motionArray;
		_animators = new Dictionary(true);
		_transformationPoint = new Point(.5, .5);
		_transformationPointZ = 0;
		_is3D = false;
		_sceneName = "";
	}

	/**
	 * The <code>MotionBase</code> instance that the <code>AnimatorFactoryBase</code> instance and its target objects are associated with.
	 * The <code>MotionBase</code> instance stores the animated properties and their values.
	 * @category Property[read-only]
	 		*  @playerversion Flash 9.0.28.0
	 		*  @langversion 3.0
	 		*  @playerversion AIR 1.0
	 		*  @productversion Flash CS4
	 * @see fl.motion.Motion
	 */
	private function get_motion():MotionBase {
		return _motion;
	}

	/**
	 * Creates and returns an <code>AnimatorBase</code> instance whose target property is set to the <code>DisplayObject</code> (if applicable)
	 * that is the <code>targetName</code> property of the <code>targetParent</code>,
	 * and whose <code>Motion</code> property is stored in the <code>AnimatorFactoryBase</code> instance upon creation.
	 *
	 * @param target The display object using the motion tween.
	 * @param repeatCount The number of times the animation should play. The default value is 0, which means the animation will loop indefinitely.
	 * @param autoPlay The value (default is true) specifying whether the animation automatically begins to play.
	 * @param startFrame The frame on which the animation starts relative to the parent's timeline.
	 * If the parent's timeline is shorter than the duration of the associated Motion,
	 * then startFrame indicates the number of frames after this <code>addTarget</code> call is made before the target animation begins.
	 * @param useCurrentFrame A flag specifying, if true, to use the parent's <code>currentFrame</code> property
	 * to determine which animation frame the target object should be on.
	 * @return A new AnimatorBase instance.
	 		*  @playerversion Flash 9.0.28.0
	 		*  @langversion 3.0
	 		*  @playerversion AIR 1.0
	 		*  @productversion Flash CS4
	 	* @see #addTargetInfo()
	 * @see fl.motion.Animator
	 * @see fl.motion.Motion
	 	* @see flash.display.DisplayObject
	 */
	public function addTarget(target:DisplayObject, repeatCount:Int = 0, autoPlay:Bool = true, startFrame:Int = -1,
		useCurrentFrame:Bool = false):AnimatorBase {
		if (target != null) {
			return addTargetInfo(target.parent, target.name, repeatCount, autoPlay, startFrame, useCurrentFrame);
		}

		return null;
	}

	/**
	 * @private
	 */
	private function getNewAnimator():AnimatorBase {
		return null;
	}

	/**
	 * References the parent <code>DisplayObjectContainer</code> and then creates and returns an <code>AnimatorBase</code>
	 * instance whose target property is set to the <code>DisplayObject</code> (if applicable)
	 * that is the <code>targetName</code> property of the <code>targetParent</code>,
	 * and whose <code>Motion</code> property is stored in the <code>AnimatorFactoryBase</code> instance upon creation.
	 *
	 * @param targetParent The parent DisplayObjectContainer.
	 * @param targetName The target's instance name as seen by its parent.
	 * @param repeatCount The number of times the animation should play. The default value is 0, which means the animation will loop indefinitely.
	 * @param autoPlay The value (default is true) specifying whether the animation automatically begins to play.
	 * @param startFrame The frame on which the animation starts relative to the parent's timeline.
	 * If the parent's timeline is shorter than the duration of the associated Motion,
	 * then startFrame indicates the number of frames after this <code>addTarget</code> call is made before the target animation begins.
	 * If the parent is a SimpleButton, then startFrame is used to indicate the button state in which the motion should be applied:
	 * 0 for upState, 1 for overState,  2 for downState.
	 * @param useCurrentFrame A flag specifying, if true, to use the parent's <code>currentFrame</code> property
	 * to determine which animation frame the target object should be on.
	 * @param initialPosition if not null, used to set initialPosition property on generated AnimatorBase instance.
	 * @param zIndex If the parent is a SimpleButton, then this value is the 0-based z order of the object to which to apply the animation. If there is only a single object in the button, then zIndex should be set to -1, not 0. defaults to -1.
	 * @param placeholderName if not null, used to specify instance on stage to be replaced by DisplayObject created by instanceNameFactoryClass. Defaults to null.
	 * @param instanceFactoryClass if not null, class used to create a DisplayObject that will replace a placeholder. Defaults to null.
	 * @return A new AnimatorBase instance.
	 		*  @playerversion Flash 9.0.28.0
	 		*  @langversion 3.0
	 		*  @playerversion AIR 1.0
	 		*  @productversion Flash CS4
	 	* @see #addTarget()
	 * @see fl.motion.Animator
	 * @see fl.motion.Motion
	 	* @see flash.display.DisplayObjectContainer
	 */
	public function addTargetInfo(targetParent:DisplayObject, targetName:String, repeatCount:Int = 0,
		autoPlay:Bool = true, startFrame:Int = -1, useCurrentFrame:Bool = false, initialPosition:Array<Dynamic> = null,
		zIndex:Int = -1, placeholderName:String = null, instanceFactoryClass:Class<Dynamic> = null):AnimatorBase {
		if (!(Std.is(targetParent, DisplayObjectContainer)) && !(Std.is(targetParent, SimpleButton))) {
			return null;
		}

		var parentDictionary:Dictionary = Reflect.field(_animators, Std.string(targetParent));
		if (parentDictionary == null) {
			parentDictionary = new Dictionary();
			Reflect.setField(_animators, Std.string(targetParent), parentDictionary);
		}

		var animator:AnimatorBase = Reflect.field(parentDictionary, targetName);
		var createdAnim:Bool = false;

		if (animator == null) {
			// setting target to null here - we will set it to the proper
			// given DisplayObject later after other attributes are set,
			// so that its targetState is initialized properly
			animator = getNewAnimator();

			// use FRAME_CONSTRUCTED if it's available
			var eventClass:Class<Dynamic> = Type.getClass(flash.utils.getDefinitionByName("flash.events.Event"));
			if (eventClass.exists("FRAME_CONSTRUCTED")) {
				animator.frameEvent = "frameConstructed";
			}

			Reflect.setField(parentDictionary, targetName, animator);
			createdAnim = true;
		}

		animator.motion = _motion;
		animator.motionArray = _motionArray;
		animator.transformationPoint = this._transformationPoint;
		animator.transformationPointZ = this._transformationPointZ;
		animator.sceneName = this._sceneName;
		if (createdAnim) {
			if (Std.is(targetParent, MovieClip)) {
				// this needs to happen after the motion has already been set, so
				// that it can determine the correct time behavior based on
				// the duration of the motion
				AnimatorBase.registerParentFrameHandler(try cast(targetParent,
					MovieClip) catch (e:Dynamic) null, animator, startFrame, repeatCount, useCurrentFrame);
			}
		}

		if (Std.is(targetParent, MovieClip)) {
			animator.targetParent = cast((targetParent), MovieClip);
			animator.targetName = targetName;
			animator.placeholderName = placeholderName;
			animator.instanceFactoryClass = instanceFactoryClass;
		} else if (Std.is(targetParent, SimpleButton)) {
			// for buttons, startFrame is overloaded to indicate button state
			AnimatorBase.registerButtonState(try cast(targetParent, SimpleButton) catch (e:Dynamic) null, animator,
				startFrame, zIndex, targetName, placeholderName, instanceFactoryClass);
		} else if (Std.is(targetParent, Sprite)) {
			AnimatorBase.registerSpriteParent(try cast(targetParent,
				Sprite) catch (e:Dynamic) null, animator, targetName, placeholderName, instanceFactoryClass);
		}

		if (initialPosition != null) {
			animator.initialPosition = initialPosition;
		}

		if (autoPlay) {
			AnimatorBase.processCurrentFrame(try cast(targetParent, MovieClip) catch (e:Dynamic) null, animator, true, true);
		}

		return animator;
	}

	/**
	 * The point of reference for rotating or scaling a display object.
	 * The <code>transformationPoint</code> property (or setter) is overridden in the <code>AnimatorFactory3D</code> subclass,
	 * In 3D, the points are not percentages like they are in 2D; they are absolute values of the original object's transformation point.
	 */
	private function set_transformationPoint(p:Point):Point {
		_transformationPoint = p;
		return p;
	}

	/**
	 * The z-coordinate point of reference for rotating or scaling a display object.
	 * The <code>transformationPointZ</code> property (or setter) is overridden in the <code>AnimatorFactory3D</code> subclass,
	 * In 3D, the points are not percentages like they are in 2D; they are absolute values of the original object's transformation point.
	 */
	private function set_transformationPointZ(z:Int):Int {
		_transformationPointZ = z;
		return z;
	}

	// for animations that we actually export (for 3d), we have
	// to track the scenes that contain them in order to determine
	// whether or not they should play - the parent timeline's frame
	// number is not enough

	/**
	 * A reference for exported scenes, for 3D motion, so the scene can be loaded into a parent timeline.
	 */
	private function set_sceneName(name:String):String {
		_sceneName = name;
		return name;
	}
}
