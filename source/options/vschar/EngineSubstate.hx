package options.vschar;

import options.Option.AffectsHUDStyle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextFormat;
import flixel.util.FlxColor;

using ue.backend.ExtendedStringTools;

class EngineSubstate extends BaseOptionsMenu {
	var camText:FlxCamera;

	public var health:Float = 1;

	// HUD Type option shit.
	public var scoreTxt:FlxText;
		// Codename Engine Hud
    public var missesTxt:FlxText; // Codename Engine Text
	public var accFormat:FlxTextFormat = new FlxTextFormat(0xFF888888, false, false, 0); // Codename Engine Text Format
    public var accuracyTxt:FlxText; // Codename Engine Text

    	// Kade Engine Hud
    public var ratingTxt:FlxText;

    	// VS Char Hud
    public var vsCharText_Score:String = 'How SICK you are:';
    public var vsCharText_MissesPt1:String = 'Messed Up';
    public var vsCharText_MissesPt2:String = ' Times';
    public var scoreTxtFormat:FlxTextFormat = new FlxTextFormat(0xFF888888, false, false, 0); // VS Char Text Format

		// Universe Engine HUD
    var UEmiss:FlxText;
    var UEscore:FlxText;
    var UErating:FlxText;
    var YHpos:Int = 670;
    var XHpos:Int = 30;

		// General HUD
	public var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	public var camHUD:FlxCamera;

		// `Option Affects` HUD
	public var optionAffects:FlxText;

    public function new() {
        title = 'Char Engine Settings';
		rpcTitle = 'Char Engine Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Do Rotation Bop',
			'If checked, allows the screen to rotate onBeatHit',
			'rotBop',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('HUD Style',
			'What should the HUD look similar to?\nGET YOUR BIG A- HEALTHBAR OUT THE CAPTION',
			'hudStyle',
			'string',
			'VS Char',
			['Universe Engine', 'Codename Engine', 'Psych Engine', 'Kade Engine', "Funkin'", 'VS Char']); // So many HUD types! ... Why did I do this again?
		addOption(option);
		option.onChange = updateHealthbar;

		var option:Option = new Option('Floor Rating',
		"Whether to round down the rating when displaying the accuracy\ni.e 97.9% becomes 97%",
		'floorRating',
		'bool',
		false);
		option.affectsHUD.vc = true;
		option.hudStyleOption = true;
		addOption(option);

		var option:Option = new Option('Force Time Bar',
		"Whether to show the time bar regardless of if the style hides it",
		'forceTimeBar',
		'bool',
		false);
		option.affectsHUD.cn = true;
		option.affectsHUD.ke = true;
		option.affectsHUD.funkin = true;
		option.hudStyleOption = true;
		addOption(option);

		var option:Option = new Option('Bads/Shits break combo',
		"Whether to break combo on bad/shit rating.",
		'badsShitsBreakCombo',
		'bool',
		false);
		option.affectsHUD.ke = true;
		option.affectsHUD.vc = true;
		option.hudStyleOption = true;
		addOption(option);

		super();
    }

	override function create() {
		super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);

		healthBarBG = new AttachedSprite('old-healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBarBG.sprTracker = healthBar;
		healthBar.createFilledBar(0xFFAF66CE, 0xFF00CCFF);
		healthBar.updateBar();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;

		accuracyTxt = new FlxText(350, scoreTxt.y, 300, 'Accuracy:69.69% - D', 16).setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		accuracyTxt.addFormat(accFormat, 0, 1);
		accuracyTxt.scrollFactor.set();

		missesTxt = new FlxText(accuracyTxt.x + 150, scoreTxt.y, 300, 'Misses:420', 16).setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		missesTxt.scrollFactor.set();

		ratingTxt = new FlxText(0, 0, FlxG.width, "Perfects: 69\nSicks: 420\nGoods: 20\nBads: 10\nShits: 2", 20);
		ratingTxt.setFormat(Paths.font('vcr.ttf'), 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
		ratingTxt.screenCenter(Y);
		
		optionAffects = new FlxText(0, 0, FlxG.width, 'Affects HUD style:\n"Universe Engine": false\n"Codename Engine": false\n"Psych Engine": false\n"Kade Engine": false\n"Funkin\'": false\n"VS Char": false', 20);
		optionAffects.setFormat(Paths.font('vcr.ttf'), 30, 0xFFFFFFFF, RIGHT, OUTLINE, 0xFF000000);
		optionAffects.borderSize = 3;
		optionAffects.screenCenter(Y);

        UEmiss = new FlxText(XHpos, YHpos - 40, 500, "Screw-Ups: 420", 21);
        UEmiss.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);

        UEscore = new FlxText(XHpos, YHpos - 20, 500, "Score: 12345", 21);
        UEscore.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);

        UErating = new FlxText(XHpos, YHpos, 500, "Rating: (Clear) 69.69%", 21);
        UErating.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);

		UEmiss.alpha = 0.5;
		UEscore.alpha = 0.5;
		UErating.alpha = 0.5;

		accuracyTxt.visible = false;
		missesTxt.visible = false;
		ratingTxt.visible = false;
		optionAffects.visible = false;
		UEmiss.visible = false;
		UEscore.visible = false;
		UErating.visible = false;

		healthBarBG.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missesTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		ratingTxt.cameras = [camHUD];
        UErating.cameras = [camHUD];
        UEscore.cameras = [camHUD];
        UEmiss.cameras = [camHUD];

		add(healthBar);
		add(healthBarBG);
		add(scoreTxt);
		add(missesTxt);
		add(accuracyTxt);
		add(ratingTxt);
        add(UEmiss);
        add(UEscore);
        add(UErating);
		add(optionAffects);

		camHUD.visible = false;
	}

	function updateHealthbar()
	{
		var hudStyle = ClientPrefs.data.hudStyle;

		// Reset the healthbar first.
		healthBar.createFilledBar(0xFFAF66CE, 0xFF00CCFF);
		healthBar.updateBar();
		healthBarBG.loadGraphic(Paths.image('old-healthBar'));
		try
		{
			scoreTxt.removeFormat(scoreTxtFormat);
		}
		catch(e:Dynamic) {}

		// Check which HUD to preview!
		switch(hudStyle)
		{
			case "Universe Engine":
				healthBarBG.loadGraphic(Paths.image('healthBar'));

			case "Funkin'" | 'Kade Engine':
				healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
				healthBar.updateBar();
		}

		updateText(hudStyle);
	}

	function updateText(hudStyle:String)
	{
		// Reset the text first.
		scoreTxt.visible = true;
		ratingTxt.visible = false;
		missesTxt.visible = false;
		accuracyTxt.visible = false;
		UEscore.visible = false;
		UEmiss.visible = false;
		UErating.visible = false;
		scoreTxt.x = 0;
		scoreTxt.text = 'Score: 12345 | Misses: 420 | Rating: 69.69% - Clear';
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.fieldWidth = FlxG.width;
		
		switch (hudStyle)
		{
			case 'Universe Engine':
				scoreTxt.visible = false;
				UEscore.visible = true;
				UEmiss.visible = true;
				UErating.visible = true;

			case 'Kade Engine':
				scoreTxt.text = 'Score:12345 | Combo Breaks:420 | Accuracy:69.69 % | Rating: C';
				ratingTxt.visible = true;

			case "Funkin'":
                scoreTxt.size = 16;
                scoreTxt.text = 'Score: 12,345';
                scoreTxt.fieldWidth = FlxG.width - 400;
                scoreTxt.alignment = RIGHT;

			case 'Codename Engine':
				scoreTxt.setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, RIGHT, OUTLINE, 0xFF000000);
				scoreTxt.text = 'Score:12345';
				scoreTxt.x = 600;
				scoreTxt.alignment = RIGHT;
				scoreTxt.fieldWidth = 300;
				missesTxt.visible = true;
				accuracyTxt.visible = true;
                @:privateAccess {
                    accFormat.format.color = 0xFFFFAA44;

                    for (i => frmtRange in accuracyTxt._formatRanges) if (frmtRange.format == accFormat) {
                        accuracyTxt._formatRanges[i].range.start = accuracyTxt.text.length - ('D').length;
                        accuracyTxt._formatRanges[i].range.end = accuracyTxt.text.length;
                        break;
                    }
                }

			case 'VS Char':
				scoreTxt.size = 16;
				var curAccuracy:Float = 69.69;
				if (ClientPrefs.data.floorRating)
					curAccuracy = curAccuracy.floor();
				scoreTxt.text = 'How SICK you are: 12,345 | Messed Up 420 Times\nAccuracy: $curAccuracy% | Rating: Hehe, Funny Number (Actually you kinda fucking suck)';
				scoreTxt.addFormat(scoreTxtFormat, 0, 1);

				@:privateAccess {
					scoreTxtFormat.format.color = 0xFF00FF00;

					for (i => frmtRange in scoreTxt._formatRanges) if (frmtRange.format == scoreTxtFormat) {
						scoreTxt._formatRanges[i].range.start = scoreTxt.text.length - ('Hehe, Funny Number (Actually you kinda fucking suck)').length;
						scoreTxt._formatRanges[i].range.end = scoreTxt.text.length;
						break;
				}
			}
		}

		if (optionAffects != null)
		{
			optionAffects.visible = curOption.hudStyleOption;
			var affectsHUD:AffectsHUDStyle = curOption.affectsHUD;
			optionAffects.text = ''
			+ 'Affects HUD style :      \n\n\n'
			+ '"Universe Engine" : ${affectsHUD.ue.toString()}\n'
			+ '"Codename Engine" : ${affectsHUD.cn.toString()}\n'
			+ '"Psych Engine"    : ${affectsHUD.pe.toString()}\n'
			+ '"Kade Engine"     : ${affectsHUD.ke.toString()}\n'
			+ '"Funkin\'"         : ${affectsHUD.funkin.toString()}\n'
			+ '"VS Char"         : ${affectsHUD.vc.toString()}';
		}
	}

	@:deprecated('Deprecated function: Use o.toString() instead (this literally just serves as a redirect.)')
	function boolToString(bool:Bool):String
	{
		return bool.toString();
	}

	override function changeSelection(change:Int = 0) {
		super.changeSelection(change);

		if (camHUD != null)
		{
			updateHealthbar();
			if (curOption.name == 'HUD Style')
			{
				camHUD.visible = true;
			}
			else
			{
				if (camHUD.visible)
					camHUD.visible = false;
			}
		}
	}
}