package;

import flixel.util.FlxSave;
import flixel.FlxG;

using StringTools;

typedef HighscoreParams = {
	// Main Stuffs
	public var score:Int;
	public var accuracy:Float;

	// Specific Ratings
	public var perfects:Int;
	public var sicks:Int;
	public var goods:Int;
	public var bads:Int;
	public var shits:Int;
	
	// Misc
	public var averageTiming:Float;
}

class Highscore
{
	// which one do i use the fuck
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songMisses:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	#end

	public static var songScores_new:Map<String, HighscoreParams> = new Map<String, HighscoreParams>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setMisses(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if (decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, ?misses:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
			{
				setScore(daSong, score);
				if (rating >= 0)
					setRating(daSong, rating);
			}
		}
		else
		{
			setScore(daSong, score);
			if (rating >= 0)
				setRating(daSong, rating);
		}

		// this is th euhhh the uhmmm missesises yeahh!!!
		if (songMisses.exists(daSong))
		{
			if (songMisses.get(daSong) < misses)
			{
				setMisses(daSong, misses);
			}
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setMisses(song:String, misses:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songMisses.set(song, misses);
		FlxG.save.data.songMisses = songMisses;
		FlxG.save.flush();
	}

	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getMisses(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songMisses.exists(daSong))
			setMisses(daSong, 0);

		return songMisses.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	/**
	 * This gets the Mean of all the timings.
	 * @param timings what do you think this is?
	 * @return Float
	 */
	public static function averageTimings(timings:Array<Float>):Float
	{
		var totalTimings:Float = 0;

		for (timing in timings)
			totalTimings += timing;

		return totalTimings / timings.length;
	}

	public static function setScore_New(song:String, diff:Int, params:HighscoreParams)
	{
		var save:FlxSave = new FlxSave();
		save.bind('Highscores', 'universe');

		song = formatSong(song, diff);
		songScores_new.set(song, params);
		save.data.songScores_new = songScores_new;
		save.flush();
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songMisses != null)
		{
			songMisses = FlxG.save.data.songMisses;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
	}
}
