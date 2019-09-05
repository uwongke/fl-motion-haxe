// Copyright © 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion;

import openfl.errors.Error;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.utils.*;

/**
 * The Keyframe class defines the visual state at a specific time in a motion tween.
 * The primary animation properties are <code>position</code>, <code>scale</code>, <code>rotation</code>, <code>skew</code>, and <code>color</code>.
 * A keyframe can, optionally, define one or more of these properties.
 * For instance, one keyframe may affect only position,
 * while another keyframe at a different point in time may affect only scale.
 * Yet another keyframe may affect all properties at the same time.
 * Within a motion tween, each time index can have only one keyframe.
 * A keyframe also has other properties like <code>blend mode</code>, <code>filters</code>, and <code>cacheAsBitmap</code>,
 * which are always available. For example, a keyframe always has a blend mode.
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
 * @keyword Keyframe, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 * @see fl.motion.KeyframeBase
 */
class Keyframe extends KeyframeBase {
	@:meta(ArrayElementType(name = "fl.motion.ITween"))

	/**
	 * An array that contains each tween object to be applied to the target object at a particular keyframe.
	 * One tween can target all animation properties (as with standard tweens on the Flash authoring tool's timeline),
	 * or multiple tweens can target individual properties (as with separate custom easing curves).
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public var tweens:Array<Dynamic>;

	/**
	 * A flag that controls whether scale will be interpolated during a tween.
	 * If <code>false</code>, the display object will stay the same size during the tween, until the next keyframe.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public var tweenScale:Bool = true;

	/**
	 * Stores the value of the Snap checkbox for motion tweens, which snaps the object to a motion guide.
	 * This property is used in the Copy and Paste Motion feature in Flash CS4
	 * but does not affect motion tweens defined using ActionScript.
	 * It is included here for compatibility with the Flex 2 compiler.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public var tweenSnap:Bool = false;

	/**
	 * Stores the value of the Sync checkbox for motion tweens, which affects graphic symbols only.
	 * This property is used in the Copy and Paste Motion feature in Flash CS4
	 * but does not affect motion tweens defined using ActionScript.
	 * It is included here for compatibility with the Flex 2 compiler.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public var tweenSync:Bool = false;

	/**
	 * Constructor for keyframe instances.
	 *
	 * @param xml Optional E4X XML object defining a keyframe in Motion XML format.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public function new(xml:Xml = null) {
		super(xml);
		this.tweens = [];
		this.parseXML(xml);
	}

	/**
	 * @private
	 */
	private function parseXML(xml:Xml = null):KeyframeBase {
		if (xml == null) {
			return this;
		}

		// ATTRIBUTES
		if (xml.exists('index')) {
			index = Std.parseInt(xml.get('index'));
		} else {
			throw new Error("<Keyframe> is missing the required attribute \"index\".");
		}

		if (xml.exists('label')) {
			label = xml.get('label');
		}

		if (xml.exists('tweenScale')) {
			this.tweenScale = xml.get('tweenScale') == "true";
		}

		if (xml.exists('tweenSnap')) {
			this.tweenScale = xml.get('tweenSnap') == "true";
		}

		if (xml.exists('tweenSync')) {
			this.tweenScale = xml.get('tweenSync') == "true";
		}

		if (xml.exists('blendMode')) {
			this.blendMode = xml.get('blendMode');
		}

		if (xml.exists('cacheAsBitmap')) {
			this.tweenScale = xml.get('cacheAsBitmap') == "true";
		}

		if (xml.exists('opaqueBackground')) {
			var bgColorStr:String = xml.get('opaqueBackground');
			if (bgColorStr == "null") {
				this.opaqueBackground = null;
			} else {
				this.opaqueBackground = as3hx.Compat.parseInt(bgColorStr);
			}
		}

		if (xml.exists('visible')) {
			this.visible = xml.get('visible') == "true";
		}
		
		if (xml.exists('rotateDirection')) {
			this.rotateDirection = xml.get('rotateDirection');
		}

		if (xml.exists('rotateTimes')) {
			this.rotateTimes = as3hx.Compat.parseInt(xml.get('rotateTimes'));
		}

		if (xml.exists('orientToPath')) {
			this.orientToPath = xml.get('orientToPath') == "true";
		}

		if (xml.exists('blank')) {
			this.blank = xml.get('blank') == "true";
		}

		// need to set rotation first in the order because skewX and skewY override it
		var tweenableNames:Array<String> = ["x", "y", "scaleX", "scaleY", "rotation", "skewX", "skewY"];
		for (tweenableName in tweenableNames) {
			if (xml.exists(tweenableName)) {
				var attributeValue:Float = Std.parseFloat(xml.get(tweenableName));
				if (attributeValue != null) {
					Reflect.setProperty(this, tweenableName, attributeValue);
				}
			}
		}
		
		var elements:Iterator<Xml> = xml.elements();
		var filtersArray:Array<BitmapFilter> = [];

		for (child in elements) {
			var name:String = child.nodeName;	//child.localName();
			if (name == "tweens") {
				var tweenChildren:Iterator<Xml> = child.elements();
				for (tweenChild in tweenChildren) {
					var tweenName:String = tweenChild.nodeName; //tweenChild.localName();
					if (tweenName == "SimpleEase") {
						this.tweens.push(new SimpleEase(tweenChild));
					} else if (tweenName == "CustomEase") {
						this.tweens.push(new CustomEase(tweenChild));
					} else if (tweenName == "BezierEase") {
						this.tweens.push(new BezierEase(tweenChild));
					} else if (tweenName == "FunctionEase") {
						this.tweens.push(new FunctionEase(tweenChild));
					}
				}
			} else if (name == "filters") {
				/*
				var filtersChildren:Iterator<Xml> = child.elements();
				for (filterXML in filtersChildren) {
					var filterName:String = filterXML.nodeName; //filterXML.localName();
					var filterClassName:String = "openfl.filters." + filterName;
					if (filterName == "AdjustColorFilter") {
						continue;
					}
					
					var filterClass:Class<Dynamic> = Type.resolveClass(filterClassName);
					var filterInstance:BitmapFilter = Type.createInstance(filterClass, []);
					
					var filterTypeInfo:Array<String> = Type.getInstanceFields(Type.createInstance(filterClass, []));
					//var accessorList:Iterator<Xml> = filterTypeInfo.accessor;
					var ratios:Array<Dynamic> = [];

					// loop through filter properties
					for (attrib in filterXML.attributes()) {
						var attribName:String = attrib;// attrib.localName();
						
						if (filterTypeInfo.indexOf(attribName) == -1) continue;
						
						
						var attribType:String = Reflect.getProperty(filterInstance, attribName);	
						var attribType:Type.ValueType = Type.typeof(filterInstance);
						var attribValue:String = Std.string(filterXML.get(attrib));

						if (attribType == Type.ValueType.TInt) {
							Reflect.setField(filterInstance, attribName, as3hx.Compat.parseInt(attribValue));
						} else if (attribType == Type.ValueType.T) {
							Reflect.setField(filterInstance, attribName, try cast(as3hx.Compat.parseInt(attribValue),
							Int) catch (e:Dynamic) null);
							var uintValue:Int = try cast(as3hx.Compat.parseInt(attribValue), Int) catch (e:Dynamic) null;
						} else if (attribType == "Number") {
							Reflect.setField(filterInstance, attribName, as3hx.Compat.parseFloat(attribValue));
						} else if (attribType == "Boolean") {
							Reflect.setField(filterInstance, attribName, (attribValue == "true"));
						} else if (attribType == "Array") {
							// remove the brackets at either end of the string
							attribValue = attribValue.substring(1, attribValue.length - 1);
							var valuesArray:Array<Dynamic> = null;
							if (attribName == "ratios" || attribName == "colors") {
								valuesArray = splitUint(attribValue);
							} else if (attribName == "alphas") {
								valuesArray = splitNumber(attribValue);
							}

							if (attribName == "ratios") {
								ratios = valuesArray;
							} else if (valuesArray != null) {
								Reflect.setField(filterInstance, attribName, valuesArray);
							}
							
						} else if (attribType == "String") {
							Reflect.setField(filterInstance, attribName, attribValue);
						}
				
					} // end attributes loop

					// force ratios array to be set after colors and alphas arrays, otherwise it won't work correctly
					if (ratios.length != null) {
						Reflect.setField(filterInstance, "ratios", ratios);
					}
					filtersArray.push(filterInstance);
				}*/
				
			} else if (name == "color") {
				this.color = Color.fromXML(child);
			}

			this.filters = filtersArray;
		}
		/*
			//// CHILD ELEMENTS
			var elements:Iterator<Xml> = xml.elements();
			var filtersArray:Array<Dynamic> = [];

			for (child in elements) {
				var name:String = child.localName();
				if (name == "tweens") {
					var tweenChildren:Iterator<Xml> = child.elements();
					// FIXME: AS3HX WARNING could not determine type for var: tweenChild exp: EIdent(tweenChildren) type: Iterator<Xml>
					for (tweenChild in tweenChildren) {
						var tweenName:String = tweenChild.localName();
						if (tweenName == "SimpleEase") {
							this.tweens.push(new SimpleEase(tweenChild));
						} else if (tweenName == "CustomEase") {
							this.tweens.push(new CustomEase(tweenChild));
						} else if (tweenName == "BezierEase") {
							this.tweens.push(new BezierEase(tweenChild));
						} else if (tweenName == "FunctionEase") {
							this.tweens.push(new FunctionEase(tweenChild));
						}
					}
				} else if (name == "filters") {
					var filtersChildren:Iterator<Xml> = child.elements();
					// FIXME AS3HX WARNING could not determine type for var: filterXML exp: EIdent(filtersChildren) type: Iterator<Xml>
					for (filterXML in filtersChildren) {
						var filterName:String = filterXML.localName();
						var filterClassName:String = "flash.filters." + filterName;
						if (filterName == "AdjustColorFilter") {
							continue;
						}

						var filterClass:Dynamic = flash.utils.getDefinitionByName(filterClassName);
						var filterInstance:BitmapFilter = new FilterClass();
						var filterTypeInfo:Xml = describeType(filterInstance);
						var accessorList:Iterator<Xml> = filterTypeInfo.accessor;
						var ratios:Array<Dynamic> = [];

						// loop through filter properties
						// FIXME: AS3HX WARNING could not determine type for var: attrib exp: ECall(EField(EIdent(filterXML),attributes),[]) type: null
						for (attrib in filterXML.attributes()) {
							var attribName:String = attrib.localName();
							var accessor:Xml = FastXML.filterNodes(accessorList, function(x:FastXML) {
								if (x.att.name == x.node.attribName.innerData)
									return true;
								return false;
							})[0];
							var attribType:String = accessor.att.type;
							var attribValue:String = Std.string(attrib);

							if (attribType == "int") {
								Reflect.setField(filterInstance, attribName, as3hx.Compat.parseInt(attribValue));
							} else if (attribType == "uint") {
								Reflect.setField(filterInstance, attribName, try cast(as3hx.Compat.parseInt(attribValue),
									Int) catch (e:Dynamic) null);
								var uintValue:Int = try cast(as3hx.Compat.parseInt(attribValue), Int) catch (e:Dynamic) null;
							} else if (attribType == "Number") {
								Reflect.setField(filterInstance, attribName, as3hx.Compat.parseFloat(attribValue));
							} else if (attribType == "Boolean") {
								Reflect.setField(filterInstance, attribName, (attribValue == "true"));
							} else if (attribType == "Array") {
								// remove the brackets at either end of the string
								attribValue = attribValue.substring(1, attribValue.length - 1);
								var valuesArray:Array<Dynamic> = null;
								if (attribName == "ratios" || attribName == "colors") {
									valuesArray = splitUint(attribValue);
								} else if (attribName == "alphas") {
									valuesArray = splitNumber(attribValue);
								}

								if (attribName == "ratios") {
									ratios = valuesArray;
								} else if (valuesArray != null) {
									Reflect.setField(filterInstance, attribName, valuesArray);
								}
							} else if (attribType == "String") {
								Reflect.setField(filterInstance, attribName, attribValue);
							}
						} // end attributes loop

						// force ratios array to be set after colors and alphas arrays, otherwise it won't work correctly
						if (ratios.length) {
							Reflect.setField(filterInstance, "ratios", ratios);
						}
						filtersArray.push(filterInstance);
					}
				} else if (name == "color") {
					this.color = Color.fromXML(child);
				}

				this.filters = filtersArray;
			}
		 */
		

		return this;
	}

	/**
	 * @private
	 */
	private static function splitNumber(valuesString:String):Array<Dynamic> {
		var valuesArray:Array<Dynamic> = valuesString.split(",");
		var vi:Int = 0;
		while (vi < valuesArray.length) {
			valuesArray[vi] = as3hx.Compat.parseFloat(valuesArray[vi]);
			vi++;
		}
		return valuesArray;
	}

	/**
	 * @private
	 */
	private static function splitUint(valuesString:String):Array<Dynamic> {
		var valuesArray:Array<Dynamic> = valuesString.split(",");
		var vi:Int = 0;
		while (vi < valuesArray.length) {
			valuesArray[vi] = try cast(as3hx.Compat.parseInt(valuesArray[vi]), Int) catch (e:Dynamic) null;
			vi++;
		}
		return valuesArray;
	}

	/**
	 * @private
	 */
	private static function splitInt(valuesString:String):Array<Dynamic> {
		var valuesArray:Array<Dynamic> = valuesString.split(",");
		var vi:Int = 0;
		while (vi < valuesArray.length) {
			valuesArray[vi] = as3hx.Compat.parseInt(as3hx.Compat.parseInt(valuesArray[vi]));
			vi++;
		}
		return valuesArray;
	}

	/**
	 * Retrieves an ITween object for a specific animation property.
	 *
	 * @param target The name of the property being tweened.
	 * @see fl.motion.ITween#target
	 *
	 * @return An object that implements the ITween interface.
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword Keyframe, Copy Motion as ActionScript
	 */
	public function getTween(target:String = ""):ITween {
		// FIXME: AS3HX WARNING could not determine type for var: tween exp: EField(EIdent(this),tweens) type: null
		for (tween in this.tweens) {
			if (tween.target == target
				|| (tween.target == "rotation" && (target == "skewX" || target == "skewY"))
				|| (tween.target == "position" && (target == "x" || target == "y"))
				|| (tween.target == "scale"
					&& (target == "scaleX" || target == "scaleY"))) { // If we're looking for a skew tween and there isn't one, use rotation if available.
				return tween;
			}
		}
		return null;
	}

	/**
	 * @private
	 */
	override private function hasTween():Bool {
		return this.getTween() != null;
	}

	/**
	 * The number of frames for the tween.
	 *
	 * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @keyword tweensLength, Copy Motion as ActionScript
	 */
	override private function get_tweensLength():Int {
		return this.tweens.length;
	}
}
