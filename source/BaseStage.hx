package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import flixel.FlxG;

import Note.EventNote;

using StringTools;

typedef StagePropertiesFile = {
	public var name:String;
	public var description:String;
	/**
	 * Determines what path to use as `./assets/(path)`
	 */
	@:optional public var path:String;
	/**
	 * Determines what path to use as `./assets/(path)/(subPath)`
	 * 
	 * useful if you have multiple versions and plan on making the global stage also use a subFolder
	 */
	@:optional public var subPath:String;
	@:optional public var overrideNoteskin:String;
	@:optional public var versions:Array<StageVersion>;
}

typedef StageVersion = {
	public var name:String;
	public var description:String;
	/**
	 * Determines what path to use as `./assets/(properties.json path)/(stage version path)`
	 *
	 * If the main path properties.json variable does not specify a week directory, will be done as `./assets/(stage version path)`
	 */
	@:optional public var path:String;
	@:optional public var overrideNoteskin:String;
}

enum Countdown
{
	THREE;
	TWO;
	ONE;
	GO;
	START;
}

/**
 * Literally just from 0.7.1h with slight modification.
 */
class BaseStage extends FlxBasic
{
	private var game(default, set):Dynamic = PlayState.instance;
	public var onPlayState:Bool = false;

	// some variables for convenience
	public var paused(get, never):Bool;
	public var songName(get, never):String;
	public var isStoryMode(get, never):Bool;
	public var seenCutscene(get, never):Bool;
	public var inCutscene(get, set):Bool;
	public var canPause(get, set):Bool;
	public var members(get, never):Dynamic;

	public var boyfriend(get, never):Character;
	public var dad(get, never):Character;
	public var gf(get, never):Character;
	public var boyfriendGroup(get, never):FlxSpriteGroup;
	public var dadGroup(get, never):FlxSpriteGroup;
	public var gfGroup(get, never):FlxSpriteGroup;
	
	public var camGame(get, never):FlxCamera;
	public var camHUD(get, never):FlxCamera;
	public var camOther(get, never):FlxCamera;

	public var defaultCamZoom(get, set):Float;
	public var camFollow(get, never):FlxObject;
	public var properties:Null<StagePropertiesFile>;
	public var subStage(get, never):String;

	public function new(?properties:Null<StagePropertiesFile> = null)
	{
		this.game = MusicBeatState.getState();
		this.properties = properties;
		if(this.game == null)
		{
			FlxG.log.warn('Invalid state for the stage added!');
			destroy();
		}
		else 
		{
			this.game.stages.push(this);
			super();
			create();
		}
	}

	//main callbacks
	public function create() {}
	public function createPost() {}
	//public function update(elapsed:Float) {}
	public function countdownTick(count:Countdown, num:Int) {}

	// FNF steps, beats and sections
	public var curBeat:Int = 0;
	public var curDecBeat:Float = 0;
	public var curStep:Int = 0;
	public var curDecStep:Float = 0;
	public var curSection:Int = 0;
	public function beatHit() {}
	public function stepHit() {}
	public function sectionHit() {}

	// Substate close/open, for pausing Tweens/Timers
	public function closeSubState() {}
	public function openSubState(SubState:FlxSubState) {}

	// Events
	public function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>) {}
	public function eventPushed(event:EventNote) {}
	public function eventPushedUnique(event:EventNote) {}
    public function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}
    public function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}
    public function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}
    public function startSong():Void {}

	// Things to replace FlxGroup stuff and inject sprites directly into the state
	function add(object:FlxBasic) game.add(object);
	function remove(object:FlxBasic) game.remove(object);
	function insert(position:Int, object:FlxBasic) game.insert(position, object);
	/**
	 * Using the current stagename this function makes and adds a sprite to current state instance, then returns that sprite.
	 * @param x 
	 * @param y 
	 * @param image The image (or color to use.)
	 * @param width 
	 * @param height 
	 * @return BGSprite
	 */
	public function newSprite(x:Float, y:Float, image:String, ?width:Float, ?height:Float):BGSpriteAlt
	{
		var stage:Null<String> = null;
		if (game.curStage != null)
			stage = game.curStage;

		if(properties != null)
		{
			if (subStage.trim() != '')
			{
				for (version in properties.versions)
				{
					if (version.name == subStage && version.path != null)
						image = version.path + '/$image';
					trace(image);
				}
			}
			else
			{
				trace('Skipping sub stage check, song does not use sub stage!');
			}
		}
		var sprite:BGSpriteAlt = new BGSpriteAlt(x, y, stage).newSprite(image, width, height);
		add(sprite);
		return sprite;
	}
	
	public function addBehindGF(obj:FlxBasic) insert(members.indexOf(game.gfGroup), obj);
	public function addBehindBF(obj:FlxBasic) insert(members.indexOf(game.boyfriendGroup), obj);
	public function addBehindDad(obj:FlxBasic) insert(members.indexOf(game.dadGroup), obj);
	public function setDefaultGF(name:String) //Fix for the Chart Editor on Base Game stages
	{
		var gfVersion:String = PlayState.SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			gfVersion = name;
			PlayState.SONG.gfVersion = gfVersion;
		}
	}

	//precache functions
	public function precacheImage(key:String) precache(key, 'image');
	public function precacheSound(key:String) precache(key, 'sound');
	public function precacheMusic(key:String) precache(key, 'music');

	public function precache(key:String, type:String)
	{
		if(onPlayState)
			PlayState.instance.precacheList.set(key, type);

		switch(type)
		{
			case 'image':
				Paths.image(key);
			case 'sound':
				Paths.sound(key);
			case 'music':
				Paths.music(key);
		}
	}

	// overrides
	function startCountdown() if(onPlayState) return PlayState.instance.startCountdown(); else return;
	function endSong() if(onPlayState)return PlayState.instance.endSong(); else return;
	function moveCameraSection() if(onPlayState) moveCameraSection();
	function moveCamera(isDad:Bool) if(onPlayState) moveCamera(isDad);
	inline private function get_paused() return game.paused;
	inline private function get_songName() return game.songName;
	inline private function get_isStoryMode() return PlayState.isStoryMode;
	inline private function get_seenCutscene() return PlayState.seenCutscene;
	inline private function get_inCutscene() return game.inCutscene;
	inline private function set_inCutscene(value:Bool)
	{
		game.inCutscene = value;
		return value;
	}
	inline private function get_canPause() return game.canPause;
	inline private function set_canPause(value:Bool)
	{
		game.canPause = value;
		return value;
	}
	inline private function get_members() return game.members;
	inline private function set_game(value:MusicBeatState)
	{
		onPlayState = (Std.isOfType(value, PlayState));
		game = value;
		return value;
	}

	inline private function get_boyfriend():Character return game.boyfriend;
	inline private function get_dad():Character return game.dad;
	inline private function get_gf():Character return game.gf;

	inline private function get_boyfriendGroup():FlxSpriteGroup return game.boyfriendGroup;
	inline private function get_dadGroup():FlxSpriteGroup return game.dadGroup;
	inline private function get_gfGroup():FlxSpriteGroup return game.gfGroup;
	
	inline private function get_camGame():FlxCamera return game.camGame;
	inline private function get_camHUD():FlxCamera return game.camHUD;
	inline private function get_camOther():FlxCamera return game.camOther;

	inline private function get_defaultCamZoom():Float return game.defaultCamZoom;
	inline private function set_defaultCamZoom(value:Float):Float
	{
		game.defaultCamZoom = value;
		return game.defaultCamZoom;
	}
	inline private function get_camFollow():FlxObject return game.camFollow;
	function get_subStage():String {
		if (PlayState.SONG.subStage != null)
			return PlayState.SONG.subStage;
		else
			return '';
	}
}