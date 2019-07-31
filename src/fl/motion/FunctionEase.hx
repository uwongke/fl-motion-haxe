// Copyright � 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import haxe.Constraints.Function;
import openfl.utils.*;

/**
 * The FunctionEase class allows custom interpolation functions to be used with
 * the fl.motion framework in place of other interpolations like SimpleEase and CustomEase.
 * The fl.motion framework includes several easing functions in the fl.motion.easing package.
 *
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword Ease, Copy Motion as ActionScript
 * @includeExample examples\FunctionEaseExample.as -noswf
 * @see ../../motionXSD.html Motion XML Elements
 * @see fl.motion.easing
 */
class FunctionEase implements ITween {
	public var functionName(get, set):String;
	public var target(get, set):String;

	/**
	 * @private
	 */
	private var _functionName:String = "";

	/**
	 * The fully qualified name of an easing function, such as <code>fl.motion.easing.Bounce.easeOut()</code>.
	 * The function must be a method of a class (Bounce, Cubic, Elastic, another class).
	 * If Flash Player cannot find the class, an exception is thrown.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Easing, Copy Motion as ActionScript
	 * @see fl.motion.easing
	 */
	private function get_functionName():String {
		return this._functionName;
	}

	/**
	 * @private (setter)
	 */
	private function set_functionName(newName:String):String {
		var parts:Array<Dynamic> = newName.split(".");
		var methodName:String = parts.pop();
		var className:String = parts.join(".");
		// This will generate an exception if the class cannot be found.
		var theClass:Class<Dynamic> = Type.getClass(Type.resolveClass(className));
		if (Std.is(Reflect.field(theClass, methodName), Function)) {
			this.easingFunction = Reflect.field(theClass, methodName);
			this._functionName = newName;
		}
		return newName;
	}

	/**
	 * A reference to a function with a <code>(t, b, c, d)</code> signature like
	 * the methods in the fl.motion.easing classes.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Easing, Copy Motion as ActionScript
	 * @see fl.motion.easing
	 */
	public var easingFunction:Function = null;

	/**
	 * An optional array of values to be passed to the easing function as additional arguments.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Easing, Copy Motion as ActionScript
	 */
	public var parameters:Array<Dynamic> = null;

	/**
	 * @private
	 */
	private var _target:String = "";

	/**
	 * The name of the animation property to target.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Easing, Copy Motion as ActionScript
	 * @see fl.motion.ITween#target
	 */
	private function get_target():String {
		return this._target;
	}

	/**
	 * @private (setter)
	 */
	private function set_target(value:String):String {
		this._target = value;
		return value;
	}

	/**
	 * Constructor for FunctionEase instances.
	 *
	 * @param xml An optional E4X XML instance.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Easing, Copy Motion as ActionScript
	 * @see ../../motionXSD.html Motion XML Elements
	 */
	public function new(xml:Xml = null) {
		this.parseXML(xml);
	}

	/**
	 * @private
	 */
	private function parseXML(xml:Xml = null):FunctionEase {
		if (xml == null) {
			return this;
		}

		if (xml.att.functionName.length()) {
			this.functionName = xml.att.functionName;
		}
		if (xml.att.target.length()) {
			this.target = xml.att.target;
		}
		return this;
	}

	/**
	 		 * Calculates an interpolated value for a numerical property of animation,
	 		 * using the specified easing function.
	 		 * If the <code>parameters</code> array has been set beforehand,
	 		 * those values will be passed to the easing function in addition to the
	 		 * time, begin, change, and duration values.
	 		 *
	 		 * @param time The time value, which must lie between <code>0</code> and <code>duration</code>, inclusive.
	 		 * You can choose any unit (for example, frames, seconds, milliseconds),
	 		 * but your choice must match the <code>duration</code> unit.
	 *
	 		 * @param begin The value of the animation property at the start of the tween, when time is 0.
	 		 *
	 		 * @param change The change in the value of the animation property over the course of the tween.
	 		 * The value can be positive or negative. For example, if an object rotates from 90 to 60 degrees, the <code>change</code> is -30.
	 		 *
	 		 * @param duration The length of time for the tween. Must be greater than zero.
	 		 * You can choose any unit (for example, frames, seconds, milliseconds),
	 		 * but your choice must match the <code>time</code> unit.
	 		 *
	 		 * @return The interpolated value at the specified time.
	 		 * @playerversion Flash 9.0.28.0
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @keyword Easing, Copy Motion as ActionScript
	 */
	public function getValue(time:Float, begin:Float, change:Float, duration:Float):Float {
		if (Std.is(this.parameters, Array)) {
			var args:Array<Dynamic> = [time, begin, change, duration].concat(this.parameters);
			return this.easingFunction.apply(null, args);
		}

		return this.easingFunction(time, begin, change, duration);
	}
}
