package vschar.backend;

import animateatlas.AtlasFrameMaker;

class BaseScript {
    // These variables come from BaseStage.hx lmao.
	private var game(default, set):Dynamic = PlayState.instance;
	public var onPlayState:Bool = false;
	public var members(get, never):Array<FlxBasic>;

    public var boyfriend(get, null):Boyfriend;
    public var dad(get, null):Character;

    var songName(get, null):String;
    var difficultyName(get, null):String;
    var bpm(get, null):Float;

    var songPosition(get, null):Float;
    var score(get, null):Int;
    var misses(get, null):Int;
    var hits(get, null):Int;
    var rating(get, null):Float;
    var ratingFC(get, null):String;
    var songLength(get, null):Float;
    var noteOffset(get, null):Int;
    var curBeat(get, null):Int;
    var curStep(get, null):Int;

    var camGame(get, null):FlxCamera;
    var camHUD(get, null):FlxCamera;
    var camOther(get, null):FlxCamera;

    public var name:String = 'Unnamed Script';

    function get_boyfriend():Boyfriend return game.boyfriend;
    function get_dad():Character return game.dad;

    function get_difficultyName():String return CoolUtil.difficulties[PlayState.storyDifficulty];
    function get_songName():String return PlayState.SONG.song;
    function get_bpm():Float return PlayState.SONG.bpm;

    function get_songPosition():Float return Conductor.songPosition;
    function get_score():Int return game.songScore;
    function get_misses():Int return game.songMisses;
    function get_songLength():Float return FlxG.sound.music.length;
    function get_noteOffset():Int return ClientPrefs.noteOffset;
    function get_hits():Int return game.songHits;
    function get_rating():Float return game.ratingPercent;
    function get_ratingFC():String return game.ratingFC;
    function get_curBeat():Int return game.curBeat;
    function get_curStep():Int return game.curStep;
    function get_camGame():FlxCamera return game.camGame;
    function get_camHUD():FlxCamera return game.camHUD;
    function get_camOther():FlxCamera return game.camOther;
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
			leSprite.antialiasing = ClientPrefs.globalAntialiasing;
			PlayState.instance.modchartSprites.set(tag, leSprite);

            return leSprite;
		}

    function debugPrint(text1:Dynamic = '', text2:Dynamic = '', text3:Dynamic = '', text4:Dynamic = '', text5:Dynamic = '', color:FlxColor = FlxColor.WHITE)
    {
        var text:String = '' + text1 + text2 + text3 + text4 + text5;
        game.addTextToDebug(text, color);
        trace(text);
    }

    /**
     * Shit to do when loading (replaces onCreate)
     */
    public function initialize():Void {}

    public function onEvent(name:String, value1:String, value2:String):Void {}

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

    function get_UEHud():Bool return ClientPrefs.ueHud;
    function get_UEDetachedHB():Bool return ClientPrefs.dhb;
    function get_UEhudZoomOut():Bool return ClientPrefs.hudZoomOut;
    function get_UEkeystrokes():Bool return ClientPrefs.keystrokes;
    function get_UEcCounter():Bool return ClientPrefs.cc;
    function get_UESmoothHP():Bool return ClientPrefs.sh;
    function get_UEe100C():Bool return ClientPrefs.ec;
    function get_UEiconBop():Bool return ClientPrefs.ib;
    function get_UEtauntGo():Bool return ClientPrefs.tng;
    function get_UEshakeMiss():Bool return ClientPrefs.snm;
    function get_UEdarkenCamGame():Bool return ClientPrefs.dcm;
    function get_UEstrumsplash():Bool return ClientPrefs.uess;
    function get_UEmisssounds():Bool return ClientPrefs.uems;
    function get_UEresultscreen():Bool return ClientPrefs.ueresultscreen;
    function get_UEhudpos():String return ClientPrefs.hudPosUE;
    function get_UEsnTimeFollow():Bool return ClientPrefs.sntf;
    function get_UEhidetimeBar():Bool return ClientPrefs.huet;

    // Gameplay Settings
    public var UEplayBothSides(get, null):Bool;
    public var UEhealthDrain(get, null):Bool;
    public var UEsustainOneNote(get, null):Bool;
    public var UEsd(get, null):Bool;
    public var UEhealthdrainp2(get, null):Bool;
    public var UEIncreasePBR(get, null):Bool;

    function get_UEplayBothSides():Bool return ClientPrefs.gameplaySettings.get('pbs');
    function get_UEhealthDrain():Bool return ClientPrefs.gameplaySettings.get('hd');
    function get_UEsustainOneNote():Bool return ClientPrefs.gameplaySettings.get('sn');
    function get_UEsd():Bool return ClientPrefs.gameplaySettings.get('sd');
    function get_UEhealthdrainp2():Bool return ClientPrefs.gameplaySettings.get('hdp2');
    function get_UEIncreasePBR():Bool return ClientPrefs.gameplaySettings.get('ipbr');
}