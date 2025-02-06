package options.vschar;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

using StringTools;

class VSCharOptions extends MusicBeatState {
    var options:Array<String> = [
		'Engine',
		'Search Test'
	];
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String)
	{
		switch (label)
		{
			case 'Engine':
                trace('NOT DONE YET!');
			case 'Search Test':
				vschar.substates.SerarchSubstate.blockInput = true;
				vschar.substates.SerarchSubstate.blockEnter = true;
				openSubState(new vschar.substates.SerarchSubstate(['ATestItem1', 'BTestItem2', 'CTestItem3', 'DTestItem4', 'ETestItem5']));
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("VS Char Options Menu", null);

		if (FlxG.random.int(0, 10) == 5)
		{
			DiscordClient.changePresence("SUUUUUUSSS Char Options Menu", null);
		}
		#end

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		if (ClientPrefs.darkmode)
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("aboutMenu", "preload"));
			bg.color = 0xFFea71fd;
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			add(bg);

			var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x337F7F7F, 0x0));
			grid.velocity.set(20, 20);
			grid.alpha = 0;
			FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			add(grid);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			bg.color = 0xFFea71fd;
			bg.screenCenter();
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			add(bg);

			var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
			grid.velocity.set(20, 20);
			grid.alpha = 0;
			FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
			add(grid);
		}

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new options.SelectThing());
		}

		if (controls.ACCEPT)
		{
			openSelectedSubstate(options[curSelected]);
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}