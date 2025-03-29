package vschar.objects;

import Note.EventNote;
import BaseStage.Countdown;

class ScriptedCharacter
{
	private var game(default, set):Dynamic = PlayState.instance;
	public var onPlayState:Bool = false;
	public var type:String = 'bf';
	public var character:Character;
	public var wasPreloaded:Bool = false;
	inline private function set_game(value:MusicBeatState)
	{
		onPlayState = (Std.isOfType(value, PlayState));
		game = value;
		return value;
	}
	public function new(type:String = 'bf', isPreloaded:Bool = false)
	{
		this.game = MusicBeatState.getState();
		
		if (this.game != null)
		{
			switch (type)
			{
				case 'bf':
					character = game.boyfriend;
				case 'gf':
					character = game.gf;
				case 'dad':
					character = game.dad;
			}
			this.type = type;
			if (!isPreloaded) // if it is preloaded, Create has to come later.
				create();
		}
	}
	//main callbacks
	public function create() {}
	public function createPost() {}
	public function update(elapsed:Float) {}
	public function countdownTick(count:Countdown, num:Int) {}

	// FNF steps, beats and sections
    var curBeat(get, null):Int;
    var curStep(get, null):Int;
    var curSection(get, null):Int;
    function get_curBeat():Int return game.curBeat;
    function get_curStep():Int return game.curStep;
    function get_curSection():Int return @:privateAccess PlayState.instance.curSection;
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
    
	// overrides
	function startCountdown() return PlayState.instance.startCountdown();
	function endSong() return PlayState.instance.endSong();
}