package;

import animateatlas.AtlasFrameMaker;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import FunkinLua.ModchartSprite;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import lime.utils.Assets as FlAssets;

using StringTools;
class BaseScript {
    // BaseScript is basically BaseStage but cooler.
	private var game(default, set):Dynamic = PlayState.instance;
	public var onPlayState:Bool = false;
	public var members(get, never):Array<FlxBasic>;
    
	private var controls(get, never):Controls;
    
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

    public var boyfriend(get, null):Boyfriend;
    public var gf(get, null):Character;
    public var dad(get, null):Character;

    var songName(get, null):String;
    var difficultyName(get, null):String;
    var bpm(get, null):Float;

    var crochet:Float;
    var songPosition(get, null):Float;
    var score(get, null):Int;
    var misses(get, null):Int;
    var health(get, set):Float;
    var healthLossMult(get, null):Float;
    var healthGainMult(get, null):Float;
    /**
     * The Accuracy after turning it into a percentage value.
     */
    var accuracy(get, null):Float;
    var ratingName(get, null):String;
    /**
     * The raw rating percent
     */
    var ratingPercent(get, null):Float;
    var hits(get, null):Int;
    var rating(get, null):Float;
    var ratingFC(get, null):String;
    var songLength(get, null):Float;
    var noteOffset(get, null):Int;
    var curBeat(get, null):Int;
    var curStep(get, null):Int;

    var hudStyle(get, null):String;

    var totalPlayed(get, null):Int;
    var totalNotesHit(get, null):Float;

    var camGame(get, null):FlxCamera;
    var camHUD(get, null):FlxCamera;
    var camOther(get, null):FlxCamera;

    public var name:String = 'Unnamed Script';

    function get_boyfriend():Boyfriend return game.boyfriend;
    function get_gf():Character return game.gf;
    function get_dad():Character return game.dad;

    function get_difficultyName():String return CoolUtil.difficulties[PlayState.storyDifficulty];
    function get_songName():String return PlayState.SONG.song;
    function get_bpm():Float return PlayState.SONG.bpm;

    function get_crochet():Float return Conductor.crochet;
    function get_songPosition():Float return Conductor.songPosition;
    function get_score():Int return game.lerpScore;
    function get_misses():Int return game.songMisses;
    function get_accuracy():Float return Highscore.floorDecimal(game.ratingPercent * 100, 2);
    function get_ratingName():String return game.ratingName;
    function get_ratingPercent():Float return game.ratingPercent;
    function get_songLength():Float return FlxG.sound.music.length;
    function get_noteOffset():Int return ClientPrefs.data.noteOffset;
    function get_hits():Int return game.songHits;
    function get_rating():Float return game.ratingPercent;
    function get_ratingFC():String return game.ratingFC;
    function get_curBeat():Int return game.curBeat;
    function get_curStep():Int return game.curStep;
    function get_totalPlayed():Int return game.totalPlayed;
    function get_totalNotesHit():Float return game.totalNotesHit;
    function get_camGame():FlxCamera return PlayState.instance.camGame;
    function get_camHUD():FlxCamera return PlayState.instance.camHUD;
    function get_camOther():FlxCamera return PlayState.instance.camOther;
    function get_hudStyle():String return ClientPrefs.data.hudStyle;
    function get_health():Float return PlayState.instance.health;
    function set_health(value:Float):Float return PlayState.instance.health = value;
    function get_healthLossMult():Float return PlayState.instance.healthLoss;
    function get_healthGainMult():Float return PlayState.instance.healthGain;
	inline private function set_game(value:MusicBeatState)
	{
		onPlayState = (Std.isOfType(value, PlayState));
		game = value;
		return value;
	}
	inline private function get_members() return game.members;
	function add(object:FlxBasic) game.add(object);
	function remove(object:FlxBasic) game.remove(object);
	function insert(position:Int, object:FlxBasic) game.insert(position, object);
	function addBehindBF(obj:FlxBasic) insert(members.indexOf(game.boyfriendGroup), obj);
    function addBehindDad(obj:FlxBasic) insert(members.indexOf(game.dadGroup), obj);

    public function onUpdate(elapsed:Float):Void {}

    public function onCreatePost():Void {}

    public function onUpdatePost(elapsed:Float):Void {}

    public function onBeatHit():Void {}

    public function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}
    
    public function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}

    public function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool):Void {}

    public function onSongStart():Void {}

    public function onDestroy():Void {}

    public function onPause():Void {}

    public function onResume():Void {}

    public function onCountdownTick(tick:Int):Void {}

    public function runLuaCode(code:String):Void
    {
        #if sys
        // Idiot prevention plan :3
        if (!FileSystem.exists('assets/embed/script.lua'))
        {
            if (!FileSystem.exists('assets/embed'))
                FileSystem.createDirectory('assets/embed');

            File.saveContent('assets/embed/script.lua', '-- This Script (while empty) is important to a function in the game.');
        }
        FunkinLua.runLuaCode(code);
        #end
    }

    public function precacheSound(name:String) CoolUtil.precacheSound(name);

    public function playSound(sound:String, volume:Float = 1, ?tag:String = null)
		{
			if (tag != null && tag.length > 0)
			{
				tag = tag.replace('.', '');
				if (PlayState.instance.modchartSounds.exists(tag))
				{
					PlayState.instance.modchartSounds.get(tag).stop();
				}
				PlayState.instance.modchartSounds.set(tag, FlxG.sound.play(Paths.sound(sound), volume, false, function()
				{
					PlayState.instance.modchartSounds.remove(tag);
					PlayState.instance.callOnLuas('onSoundFinished', [tag]);
				}));
				return;
			}
			FlxG.sound.play(Paths.sound(sound), volume);
		}

    public function stopSound(tag:String)
        {
            if (tag != null && tag.length > 1 && PlayState.instance.modchartSounds.exists(tag))
            {
                PlayState.instance.modchartSounds.get(tag).stop();
                PlayState.instance.modchartSounds.remove(tag);
            }
        }

    public function changePresence(details:String, ?state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
        {
            #if desktop
            Discord.DiscordClient.changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
            #end
        }

    public function loadFrames(spr:FlxSprite, image:String, spriteType:String)
	{
		switch (spriteType.toLowerCase().trim())
		{
			case "texture" | "textureatlas" | "tex":
				spr.frames = AtlasFrameMaker.construct(image);

			case "texture_noaa" | "textureatlas_noaa" | "tex_noaa":
				spr.frames = AtlasFrameMaker.construct(image, null, true);

			case "packer" | "packeratlas" | "pac":
				spr.frames = Paths.getPackerAtlas(image);

			default:
				spr.frames = Paths.getSparrowAtlas(image);
		}
	}

    public function resetSpriteTag(tag:String)
        {
            if (!PlayState.instance.modchartSprites.exists(tag))
            {
                return;
            }
    
            var pee:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
            pee.kill();
            if (pee.wasAdded)
            {
                PlayState.instance.remove(pee, true);
            }
            pee.destroy();
            PlayState.instance.modchartSprites.remove(tag);
        }

    public function makeAnimatedSprite(tag:String, image:String, x:Float, y:Float, ?spriteType:String = "sparrow"):ModchartSprite
		{
			tag = tag.replace('.', '');
			resetSpriteTag(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);

			loadFrames(leSprite, image, spriteType);
			leSprite.antialiasing = ClientPrefs.data.globalAntialiasing;
			PlayState.instance.modchartSprites.set(tag, leSprite);

            return leSprite;
		}

    function debugPrint(text1:Dynamic = '', text2:Dynamic = '', text3:Dynamic = '', text4:Dynamic = '', text5:Dynamic = '', color:FlxColor = FlxColor.WHITE)
    {
        var text:String = '' + text1 + text2 + text3 + text4 + text5;
        game.addTextToDebug(text, color);
        trace(text);
    }

    function formatSong(song:String, diff:Int):String return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);

    function keyPressed(name:String)
		{
			var key:Bool = false;
			switch (name)
			{
				case 'left':
					key = PlayState.instance.getControl('NOTE_LEFT');
				case 'down':
					key = PlayState.instance.getControl('NOTE_DOWN');
				case 'up':
					key = PlayState.instance.getControl('NOTE_UP');
				case 'right':
					key = PlayState.instance.getControl('NOTE_RIGHT');
				case 'space':
					key = FlxG.keys.pressed.SPACE; // an extra key for convinience
			}
			return key;
		}

    /**
     * Shit to do when loading (replaces onCreate)
     */
    public function initialize():Void {}

    public function onEvent(name:String, value1:String, value2:String, strumTime:Float):Void {}

    public function new(?name:String) if (name != null) this.name = name;

    // OPTIONS
    public var UEHud(get, null):Bool;
    public var UEDetachedHB(get, null):Bool;
    public var UEhudZoomOut(get, null):Bool;
    public var UEkeystrokes(get, null):Bool;
    public var UEcCounter(get, null):Bool;
    public var UESmoothHP(get, null):Bool;
    public var UEe100C(get, null):Bool;
    public var UEiconBop(get, null):Bool;
    public var UEtauntGo(get, null):Bool;
    public var UEshakeMiss(get, null):Bool;
    public var UEdarkenCamGame(get, null):Bool;
    public var UEstrumsplash(get, null):Bool;
    public var UEresultscreen(get, null):Bool;
    public var UEmisssounds(get, null):Bool;
    public var UEhudpos(get, null):String;
    public var UEsnTimeFollow(get, null):Bool;
    public var UEhidetimeBar(get, null):Bool;
    public var UEkeyFT(get, null):Float;
    public var UEkeyA(get, null):Float;
    public var UEkeyXPos(get, null):Float;
    public var UEkeyYPos(get, null):Float;

    //VS Char Settings
    public var rotBop(get, null):Bool;
    public var floorRating(get, null):Bool;
    public var forceTimeBar(get, null):Bool;

    function get_UEHud():Bool return ClientPrefs.data.ueHud;
    function get_UEDetachedHB():Bool return ClientPrefs.data.dhb;
    function get_UEhudZoomOut():Bool return ClientPrefs.data.hudZoomOut;
    function get_UEkeystrokes():Bool return ClientPrefs.data.keystrokes;
    function get_UEcCounter():Bool return ClientPrefs.data.cc;
    function get_UESmoothHP():Bool return ClientPrefs.data.sh;
    function get_UEe100C():Bool return ClientPrefs.data.ec;
    function get_UEiconBop():Bool return ClientPrefs.data.ib;
    function get_UEtauntGo():Bool return ClientPrefs.data.tng;
    function get_UEshakeMiss():Bool return ClientPrefs.data.snm;
    function get_UEdarkenCamGame():Bool return ClientPrefs.data.dcm;
    function get_UEstrumsplash():Bool return ClientPrefs.data.uess;
    function get_UEmisssounds():Bool return ClientPrefs.data.uems;
    function get_UEresultscreen():Bool return ClientPrefs.data.ueresultscreen;
    function get_UEhudpos():String return ClientPrefs.data.hudPosUE;
    function get_UEsnTimeFollow():Bool return ClientPrefs.data.sntf;
    function get_UEhidetimeBar():Bool return ClientPrefs.data.huet;
    function get_UEkeyFT():Float return ClientPrefs.data.keyFT;
    function get_UEkeyA():Float return ClientPrefs.data.keyA;
    function get_UEkeyXPos():Float return ClientPrefs.data.keyXPos;
    function get_UEkeyYPos():Float return ClientPrefs.data.keyYPos;

    function get_rotBop():Bool return ClientPrefs.data.rotBop;
    function get_floorRating():Bool return ClientPrefs.data.floorRating;
    function get_forceTimeBar():Bool return ClientPrefs.data.forceTimeBar;

    // Gameplay Settings
    public var UEplayBothSides(get, null):Bool;
    public var UEhealthDrain(get, null):Bool;
    public var UEsustainOneNote(get, null):Bool;
    public var UEsd(get, null):Bool;
    public var UEhealthdrainp2(get, null):Bool;
    public var UEIncreasePBR(get, null):Bool;

    function get_UEplayBothSides():Bool return ClientPrefs.data.gameplaySettings.get('pbs');
    function get_UEhealthDrain():Bool return ClientPrefs.data.gameplaySettings.get('hd');
    function get_UEsustainOneNote():Bool return ClientPrefs.data.gameplaySettings.get('sn');
    function get_UEsd():Bool return ClientPrefs.data.gameplaySettings.get('sd');
    function get_UEhealthdrainp2():Bool return ClientPrefs.data.gameplaySettings.get('hdp2');
    function get_UEIncreasePBR():Bool return ClientPrefs.data.gameplaySettings.get('ipbr');
}