// ActionScript file
package fl.motion;

/**
 * The DynamicMatrix class calculates and stores a matrix based on given values.
 * This class supports the ColorMatrixFilter and can be extended by the ColorMatrix class.
 * @playerversion Flash 9
 * @playerversion AIR 1.0
 * @productversion Flash CS3
 * @langversion 3.0
 * @see fl.motion.ColorMatrix
 * @see flash.filters.ColorMatrixFilter
 */
class DynamicMatrix {
	/**
	 * Specifies that a matrix is prepended for concatenation.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public static inline var MATRIX_ORDER_PREPEND:Int = 0;

	/**
	 * Specifies that a matrix is appended for concatenation.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public static inline var MATRIX_ORDER_APPEND:Int = 1;

	/**
	 * @private
	 */
	private var m_width:Int;

	/**
	 * @private
	 */
	private var m_height:Int;

	/**
	 * @private
	 */
	private var m_matrix:Array<Dynamic>;

	/**
	 * Constructs a matrix with the given number of rows and columns.
	 * @param width Number of columns.
	 * @param height Number of rows.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function new(width:Int, height:Int) {
		create(width, height);
	}

	/**
	 * @private
	 */
	private function create(width:Int, height:Int):Void {
		if (width > 0 && height > 0) {
			m_width = width;
			m_height = height;

			var m_matrix:Array<Array<Null<Int>>> = [for (n in 0...height) []];
			for (i in 0...height) {
				m_matrix[i] = [for (n in 0...width) null];
				for (j in 0...height) {
					m_matrix[i][j] = 0;
				}
			}
		}
	}

	/**
	 * @private
	 */
	private function destroy():Void {
		m_matrix = null;
	}

	/**
	 * Returns the number of columns in the current matrix.
	 * @return The number of columns.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @see #GetHeight
	 */
	public function GetWidth():Float {
		return m_width;
	}

	/**
	 * Returns the number of rows in the current matrix.
	 * @return The number of rows.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function GetHeight():Float {
		return m_height;
	}

	/**
	 * Returns the value at the specified zero-based row and column in the current matrix.
	 * @param row The row containing the value you want.
	 * @param col The column containing the value you want.
	 * @return Number The value at the specified row and column location.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function GetValue(row:Int, col:Int):Float {
		var value:Float = 0;
		if (row >= 0 && row < m_height && col >= 0 && col <= m_width) {
			value = m_matrix[row][col];
		}

		return value;
	}

	/**
	 * Sets the value at a specified zero-based row and column in the current matrix.
	 * @param row The row containing the value you want to set.
	 * @param col The column containing the value you want to set.
	 * @param value The number to insert into the matrix.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function SetValue(row:Int, col:Int, value:Float):Void {
		if (row >= 0 && row < m_height && col >= 0 && col <= m_width) {
			m_matrix[row][col] = value;
		}
	}

	/**
	 * Sets the current matrix to an identity matrix.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 * @see flash.geom.Matrix#identity()
	 */
	public function LoadIdentity():Void {
		if (m_matrix != null) {
			for (i in 0...m_height) {
				for (j in 0...m_width) {
					if (i == j) {
						m_matrix[i][j] = 1;
					} else {
						m_matrix[i][j] = 0;
					}
				}
			}
		}
	}

	/**
	 * Sets all values in the current matrix to zero.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function LoadZeros():Void {
		if (m_matrix != null) {
			for (i in 0...m_height) {
				for (j in 0...m_width) {
					m_matrix[i][j] = 0;
				}
			}
		}
	}

	/**
	 		 * Multiplies the current matrix with a specified matrix; and either
	 		 * appends or prepends the specified matrix. Use the
	 		 * second parameter of the <code>DynamicMatrix.Multiply()</code> method to
	 		 * append or prepend the specified matrix.
	 		 * @param inMatrix The matrix to add to the current matrix.
	 		 * @param order Specifies whether to append or prepend the matrix from the
	 		 * <code>inMatrix</code> parameter; either <code>MATRIX_ORDER_APPEND</code>
	 		 * or <code>MATRIX_ORDER_PREPEND</code>.
	 		 * @return  A Boolean value indicating whether the multiplication succeeded (<code>true</code>) or
	 		 * failed (<code>false</code>). The value is <code>false</code> if either the current matrix or
	 		 * specified matrix (the <code>inMatrix</code> parameter) is null, or if the order is to append and the
	 		 * current matrix's width is not the same as the supplied matrix's height; or if the order is to prepend
	 		 * and the current matrix's height is not equal to the supplied matrix's width.
	 *
	 		 * @playerversion Flash 9
	 		 * @playerversion AIR 1.0
	 		 * @productversion Flash CS3
	 		 * @langversion 3.0
	 		 * @see #MATRIX_ORDER_PREPEND
	 		 * @see #MATRIX_ORDER_APPEND
	 */
	public function Multiply(inMatrix:DynamicMatrix, order:Int = MATRIX_ORDER_PREPEND):Bool {
		if (m_matrix == null || inMatrix == null) {
			return false;
		}

		var inHeight:Int = Std.int(inMatrix.GetHeight());
		var inWidth:Int = Std.int(inMatrix.GetWidth());

		if (order == MATRIX_ORDER_APPEND) {
			//inMatrix on the left

			if (m_width != inHeight) {
				return false;
			}

			var result:DynamicMatrix = new DynamicMatrix(inWidth, m_height);
			for (i in 0...m_height) {
				for (j in 0...inWidth) {
					var total:Float = 0;
					var k:Int = 0;
					var m:Int = 0;
					while (k < Math.max(m_height, inHeight) && m < Math.max(m_width, inWidth)) {
						total = total + (inMatrix.GetValue(k, j) * m_matrix[i][m]);
						k++;
						m++;
					}

					result.SetValue(i, j, total);
				}
			}

			// destroy self and recreate with a new dimension
			destroy();
			create(inWidth, m_height);

			// assign result back to self
			for (i in 0...inHeight) {
				for (j in 0...m_width) {
					m_matrix[i][j] = result.GetValue(i, j);
				}
			}
		} else {
			// inMatrix on the right
			if (m_height != inWidth) {
				return false;
			}
			var result = new DynamicMatrix(m_width, inHeight);
			for (i in 0...inHeight) {
				for (j in 0...m_width) {
					var total:Float = 0;
					var k = 0;
					var m = 0;
					while (k < Math.max(inHeight, m_height) && m < Math.max(inWidth, m_width)) {
						total = total + (m_matrix[k][j] * inMatrix.GetValue(i, m));
						k++;
						m++;
					}
					result.SetValue(i, j, total);
				}
			}
			// destroy self and recreate with a new dimension
			destroy();
			create(m_width, inHeight);
			// assign result back to self
			for (i in 0...inHeight) {
				for (j in 0...m_width) {
					m_matrix[i][j] = result.GetValue(i, j);
				}
			}
		}
		return true;
	}

	// Multiply matrix with a value

	/**
	 * Multiplies a number with each item in the matrix and stores the results in
	 * the current matrix.
	 * @param value A number to multiply by each item in the matrix.
	 * @return A Boolean value indicating whether the multiplication succeeded (<code>true</code>)
	 * or failed (<code>false</code>).
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function MultiplyNumber(value:Float):Bool {
		if (m_matrix == null) {
			return false;
		}

		for (i in 0...m_height) {
			for (j in 0...m_width) {
				var total:Float = 0;
				total = m_matrix[i][j] * value;
				m_matrix[i][j] = total;
			}
		}

		return true;
	}

	// Add two matrices

	/**
	 * Adds the current matrix with a specified matrix. The
	 * current matrix becomes the result of the addition (in other
	 * words the <code>DynamicMatrix.Add()</code> method does
	 * not create a new matrix to contain the result).
	 * @param inMatrix The matrix to add to the current matrix.
	 * @return A Boolean value indicating whether the addition succeeded (<code>true</code>)
	 * or failed (<code>false</code>). If the dimensions of the matrices are not
	 * the same, <code>DynamicMatrix.Add()</code> returns <code>false</code>.
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Flash CS3
	 * @langversion 3.0
	 */
	public function Add(inMatrix:DynamicMatrix):Bool {
		if (m_matrix == null || inMatrix == null) {
			return false;
		}

		var inHeight:Int = Std.int(inMatrix.GetHeight());
		var inWidth:Int = Std.int(inMatrix.GetWidth());

		if (m_width != inWidth || m_height != inHeight) {
			return false;
		}

		for (i in 0...m_height) {
			for (j in 0...m_width) {
				var total:Float = 0;
				total = m_matrix[i][j] + inMatrix.GetValue(i, j);
				m_matrix[i][j] = total;
			}
		}

		return true;
	}
}
