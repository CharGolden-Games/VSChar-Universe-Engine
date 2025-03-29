package;

import vschar.objects.ScriptedCharacter;
import vschar.backend.ExtendedMeta;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxBasic;

class MusicBeatState extends modchart.modcharting.ModchartMusicBeatState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	public static var blockReset:Bool = false;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		if (PlayState.instance != null)
		{
			if (getState() != PlayState.instance){
				if (ExtendedMeta.get('songArtist') != '')
					ExtendedMeta.set('songArtist', '');

				if (ExtendedMeta.get('songAssetArtist') != '')
					ExtendedMeta.set('songAssetArtist', '');
				
				if (ExtendedMeta.get('curSong') != '')
					ExtendedMeta.set('curSong', '');
			}
			else
			{
				ExtendedMeta.initialize(); // Reset them variables.
			}
		}
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		if (!blockReset)
			Paths.change_songFolderRedirect('basegame'); // Reset this value every state change!
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.6, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];
	public var curScriptedCharacters:CurScriptedCharacters;
	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}

	//Stupid stage function shit. - Char 2025
	function stagesFunc(func:BaseStage->Void)
		{
			for (stage in stages)
				if(stage != null && stage.exists && stage.active)
					func(stage);
		}

	function scriptedCharFunc(func:ScriptedCharacter->Void)
	{
		if (curScriptedCharacters != null)
		{
			curScriptedCharacters.allFunc(func);
		}
	}
}

class CurScriptedCharacters
{
	public var bf:ScriptedCharacter;
	public var gf:ScriptedCharacter;
	public var dad:ScriptedCharacter;

	public function new(?preloadBF:String, ?preloadGF:String, ?preloadDad:String)
	{
		if (preloadBF != null)
		{
			bf = new ScriptedCharacter(preloadBF, true);
		}

		if (preloadGF != null)
		{
			gf = new ScriptedCharacter(preloadGF, true);
		}

		if (preloadDad != null)
		{
			dad = new ScriptedCharacter(preloadDad, true);
		}
	}

	public function initializeScriptedCharacter(char:String, type:String = 'bf')
	{
		switch(char)
		{
			case 'char':
				switch (type)
				{
					case 'bf':
						bf = new vschar.characters.Char(type);
					case 'gf':
						gf = new vschar.characters.Char(type);
					case 'dad':
						dad = new vschar.characters.Char(type);
				}
			default:
				switch (type)
				{
					case 'bf':
						bf = null;
					case 'gf':
						gf = null;
					case 'dad':
						dad = null;
				}
		}
	}

	public function allFunc(func:ScriptedCharacter->Void)
	{
		if (bf != null)
			func(bf);
		if (gf != null)
			func(gf);
		if (dad != null)
			func(dad);
	}
}