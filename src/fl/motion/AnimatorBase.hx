// Copyright ? 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import openfl.errors.Error;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.SimpleButton;
import openfl.utils.Dictionary;

@:meta(DefaultProperty(name = "motion"))
/**
 *  Dispatched when the motion finishes playing,
 *  either when it reaches the end, or when the motion is
 *  interrupted by a call to the <code>stop()</code> or <code>end()</code> methods.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_END
 */
@:meta(Event(name = "motionEnd", type = "fl.motion.MotionEvent"))
/**
 *  Dispatched when the motion starts playing.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_START
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 */
@:meta(Event(name = "motionStart", type = "fl.motion.MotionEvent"))
/**
 *  Dispatched when the motion has changed and the screen has been updated.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_UPDATE
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 */
@:meta(Event(name = "motionUpdate", type = "fl.motion.MotionEvent"))
/**
 *  Dispatched when the Animator's <code>time</code> value has changed,
 *  but the screen has not yet been updated (i.e., the <code>motionUpdate</code> event).
 *
 *  @eventType fl.motion.MotionEvent.TIME_CHANGE
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 */
@:meta(Event(name = "timeChange", type = "fl.motion.MotionEvent"))

/**
 * The AnimatorBase class applies an XML description of a motion tween to a display object.
 * The properties and methods of the AnimatorBase class control the playback of the motion,
 * and Flash Player broadcasts events in response to changes in the motion's status.
 * The AnimatorBase class is primarily used by the Copy Motion as ActionScript command in Flash CS4.
 * You can then edit the ActionScript using the application programming interface
 * (API) or construct your own custom animation.
 * The AnimatorBase class should not be used on its own. Use its subclasses: Animator or Animator3D, instead.
 *
 * <p>If you plan to call methods of the AnimatorBase class within a function, declare the AnimatorBase
 * instance outside of the function so the scope of the object is not restricted to the
 * function itself. If you declare the instance within a function, Flash Player deletes the
 * AnimatorBase instance at the end of the function as part of Flash Player's routine "garbage collection"
 * and the target object will not animate.</p>
 *
 * @internal <p><strong>Note:</strong> If you're not using Flash CS4 to compile your SWF file, you need the
 * fl.motion classes in your classpath at compile time to apply the motion to the display object.</p>
 *
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 * @keyword Animator, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 */
class AnimatorBase extends EventDispatcher {
	public var motion(get, set):MotionBase;
	public var motionArray(get, set):Array<Dynamic>;
	public var isPlaying(get, never):Bool;
	public var target(get, set):DisplayObject;
	public var initialPosition(never, set):Array<Dynamic>;
	public var time(get, set):Int;
	public var targetParent(get, set):DisplayObjectContainer;
	public var targetParentButton(get, set):SimpleButton;
	public var targetName(get, set):String;
	public var placeholderName(get, set):String;
	public var instanceFactoryClass(get, set):Class<Dynamic>;
	public var usingCurrentFrame(get, never):Bool;
	public var spanStart(get, never):Int;
	public var spanEnd(get, never):Int;
	public var sceneName(get, set):String;
	public var frameEvent(get, set):String;
	public var targetState3D(get, set):Array<Dynamic>;

	/**
	 * @private
	 */
	private var _motion:MotionBase;

	private var _motionArray:Array<Dynamic>;

	/**
	 * @private
	 */
	private var _lastMotionUsed:MotionBase;

	/**
	 * @private
	 */
	private var _lastColorTransformApplied:ColorTransform;

	/**
	 * @private
	 */
	private var _filtersApplied:Bool;

	/**
	 * @private
	 */
	private var _lastBlendModeApplied:String;

	/**
	 * @private
	 */
	private var _cacheAsBitmapHasBeenApplied:Bool;

	/**
	 * @private
	 */
	private var _lastCacheAsBitmapApplied:Bool;

	/**
	 * @private
	 */
	private var _opaqueBackgroundHasBeenApplied:Bool;

	/**
	 * @private
	 */
	private var _lastOpaqueBackgroundApplied:Dynamic;

	/**
	 * @private
	 */
	private var _visibleHasBeenApplied:Bool;

	/**
	 * @private
	 */
	private var _lastVisibleApplied:Bool;

	/**
	 * @private
	 */
	private var _lastMatrixApplied:Matrix;

	/**
	 * @private
	 */
	private var _lastMatrix3DApplied:Dynamic;

	/**
	 * @private
	 */
	private var _toRemove:Array<Dynamic>;

	/**
	 * @private
	 */
	private var _lastFrameHandled:Int;

	/**
	 * @private
	 */
	private var _lastSceneHandled:String;

	/**
	 * @private
	 */
	private var _registeredParent:Bool;

	/**
	 * The object that contains the motion tween properties for the
	 * animation. You cannot set both motion and motionArray to
	 * non-null values; if you set motionArray to a non-null value,
	 * then motion is set to null automatically and vice versa.
	 */
	private function get_motion():MotionBase {
		return this._motion;
	}

	/**
	 * @private (setter)
	 */
	private function set_motion(value:MotionBase):MotionBase {
		this._motion = value;
		if (value != null) {
			if (this.motionArray) {
				_spanStart = _spanEnd = -1;
			}
			this.motionArray = null;
		}
		return value;
	}

	/**
	 * The Array of objects that contains the motion tween properties
	 * for the animation. You cannot set both motion and motionArray
	 * to non-null values; if you set motionArray to a non-null value,
	 * then motion is set to null automatically and vice
	 * versa. Animation using motionArray only works properly when
	 * usingCurrentFrame is true. The array should have MotionBase
	 * instances with the spanStart property set and the
	 * initialPosition property set if 3D is supported. The array
	 * instances should be placed in the array in spanStart order from
	 * lowest to highest.  Also when motionArray is set, then the time
	 * property is not relative to one motion instance, but instead is
	 * absolute for the target parent, still zero-indexed, and
	 * restricted to the span of the motion (so it should be
	 * parent.currentFrame - 1 when currentFrame - 1 is greater than
	 * spanStart and less than spanEnd). Will not accept an empty
	 * array; passing an empty array is the equivalent of setting to
	 * null.  The motionArray should have no null entries and the
	 * spanStart and duration entries should not have any holes in
	 * them (so for example if the first entry had spanStart == 5 and
	 * duration == 3, then the second entry would be required to have
	 * spanStart == 8).
	 */
	private function get_motionArray():Array<Dynamic> {
		return _motionArray;
	}

	/**
	 * @private
	 */
	private function set_motionArray(value:Array<Dynamic>):Array<Dynamic> {
		_motionArray = ((value != null && value.length > 0)) ? value : null;
		if (_motionArray != null) {
			this.motion = null;
			_spanStart = _motionArray[0].motion_internal::spanStart;
			_spanEnd = _spanStart - 1;
			var i:Int = 0;
			while (i < _motionArray.length) {
				_spanEnd += _motionArray[i].duration;
				i++;
			}
		}
		return value;
	}

	/**
	 * Sets the position of the display object along the motion path. If set to <code>true</code>
	 * the baseline of the display object orients to the motion path; otherwise the registration
	 * point orients to the motion path.
	 */
	public var orientToPath:Bool = false;

	/**
	 * The point of reference for rotating or scaling a display object. For 2D motion, the transformation point is
	 * relative to the display object's bounding box. The point's coordinates must be scaled to a 1px x 1px box, where (1, 1) is the object's lower-right corner,
	 * and (0, 0) is the object's upper-left corner. For 3Dmotion (when the AnimatorBase instance is an Animator3D), the transformationPoint's x and y plus the transformationPointZ are
	 * absolute values in the target parent's coordinate space.
	 */
	public var transformationPoint:Point;

	/**
	 * The z-coordinate point of reference for rotating or scaling a display object.
	 * The <code>transformationPointZ</code> property (or setter) is overridden in the <code>AnimatorFactory3D</code> subclass,
	 * In 3D, the points are not percentages like they are in 2D; they are absolute values of the original object's transformation point.
	 */
	public var transformationPointZ:Int;

	/**
	 * Sets the animation to restart after it finishes.
	 */
	public var autoRewind:Bool = false;

	/**
	 * The Matrix object that applies an overall transformation to the motion path.
	 * This matrix allows the path to be shifted, scaled, skewed or rotated,
	 * without changing the appearance of the display object.
	 */
	public var positionMatrix:Matrix;

	/**
	 *  Number of times to repeat the animation.
	 *  Possible values are any integer greater than or equal to <code>0</code>.
	 *  A value of <code>1</code> means to play the animation once.
	 *  A value of <code>0</code> means to play the animation indefinitely
	 *  until explicitly stopped (by a call to the <code>end()</code> method, for example).
	 *
	 * @default 1
	 */
	public var repeatCount:Int = 1;

	/**
	 * @private
	 */
	private var _isPlaying:Bool = false;

	/**
	 * Indicates whether the animation is currently playing.
	 */
	private function get_isPlaying():Bool {
		return _isPlaying;
	}

	/**
	 * @private
	 */
	private var _target:DisplayObject;

	/**
	 * @private
	 */
	private var _lastTarget:DisplayObject;

	/**
	 * The display object being animated.
	 * Any subclass of flash.display.DisplayObject can be used, such as a <code>MovieClip</code>, <code>Sprite</code>, or <code>Bitmap</code>.
	 */
	private function get_target():DisplayObject {
		return this._target;
	}

	/**
	 * @private (setter)
	 */
	private function set_target(value:DisplayObject):DisplayObject {
		if (value == null) {
			return value;
		}
		this._target = value;

		if (value != _lastTarget) {
			// reset cache of what has been set on target
			_lastColorTransformApplied = null;
			_filtersApplied = false;
			_lastBlendModeApplied = null;
			_cacheAsBitmapHasBeenApplied = false;
			_opaqueBackgroundHasBeenApplied = false;
			_visibleHasBeenApplied = false;
			_lastMatrixApplied = null;
			_lastMatrix3DApplied = null;
			_toRemove = new Array<Dynamic>();
		}

		_lastTarget = value;
		var setTargetStateOriginal:Bool = false;
		if (this.targetParent && this.targetName != "") {
			if (this.targetStateOriginal) {
				this.targetState = this.targetStateOriginal;
				return value;
			} else {
				setTargetStateOriginal = true;
			}
		}
		this.targetState = {};
		this.setTargetState();
		if (setTargetStateOriginal) {
			this.targetStateOriginal = this.targetState;
		}
		return value;
	}

	/**
	 * @private
	 */
	private function setTargetState():Void {}

	/**
	 * An array of coordinates defining the starting location of the animation.
	 */
	private function set_initialPosition(initPos:Array<Dynamic>):Array<Dynamic> {
		// subclasses can override
		return initPos;
	}

	/**
	 * @private
	 */
	private var _lastRenderedTime:Int = -1;

	/**
	 * @private
	 */
	private var _lastRenderedMotion:MotionBase = null;

	/**
	 * @private
	 */
	private var _time:Int = -1;

	/**
	 * A zero-based integer that indicates and controls the time in
	 * the current animation.  At the animation's first frame the
	 * <code>time</code> value is <code>0</code>.  If the animation
	 * has a duration of 10 frames, at the last frame the
	 * <code>time</code> value is <code>9</code>.  <p>If motionArray
	 * is set to non-null, then instead of being a zero-based relative
	 * index, the time is absolute for the target parent, restricted
	 * to the span of the motion and still zero indexed (so it should
	 * be parent.currentFrame - 1 when currentFrame - 1 is greater
	 * than spanStart and less than spanEndwithin the span).</p>
	 */
	private function get_time():Int {
		return this._time;
	}

	/**
	 * @private (setter)
	 */
	private function set_time(newTime:Int):Int {
		if (newTime == this._time) {
			return newTime;
		}

		// be sure to track the display index of the placeholder
		if (_placeholderName) {
			var placeHolder:DisplayObject = _targetParent[_placeholderName];
			if (placeHolder == null) {
				placeHolder = _targetParent.getChildByName(_placeholderName);
			}
			if (placeHolder != null && placeHolder.parent == _targetParent && _target.parent == _targetParent) {
				_targetParent.addChildAt(_target, _targetParent.getChildIndex(placeHolder) + 1);
			}
		}

		var thisMotion:MotionBase = this.motion;
		var thisMotionArray:Array<Dynamic>;
		if (thisMotion != null) {
			if (newTime > thisMotion.duration - 1) {
				newTime = as3hx.Compat.parseInt(thisMotion.duration - 1);
			} else if (newTime < 0) {
				newTime = 0;
			}
			this._time = newTime;
		} else {
			thisMotionArray = this.motionArray;
			if (newTime <= _spanStart) {
				thisMotion = thisMotionArray[0];
				newTime = _spanStart;
			} else if (newTime >= _spanEnd) {
				thisMotion = thisMotionArray[thisMotionArray.length - 1];
				newTime = _spanEnd;
			} else {
				var i:Int = 0;
				while (i < thisMotionArray.length) {
					thisMotion = thisMotionArray[i];
					if (newTime <= thisMotion.motion_internal::spanStart + thisMotion.duration - 1) {
						break;
					}
					i++;
				}
			}
			this._time = newTime;
			// now fix newTime so that it will be relative to thisMotion duration
			newTime -= thisMotion.motion_internal::spanStart;
		}

		this.dispatchEvent(new MotionEvent(MotionEvent.TIME_CHANGE));

		var curKeyframe:KeyframeBase = thisMotion.getCurrentKeyframe(newTime);
		// optimization to detect when a keyframe is "holding" for several frames and not tweening
		var isHoldKeyframe:Bool = (curKeyframe.index == _lastRenderedTime
			&& (!thisMotionArray || _lastRenderedMotion == thisMotion)
			&& !curKeyframe.tweensLength);
		if (isHoldKeyframe) {
			return newTime;
		}

		if (curKeyframe.blank) {
			this._target.visible = false;
		} else {
			if (this._isAnimator3D) {
				_lastMatrixApplied = null;
				setTime3D(newTime, thisMotion);
			} else {
				_lastMatrix3DApplied = null;
				setTimeClassic(newTime, thisMotion, curKeyframe);
			}

			var colorTransform:ColorTransform = thisMotion.getColorTransform(newTime);
			if (thisMotionArray != null) {
				if (colorTransform == null && _lastColorTransformApplied != null) {
					colorTransform = new ColorTransform();
				}
				if (colorTransform != null
					&& (_lastColorTransformApplied == null || !colorTransformsEqual(colorTransform, _lastColorTransformApplied))) {
					this._target.transform.colorTransform = colorTransform;
					_lastColorTransformApplied = colorTransform;
				}
			} else if (colorTransform != null) {
				this._target.transform.colorTransform = colorTransform;
			}

			var filters:Array<Dynamic> = thisMotion.getFilters(newTime);
			if (thisMotionArray != null && filters == null && _filtersApplied) {
				this._target.filters = null;
				_filtersApplied = false;
			} else if (filters != null) {
				this._target.filters = filters;
				_filtersApplied = true;
			}

			if (thisMotionArray == null || _lastBlendModeApplied != curKeyframe.blendMode) {
				this._target.blendMode = curKeyframe.blendMode;
				_lastBlendModeApplied = curKeyframe.blendMode;
			}

			if (thisMotionArray == null || _lastOpaqueBackgroundApplied != curKeyframe.opaqueBackground || !_opaqueBackgroundHasBeenApplied) {
				this._target.opaqueBackground = curKeyframe.opaqueBackground;
				_opaqueBackgroundHasBeenApplied = true;
				_lastOpaqueBackgroundApplied = curKeyframe.opaqueBackground;
			}

			if (thisMotionArray == null || _lastVisibleApplied != curKeyframe.visible || !_visibleHasBeenApplied) {
				this._target.visible = curKeyframe.visible;
				_visibleHasBeenApplied = true;
				_lastVisibleApplied = curKeyframe.visible;
			}
		}

		this._lastRenderedTime = newTime;
		this._lastRenderedMotion = thisMotion;
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_UPDATE));
		return newTime;
	}

	/**
	 * @private
	 */
	private static function colorTransformsEqual(a:ColorTransform, b:ColorTransform):Bool {
		return (a.alphaMultiplier == b.alphaMultiplier
			&& a.alphaOffset == b.alphaOffset
			&& a.blueMultiplier == b.blueMultiplier
			&& a.blueOffset == b.blueOffset
			&& a.greenMultiplier == b.greenMultiplier
			&& a.greenOffset == b.greenOffset
			&& a.redMultiplier == b.redMultiplier
			&& a.redOffset == b.redOffset);
	}

	/**
	 * @private
	 */
	private function setTime3D(newTime:Int, thisMotion:MotionBase):Bool {
		return false;
	}

	/**
	 * @private
	 */
	private function setTimeClassic(newTime:Int, thisMotion:MotionBase, curKeyframe:KeyframeBase):Bool {
		return false;
	}

	private var _targetParent:DisplayObjectContainer = null;
	private var _targetParentBtn:SimpleButton = null;
	private var _targetName:String = "";
	private var targetStateOriginal:Dynamic = null;
	private var _placeholderName:String = null;
	private var _instanceFactoryClass:Class<Dynamic> = null;
	private var instanceFactory:Dynamic = null;

	/**
	 * The target parent <code>DisplayObjectContainer</code> being animated, which can be used in conjunction with <code>targetName</code>
	 * to retrieve the target object after it is removed and then replaced on the timeline.
	 */
	private function get_targetParent():DisplayObjectContainer {
		return _targetParent;
	}

	private function set_targetParent(p:DisplayObjectContainer):DisplayObjectContainer {
		_targetParent = p;
		return p;
	}

	/**
	 * @protected
	 */
	private function get_targetParentButton():SimpleButton {
		return _targetParentBtn;
	}

	private function set_targetParentButton(p:SimpleButton):SimpleButton {
		_targetParentBtn = p;
		return p;
	}

	/**
	 * The name of the target object as seen by the parent <code>DisplayObjectContainer</code>.
	 * This can be used in conjunction with <code>targetParent</code> to retrieve the target object after it is removed and then replaced on the timeline.
	 */
	private function get_targetName():String {
		return _targetName;
	}

	private function set_targetName(n:String):String {
		_targetName = n;
		return n;
	}

	/**
	 * When creating instances with ActionScript, this is the instance that appears on stage that we will replace.
	 */
	private function get_placeholderName():String {
		return _placeholderName;
	}

	private function set_placeholderName(n:String):String {
		_placeholderName = n;
		return n;
	}

	/**
	 * When creating instances with ActionScript, this is the class that creates the instance.
	 */
	private function get_instanceFactoryClass():Class<Dynamic> {
		return _instanceFactoryClass;
	}

	private function set_instanceFactoryClass(f:Class<Dynamic>):Class<Dynamic> {
		if (f == _instanceFactoryClass) {
			return f;
		}
		_instanceFactoryClass = f;
		try {
			instanceFactory = Reflect.field(_instanceFactoryClass, "getSingleton")();
		} catch (e:Error) {
			instanceFactory = null;
		}
		return f;
	}

	private var _useCurrentFrame:Bool = false;

	/**
	 * Sets the <code>currentFrame</code> property whenever a new frame is entered, and
	 * sets whether the target's animation is synchronized to the frames in its parent MovieClips's timeline.
	 * <code>spanStart</code> is the start frame of the animation in terms of the parent's timeline.
	 * If <code>enable</code> is <code>true</code>, then in any given enter frame event within the span of the animation,
	 * the <code>time</code> property is set to a frame number relative to the <code>spanStart</code> frame.
	 *
	 * <p>For example, if a 4-frame animation starts on frame 5 (<code>spanStart=5</code>),
	 * and you have a script on frame 5 to <code>gotoAndPlay</code> frame 8,
	 * then upon entering frame 8 the time property is set to <code>3</code> (skipping <code>time = 1</code>
	 * and <code>time = 2</code>).</p>
	 * @param enable The true or false value that determines whether the currentFrame property is checked.
	 * @param spanStart The start frame of the animation in terms of the parent MovieClip's timeline.
	 */
	public function useCurrentFrame(enable:Bool, spanStart:Int):Void {
		_useCurrentFrame = enable;
		if (motionArray == null) {
			_spanStart = spanStart;
		}
	}

	/**
	 * Indicates whether the <code>currentFrame</code> property is checked whenever a new frame is entered and
	 * whether the target's animation is synchronized to the frames in its parent's timeline,
	 * or always advancing no matter what the parent's current frame is.
	 */
	private function get_usingCurrentFrame():Bool {
		return _useCurrentFrame;
	}

	private var _spanStart:Int = -1;
	private var _spanEnd:Int = -1;

	/**
	 * Returns the frame of the target's parent on which the animation of the target begins.
	 */
	private function get_spanStart():Int {
		return _spanStart;
	}

	/**
	 * Returns the frame of the target's parent on which the animation of the target ends.
	 * This value is determined using <code>spanStart</code> and the motion's <code>duration</code> property.
	 */
	private function get_spanEnd():Int {
		if (_spanEnd >= 0) {
			return _spanEnd;
		}
		if (this._motion && this._motion.duration > 0) {
			return as3hx.Compat.parseInt(_spanStart + this._motion.duration - 1);
		}

		return _spanStart;
	}

	// for animations that we actually export (for 3d), we have
	// to track the scenes that contain them in order to determine
	// whether or not they should play - the parent timeline's frame
	// number is not enough
	private var _sceneName:String = "";

	/**
	 * A reference for exported scenes, for 3D motion, so the scene can be loaded into a parent timeline.
	 */
	private function get_sceneName():String {
		return this._sceneName;
	}

	private function set_sceneName(name:String):String {
		this._sceneName = name;
		return name;
	}

	/**
	 * Registers the given <code>MovieClip</code> and an <code>AnimatorBase</code> instance for a child of that <code>MovieClip</code>.
	 * The parent MovieClip's <code>FRAME_CONSTRUCTED</code> events are processed,
	 * and its <code>currentFrame</code> and the AnimatorBase's <code>spanStart</code> properties
	 * are used to determine the current relative frame of the animation that should be playing.
	 * <p>Calling this function automatically sets the AnimatorBase's <code>useCurrentFrame</code> property to <code>true</code>,
	 * and its <code>spanStart</code> property using the parameter of the same name.</p>
	 * @param parent The parent MovieClip of the AnimatorBase instance.
	 * @param anim The AnimatorBase instance associated with the parent MovieClip.
	 * @param spanStart The start frame of the animation in terms of the parent MovieClip's timeline.
	 * @param repeatCount The number of times the animation should play. The default value is 0, which means the animation will loop indefinitely.
	 * @param useCurrentFrame Indicates whether the useCurrentFrame property is checked whenever a new frame is entered.
	 */
	public static function registerParentFrameHandler(parent:MovieClip, anim:AnimatorBase, spanStart:Int,
		repeatCount:Int = 0, useCurrentFrame:Bool = false):Void {
		anim._registeredParent = true;
		if (spanStart == -1) {
			spanStart = as3hx.Compat.parseInt(parent.currentFrame - 1);
		}

		if (useCurrentFrame) {
			anim.useCurrentFrame(true, spanStart);
		} else {
			// if we're not trying to adhere to the parent's timeline,
			// then we'll just keep looping the animation by default
			anim.repeatCount = repeatCount;
		}
	}

	private function handleEnterFrame(evt:Event):Void {
		if (_registeredParent) {
			var parent:MovieClip = try cast(this._targetParent, MovieClip) catch (e:Dynamic) null;
			if (parent == null) {
				return;
			}

			// if the current frame of this parent is the same as the last one
			// we processed, and we are in the usingCurrentFrame mode for the
			// animation, then don't reprocess the frame. this has to be done
			// at the parent level instead of within the animation because there
			// can be multiple Animators for a given child object (but they would
			// never overlap frames). ALSO we always need to process the frame
			// again if target == null when there is an instanceFactoryClass
			// to deal with the case where the instance could not be created
			// immediately, which could be due to waiting for RSL to download issues.
			if (!this.usingCurrentFrame
				|| parent.currentFrame != this._lastFrameHandled
				|| parent.currentScene.name != this._lastSceneHandled
				|| (this.target == null && this.instanceFactoryClass != null)) {
				processCurrentFrame(parent, this, false);
			}

			// see if there are any instances that need to be removed from timeline
			this.removeChildren();

			this._lastFrameHandled = parent.currentFrame;
			this._lastSceneHandled = parent.currentScene.name;
		} else {
			this.nextFrame();
		}
	}

	private function removeChildren():Void {
		var i:Int = 0;
		while (i < _toRemove.length) {
			var obj:Dynamic = _toRemove[i];
			if (obj.target == _target || obj.target.parent != _targetParent) {
				// just remove from array, no need to removeChild
				_toRemove.splice(i, 1);
			} else {
				var mc:MovieClip = cast((_targetParent), MovieClip);
				if (obj.currentFrame == mc.currentFrame && (mc.scenes.length <= 1 || obj.currentSceneName == mc.currentScene.name)) {
					// leave for now, keep checking
					i++;
				} else {
					// removeChild
					removeChildTarget(mc, obj.target, obj.target.name);
					_toRemove.splice(i, 1);
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function removeChildTarget(parent:MovieClip, child:DisplayObject, childName:String):Void {
		parent.removeChild(child);
		if (parent.exists(childName) && Reflect.field(parent, childName) == child) {
			Reflect.setField(parent, childName, null);
		}

		_lastColorTransformApplied = null;
		_filtersApplied = false;
		_lastBlendModeApplied = null;
		_cacheAsBitmapHasBeenApplied = false;
		_opaqueBackgroundHasBeenApplied = false;
		_visibleHasBeenApplied = false;
		_lastMatrixApplied = null;
		_lastMatrix3DApplied = null;
	}

	public static function processCurrentFrame(parent:MovieClip, anim:AnimatorBase, startEnterFrame:Bool,
		playOnly:Bool = false):Void {
		if (anim != null && parent != null) {
			if (anim.usingCurrentFrame) {
				// if the animator is not playing but the playhead
				// has jumped to a frame that's part of the animation,
				// then start it up
				var curFrame:Int = as3hx.Compat.parseInt(parent.currentFrame - 1);

				// check to make sure we're in the right scene for this
				// animation - if there's only one scene then don't bother
				// checking
				if (parent.scenes.length > 1) {
					if (parent.currentScene.name != anim.sceneName) {
						curFrame = -1;
					}
				}

				if (curFrame >= anim.spanStart && curFrame <= anim.spanEnd) {
					var curRelativeFrame:Int = ((anim.motionArray)) ? curFrame : curFrame - anim.spanStart;
					if (!anim.isPlaying) {
						anim.play(curRelativeFrame, startEnterFrame);
					} else if (!playOnly) {
						if (curFrame == anim.spanEnd) {
							anim.handleLastFrame(true, false);
						} else {
							anim.time = curRelativeFrame;
						}
					}
				} else {
					// otherwise, if it is playing but the playhead
					// has moved out of the span of the animation, then  // stop it  if (anim.isPlaying && !playOnly)
					anim.end(true, false, true);
				}
			else if (!anim.isPlaying && playOnly) {
				anim.startFrameEvents();
			}
			} else if (anim.targetParent
				&& ((anim.targetParent.exists(anim.targetName) && anim.targetParent[anim.targetName] == null)
					|| anim.targetParent.getChildByName(anim.targetName) == null)) {
				if (anim.isPlaying) {
					anim.end(true, false);
				} else if (playOnly) {
					anim.startFrameEvents();
				}
			} else if (!anim.isPlaying) {
				if (playOnly) {
					anim.play(0, startEnterFrame);
				}
			} else if (!playOnly) {
				anim.nextFrame(false, false);
			}
		}
	}

	private var _frameEvent:String = Event.ENTER_FRAME; // default to using ENTER_FRAME, but can also used FRAME_CONSTRUCTED

	/**
	 		 * The name of the event object created by the <code>Event.ENTER_FRAME</code> event.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 */
	private function get_frameEvent():String {
		return _frameEvent;
	}

	private function set_frameEvent(evt:String):String {
		_frameEvent = evt;
		return evt;
	}

	private var _targetState3D:Array<Dynamic> = null;

	/**
	 		 * The initial orientation for the target object. All 3D rotation is absolute to the motion data.
	 		 * If you target another object that has a different starting 3D orientation, it is reset to this target state first.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 */
	private function get_targetState3D():Array<Dynamic> {
		return _targetState3D;
	}

	private function set_targetState3D(state:Array<Dynamic>):Array<Dynamic> {
		_targetState3D = state;
		return state;
	}

	/**
	 * @private
	 */
	private var _isAnimator3D:Bool;

	/**
	 * @private
	 */
	public static function registerButtonState(targetParentBtn:SimpleButton, anim:AnimatorBase, stateFrame:Int,
		zIndex:Int = -1, targetName:String = null, placeholderName:String = null,
		instanceFactoryClass:Class<Dynamic> = null):Void {
		var target:DisplayObject = targetParentBtn.upState;
		switch (stateFrame) {
			case 1:
				{
					target = targetParentBtn.overState;
				}
			case 2:
				{
					target = targetParentBtn.downState;
				}
			case 3:
				{
					target = targetParentBtn.hitTestState;
				}
		}


		if (target == null) {
			return;
		}


		if (zIndex >= 0) {
			var newTarget:DisplayObject;
			try {
				var container:DisplayObjectContainer = cast((target), DisplayObjectContainer);
				newTarget = container.getChildAt(zIndex);
			} catch (e:Error) {
				newTarget = null;
			}
			if (newTarget != null) {
				target = newTarget;
			}
		}


		anim.target = target;
		if (placeholderName != null && instanceFactoryClass != null) {
			anim.targetParentButton = targetParentBtn;
			anim.targetName = targetName;
			anim.instanceFactoryClass = instanceFactoryClass;
			anim.useCurrentFrame(true, stateFrame);
			anim.target.addEventListener(anim.frameEvent, anim.placeholderButtonEnterFrameHandler, false, 0, true);
			anim.placeholderButtonEnterFrameHandler(null);
		} else {
			anim.time = 0;
		}
	}

	/**
	 * @private
	 */
	public static function registerSpriteParent(targetParentSprite:Sprite, anim:AnimatorBase, targetName:String,
		placeholderName:String = null, instanceFactoryClass:Class<Dynamic> = null):Void {
		if (targetParentSprite == null || anim == null || targetName == null) {
			return;
		}


		var newTarget:DisplayObject;
		if (placeholderName != null && instanceFactoryClass != null) {
			newTarget = Reflect.field(targetParentSprite, placeholderName);
			if (newTarget == null) {
				newTarget = targetParentSprite.getChildByName(placeholderName);
			}
			anim.target = newTarget;
			anim.targetParent = targetParentSprite;
			anim.targetName = targetName;
			anim.placeholderName = placeholderName;
			anim.instanceFactoryClass = instanceFactoryClass;
			anim.useCurrentFrame(true, 0);
			anim.target.addEventListener(anim.frameEvent, anim.placeholderSpriteEnterFrameHandler, false, 0, true);
			anim.placeholderSpriteEnterFrameHandler(null);
		} else {
			newTarget = Reflect.field(targetParentSprite, targetName);
			if (newTarget == null) {
				newTarget = targetParentSprite.getChildByName(targetName);
			}
			anim.target = newTarget;
			anim.time = 0;
		}
	}

	/**
	 		 * Creates an AnimatorBase object to apply the XML-based motion tween description to a display object.
	 		 * If XML is null (which is the default value), then you can either supply XML directly to a Motion instance
	 		 * or you can set the arrays of property values in the Motion instance.
	 		 * @param xml An E4X object containing an XML-based motion tween description.
	 		 *
	 		 * @param target The display object using the motion tween.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 		 * @keyword AnimatorBase
	 		 * @see ../../motionXSD.html Motion XML Elements
	 */
	public function new(xml:Xml = null, target:DisplayObject = null) {
		super();
		this.target = target;
		this._isAnimator3D = false;
		this.transformationPoint = new Point(.5, .5);
		this.transformationPointZ = 0;
		this._sceneName = "";
		this._toRemove = new Array<Dynamic>();
		this._lastFrameHandled = -1;
		this._lastSceneHandled = null;
		this._registeredParent = false;
	}

	/**
	 		 * Advances Flash Player to the next frame in the animation sequence.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 		 * @keyword nextFrame
	 */
	public function nextFrame(reset:Bool = false, stopEnterFrame:Bool = true):Void {
		if ((motionArray != null && this.time >= spanEnd) || (motionArray == null && this.time >= this.motion.duration - 1)) {
			this.handleLastFrame(reset, stopEnterFrame);
		} else {
			this.time++;
		}
	}

	/**
	 		 *  Begins the animation. Call the <code>end()</code> method
	 		 *  before you call the <code>play()</code> method to ensure that any previous
	 		 *  instance of the animation has ended before you start a new one.
	 *  @playerversion Flash 9.0.28.0
	 *  @langversion 3.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS4
	 		 * @param startTime Indicates an alternate start time (relative frame) to use. If not specified, then the default start time of 0 is used. If motionArray is set to non-null, then startTime is not relative but absolute, just like the time property.
	 		 * @param startEnterFrame Indicates whether the event listener needs to be added to the parent in order to capture frame events.
	 		 * The value can be <code>false</code> if the parent was registered to its AnimatorBase instance via <code>registerParentFrameHandler()</code>.
	 		 * @keyword play, begin
	 		 * @see #end()
	 */
	public function play(startTime:Int = -1, startEnterFrame:Bool = true):Void {
		if (!this._isPlaying) {
			if (this._target == null && this._targetParent && this._targetName != "") {
				var newTarget:DisplayObject = (this._targetParent.exists(this._targetName)) ? this._targetParent[this._targetName] : this._targetParent.getChildByName(this._targetName);
				if (instanceFactory == null || Reflect.field(instanceFactory, "isTargetForFrame")(newTarget, startTime, sceneName)) {
					this.target = newTarget;
				}


				if (!this.target) {
					newTarget = this._targetParent.getChildByName(this._targetName);
					if (instanceFactory == null || Reflect.field(instanceFactory, "isTargetForFrame")(newTarget, startTime, sceneName)) {
						this.target = newTarget;
					}


					// get instance from the instanceFactory when appropriate
					if (!this.target && this._placeholderName && this.instanceFactory) {
						var newInstance:DisplayObject = this.instanceFactory["getInstance"](this._targetParent, this._targetName, startTime, sceneName);
						if (newInstance != null)
							// set up the name{


							newInstance.name = _targetName;
						Reflect.setField(_targetParent, _targetName, newInstance);


						// add target just under the placeholder, if we can find it
						var placeHolder:DisplayObject = this._targetParent[this._placeholderName];
						if (placeHolder == null) {
							placeHolder = this._targetParent.getChildByName(this._placeholderName);
						}
						if (placeHolder != null) {
							_targetParent.addChildAt(newInstance, _targetParent.getChildIndex(placeHolder) + 1);
						} else {
							_targetParent.addChild(newInstance);
						}
						this.target = newInstance;
					}
				}
			}
		}


		if (startEnterFrame) {
			enterFrameBeacon.addEventListener(frameEvent, this.handleEnterFrame, false, 0, true);
		}


		// if we still don't have a target object, get out of here - the
		// parent's enter frame handler will call play again when the target
		// should exist
		if (!this.target) {
			return;
		}


		this._isPlaying = true;
	}

	this.playCount = 0;
	// enterFrame event will fire on the following frame,
	// so call the time setter to update the position immediately
	if (startTime > -1) {
		this.time = startTime;
	} else {
		this.rewind();
	}
	this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_START));
} /**
 		 *  Stops the animation and Flash Player goes immediately to the last frame in the animation sequence.
 		 *  If the <code>autoRewind</code> property is set to <code>true</code>, Flash Player goes to the first
 		 * frame in the animation sequence.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 		 * @param reset Indicates whether <code>_lastRenderedTime</code> and <code>_target</code> should be reset to their original values.
 		 * <code>_target</code> only resets if <code>targetParent</code> and <code>targetName</code> have been supplied.
 		 * @keyword end, stop
 		 * @see #autoRewind
 */

public function end(reset:Bool = false, stopEnterFrame:Bool = true, pastLastFrame:Bool = false):Void {
	if (stopEnterFrame) {
		enterFrameBeacon.removeEventListener(frameEvent, this.handleEnterFrame);
	}
	this._isPlaying = false;
	this.playCount = 0;

	if (this.autoRewind) {
		this.rewind();
	} else if (this.motion && this.time != this.motion.duration - 1) {
		this.time = this.motion.duration - 1;
	} else if (motionArray != null && this.time != _spanEnd) {
		this.time = _spanEnd;
	}

	if (reset) {
		if (this._targetParent && this._targetName != "") {
			if (this._target
				&& this.instanceFactory
				&& Std.is(this._targetParent, MovieClip)
				&& this._targetParent == this._target.parent) {
				if (pastLastFrame) {
					removeChildTarget(cast((_targetParent), MovieClip), _target, _targetName);
				} else {
					var mc:MovieClip = cast((_targetParent), MovieClip);
					_toRemove.push({
						target: _target,
						currentFrame: mc.currentFrame,
						currentSceneName: mc.currentScene.name
					});
				}
			}
			this._target = null;
		}
		this._lastRenderedTime = -1;
		this._time = -1;
	}

	this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
}

/**
 		 *  Stops the animation and Flash Player goes back to the first frame in the animation sequence.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 		 * @keyword stop, end
 		 * @see #end()
 */
public function stop():Void {
	enterFrameBeacon.removeEventListener(frameEvent, this.handleEnterFrame);
	this._isPlaying = false;
	this.playCount = 0;
	this.rewind();
	this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
}

/**
 		 *  Pauses the animation until you call the <code>resume()</code> method.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 		 * @keyword pause
 		 * @see #resume()
 */
public function pause():Void {
	enterFrameBeacon.removeEventListener(frameEvent, this.handleEnterFrame);
	this._isPlaying = false;
}

/**
 		 *  Resumes the animation after it has been paused
 		 *  by the <code>pause()</code> method.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 		 * @keyword resume
 		 * @see #pause()
 */
public function resume():Void {
	enterFrameBeacon.addEventListener(frameEvent, this.handleEnterFrame, false, 0, true);
	this._isPlaying = true;
}

/**
 		 *  Initiates frame events.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 */
public function startFrameEvents():Void {
	enterFrameBeacon.addEventListener(frameEvent, this.handleEnterFrame, false, 0, true);
}

/**
 		 * Sets Flash Player to the first frame of the animation.
 		 * If the animation was playing, it continues playing from the first frame.
 		 * If the animation was stopped, it remains stopped at the first frame.
 *  @playerversion Flash 9.0.28.0
 *  @langversion 3.0
 *  @playerversion AIR 1.0
 *  @productversion Flash CS4
 		 * @keyword rewind
 */
public function rewind():Void {
	this.time = ((motionArray != null)) ? _spanStart : 0;
}

private function placeholderButtonEnterFrameHandler(e:Event):Void {
	if (_targetParentBtn == null || instanceFactory == null) {
		_target.removeEventListener(frameEvent, placeholderButtonEnterFrameHandler);
		return;
	}
	var realTarget:DisplayObject = Reflect.field(instanceFactory, "getInstance")(_targetParentBtn, _targetName, _spanStart);
	if (realTarget == null) {
		return;
	}
	_target.removeEventListener(frameEvent, placeholderButtonEnterFrameHandler);
	if (_target.parent == null || cast((_target.parent), DisplayObject) == _targetParentBtn) {
		switch (_spanStart) {
			case 1:
				_targetParentBtn.overState = realTarget;
			case 2:
				_targetParentBtn.downState = realTarget;
			case 3:
				_targetParentBtn.hitTestState = realTarget;
			default:
				_targetParentBtn.upState = realTarget;
		}
	} else {
		var theParent:DisplayObjectContainer = try cast(_target.parent, DisplayObjectContainer) catch (e:Dynamic) null;
		if (theParent != null) {
			theParent.addChildAt(realTarget, theParent.getChildIndex(_target) + 1);
			theParent.removeChild(_target);
		}
	}
	target = realTarget;
	time = 0;
}

private function placeholderSpriteEnterFrameHandler(e:Event):Void {
	if (_targetParent == null || instanceFactory == null) {
		_target.removeEventListener(frameEvent, placeholderSpriteEnterFrameHandler);
		return;
	}

	var realTarget:DisplayObject = Reflect.field(instanceFactory, "getInstance")(_targetParent, _targetName, 0);
	if (realTarget == null) {
		return;
	}

	// set up the name
	realTarget.name = _targetName;
	Reflect.setField(_targetParent, _targetName, realTarget);

	// remove placeholder, if we can find it
	_target.removeEventListener(frameEvent, placeholderSpriteEnterFrameHandler);
	Reflect.setField(_targetParent, _placeholderName, null);
	_targetParent.addChildAt(realTarget, _targetParent.getChildIndex(_target) + 1);
	_targetParent.removeChild(_target);
	target = realTarget;
	time = 0;
}

//////////////////////////////////////////////////////////////

/**
 * @private
 */
private var playCount:Int = 0;

/**
 * @private
 */
// This code is run just once, during the class initialization.
// Create a MovieClip to generate enterFrame events.
private static var enterFrameBeacon:MovieClip = new MovieClip();

/**
 * @private
 */
// The initial state of the target when assigned to the Animator.
private var targetState:Dynamic;

/**
 * @private
 */
private function handleLastFrame(reset:Bool = false, stopEnterFrame:Bool = true):Void {
	++this.playCount;
	if (this.repeatCount == 0 || this.playCount < this.repeatCount) {
		this.rewind();
	} else {
		this.end(reset, stopEnterFrame, false);
	}
}
}
