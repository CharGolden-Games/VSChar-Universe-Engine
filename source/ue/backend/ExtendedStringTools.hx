package ue.backend;

import haxe.ds.Either;
import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.addons.ui.U as FlxU;

using StringTools;

/**
 * Extra string functions.
 */
class ExtendedStringTools
{
    /**
     * Shortcut function to StringTools.toLowerCase().
     * 
     * (For easier lua porting since some scripts structure it as string:lower.)
     * 
     * @param s The String to make lower case
     * @return Lowercase'd String
     */
     @:deprecated('This function is just a shortcut to s.toLowerCase()!')
    public static function lower(s:String):String return s.toLowerCase();

    /**
     * Formats a float to basically be smth like '1,000,000'
     * @param m 
     * @return String
     */
    public static function formatMoney(m:Float, showDecimal:Bool = false):String return FlxStringUtil.formatMoney(m, showDecimal);

    public static function toString(o:Dynamic):String
        {
            if (Std.isOfType(o, Bool))
            {
                var bool:Bool = o;
                if (bool)
                {
                    return ' true';
                }
                else
                {
                    return 'false';
                }
            }
            else if (Std.isOfType(o, String))
            {
                trace('ALREADY A STRING DIPSHIT.');
                var string:String = o;
                return string;
            }
            return '$o'; // Yeah.
        }

	/**
	 * Return string with first character uppercase'd, rest lowercase'd
	 */
    public static function FUL(s:String):String
    {
        return FlxU.FUL(s);
    }
}

/**
 * Shit I use regularly
 */
class MathTools
{
    /**
		Returns the largest integer value that is not greater than `v`.

		If `v` is outside of the signed `Int32` range, or is `NaN`, `NEGATIVE_INFINITY`
		or `POSITIVE_INFINITY`, the result is unspecified.
	**/
    public static function floor(v:Float):Int return Math.floor(v);

    /**
		Returns the smallest integer value that is not less than `v`.

		If `v` is outside of the signed `Int32` range, or is `NaN`, `NEGATIVE_INFINITY`
		or `POSITIVE_INFINITY`, the result is unspecified.
	**/
    public static function ceil(v:Float):Int return Math.ceil(v);

	/**
		Rounds `v` to the nearest integer value.

		Ties are rounded up, so that `0.5` becomes `1` and `-0.5` becomes `0`.

		If `v` is outside of the signed `Int32` range, or is `NaN`, `NEGATIVE_INFINITY`
		or `POSITIVE_INFINITY`, the result is unspecified.
	**/
    public static function round(v:Float):Int return Math.round(v);

	/**
	 * Round a decimal number to have reduced precision (less decimal numbers).
	 *
	 * ```haxe
	 * roundDecimal(1.2485, 2) = 1.25
	 * ```
	 *
	 * @param	Value		Any number.
	 * @param	Precision	Number of decimals the result should have.
	 * @return	The rounded value of that number.
	 */
    public static function roundDecimal(Value:Float, Precision:Int):Float return FlxMath.roundDecimal(Value, Precision);

    public static function toPower(v:Float, power:Int):Float return Math.pow(v, power);
    public static function getRandomInt(min:Int, max:Int, ?excludes:Array<Int>):Int return FlxG.random.int(min, max, excludes);
    public static function getRandomFloat(min:Float, max:Float, ?excludes:Array<Float>):Float return FlxG.random.float(min, max, excludes);
	/**
        Recreates LUA Int iteration.
        
		Iterates from `Start` (inclusive) to `Stop` (exclusive) by `Step`.

		If `Stop <= Start`, the iterator will not act as a countdown
	**/
    public static function newIterator(Start:Int, Stop:Int, ?Step:Int = 1):CustomIntIterator return new CustomIntIterator(Start, Stop, Step);
    public static function toNegative(Value:Float):Float return Value < 0 ? Value : -Value;
    public static function intToNegative(Value:Int):Int return Value < 0 ? Value : -Value;
}