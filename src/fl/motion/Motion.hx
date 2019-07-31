// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import openfl.filters.*;
import openfl.geom.ColorTransform;
import openfl.utils.*;

@:meta(DefaultProperty(name = "keyframesCompact"))

/**
 * The Motion class stores a keyframe animation sequence that can be applied to a visual object.
 * The animation data includes position, scale, rotation, skew, color, filters, and easing.
 * The Motion class has methods for retrieving data at specific points in time, and
 * interpolating values between keyframes automatically.
 * <p><strong>Note:</strong> In Flash CS3, many of the properties and methods supported by this class were members of this class, exclusively.
 * Flash CS4 introduced a base class, KeyframeBase, for those
 * properties and methods of this class, and they are now shared by other classes through the inheritance chain. If you have been working in Flash CS3,
 * notice that these properties and methods are still supported by the Keyframe class, but are members of the KeyframeBase class in releases
 * of Flash Professional after Flash CS3. As with any other class in this reference, select Show Inherited Public Properties and Show Inherited Public Methods
 * to see all of the properties and methods supported by this class. </p>
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword Motion, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 */
class Motion extends MotionBase {
	public var keyframesCompact(get, set):Array<Dynamic>;

	/**
	 * An object that stores information about the context in which the motion was created,
	 * such as frame rate, dimensions, transformation point, and initial position, scale, rotation, and skew.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	public var source:Source;

	/**
	 * @private
	 */
	private var _keyframesCompact:Array<Dynamic>;

	/**
	 * A compact array of keyframes, where each index is occupied by a keyframe.
	 * By contrast, a sparse array has empty indices (as in the <code>keyframes</code> property).
	 * In the compact array, no <code>null</code> values are used to fill indices between keyframes.
	 * However, the index of a keyframe in <code>keyframesCompact</code> likely does not match its index in the <code>keyframes</code> array.
	 * <p>This property is primarily used for compatibility with the Flex MXML compiler,
	 * which generates a compact array from the motion XML.</p>
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see #keyframes
	 */
	private function get_keyframesCompact():Array<Dynamic> {
		this._keyframesCompact = [];
		/* FIXME: AS3HX WARNING could not determine type for var: kf exp: EField(EIdent(this),keyframes) type: null */
		for (kf in this.keyframes) {
			if (kf) {
				this._keyframesCompact.push(kf);
			}
		}
		return this._keyframesCompact;
	}

	/**
	 * @private (setter)
	 */
	@:meta(ArrayElementType(name = "fl.motion.Keyframe"))
	private function set_keyframesCompact(compactArray:Array<Dynamic>):Array<Dynamic> {
		this._keyframesCompact = compactArray.copy();
		this.keyframes = [];
		// FIXME: AS3HX WARNING could not determine type for var: kf exp: EField(EIdent(this),_keyframesCompact) type: null
		for (kf in this._keyframesCompact) {
			this.addKeyframe(kf);
		}
		return compactArray;
	}

	/**
	 * Constructor for Motion instances.
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
		super();
		this.keyframes = [];

		this.parseXML(xml);
		if (this.source == null) {
			this.source = new Source();
		}

		// ensure there is at least one keyframe
		if (this.duration == 0) {
			var kf:Keyframe = try cast(getNewKeyframe(), Keyframe) catch (e:Dynamic) null;
			kf.index = 0;
			this.addKeyframe(kf);
		}
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
	override public function getColorTransform(index:Int):ColorTransform {
		var result:ColorTransform = null;
		var curKeyframe:Keyframe = try cast(this.getCurrentKeyframe(index, "color"), Keyframe) catch (e:Dynamic) null;
		if (curKeyframe == null || curKeyframe.color == null) {
			return null;
		}

		var begin:ColorTransform = curKeyframe.color;
		var timeFromKeyframe:Float = index - curKeyframe.index;
		var tween:ITween = null;

		if (curKeyframe.getTween("color") != null) {
			tween = curKeyframe.getTween("color");
		} else if (curKeyframe.getTween("alpha") != null) {
			tween = curKeyframe.getTween("alpha");
		} else if (curKeyframe.getTween() != null) {
			tween = curKeyframe.getTween();
		};

		if (timeFromKeyframe == 0 || tween == null) {
			result = begin;
		} else if (tween != null) {
			var nextKeyframe:Keyframe = try cast(this.getNextKeyframe(index, "color"), Keyframe) catch (e:Dynamic) null;
			if (nextKeyframe == null || nextKeyframe.color == null) {
				result = begin;
			} else {
				var nextColor:ColorTransform = nextKeyframe.color;
				var keyframeDuration:Float = nextKeyframe.index - curKeyframe.index;
				var easedTime:Float = tween.getValue(timeFromKeyframe, 0, 1, keyframeDuration);

				result = Color.interpolateTransform(begin, nextColor, easedTime);
			}
		}

		return result;
	}

	/**
	 		 * Retrieves an interpolated array of filters at a specific time index in the Motion instance.
	 		 *
	 * @param index The time index of a frame in the Motion instance, as an integer greater than or equal to zero.
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
	override public function getFilters(index:Int):Array<Dynamic> {
		var result:Array<Dynamic> = null;
		var curKeyframe:Keyframe = try cast(this.getCurrentKeyframe(index, "filters"), Keyframe) catch (e:Dynamic) null;
		if (curKeyframe == null || (curKeyframe.filters != null && curKeyframe.filters.length == 0)) {
			return [];
		}

		var begin:Array<Dynamic> = curKeyframe.filters;
		var timeFromKeyframe:Float = index - curKeyframe.index;
		var tween:ITween = null;

		if (curKeyframe.getTween("filters") != null) {
			tween = curKeyframe.getTween("filters");
		} else if (curKeyframe.getTween() != null) {
			tween = curKeyframe.getTween();
		}

		if (timeFromKeyframe == 0 || tween == null) {
			result = begin;
		} else if (tween != null) {
			var nextKeyframe:Keyframe = try cast(this.getNextKeyframe(index, "filters"), Keyframe) catch (e:Dynamic) null;
			if (nextKeyframe == null || nextKeyframe.filters.length == 0) {
				result = begin;
			} else {
				var nextFilters:Array<Dynamic> = nextKeyframe.filters;
				var keyframeDuration:Float = nextKeyframe.index - curKeyframe.index;
				var easedTime:Float = tween.getValue(timeFromKeyframe, 0, 1, keyframeDuration);

				result = interpolateFilters(begin, nextFilters, easedTime);
			}
		}

		return result;
	}

	/**
	 * @private
	 */
	override private function findTweenedValue(index:Int, tweenableName:String, curKeyframeBase:KeyframeBase,
		timeFromKeyframe:Float, begin:Float):Float {
		var curKeyframe:Keyframe = try cast(curKeyframeBase, Keyframe) catch (e:Dynamic) null;
		if (curKeyframe == null) {
			return Math.NaN;
		}

		// Search for a possible tween targeted to an individual property.
		// If the property doesn't have a tween, check for a tween targeting all properties.
		var tween:ITween = null;

		if (curKeyframe.getTween(tweenableName) != null) {
			tween = curKeyframe.getTween(tweenableName);
		} else if (curKeyframe.getTween() != null) {
			tween = curKeyframe.getTween();
		}

		// if there is no interpolation, use the value at the current keyframe
		if (tween == null
			|| (!curKeyframe.tweenScale && (tweenableName == Tweenables.SCALE_X || tweenableName == Tweenables.SCALE_Y))
			|| (curKeyframe.rotateDirection == RotateDirection.NONE
				&& (tweenableName == Tweenables.ROTATION || tweenableName == Tweenables.SKEW_X || tweenableName == Tweenables.SKEW_Y))) {
			return begin;
		}

		// Now we know we have a tween, so find the next keyframe and interpolate
		var nextKeyframeTweenableName:String = tweenableName;
		// If the tween is targeting all properties, the next keyframe will terminate the tween,
		// even if it doesn't directly affect the tweenable.
		// This check is necessary for the case where the object doesn't change x, y, etc. in the XML at all
		// during the tween, but rotates using the rotateTimes property.
		if (tween.target == "") {
			nextKeyframeTweenableName = "";
		}
		var nextKeyframe:Keyframe = try cast(this.getNextKeyframe(index, nextKeyframeTweenableName), Keyframe)
		catch (e:Dynamic) null;

		if (nextKeyframe == null || nextKeyframe.blank) {
			return begin;
		} else {
			var nextValue:Float = nextKeyframe.getValue(tweenableName);
			if (Math.isNaN(nextValue)) {
				nextValue = begin;
			}

			var change:Float = nextValue - begin;

			if ((tweenableName == Tweenables.SKEW_X || tweenableName == Tweenables.SKEW_Y) || tweenableName == Tweenables.ROTATION) {
				// At this point, we've already eliminated RotateDirection.NONE as a possibility.

				// The remaining options are AUTO, CW and CCW
				if (curKeyframe.rotateDirection == RotateDirection.AUTO) {
					change %= 360;
					// detect the shortest direction around the circle
					// i.e. keep the amount of rotation less than 180 degrees
					if (change > 180) {
						change -= 360;
					} else if (change < -180) {
						change += 360;
					}
				} else if (curKeyframe.rotateDirection == RotateDirection.CW) {
					// force the rotation to be positive and clockwise
					if (change < 0) {
						change = change % 360 + 360;
					}
					change += curKeyframe.rotateTimes * 360;
				} else { // CCW
					// force the rotation to be negative and counter-clockwise
					if (change > 0) {
						change = change % 360 - 360;
					}
					change -= curKeyframe.rotateTimes * 360;
				}
			}

			var keyframeDuration:Float = nextKeyframe.index - curKeyframe.index;
			return tween.getValue(timeFromKeyframe, begin, change, keyframeDuration);
		}

		return Math.NaN;
	}

	/**
	 * @private
	 */
	private function parseXML(xml:Xml):Motion {
		/** TODO@Wolfie -> XML 
			if (xml == null) {
				return this;
			}

			//// ATTRIBUTES
			if (xml.att.duration.length()) {
				this.duration = as3hx.Compat.parseInt(xml.att.duration);
			}

			//// CHILD ELEMENTS
			var elements:Iterator<Xml> = xml.elements();
			var i:Float = 0;
			while (i < elements.length()) {
				var child:Xml = Reflect.field(elements, Std.string(i));
				if (child.localName() == "source") {
					var sourceChild:Xml = child.children()[0];
					this.source = new Source(sourceChild);
				} else if (child.localName() == "Keyframe") {
					this.addKeyframe(getNewKeyframe(child));
				}
				i++;
			}
		**/


		return this;
	}

	/**
	 * A method needed to create a Motion instance from a string of XML.
	 *
	 * @param xmlString A string of motion XML.
	 *
	 * @return A new Motion instance.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 */
	public static function fromXMLString(xmlString:String):Motion {
		var xml:Xml = Xml.parse(xmlString);
		return new Motion(xml);
	}

	/**
	 * Blends filters smoothly from one array of filter objects to another.
	 *
	 * @param fromFilters The starting array of filter objects.
	 *
	 * @param toFilters The ending array of filter objects.
	 *
	 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
	 *
	 * @return The interpolated array of filter objects.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see flash.filters
	 */
	public static function interpolateFilters(fromFilters:Array<Dynamic>, toFilters:Array<Dynamic>,
		progress:Float):Array<Dynamic> {
		if (fromFilters.length != toFilters.length) {
			return null;
		}

		var resultFilters:Array<Dynamic> = [];
		var i:Int = 0;
		while (i < fromFilters.length) {
			var fromFilter:BitmapFilter = fromFilters[i];
			var toFilter:BitmapFilter = toFilters[i];
			var resultFilter:BitmapFilter = interpolateFilter(fromFilter, toFilter, progress);
			if (resultFilter != null) {
				resultFilters.push(resultFilter);
			}
			i++;
		}

		return resultFilters;
	}

	/**
	 * Blends filters smoothly from one filter object to another.
	 *
	 * @param fromFilters The starting filter object.
	 *
	 * @param toFilters The ending filter object.
	 *
	 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
	 *
	 * @return The interpolated filter object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Motion, Copy Motion as ActionScript
	 * @see flash.filters
	 */
	public static function interpolateFilter(fromFilter:BitmapFilter, toFilter:BitmapFilter,
		progress:Float):BitmapFilter { // If we can't find a valid interpolation, because the second filter is null
		// or doesn't match the first filter, return the first filter.
		if (toFilter == null || Reflect.field(fromFilter, "constructor") != Reflect.field(toFilter, "constructor")) {
			return fromFilter;
		}

		if (progress > 1) {
			progress = 1;
		} else if (progress < 0) {
			progress = 0;
		}
		var q:Float = 1 - progress;

		var resultFilter:BitmapFilter = fromFilter.clone();
		var filterTypeInfo:Xml = getTypeInfo(fromFilter);
		/** FIXME: getTypeInfo is returning `null` for now anyway. Commenting the bloack for now.
			var accessorList:Iterator<Xml> = filterTypeInfo.accessor;
			// FIXME: AS3HX WARNING could not determine type for var: accessor exp: EIdent(accessorList) type: Iterator<Xml>
			for (accessor in accessorList) {
				var accessorName:String = Std.string(accessor.att.name);
				var attribType:String = accessor.att.type;
				if (attribType == "Number" || attribType == "int") {
					Reflect.setField(resultFilter, accessorName,
						Reflect.field(fromFilter, accessorName) * q + Reflect.field(toFilter, accessorName) * progress);
				} else if (attribType == "uint") {
					switch (accessorName) {
						case "color", "highlightColor", "shadowColor":
							// for these properties, uint is a 0xRRGGBB color value, so we must interpolate r, g, b separately
							var color1:Int = Reflect.field(fromFilter, accessorName);
							var color2:Int = Reflect.field(toFilter, accessorName);
							var colorBlended:Int = Color.interpolateColor(color1, color2, progress);
							Reflect.setField(resultFilter, accessorName, colorBlended);
						default:
							Reflect.setField(resultFilter, accessorName,
								Reflect.field(fromFilter, accessorName) * q + Reflect.field(toFilter, accessorName) * progress);
					}
				}
			} // end accessor loop
		 */

		// interpolate gradient, which has arrays for colors, alphas, and ratios

		/** WARNING: There is no `GradientGlowFilter` nor `GradientBevelFilter` in OpenFL. 
				But maybe they exist in Pixi.js? I'm commenting it for not and let's hope
				it's never used.

			if (Std.is(fromFilter, GradientGlowFilter) || Std.is(fromFilter, GradientBevelFilter)) {
				var resultRatios:Array<Dynamic> = [];
				var resultColors:Array<Dynamic> = [];
				var resultAlphas:Array<Dynamic> = [];
				var fromLength:Int = Reflect.field(fromFilter, "ratios").length;
				var toLength:Int = Reflect.field(toFilter, "ratios").length;
				var maxLength:Int = Math.max(fromLength, toLength);
				for (i in 0...maxLength) {
					var fromIndex:Int = Math.min(i, fromLength - 1);
					var fromRatio:Float = Reflect.field(fromFilter, "ratios")[fromIndex];
					var fromColor:Int = Reflect.field(fromFilter, "colors")[fromIndex];
					var fromAlpha:Float = Reflect.field(fromFilter, "alphas")[fromIndex];

					var toIndex:Int = Math.min(i, toLength - 1);
					var toRatio:Float = Reflect.field(toFilter, "ratios")[toIndex];
					var toColor:Int = Reflect.field(toFilter, "colors")[toIndex];
					var toAlpha:Float = Reflect.field(toFilter, "alphas")[toIndex];

					var resultRatio:Int = as3hx.Compat.parseInt(fromRatio * q + toRatio * progress);
					var resultColor:Int = Color.interpolateColor(fromColor, toColor, progress);
					var resultAlpha:Float = fromAlpha * q + toAlpha * progress;
					resultRatios[i] = resultRatio;
					resultColors[i] = resultColor;
					resultAlphas[i] = resultAlpha;
				}
				Reflect.setField(resultFilter, "colors", resultColors);
				Reflect.setField(resultFilter, "alphas", resultAlphas);
				Reflect.setField(resultFilter, "ratios", resultRatios);
		}*/


		return resultFilter;
	}

	/**
	 *  @private
	 */
	private static var typeCache:Dictionary<String, Dynamic> = new Dictionary();

	/**
	 * @private
	 */
	private static function getTypeInfo(o:Dynamic):Xml {
		var className:String = "";

		if (Std.is(o, String)) {
			className = o;
		} else {
			className = Type.getClassName(o);
		}

		if (typeCache.exists(className)) {
			return typeCache[className];
		}

		if (Std.is(o, String)) {
			o = Type.resolveClass(o);
		}

		return null;
		// return (typeCache[className] = flash.utils.describeType(o));
		/** TODO@Wolfie -> XML 
			OpenFL doesn't have an equivalent... We need to think how to replace it:
			https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/package.html#describeType() */
	}

	/**
	 * @private
	 */
	override private function getNewKeyframe(xml:Xml = null):KeyframeBase {
		return new Keyframe(xml);
	}
}
