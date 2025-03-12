package ue.backend;

using ue.backend.ExtendedStringTools.MathTools;
/**
 * Recreates LUA Int iteration.
 */
 class CustomIntIterator {
	var min:Int;
	var max:Int;
	var step:Int;
    var baseMin:Int;
    var iterated:Int;

	/**
        Recreates LUA Int iteration.
        
		Iterates from `Start` (inclusive) to `Stop` (exclusive) by `Step`.

		If `Stop <= Start`, the iterator will not act as a countdown
	**/
	public function new(Start:Int, Stop:Int, ?Step:Int = 1) 
    {
		max = Stop;
		step = Step;
        baseMin = Start;
        min = Start;
        iterated = 0;
	}

    /**
     * Resets the Iterator allowing reuse along with optionally changing the min, max, or step.
     * @param Start (optional) New value to iterate from (inclusive).
     * @param Stop (optional) New value to iterate to (exclusive).
     * @param Step (optional) New value to iterate by.
     * @return CustomIntIterator
     */
    public inline function recycleIterator(?Start:Null<Int> = null, ?Stop:Null<Int> = null, ?Step:Null<Int> = null):CustomIntIterator
    {
        iterated = 0;

        if (Start != null)
        {
            min = Start;
            baseMin = Start;
        }

        if (Stop != null)
            max = Stop;

        if (Step != null)
            step = Step;

        return this;
    }

	/**
		Returns true if the iterator has other items, false otherwise.
	**/
	public inline function hasNext() 
    {
		if (step == 0)
        {
            throw 'You cannot iterate by 0.';
			return false;
        }

        if (step > 0 && max < min)
        {
            step = step.intToNegative();
        }
		return (min + step) < max;
	}

	/**
		Moves to the next item of the iterator.

		If this is called while hasNext() is false, the result is unspecified.
	**/
	public inline function next() 
    {
        min = baseMin + (step * iterated);
        iterated++;
        return min;
	}
}