// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import haxe.macro.Type.Ref;
import openfl.utils.Dictionary;
import haxe.rtti.Rtti;
import fl.motion.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * The Source class stores information about the context in which a Motion instance was generated.
 * Many of its properties do not affect animation created using ActionScript with the Animator class
 * but are present to store data from the Motion XML.
 * The <code>transformationPoint</code> property is the most important for an ActionScript Motion instance.
 * @playerversion Flash 9.0.28.0
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @keyword Source, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 */
@:rtti
class Source {
	/**
	 * Indicates the frames per second of the movie in which the Motion instance was generated.
	 * This property stores data from Motion XML but does not affect Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var frameRate:Float = Math.NaN;

	/**
	 * Indicates the type of object from which the Motion instance was generated.
	 * Possible values are <code>"rectangle object"</code>, <code>"oval object"</code>, <code>"drawing object"</code>, <code>"group"</code>, <code>"bitmap"</code>, <code>"compiled clip"</code>, <code>"video"</code>, <code>"text"</code>
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var elementType:String = "";

	/**
	 * Indicates the name of the symbol from which the Motion instance was generated.
	 * This property stores data from Motion XML but does not affect Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var symbolName:String = "";

	/**
	 * Indicates the instance name given to the movie clip from which the Motion instance was generated.
	 * This property stores data from Motion XML but does not affect Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var instanceName:String = "";

	/**
	 * Indicates the library linkage identifier for the symbol from which the Motion instance was generated.
	 * This property stores data from Motion XML but does not affect Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var linkageID:String = "";

	/**
	 * Indicates the <code>x</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#x
	 */
	public var x:Float = 0;

	/**
	 * Indicates the <code>y</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#y
	 */
	public var y:Float = 0;

	/**
	 * Indicates the <code>scaleX</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#scaleX
	 */
	public var scaleX:Float = 1;

	/**
	 * Indicates the <code>scaleY</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#scaleY
	 */
	public var scaleY:Float = 1;

	/**
	 * Indicates the <code>skewX</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#skewX
	 */
	public var skewX:Float = 0;

	/**
	 * Indicates the <code>skewY</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#skewY
	 */
	public var skewY:Float = 0;

	/**
	 * Indicates the <code>rotation</code> value of the original object.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 * @see fl.motion.Keyframe#rotation
	 */
	public var rotation:Float = 0;

	/**
	 * Specifies the location of the transformation or "pivot" point of the original object,
	 * from which transformations are applied.
	 * The coordinates of the transformation point are defined as a percentage of the visual object's dimensions (its bounding box). If the transformation point is at the upper-left
	 * corner of the bounding box, the coordinates are (0, 0). The lower-right corner of the
	 * bounding box is (1, 1). This property allows the transformation point to be applied
	 * consistently to objects of different proportions
	 * and registration points. The transformation point can lie outside of the bounding box,
	 * in which case the coordinates may be less than 0 or greater than 1.
	 * This property has a strong effect on Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var transformationPoint:Point;

	/**
	 * Indicates the position and size of the bounding box of the object from which the Motion instance was generated.
	 * This property stores data from Motion XML but does not affect Motion instances created using ActionScript.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public var dimensions:Rectangle;

	/**
	 * Constructor for Source instances.
	 *
	 * @param xml Optional E4X XML object defining a Source instance in Motion XML format.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Source, Copy Motion as ActionScript
	 */
	public function new(xml:Xml = null) {
		this.parseXML(xml);
	}

	/**
	 * @private
	 */
	private function parseXML(xml:Xml = null):Source {
		if (xml == null) {
			return this;
		}

		var source:Xml = xml.elementsNamed('Source').next();

		// ATTRIBUTES
		var rtti = Rtti.getRtti(Type.getClass(this));

		for (att in source.attributes()) {
			var value:Dynamic = source.get(att);
			for (f in rtti.fields) {
				if (f.name == att) {
					switch Reflect.field(f.type, 'name') {
						case 'Float':
							value = Std.parseFloat(value);
					}
				}
			}

			Reflect.setProperty(this, att, value);
		}

		for (child in source.elements()) {
			if (child.nodeName == 'transformationPoint') {
				var pointXML:Xml = child.elementsNamed('geom:Point').next();
				transformationPoint = new Point(Std.parseFloat(pointXML.get('x')), Std.parseFloat(pointXML.get('y')));
			} else if (child.nodeName == 'dimensions') {
				var dimXML:Xml = child.elementsNamed('geom:Rectangle').next();
				dimensions = new Rectangle(Std.parseFloat(dimXML.get('left')), Std.parseFloat(dimXML.get('top')),
					Std.parseFloat(dimXML.get('width')), Std.parseFloat(dimXML.get('height')));
			}
		}

		return this;
	}
}
