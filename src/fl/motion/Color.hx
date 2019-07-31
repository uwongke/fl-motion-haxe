// Copyright � 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import fl.motion.*;
import openfl.display.*;
import openfl.geom.ColorTransform;

/**
 * The Color class extends the Flash Player ColorTransform class,
 * adding the ability to control brightness and tint.
 * It also contains static methods for interpolating between two ColorTransform objects
 * or between two color numbers.
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword Color, Copy Motion as ActionScript
 * @see flash.geom.ColorTransform ColorTransform class
 * @includeExample examples\ColorExample.as -noswf
 * @see ../../motionXSD.html Motion XML Elements
 */
class Color extends ColorTransform {
	public var brightness(get, set):Float;
	public var tintColor(get, set):Int;
	public var tintMultiplier(get, set):Float;

	/**
	 * Constructor for Color instances.
	 *
	 * @param redMultiplier The percentage to apply the color, as a decimal value between 0 and 1.
	 * @param greenMultiplier The percentage to apply the color, as a decimal value between 0 and 1.
	 * @param blueMultiplier The percentage to apply the color, as a decimal value between 0 and 1.
	 * @param alphaMultiplier A decimal value that is multiplied with the alpha transparency channel value, as a decimal value between 0 and 1.
	 * @param redOffset A number from -255 to 255 that is added to the red channel value after it has been multiplied by the <code>redMultiplier</code> value.
	 * @param greenOffset A number from -255 to 255 that is added to the green channel value after it has been multiplied by the <code>greenMultiplier</code> value.
	 * @param blueOffset A number from -255 to 255 that is added to the blue channel value after it has been multiplied by the <code>blueMultiplier</code> value.
	 * @param alphaOffset A number from -255 to 255 that is added to the alpha channel value after it has been multiplied by the <code>alphaMultiplier</code> value.
	 *
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Color
	 */
	public function new(redMultiplier:Float = 1.0, greenMultiplier:Float = 1.0, blueMultiplier:Float = 1.0,
		alphaMultiplier:Float = 1.0, redOffset:Float = 0, greenOffset:Float = 0, blueOffset:Float = 0,
		alphaOffset:Float = 0) {
		super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset,
			alphaOffset);
	}

	/**
	 * The percentage of brightness, as a decimal between <code>-1</code> and <code>1</code>.
	 * Positive values lighten the object, and a value of <code>1</code> turns the object completely white.
	 * Negative values darken the object, and a value of <code>-1</code> turns the object completely black.
	 *
	 * @default 0
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword brightness, Copy Motion as ActionScript
	 */
	private function get_brightness():Float {
		return (this.redOffset != 0) ? (1 - this.redMultiplier) : (this.redMultiplier - 1);
	}

	/**
	 * @private (setter)
	 */
	private function set_brightness(value:Float):Float {
		if (value > 1) {
			value = 1;
		} else if (value < -1) {
			value = -1;
		}
		var percent:Float = 1 - Math.abs(value);
		var offset:Float = 0;
		if (value > 0) {
			offset = value * 255;
		}
		this.redMultiplier = this.greenMultiplier = this.blueMultiplier = percent;
		this.redOffset = this.greenOffset = this.blueOffset = offset;
		return value;
	}

	/**
	 * Sets the tint color and amount at the same time.
	 *
	 * @param tintColor The tinting color value in the 0xRRGGBB format.
	 *
	 * @param tintMultiplier The percentage to apply the tint color, as a decimal value between <code>0</code> and <code>1</code>.
	 * When <code>tintMultiplier = 0</code>, the target object is its original color and no tint color is visible.
	 * When <code>tintMultiplier = 1</code>, the target object is completely tinted and none of its original color is visible.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword brightness, Copy Motion as ActionScript
	 */
	public function setTint(tintColor:Int, tintMultiplier:Float):Void {
		this._tintColor = tintColor;
		this._tintMultiplier = tintMultiplier;
		this.redMultiplier = this.greenMultiplier = this.blueMultiplier = 1 - tintMultiplier;
		var r:Int = as3hx.Compat.parseInt(tintColor >> 16) & 0xFF;
		var g:Int = as3hx.Compat.parseInt(tintColor >> 8) & 0xFF;
		var b:Int = tintColor & 0xFF;
		this.redOffset = Math.round(r * tintMultiplier);
		this.greenOffset = Math.round(g * tintMultiplier);
		this.blueOffset = Math.round(b * tintMultiplier);
	}

	/**
	 * @private
	 */
	private var _tintColor:Float = 0x000000;

	/**
	 * The tinting color value in the 0xRRGGBB format.
	 *
	 *
	 * @default 0x000000 (black)
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword tint, Copy Motion as ActionScript
	 */
	private function get_tintColor():Int {
		return Std.int(this._tintColor);
	}

	/**
	 * @private (setter)
	 */
	private function set_tintColor(value:Int):Int {
		this.setTint(value, this.tintMultiplier);
		return value;
	}

	// Capable of deriving a tint color from the color offsets,
	// but the accuracy decreases as the tint multiplier decreases (rounding issues).

	/**
	 * @private
	 */
	private function deriveTintColor():Int {
		var ratio:Float = 1 / (this.tintMultiplier);
		var r:Int = Math.round(this.redOffset * ratio);
		var g:Int = Math.round(this.greenOffset * ratio);
		var b:Int = Math.round(this.blueOffset * ratio);
		var colorNum:Int = as3hx.Compat.parseInt(r << 16 | g << 8) | b;
		return colorNum;
	}

	/**
	 * @private
	 */
	private var _tintMultiplier:Float = 0;

	/**
	 * The percentage to apply the tint color, as a decimal value between <code>0</code> and <code>1</code>.
	 * When <code>tintMultiplier = 0</code>, the target object is its original color and no tint color is visible.
	 * When <code>tintMultiplier = 1</code>, the target object is completely tinted and none of its original color is visible.
	 * @default 0
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword tint, Copy Motion as ActionScript
	 */
	private function get_tintMultiplier():Float {
		return this._tintMultiplier;
	}

	/**
	 * @private (setter)
	 */
	private function set_tintMultiplier(value:Float):Float {
		this.setTint(this.tintColor, value);
		return value;
	}

	/**
	 * Creates a Color instance from XML.
	 *
	 * @param xml An E4X XML object containing a <code>&lt;color&gt;</code> node from Motion XML.
	 *
	 * @return A Color instance that matches the XML description.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword color, Copy Motion as ActionScript
	 */
	public static function fromXML(xml:Xml):Color {
		return cast(((new Color()).parseXML(xml)), Color);
	}

	/**
	 * @private
	 */
	private function parseXML(xml:Xml = null):Color {
		/** TODO@Wolfie -> Fix
			if (xml == null) {
				return this;
			}

			var firstChild:Xml = xml.elements()[0];
			if (firstChild == null) {
				return this;
			}

			//// ATTRIBUTES
			// FIXME: AS3HX WARNING could not determine type for var: att exp: ECall(EField(EIdent(firstChild),attributes),[]) type: null
			for (att in firstChild.attributes()) {
				var name:String = att.localName();
				if (name == "tintColor") {
					var tintColorNumber:Int = try cast(as3hx.Compat.parseFloat(Std.string(att)), Int) catch (e:Dynamic) null;
					this.tintColor = tintColorNumber;
				} else {
					Reflect.setField(this, name, as3hx.Compat.parseFloat(Std.string(att)));
				}
			}

			return this;
		 */


		return null;
	}

	/**
	 * Blends smoothly from one ColorTransform object to another.
	 *
	 * @param fromColor The starting ColorTransform object.
	 *
	 * @param toColor The ending ColorTransform object.
	 *
	 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
	 *
	 * @return The interpolated ColorTransform object.
	 */
	public static function interpolateTransform(fromColor:ColorTransform, toColor:ColorTransform,
		progress:Float):ColorTransform {
		var q:Float = 1 - progress;
		var resultColor:ColorTransform = new ColorTransform(fromColor.redMultiplier * q
			+ toColor.redMultiplier * progress,
			fromColor.greenMultiplier * q
			+ toColor.greenMultiplier * progress,
			fromColor.blueMultiplier * q
			+ toColor.blueMultiplier * progress,
			fromColor.alphaMultiplier * q
			+ toColor.alphaMultiplier * progress,
			fromColor.redOffset * q
			+ toColor.redOffset * progress,
			fromColor.greenOffset * q
			+ toColor.greenOffset * progress,
			fromColor.blueOffset * q
			+ toColor.blueOffset * progress,
			fromColor.alphaOffset * q
			+ toColor.alphaOffset * progress);
		return resultColor;
	}

	/**
	 * Blends smoothly from one color value to another.
	 *
	 * @param fromColor The starting color value, in the 0xRRGGBB or 0xAARRGGBB format.
	 *
	 * @param toColor The ending color value, in the 0xRRGGBB or 0xAARRGGBB format.
	 *
	 * @param progress The percent of the transition as a decimal, where <code>0</code> is the start and <code>1</code> is the end.
	 *
	 * @return The interpolated color value, in the 0xRRGGBB or 0xAARRGGBB format.
	 */
	public static function interpolateColor(fromColor:Int, toColor:Int, progress:Float):Int {
		var q:Float = 1 - progress;
		var fromA:Int = as3hx.Compat.parseInt(fromColor >> 24) & 0xFF;
		var fromR:Int = as3hx.Compat.parseInt(fromColor >> 16) & 0xFF;
		var fromG:Int = as3hx.Compat.parseInt(fromColor >> 8) & 0xFF;
		var fromB:Int = fromColor & 0xFF;

		var toA:Int = as3hx.Compat.parseInt(toColor >> 24) & 0xFF;
		var toR:Int = as3hx.Compat.parseInt(toColor >> 16) & 0xFF;
		var toG:Int = as3hx.Compat.parseInt(toColor >> 8) & 0xFF;
		var toB:Int = toColor & 0xFF;

		var resultA:Int = as3hx.Compat.parseInt(fromA * q + toA * progress);
		var resultR:Int = as3hx.Compat.parseInt(fromR * q + toR * progress);
		var resultG:Int = as3hx.Compat.parseInt(fromG * q + toG * progress);
		var resultB:Int = as3hx.Compat.parseInt(fromB * q + toB * progress);
		var resultColor:Int = as3hx.Compat.parseInt(resultA << 24 | resultR << 16 | resultG << 8) | resultB;
		return resultColor;
	}
}
