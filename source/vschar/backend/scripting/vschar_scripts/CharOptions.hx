package vschar.backend.scripting.vschar_scripts;

import ue.UEScript;
import ue.uescripts.Options.UEHud as UEHud_Script;

class CharOptions extends BaseScript {}

class RotBop extends BaseScript
{
    public function new() super('Rotate HUD onBeatHit');
    public static var isInitialized:Bool = false;

    public static var frequency:Int = 2;
    public static var intensity:Float = 1;
    public static var allowFlickering = false;
    public static var rotateCamGame:Bool = true;

    var timesBopped:Int = 0;

    public override function initialize() {
        super.initialize();

        frequency = 2;
        intensity = 1;
        allowFlickering = false;
        rotateCamGame = true;
    }

    public override function onBeatHit() {
        super.onBeatHit();

        doBop();
    }

    function doBop()
    {
        var finalAngle1:Float = -(15 * intensity);
        var finalAngle2:Float = (15 * intensity);

        // Have to int these so it doesn't flicker as it looks worse then when it's the HUD flickering.
        var finalAngle3:Float = Std.int(7 * intensity);
        var finalAngle4:Float = Std.int(-(7 * intensity));

        if (!allowFlickering)
        {
            finalAngle1 = Std.int(finalAngle1);
            finalAngle2 = Std.int(finalAngle2);
        }
        
        if (curBeat % frequency == 0)
        {
            if (timesBopped == 0)
            {
                camGame.angle = finalAngle3;
                camHUD.angle = finalAngle1;
                timesBopped = 1;
            }
            else
            {
                camHUD.angle = finalAngle2;
                camGame.angle = finalAngle4;
                timesBopped = 0;
            }
        }
    }

    public override function onSongStart() {
        super.onSongStart();

        isInitialized = true;
        doBop();
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (isInitialized)
        {
            if (camHUD.angle != 0)
            {
                if (camHUD.angle < 0)
                {
                    camHUD.angle++;
                }
                else
                {
                    camHUD.angle += -1;
                }
            }
            if (camGame.angle != 0)
            {
                if (camGame.angle < 0)
                {
                    camGame.angle++;
                }
                else
                {
                    camGame.angle += -1;
                }
            }
        }
    }

    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
        super.onEvent(name, value1, value2, strumTime);
		var flValue1:Null<Float> = Std.parseFloat(value1);
		var flValue2:Null<Float> = Std.parseFloat(value2);
		if(Math.isNaN(flValue1)) flValue1 = null;
		if(Math.isNaN(flValue2)) flValue2 = null;
        

        if (name == 'Change RotSpeed')
        {
            if (flValue1 != null)
            {
                frequency = Std.int(flValue1);
            }
            if (flValue2 != null)
            {
                intensity = flValue2;
            }
        }
        if (name == 'RotBop Properties')
        {
            if (value1.toLowerCase() == 'true' || value1 == '1')
            {
                allowFlickering = true;
            }
            else
            {
                allowFlickering = false;
            }
            if (value2.toLowerCase() == 'true' || value1 == '1')
            {
                rotateCamGame = true;
            }
            else
            {
                rotateCamGame = false;
            }
        }
    }
}

class HudType extends BaseScript
{
    // Main variables
    public function new() super('VSChar Hud Type');

    // Codename Engine Hud
    public var missesTxt:FlxText; // Codename Engine Text
	public var accFormat:FlxTextFormat = new FlxTextFormat(0xFF888888, false, false, 0); // Codename Engine Text Format
    public var accuracyTxt:FlxText; // Codename Engine Text
    public var curRating:ComboRating; // Codename Engine Text
    public var comboRatings:Array<ComboRating> = [new ComboRating(0, "F", 0xFFFF4444), new ComboRating(0.5, "E", 0xFFFF8844), new ComboRating(0.7, "D", 0xFFFFAA44), new ComboRating(0.8, "C", 0xFFFFFF44), new ComboRating(0.85, "B", 0xFFAAFF44), new ComboRating(0.9, "A", 0xFF88FF44), new ComboRating(0.95, "S", 0xFF44FFFF), new ComboRating(1, "S++", 0xFF44FFFF)];

    // Kade Engine Hud
    public var ratingTxt:FlxText;

    // VS Char Hud
    public var vsCharText_Score:String = 'How SICK you are:';
    public var vsCharText_MissesPt1:String = 'Messed Up';
    public var vsCharText_MissesPt2:String = ' Times';
    public var scoreTxtFormat:FlxTextFormat = new FlxTextFormat(0xFF888888, false, false, 0); // VS Char Text Format
    public var vsCharRatingStuff:Array<Dynamic> = [
        ['COORDINATION, HAVE YOU HEARD OF IT?', 0.2], // From 0% to 19%
        ['Are you even hitting the notes?', 0.4], // From 20% to 39%
        ['Get better nerd.', 0.5], // From 40% to 49%
        ['Bruh', 0.6], // From 50% to 59%
        ['Gettin\' there.', 0.69], // From 60% to 68%
        ['Hehe, Funny Number', 0.7], // 69%
        ['Pretty Nice', 0.8], // From 70% to 79%
        ['Kickin\' Ass!', 0.9], // From 80% to 89%
        ['HELL YEAH!', 1], // From 90% to 99%
        ['YOU ARE A BOT!!', 1] // The value on this one isn't used actually, since Perfect is always "1"
    ];
    var funnyMissText:FlxText;

    public override function onCreatePost() {
        super.onCreatePost();

        PlayState.instance.healthBarBG.loadGraphic(Paths.image('old-healthBar'));

        switch (hudStyle)
        {
            case 'Codename Engine':
                PlayState.instance.scoreTxt.setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, RIGHT, OUTLINE, 0xFF000000);
                PlayState.instance.scoreTxt.alignment = RIGHT;
                PlayState.instance.scoreTxt.x = 200;
                PlayState.instance.scoreTxt.fieldWidth = 300;
                accuracyTxt = new FlxText(PlayState.instance.scoreTxt.x + 150, PlayState.instance.scoreTxt.y, 300, 'Accuracy:-% (N/A)', 16).setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
                missesTxt = new FlxText(accuracyTxt.x + 150, PlayState.instance.scoreTxt.y, 300, 'Misses:0', 16).setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
                accuracyTxt.addFormat(accFormat, 0, 1);
                accuracyTxt.scrollFactor.set();
                accuracyTxt.cameras = [camHUD];
                missesTxt.scrollFactor.set();
                missesTxt.cameras = [camHUD];
                add(missesTxt);
                add(accuracyTxt);
                PlayState.instance.scoreTxt.x = 600; // BIT redundant ig but screw you!
                
                // Codename don't got no timebar.
                if (!forceTimeBar){
                    game.timeBarBG.visible = false;
                    game.timeBar.visible = false;
                    game.timeTxt.visible = false;
                }

            case 'Psych Engine':
                UEScript.removeScript('VSChar Hud Type'); // Remove this script if using vanilla psych HUD
                return;

            case "Funkin'":
                // Base Funkin' don't got no timebar.
                if (!forceTimeBar){
                    game.timeBarBG.visible = false;
                    game.timeBar.visible = false;
                    game.timeTxt.visible = false;
                }
    
                PlayState.instance.healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
                PlayState.instance.healthBar.updateBar();
                PlayState.instance.scoreTxt.size = 16;
                PlayState.instance.scoreTxt.text = 'Score: 0';
                PlayState.instance.scoreTxt.fieldWidth = FlxG.width - 400;
                PlayState.instance.scoreTxt.alignment = RIGHT;

            case "VS Char":
                checkCurStage();
                PlayState.instance.scoreTxt.text = '$vsCharText_Score 0 | $vsCharText_MissesPt1 0$vsCharText_MissesPt2\nAccuracy: N/A | Rating: YOU HAVEN\'T DONE SHIT YET';
                PlayState.instance.scoreTxt.size = 16;
                PlayState.instance.scoreTxt.addFormat(scoreTxtFormat, 0, 1);
                @:privateAccess {
                    scoreTxtFormat.format.color = 0xFF888888;
                    
                    for (i => frmtRange in PlayState.instance.scoreTxt._formatRanges) if (frmtRange.format == scoreTxtFormat) {
                        PlayState.instance.scoreTxt._formatRanges[i].range.start = PlayState.instance.scoreTxt.text.length - ("YOU HAVEN'T DONE SHIT YET").length;
                        PlayState.instance.scoreTxt._formatRanges[i].range.end = PlayState.instance.scoreTxt.text.length;
                        break;
                    }
                }
                PlayState.ratingStuff = vsCharRatingStuff;
                PlayState.instance.timeBar.createFilledBar(0xFF000000, 0xFFFFAA44);
                PlayState.instance.timeBar.updateBar();
                funnyMissText = new FlxText(0, 0, FlxG.width, "you fucking SUCK!\n(Ya missed bud)");
                funnyMissText.setFormat(Paths.font('vcr.ttf'), 60, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
                funnyMissText.borderSize = 5;
                funnyMissText.screenCenter(Y);
                funnyMissText.cameras = [camHUD];
                add(funnyMissText);
                funnyMissText.alpha = 0;

            case "Kade Engine":
                PlayState.instance.scoreTxt.text = 'Score:0 | Combo Breaks:0 | Accuracy:0 % | Rating: N/A';
                ratingTxt = new FlxText(0, 0, FlxG.width, "Perfects: 0\nSicks: 0\nGoods: 0\nBads: 0\nShits: 0", 20);
                ratingTxt.setFormat(Paths.font('vcr.ttf'), 20, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
                ratingTxt.screenCenter(Y);
                ratingTxt.cameras = [camHUD];
                PlayState.instance.healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
                PlayState.instance.healthBar.updateBar();
                add(ratingTxt);

                // Kade Engine don't got no timebar.
                if (!forceTimeBar){
                    game.timeBarBG.visible = false;
                    game.timeBar.visible = false;
                    game.timeTxt.visible = false;
                }
        }
        
        // For shit like Codename HUD that has a specific way to update the text.
        updateText();
    }

    function checkCurStage()
    {
        var curStage:String = PlayState.curStage.toLowerCase();
        switch (hudStyle)
        {
            case "VS Char":
                if (curStage == 'saloon')
                {
                    vsCharText_Score = 'Money Earned:';
                    vsCharText_MissesPt1 = 'Shots Missed:';
                    vsCharText_MissesPt2 = '';
                }
                if (curStage == 'micheals-forest')
                {
                    if (PlayState.SONG.subStage == "Micheal's Virtual Forest Stage")
                    {
                        vsCharText_Score = 'Score:';
                        vsCharText_MissesPt1 = 'Missed:';
                        vsCharText_MissesPt2 = '';
                        vsCharRatingStuff = [
                            ['Slow af reflexes ig.', 0.2], // From 0% to 19%
                            ['Are you even hitting the notes?', 0.4], // From 20% to 39%
                            ['Die.', 0.5], // From 40% to 49%
                            ['Yeesh, that\'s... bad.', 0.6], // From 50% to 59%
                            ['Ok.', 0.69], // From 60% to 68%
                            ['Hehe, Funny Number', 0.7], // 69%
                            ['Nice', 0.8], // From 70% to 79%
                            ['Good', 0.9], // From 80% to 89%
                            ['Sick!', 1], // From 90% to 99%
                            ['PERFECT!!', 1] // The value on this one isn't used actually, since Perfect is always "1"
                        ];
                    }
                }
        }
    }

    function updateText()
    {
        switch (hudStyle)
        {
            case 'Codename Engine':
                /* Basically Codename Engine's code adapted for Psych Engine.
                * Sorry I just R E A L L Y like how Codename's score text looks.
                */
                PlayState.instance.scoreTxt.text = 'Score:$score';
                missesTxt.text = 'Misses:$misses';
                
                if (curRating == null)
                    curRating = new ComboRating(0, '[N/A]', 0xFF888888);

                @:privateAccess {
                    accFormat.format.color = curRating.color;
                    accuracyTxt.text = 'Accuracy:${accuracy < 0 ? '-%' : '$accuracy% - ${curRating.rating}'}';

                    for (i => frmtRange in accuracyTxt._formatRanges) if (frmtRange.format == accFormat) {
                        accuracyTxt._formatRanges[i].range.start = accuracyTxt.text.length - curRating.rating.length;
                        accuracyTxt._formatRanges[i].range.end = accuracyTxt.text.length;
                        break;
                    }
                }

            case "Funkin'":
                PlayState.instance.scoreTxt.text = 'Score: $score';

            case 'VS Char':
                if (totalPlayed > 0)
                {
                    var curRating:String = ratingName;
                    var curColor = 0xFFFFFFFF; // So if there's an override it's still visible.

                    if (ratingName == 'COORDINATION, HAVE YOU HEARD OF IT?' || ratingName == 'Are you even hitting the notes?' || ratingName == 'Get better nerd.' || ratingName == 'Bruh') {
                        curColor = 0xFFFF0000;
                    }
                    else if (ratingName == 'Gettin\' there.' || ratingName == 'Hehe, Funny Number' || ratingName == 'Pretty Nice') {
                        curColor = 0xFF00FF00;
                        if (PlayState.instance.shits > 0 || PlayState.instance.bads > 0 || misses > 0)
                        {
                            curRating += ' (Actually you kinda fucking suck)';
                        }
                    }
                    else {
                        curColor = 0xFF00FFFF;
                        if (PlayState.instance.shits > 0 || PlayState.instance.bads > 0 || misses > 0)
                        {
                           curRating += ' (Actually you kinda fucking suck)';
                        }
                    }
                    var curAccuracy:Float = accuracy;
                    if (floorRating)
                        curAccuracy = Math.floor(accuracy);

                    var ratingText:String = 'Accuracy: $curAccuracy% | Rating: $curRating';
                    PlayState.instance.scoreTxt.text = '$vsCharText_Score $score | $vsCharText_MissesPt1 $misses$vsCharText_MissesPt2\n$ratingText';

                    @:privateAccess {
                        scoreTxtFormat.format.color = curColor;
                        
                        for (i => frmtRange in PlayState.instance.scoreTxt._formatRanges) if (frmtRange.format == scoreTxtFormat) {
                            PlayState.instance.scoreTxt._formatRanges[i].range.start = PlayState.instance.scoreTxt.text.length - curRating.length;
                            PlayState.instance.scoreTxt._formatRanges[i].range.end = PlayState.instance.scoreTxt.text.length;
                            break;
                        }
                    }
                }

            case "Kade Engine":
                if (totalPlayed > 0)
                {
                    PlayState.instance.scoreTxt.text = 'Score:$score | Combo Breaks:$misses | Accuracy:$accuracy % | Rating: ${GenerateLetterRank(accuracy)}';
                    ratingTxt.text = 'Perfects: ${PlayState.instance.perfects}\nSicks: ${PlayState.instance.sicks}\nGoods: ${PlayState.instance.goods}\nBads: ${PlayState.instance.bads}\nShits: ${PlayState.instance.shits}';
                }
        }
    }

    // From KE directly
    public function GenerateLetterRank(accuracy:Float) // generate a letter ranking
        {
            var ranking:String = "N/A";
            if (ClientPrefs.getGameplaySetting('botplay', false) == true)
                ranking = "BotPlay";
    
            if (misses == 0 && PlayState.instance.bads == 0 && PlayState.instance.shits == 0 && PlayState.instance.goods == 0) // Marvelous (SICK) Full Combo
                ranking = "(MFC)";
            else if (misses == 0 && PlayState.instance.bads == 0 && PlayState.instance.shits == 0 && PlayState.instance.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
                ranking = "(GFC)";
            else if (misses == 0) // Regular FC
                ranking = "(FC)";
            else if (misses < 10) // Single Digit Combo Breaks
                ranking = "(SDCB)";
            else
                ranking = "(Clear)";
    
            // WIFE TIME :)))) (based on Wife3)
    
            var wifeConditions:Array<Bool> = [
                accuracy >= 99.9935, // AAAAA
                accuracy >= 99.980, // AAAA:
                accuracy >= 99.970, // AAAA.
                accuracy >= 99.955, // AAAA
                accuracy >= 99.90, // AAA:
                accuracy >= 99.80, // AAA.
                accuracy >= 99.70, // AAA
                accuracy >= 99, // AA:
                accuracy >= 96.50, // AA.
                accuracy >= 93, // AA
                accuracy >= 90, // A:
                accuracy >= 85, // A.
                accuracy >= 80, // A
                accuracy >= 70, // B
                accuracy >= 60, // C
                accuracy < 60 // D
            ];
    
            for (i in 0...wifeConditions.length)
            {
                var b = wifeConditions[i];
                if (b)
                {
                    switch (i)
                    {
                        case 0:
                            ranking += " AAAAA";
                        case 1:
                            ranking += " AAAA:";
                        case 2:
                            ranking += " AAAA.";
                        case 3:
                            ranking += " AAAA";
                        case 4:
                            ranking += " AAA:";
                        case 5:
                            ranking += " AAA.";
                        case 6:
                            ranking += " AAA";
                        case 7:
                            ranking += " AA:";
                        case 8:
                            ranking += " AA.";
                        case 9:
                            ranking += " AA";
                        case 10:
                            ranking += " A:";
                        case 11:
                            ranking += " A.";
                        case 12:
                            ranking += " A";
                        case 13:
                            ranking += " B";
                        case 14:
                            ranking += " C";
                        case 15:
                            ranking += " D";
                    }
                    break;
                }
            }
    
            if (accuracy == 0)
                ranking = "N/A";
            else if (ClientPrefs.getGameplaySetting('botplay', false) == true)
                ranking = "BotPlay";
    
            return ranking;
        }

    function updateRating()
    {
        if (hudStyle == 'Codename Engine')
        {
            for (rating in comboRatings)
            {
                if (rating.percent <= ratingPercent)
                    curRating = rating;
            }
        }
    }

    var missesTxtTween:FlxTween = null;
    var accuracyTxtTween:FlxTween = null;

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        updateRating();
        updateText();
    
        if (hudStyle == 'Codename Engine')
        {
            if (ClientPrefs.data.scoreZoom)
            {
                if (missesTxtTween != null)
                    missesTxtTween.cancel();
                if (accuracyTxtTween != null)
                    accuracyTxtTween.cancel();
    
                accuracyTxt.scale.set(1.075, 1.075);
                missesTxt.scale.set(1.075, 1.075);
    
                missesTxtTween = FlxTween.tween(missesTxt.scale, {x: 1, y: 1}, 0.2, {onComplete: function(twn:FlxTween){
                    missesTxtTween = null;
                }});
                accuracyTxtTween = FlxTween.tween(accuracyTxt.scale, {x: 1, y: 1}, 0.2, {onComplete: function(twn:FlxTween){
                    accuracyTxtTween = null;
                }});
            }
        }
    }

    var funnyMissTween:FlxTween;

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        switch (hudStyle)
        {
            case 'VS Char':
                if (funnyMissTween != null)
                    funnyMissTween.cancel();

                funnyMissText.alpha = 1;
                funnyMissTween = FlxTween.tween(funnyMissText, {alpha: 0}, 0.75, {ease: FlxEase.linear});
        }

        updateRating();
        updateText();
    }

    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
        super.onEvent(name, value1, value2, strumTime);

        if (name == 'Change Character')
        {
            switch (hudStyle)
            {
                case "Funkin'" | "Kade Engine":
                    PlayState.instance.healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
                    PlayState.instance.healthBar.updateBar();
            }
        }
    }
}

private final class ComboRating {
	public var percent:Float;
	public var rating:String;
	public var color:FlxColor;

	public function new(percent:Float, rating:String, color:FlxColor) {
		this.percent = percent;
		this.rating = rating;
		this.color = color;
	}
}