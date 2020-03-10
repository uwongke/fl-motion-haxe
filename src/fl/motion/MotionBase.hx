// Copyright ? 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import openfl.filters.*;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.utils.*;

/**
 * The MotionBase class stores a keyframe animation sequence that can be applied to a visual object.
 * The animation data includes position, scale, rotation, skew, color, filters, and easing.
 * The MotionBase class has methods for retrieving data at specific keyframe points. To get
 * interpolated values between keyframes, use the Motion class.
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword Motion, Copy Motion as ActionScript
 * @includeExample examples\MotionBaseExample.as -noswf
 * @see fl.motion.Motion Motion class
 * @see ../../motionXSD.html Motion XML Elements
 */
class MotionBase {
	private var spanStart(get, set):Int;
	private var transformationPoint(get, set):Point;
	private var transformationPointZ(get, set):Int;
	private var initialPosition(get, set):Array<Dynamic>;
	private var initialMatrix(get, set):Matrix;

	public var duration(get, set):Int;
	public var is3D(get, set):Bool;

	/**
	 * An array of keyframes that define the motion's behavior over time.
	 * This property is a sparse array, where a keyframe is placed at an index in the array
	 * that matches its own index. A motion object with keyframes at 0 and 5 has
	 * a keyframes array with a length of 6.
	 * Indices 0 and 5 in the array each contain a keyframe,
	 * and indices 1 through 4 have null values.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	public var keyframes:Array<KeyframeBase>;

	/**
	 * Constructor for MotionBase instances.
	 * By default, one initial keyframe is created automatically, with default transform properties.
	 *
	 * @param xml Optional E4X XML object defining a Motion instance.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	public function new(xml:Xml = null) {
		this.keyframes = [];

		// ensure there is at least one keyframe
		if (duration == 0) {
			var kf:KeyframeBase = getNewKeyframe();
			kf.index = 0;
			addKeyframe(kf);
		}

		_overrideScale = false;
		_overrideSkew = false;
		_overrideRotate = false;
	}

	/**
	 * @private
	 */
	private var _spanStart:Int;

	/**
	 * Used when an array of MotionBase instances are passed into a AnimatorBase subclass.
	 */
	private function set_spanStart(v:Int):Int {
		_spanStart = v;
		return v;
	}

	/**
	 * @private
	 */
	private function get_spanStart():Int {
		return _spanStart;
	}

	/**
	 * @private
	 */
	private var _transformationPoint:Point;

	/**
	 * Used when an array of MotionBase instances are passed into a AnimatorBase subclass.
	 */
	private function set_transformationPoint(v:Point):Point {
		_transformationPoint = v;
		return v;
	}

	/**
	 * @private
	 */
	private function get_transformationPoint():Point {
		return _transformationPoint;
	}

	/**
	 * @private
	 */
	private var _transformationPointZ:Int;

	/**
	 * Used when an array of MotionBase instances are passed into a AnimatorBase subclass.
	 */
	private function set_transformationPointZ(v:Int):Int {
		_transformationPointZ = v;
		return v;
	}

	/**
	 * @private
	 */
	private function get_transformationPointZ():Int {
		return _transformationPointZ;
	}

	/**
	 * @private
	 */
	private var _initialPosition:Array<Dynamic>;

	/**
	 * Used when an array of MotionBase instances are passed into a AnimatorBase subclass.
	 */
	private function set_initialPosition(v:Array<Dynamic>):Array<Dynamic> {
		_initialPosition = v;
		return v;
	}

	/**
	 * @private
	 */
	private function get_initialPosition():Array<Dynamic> {
		return _initialPosition;
	}

	/**
	 * @private
	 */
	private var _initialMatrix:Matrix;

	/**
	 * Used when an array of MotionBase instances are passed into a AnimatorBase subclass.
	 */
	private function set_initialMatrix(v:Matrix):Matrix {
		_initialMatrix = v;
		return v;
	}

	/**
	 * @private
	 */
	private function get_initialMatrix():Matrix {
		return _initialMatrix;
	}

	/**
	 * @private
	 */
	private var _duration:Int = 0;

	/**
	 * Controls the Motion instance's length of time, measured in frames.
	 * The duration cannot be less than the time occupied by the Motion instance's keyframes.
	 * @default 0
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	private function get_duration():Int // check again on the getter because the keyframes array may have changed after the setter was called
	{
		if (this._duration < this.keyframes.length) {
			this._duration = this.keyframes.length;
		}
		return this._duration;
	}

	/**
	 * @private (setter)
	 */
	private function set_duration(value:Int):Int {
		if (value < this.keyframes.length) {
			value = this.keyframes.length;
		}
		this._duration = value;
		return value;
	}

	private var _is3D:Bool = false;

	/**
	 * Specifies whether the motion contains 3D property changes. If <code>true</code>, the
	 * motion contains 3D property changes.
	 * @default false
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	private function get_is3D():Bool {
		return _is3D;
	}

	/**
	 * Sets flag that indicates whether the motion contains 3D properties.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	private function set_is3D(enable:Bool):Bool {
		_is3D = enable;
		return enable;
	}

	/**
	 * Indicates whether property values for scale, skew, and rotate added in subsequent
	 * calls to addPropertyArray should be made relative to the first value, or used as-is,
	 * such that they override the target object's initial target transform.
	 */
	private var _overrideScale:Bool;

	private var _overrideSkew:Bool;
	private var _overrideRotate:Bool;

	public function overrideTargetTransform(scale:Bool = true, skew:Bool = true, rotate:Bool = true):Void {
		_overrideScale = scale;
		_overrideSkew = skew;
		_overrideRotate = rotate;
	}

	/**
	 * @private
	 */
	private function indexOutOfRange(index:Int):Bool {
		return (Math.isNaN(index) || index < 0 || index > this.duration - 1);
	}

	/**
	 * Retrieves the keyframe that is currently active at a specific frame in the Motion instance.
	 * A frame that is not a keyframe derives its values from the keyframe that preceded it.
	 *
	 * <p>This method can also filter values by the name of a specific tweenables property.
	 * You can find the currently active keyframe for <code>x</code>, which may not be
	 * the same as the currently active keyframe in general.</p>
	 *
	 * @param index The index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 *
	 		 * @param tweenableName Optional name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
	 *
	 * @return The closest matching keyframe at or before the supplied frame index.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see fl.motion.Tweenables
	 */
	public function getCurrentKeyframe(index:Int,
		tweenableName:String = ""):KeyframeBase // catch out-of-range frame values
	{
		if (Math.isNaN(index) || index < 0 || index > this.duration - 1) {
			return null;
		}
		// start at the given time and go backward until we hit a keyframe that matches
		var i:Int = index;
		while (i > 0) {
			var kf:KeyframeBase = this.keyframes[i];
			// if a keyframe exists, return it if the name matches or no name was given,
			// or if it's tweening all properties
			if (kf != null && kf.affectsTweenable(tweenableName)) {
				return kf;
			}
			i--;
		}
		// return the first keyframe if no other match
		return this.keyframes[0];
	}

	/**
	 * Retrieves the next keyframe after a specific frame in the Motion instance.
	 * If a frame is not a keyframe, and is in the middle of a tween,
	 * this method derives its values from both the preceding keyframe and the following keyframe.
	 *
	 * <p>This method also allows you to filter by the name of a specific tweenables property
	 		 * to find the next keyframe for a property, which might not be
	 * the same as the next keyframe in general.</p>
	 *
	 * @param index The index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 *
	 		 * @param tweenableName Optional name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
	 *
	 * @return The closest matching keyframe after the supplied frame index.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see fl.motion.Tweenables
	 */
	public function getNextKeyframe(index:Int, tweenableName:String = ""):KeyframeBase // catch out-of-range frame values
	{
		if (Math.isNaN(index) || index < 0 || index > this.duration - 1) {
			return null;
		}

		// start just after the given time and go forward until we hit a keyframe that matches
		var i:Int = as3hx.Compat.parseInt(index + 1);
		while (i < this.keyframes.length) {
			var kf:KeyframeBase = this.keyframes[i];
			// if a keyframe exists, return it if no name was given or the name matches or there's a keyframe tween
			if (kf != null && kf.affectsTweenable(tweenableName)) {
				return kf;
			}
			i++;
		}
		return null;
	}

	/**
	 		 * Sets the value of a specific tweenables property at a given time index in the Motion instance.
	 		 * If a keyframe doesn't exist at the index, one is created automatically.
	 		 *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than zero.
	 * If the index is zero, no change is made.
	 * Transformation properties are relative to the starting transformation values of the target object,
	 * the values for the first frame (zero index value) are always default values and should not be changed.
	 		 *
	 		 * @param tweenableName The name of a tweenable's property as a string (like <code>"x"</code> or <code>"rotation"</code>).
	 		 *
	 		 * @param value The new value of the tweenable property.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see fl.motion.Tweenables
	 */
	public function setValue(index:Int, tweenableName:String, value:Float):Void {
		if (index == 0) {
			return;
		}

		var kf:KeyframeBase = this.keyframes[index];
		if (kf == null) {
			kf = getNewKeyframe();
			kf.index = index;
			this.addKeyframe(kf);
		}

		kf.setValue(tweenableName, value);
	}

	/**
	 		 * Retrieves an interpolated ColorTransform object at a specific time index in the Motion instance.
	 		 *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 		 *
	 		 * @return The interpolated ColorTransform object.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see flash.geom.ColorTransform
	 */
	public function getColorTransform(index:Int):ColorTransform {
		var result:ColorTransform = null;
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, "color");
		if (curKeyframe == null || curKeyframe.color == null) {
			return null;
		}

		var begin:ColorTransform = curKeyframe.color;
		var timeFromKeyframe:Float = index - curKeyframe.index;

		if (timeFromKeyframe == 0) {
			result = begin;
		}

		return result;
	}

	/**
	 * Returns the Matrix3D object for the specified index position of
	 * the frame of animation.
	 * @param index The zero-based index position of the frame of animation containing the 3D matrix.
	 * @return The Matrix3D object, or null value. This method can return a null value even if
	 * <code>MotionBase.is3D</code> is <code>true</code>, because other 3D motion tween property changes can be used
	 * without a Matrix3D object.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see flash.geom.Matrix3D
	 */
	public function getMatrix3D(index:Int):Dynamic {
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, "matrix3D");
		return (curKeyframe != null) ? curKeyframe.matrix3D : null;
	}

	/**
	 * Returns the Matrix object for the specified index position of
	 * the frame of animation.
	 * @param index The zero-based index position of the frame of animation containing the matrix.
	 * @return The Matrix object, or null value. This method can return a null value even if
	 * <code>MotionBase.is3D</code> is <code>false</code>, because other motion tween property changes can be used
	 * without a Matrix object.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see flash.geom.Matrix
	 */
	public function getMatrix(index:Int):Matrix {
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, "matrix");
		return (curKeyframe != null) ? curKeyframe.matrix : null;
	}

	/**
	 * Rotates the target object when data for the motion is supplied by the <code>addPropertyArray()</code> method.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @param index The index position of the frame of animation.
	 * @return Indicates whether the target object will rotate using the stored property from
	 * <code>KeyframeBase.rotationConcat</code>.
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see #addPropertyArray()
	 * @see fl.motion.KeyframeBase#rotationConcat
	 */
	public function useRotationConcat(index:Int):Bool {
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, "rotationConcat");
		return (curKeyframe != null) ? curKeyframe.useRotationConcat : false;
	}

	/**
	 		 * Retrieves an interpolated array of filters at a specific time index in the Motion instance.
	 		 *
	 * @param index The time index of a frame in the Motion, as an integer greater than or equal to zero.
	 		 *
	 		 * @return The interpolated array of filters.
	 		 * If there are no applicable filters, returns an empty array.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see flash.filters
	 */
	public function getFilters(index:Int):Array<Dynamic> {
		var result:Array<Dynamic> = null;
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, "filters");
		if (curKeyframe == null || (curKeyframe.filters != null && curKeyframe.filters.length == 0)) {
			return [];
		}

		var begin:Array<Dynamic> = curKeyframe.filters;
		var timeFromKeyframe:Float = index - curKeyframe.index;

		if (timeFromKeyframe == 0) {
			result = begin;
		}

		return result;
	}

	/**
	 * @private
	 */
	private function findTweenedValue(index:Int, tweenableName:String, curKeyframeBase:KeyframeBase,
		timeFromKeyframe:Float, begin:Float):Float {
		return Math.NaN;
	}

	/**
	 		 * Retrieves the value for an animation property at a point in time.
	 		 *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than or equal to zero.
	 		 *
	 		 * @param tweenableName The name of a tweenable's property (like <code>"x"</code> or <code>"rotation"</code>).
	 		 * @return The number value for the property specified in the <code>tweenableName</code> parameter.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Motion, Copy Motion as ActionScript
	 		 * @see fl.motion.Tweenables
	 */
	public function getValue(index:Int, tweenableName:String):Float {
		var result:Float = Math.NaN;

		// range checking is done in getCurrentKeyindex()
		var curKeyframe:KeyframeBase = this.getCurrentKeyframe(index, tweenableName);
		if (curKeyframe == null || curKeyframe.blank) {
			return Math.NaN;
		}

		var begin:Float = curKeyframe.getValue(tweenableName);

		// If the property isn't defined at this keyframe,
		// we have to figure out what it should be at this time,
		// so grab the value from the previous keyframe--works recursively.
		if (Math.isNaN(begin) && curKeyframe.index > 0) {
			//var prevKeyframe:KeyframeBase = this.getCurrentKeyframe(curKeyframe.index-1, tweenableName);
			begin = this.getValue(curKeyframe.index - 1, tweenableName);
		}

		if (Math.isNaN(begin)) {
			return Math.NaN;
		}
		var timeFromKeyframe:Float = index - curKeyframe.index;
		// if we're right on the first keyframe, use the value defined on it
		if (timeFromKeyframe == 0) {
			return begin;
		}
		result = findTweenedValue(index, tweenableName, curKeyframe, timeFromKeyframe, begin);
		return result;
	}

	/**
	 * Adds a keyframe object to the Motion instance.
	 *
	 * @param newKeyframe A keyframe object with an index property already set.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe
	 */
	public function addKeyframe(newKeyframe:KeyframeBase):Void {
		this.keyframes[newKeyframe.index] = newKeyframe;
		if (this.duration < this.keyframes.length) {
			this.duration = this.keyframes.length;
		}
	}

	/**
	 * Stores an array of values in corresponding keyframes for a declared property of the Motion class.
	 * The order of the values in the array determines the assignment of each value to a keyframe. For each
	 * non-null value in the given <code>values</code> array, this method finds the keyframe
	 * corresponding to the value's index position in the array, or creates a new keyframe for that index
	 * position, and stores the property name/value pair in the keyframe.
	 *
	 * @param name The name of the Motion class property to store in each keyframe.
	 *
	 * @param values The array of values for the property specified in the <code>name</code>
	 * parameter. Each non-null value is assigned to a keyframe that corresponds to the value's
	 * order in the array.
	 *
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see fl.motion.Motion
	 */
	public function addPropertyArray(name:String, values:Array<Dynamic>, startFrame:Int = -1, endFrame:Int = -1):Void {
		var numValues:Int = values.length;

		var lastValue:Dynamic = null;
		var useLastValue:Bool = true;
		var startNumValue:Float = 0;
		if (numValues > 0) {
			if (Std.is(values[0], Float)) {
				useLastValue = false;

				if (Std.is(values[0], Float)) {
					startNumValue = as3hx.Compat.parseFloat(values[0]);
				}
			}
		}

		// this should never be the case for motion code created by Flash authoring
		// it sets the duration property before calling this API
		if (this.duration < numValues) {
			this.duration = numValues;
		}

		if (startFrame == -1 || endFrame == -1) {
			startFrame = 0;
			endFrame = this.duration;
		}

		for (i in startFrame...endFrame) {
			// add a Keyframe for every changed value, since we're working
			// with frame-by-frame data
			var kf:KeyframeBase = cast((this.keyframes[i]), KeyframeBase);
			if (kf == null) {
				kf = getNewKeyframe();
				kf.index = i;
				this.addKeyframe(kf);
			}

			if (kf.filters != null && kf.filters.length == 0) {
				// Keyframes created using the property array APIs (as opposed to
				// the XML) should default to having a null filters property. it
				// will get set if initFilters/addFilterPropertyArray are called.
				kf.filters = null;
			}

			// use the last non-null value
			var curValue:Dynamic = lastValue;
			var valueIndex:Int = as3hx.Compat.parseInt(i - startFrame);
			if (valueIndex < values.length) {
				if (values[valueIndex] != null || !useLastValue) {
					curValue = values[valueIndex];
				}
			}
			switch (name) {
				case "blendMode", "matrix3D", "matrix", "cacheAsBitmap", "opaqueBackground", "visible":
					{
						Reflect.setField(kf, name, curValue);
					}
				case "rotationConcat":
					{
						// special case for rotation, in order to be
						// backwards-compatible with old rotation -
						// since the Matrix math needed to concat the
						// rotation requires radians, do the conversion here
						kf.useRotationConcat = true;
						if (!this._overrideRotate && !useLastValue) {
							kf.setValue(name, (curValue - startNumValue) * Math.PI / 180);
						} else {
							kf.setValue(name, curValue * Math.PI / 180);
						}
					}
				case "brightness", "tintMultiplier", "tintColor", "alphaMultiplier", "alphaOffset", "redMultiplier",
					"redOffset", "greenMultiplier", "greenOffset", "blueMultiplier", "blueOffset":
					{
						// color transform values can be set directly on
						// the keyframe's Color object (the names map to
						// property setters
						if (kf.color == null) {
							kf.color = new Color();
						}
						// kf.color[name] = curValue;
						Reflect.setProperty(kf.color, name, curValue);
					}
				case "rotationZ":
					{
						kf.useRotationConcat = true;
						this._is3D = true;
						if (!this._overrideRotate && !useLastValue) {
							kf.setValue("rotationConcat", curValue - startNumValue);
						} else {
							kf.setValue("rotationConcat", curValue);
						}
					}
				case "rotationX", "rotationY", "z":
					{
						// remember if any of the 3d properties get set
						// (aside from the special case matrix3D, which
						// will trump all the others
						this._is3D = true;
					}
				default:
					{
						var newValue:Dynamic = curValue;
						if (!useLastValue) {
							switch (name) {
								case "scaleX", "scaleY":
									{
										if (!this._overrideScale) {
											if (startNumValue == 0) {
												newValue = curValue + 1;
											} else {
												newValue = curValue / startNumValue;
											}
										}
									}
								case "skewX", "skewY":
									{
										if (!this._overrideSkew) {
											newValue = curValue - startNumValue;
										}
									}
								case "rotationX", "rotationY":
									{
										if (!this._overrideRotate) {
											newValue = curValue - startNumValue;
										}
									}
							}
						}
						kf.setValue(name, newValue);
						break;
					}
			}
			lastValue = curValue;
		}
	}

	/**
	 * Initializes the filters list for the target object and copies the list of filters to each Keyframe
	 * instance of the Motion object.
	 *
	 * @param filterClasses An array of filter classes. Each item in the array is the fully qualified
	 * class name (in String form) for the filter type occupying that index.
	 *
	 * @param gradientSubarrayLengths An array of numbers containing a value for every filter that will be in the filters
	 * list for the motion (every class name in the <code>filterClasses</code> array). A value in the
	 * <code>gradientSubarrayLengths</code> array is only used if the filter class entry at the same index position in the
	 * <code>filterClasses</code> array is GradientGlowFilter or GradientBevelFilter.
	 * The corresponding value in the <code>gradientSubarrayLengths</code> array is a number that determines the length for the arrays
	 * that initialize the <code>colors</code>, <code>alphas</code>, and <code>ratios</code> parameters for the
	 * GradientGlowFilter and GradientBevelFilter constructor functions.
	 *
	 *
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see flash.filters
	 * @see flash.filters.GradientGlowFilter
	 * @see flash.filters.GradientBevelFilter
	 */
	public function initFilters(filterClasses:Array<Dynamic>, gradientSubarrayLengths:Array<Dynamic>,
		startFrame:Int = -1, endFrame:Int = -1):Void { // create the filters arrays based on the filter class names that
		// we are given
		if (startFrame == -1 || endFrame == -1) {
			startFrame = 0;
			endFrame = this.duration;
		}

		var j:Int = 0;
		while (j < filterClasses.length) {
			var filterClass:Class<Dynamic> = Type.getClass(Type.resolveClass(filterClasses[j]));

			for (i in startFrame...endFrame) {
				var kf:KeyframeBase = cast((this.keyframes[i]), KeyframeBase);
				if (kf == null) {
					kf = getNewKeyframe();
					kf.index = i;
					this.addKeyframe(kf);
				}

				if (kf != null && kf.filters == null) {
					kf.filters = [];
				}

				if (kf != null && kf.filters != null) {
					var filter:BitmapFilter = null;
					var _sw0_ = (filterClasses[j]);

					switch (_sw0_) {
						case "flash.filters.GradientBevelFilter", "flash.filters.GradientGlowFilter":
							{
								throw "Can't instantiate filters that do not exist in OpenFL [GradientBevelFilter, GradientGlowFilter]";
								var subarrayLength:Int = gradientSubarrayLengths[j];
								// @formatter:off
								filter = cast((Type.createInstance(filterClass, [
									4,
									45,
									[for(n in 0...subarrayLength) null],
									[for(n in 0...subarrayLength) null],
									[for(n in 0...subarrayLength) null],
								])), BitmapFilter);
								// @formatter:on
							}
						default:
							{
								filter = cast((Type.createInstance(filterClass, [])), BitmapFilter);
								break;
							}
					}
					if (filter != null) {
						kf.filters.push(filter);
					}
				}
			}
			j++;
		}
	}

	/**
	 * Modifies a filter property in all corresponding keyframes for a Motion object. Call <code>initFilters()</code> before
	 * using this method. The order of the values in the array determines the assignment of each value
	 * to the filter property for all keyframes. For each non-null value in the specified <code>values</code>
	 * array, this method finds the keyframe corresponding to the value's index position in the array,
	 * and stores the property name/value pair for the filter in the keyframe.
	 *
	 * @param index The zero-based index position in the array of filters.
	 *
	 * @param name The name of the filter property to store in each keyframe.
	 *
	 * @param values The array of values for the property specified in the <code>name</code>
	 * parameter. Each non-null value is assigned to the filter in a keyframe that corresponds to
	 * the value's index in the array.
	 *
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see #initFilters()
	 * @see flash.filters
	 */
	public function addFilterPropertyArray(index:Int, name:String, values:Array<Dynamic>, startFrame:Int = -1,
		endFrame:Int = -1):Void {
		var numValues:Int = values.length;

		var lastValue:Dynamic = null;
		var useLastValue:Bool = true;
		if (numValues > 0) {
			if (Std.is(values[0], Float)) {
				useLastValue = false;
			}
		}

		// this should never be the case for motion code created by Flash authoring
		// it sets the duration property before calling this API
		if (this.duration < numValues) {
			this.duration = numValues;
		}

		if (startFrame == -1 || endFrame == -1) {
			startFrame = 0;
			endFrame = this.duration;
		}

		for (i in startFrame...endFrame) {
			// add a Keyframe for every changed value, since we're working
			// with frame-by-frame data
			var kf:KeyframeBase = cast((this.keyframes[i]), KeyframeBase);
			if (kf == null) {
				kf = getNewKeyframe();
				kf.index = i;
				this.addKeyframe(kf);
			}

			// use the last non-null value
			var curValue:Dynamic = lastValue;
			var valueIndex:Int = as3hx.Compat.parseInt(i - startFrame);
			if (valueIndex < values.length) {
				if (values[valueIndex] != null || !useLastValue) {
					curValue = values[valueIndex];
				}
			}

			switch (name) {
				case "adjustColorBrightness", "adjustColorContrast", "adjustColorSaturation", "adjustColorHue":
					{
						kf.setAdjustColorProperty(index, name, curValue);
					}
				default:
					{
						// get the filters Array
						if (index < kf.filters.length) {
							// kf.filters[index][name] = curValue;
							Reflect.setProperty(kf.filters[index], name, curValue);
						}
						break;
					}
			}

			lastValue = curValue;
		}
	}

	/**
	 * @private
	 */
	private function getNewKeyframe(xml:Xml = null):KeyframeBase {
		return new KeyframeBase(xml);
	}
}
