package ue.uescripts;

import ue.UEScript.MasterScript;
import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;
class Options extends MasterScript
{
    public function new(?script:String)
    {
        super('Options Master Class');

        if (script != null)
            callScript(script);
    }
}
class UEHud extends BaseScript
{
    public function new() super('UEHud');
    var UEsong:FlxText;
    var UEtimetxt:FlxText;
    var UEmiss:FlxText;
    var UEscore:FlxText;
    var UErating:FlxText;

    var YHpos:Int = 670;
    var XHpos:Int = 30;

    public override function onCreatePost() {
        super.onCreatePost();

        UEsong = new FlxText(XHpos, 30, 500, "", 21);
        UEsong.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UEsong.cameras = [game.camHUD];
        add(UEsong);

        UEtimetxt = new FlxText(XHpos, 60, 500, "", 31);
        UEtimetxt.setFormat(Paths.font('funkin.ttf'), 31, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UEtimetxt.alpha = 0;
        UEtimetxt.cameras = [game.camHUD];
        add(UEtimetxt);

        UEmiss = new FlxText(XHpos, YHpos - 40, 500, "", 21);
        UEmiss.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UEmiss.cameras = [game.camHUD];
        add(UEmiss);

        UEscore = new FlxText(XHpos, YHpos - 20, 500, "", 21);
        UEscore.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UEscore.cameras = [game.camHUD];
        add(UEscore);

        UErating = new FlxText(XHpos, YHpos, 500, "", 21);
        UErating.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UErating.cameras = [game.camHUD];
        add(UErating);

            game.scoreTxt.visible = false;
            game.timeBarBG.visible = false;
            game.timeBar.visible = false;
            game.timeTxt.visible = false;
        UEtimetxt.x = UEsong.x;

        if (UEhudpos == 'CENTER')
        {
            UEmiss.screenCenter(X);
            UEscore.x = UEmiss.x;
            UErating.x = UEmiss.x;

            UEmiss.alignment = CENTER;
            UEscore.alignment = CENTER;
            UErating.alignment = CENTER;

            if (UEsnTimeFollow)
            {
                UEsong.x = UEmiss.x;
                if (UEDetachedHB)
                {
                    UEsong.y = 30;
                }
                else
                {
                    UEsong.y = 140;
                }
                UEtimetxt.x = UEmiss.x;
                UEtimetxt.y = UEsong.y + 30;
                UEsong.alignment = CENTER;
                UEtimetxt.alignment = CENTER;
            }
        }

        if (UEhudpos == 'RIGHT')
        {
            UEmiss.x = 740;
            UEscore.x = UEmiss.x;
            UErating.x = UEmiss.x;

            UEmiss.alignment = RIGHT;
            UEscore.alignment = RIGHT;
            UErating.alignment = RIGHT;

            if (UEsnTimeFollow)
            {
                UEsong.x = UEmiss.x;
                UEtimetxt.x = UEmiss.x;
                UEtimetxt.y = UEsong.y + 30;
                UEsong.alignment = RIGHT;
                UEtimetxt.alignment = RIGHT;
            }
        }
    }

    public override function onUpdatePost(elapsed:Float)
    {
        super.onUpdatePost(elapsed);
        
        UEtimetxt.text = '${formatTime(songPosition - noteOffset)} / ${formatTime(songLength)}';

        game.botplayTxt.alpha = 1;

        if (hits < 1)
        {
            UErating.text = 'Rating: ?'; // Original string is 'Rating: (N/A) 0%' but fuck you I like this better.
            UEscore.text = 'Score: 0';
        }
        else
        {
            UErating.text = 'Rating: ($ratingFC) ${FlxMath.roundDecimal(rating * 100, 2)}%';
            UEscore.text = 'Score: ${game.lerpScore}';
        }
    }

    var UEH_Disspear:FlxTimer;
    var UEHM_Disspear:FlxTimer;

    var UEmiss_m:FlxTween;
    var UEscore_h:FlxTween;
    var UErating_h:FlxTween;
    var UEtimetext_s:FlxTween;

    var UEmiss_red:FlxTween;
    var UEscore_red:FlxTween;
    var UErating_red:FlxTween;

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool)
    {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        if (UEH_Disspear != null)
            UEH_Disspear.cancel();
        if (UEHM_Disspear != null)
            UEHM_Disspear.cancel();

        if (UEmiss_m != null)
            UEmiss_m.cancel();
        if (UEscore_h != null)
            UEscore_h.cancel();
        if (UErating_h != null)
            UErating_h.cancel();

        UEmiss.alpha = 1;
        UEscore.alpha = 1;
        UErating.alpha = 1;

        UEH_Disspear = new FlxTimer().start(1, function(tmr:FlxTimer){
            UEscore_h = FlxTween.tween(UEscore, {alpha: 0.5}, 1, {ease: FlxEase.linear});
            UErating_h = FlxTween.tween(UErating, {alpha: 0.5}, 1, {ease: FlxEase.linear});
        });

        UEHM_Disspear = new FlxTimer().start(1, function(tmr:FlxTimer){
            UEmiss_m = FlxTween.tween(UEmiss, {alpha: 0.5}, 1, {ease: FlxEase.linear});
        });

        if (UEmiss_red != null)
            UEmiss_red.cancel();
        if (UEscore_red != null)
            UEscore_red.cancel();
        if (UErating_red != null)
            UErating_red.cancel();

        UEscore.color = 0xFFFF2B2B;
        UEmiss.color = 0xFFFF2B2B;
        UErating.color = 0xFFFF2B2B;

        UEmiss_red = FlxTween.color(UEmiss, 1, UEmiss.color, 0xFFFFFFFF, {ease: FlxEase.linear});
        UEscore_red = FlxTween.color(UEscore, 1, UEscore.color, 0xFFFFFFFF, {ease: FlxEase.linear});
        UErating_red = FlxTween.color(UErating, 1, UErating.color, 0xFFFFFFFF, {ease: FlxEase.linear});

        UEmiss.text = 'Screw-Ups: $misses';
    }

    var UEMtextSizeY:FlxTween;
    var UEMtextSizeXR:FlxTween;
    var ueBPTsizeR:Float = 0.75;
    var ueBPTsize:Float = 1.5;
    var ueBPTdur:Float = 0.25; 

    public override function onBeatHit()
    {
        if (game.curBeat % 1 == 0)
        {
            if (UEMtextSizeY != null)
                UEMtextSizeY.cancel();
            game.botplayTxt.scale.y = ueBPTsize;

            UEMtextSizeY = FlxTween.tween(game.botplayTxt.scale, {y: ueBPTdur}, 1, {ease: FlxEase.linear});
        }

        if (game.curBeat % 1 == 0)
        {
            if (UEMtextSizeXR != null)
                UEMtextSizeXR.cancel();
            game.botplayTxt.scale.x = ueBPTsizeR;

            UEMtextSizeXR = FlxTween.tween(game.botplayTxt.scale, {x: ueBPTdur}, 1, {ease: FlxEase.linear});
        }
    }

    public override function onSongStart() {
        super.onSongStart();

        UEscore_h = FlxTween.tween(UEscore, {alpha: 0.5}, 1, {ease: FlxEase.linear});
        UErating_h = FlxTween.tween(UErating, {alpha: 0.5}, 1, {ease: FlxEase.linear});
        UEmiss_m = FlxTween.tween(UEmiss, {alpha: 0.5}, 1, {ease: FlxEase.linear});
        if (!UEhidetimeBar)
        {
            UEtimetext_s = FlxTween.tween(UEtimetxt, {alpha: 1}, 1, {ease: FlxEase.linear});
        }
        lerpTypeString('$songName - $difficultyName');
    }

    public function lerpTypeString(s:String)
    {
        for (letter in 0...s.length)
        {
            new FlxTimer().start(0.1 * letter, function(tmr:FlxTimer){
                UEsong.text += s.charAt(letter);
            });
        }
    }

    function formatTime(milliseconds:Float):String
    {
        var seconds:Float = Math.floor(milliseconds / 1000);

        return FlxStringUtil.formatTime(seconds);
    }
}

/**
 *  This can literally just be put in PlayState, but to keep with the spirit of the other script recreations, I'll put it here.
 */
class IconBop extends BaseScript
{
    // Generic Values
    var funnies:Int = 1;
    var funnies64:Float = 0.5;
    var funnies2:Int = 50;
    var nuhuhy:Float = 0.7;
    var nuhuhx:Float = 1.2;

    // Tweens
        // iconP1
    var iconP1ANG:FlxTween;
    var iconP1_1x:FlxTween;
    var iconP1_1y:FlxTween;
    var iconP1_2x:FlxTween;
    var iconP1_2y:FlxTween;

        // iconP2
    var iconP2ANG:FlxTween;
    var iconP2_1x:FlxTween;
    var iconP2_1y:FlxTween;
    var iconP2_2x:FlxTween;
    var iconP2_2y:FlxTween;

    public function new() super('IconBop');

    function cancelTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.cancel();
        if (iconP2ANG != null)
            iconP2ANG.cancel();

        if (iconP1_1x != null)
            iconP1_1x.cancel();
        if (iconP1_1y != null)
            iconP1_1y.cancel();
        if (iconP2_1x != null)
            iconP2_1x.cancel();
        if (iconP2_1y != null)
            iconP2_1y.cancel();

        if (iconP1_2x != null)
            iconP1_2x.cancel();
        if (iconP1_2y != null)
            iconP1_2y.cancel();
        if (iconP2_2x != null)
            iconP2_2x.cancel();
        if (iconP2_2y != null)
            iconP2_2y.cancel();
    }

    function pauseTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.active = false;
        if (iconP2ANG != null)
            iconP2ANG.active = false;

        if (iconP1_1x != null)
            iconP1_1x.active = false;
        if (iconP1_1y != null)
            iconP1_1y.active = false;
        if (iconP2_1x != null)
            iconP2_1x.active = false;
        if (iconP2_1y != null)
            iconP2_1y.active = false;

        if (iconP1_2x != null)
            iconP1_2x.active = false;
        if (iconP1_2y != null)
            iconP1_2y.active = false;
        if (iconP2_2x != null)
            iconP2_2x.active = false;
        if (iconP2_2y != null)
            iconP2_2y.active = false;
    }

    function resumeTweens()
    {
        if (iconP1ANG != null)
            iconP1ANG.active = true;
        if (iconP2ANG != null)
            iconP2ANG.active = true;

        if (iconP1_1x != null)
            iconP1_1x.active = true;
        if (iconP1_1y != null)
            iconP1_1y.active = true;
        if (iconP2_1x != null)
            iconP2_1x.active = true;
        if (iconP2_1y != null)
            iconP2_1y.active = true;

        if (iconP1_2x != null)
            iconP1_2x.active = true;
        if (iconP1_2y != null)
            iconP1_2y.active = true;
        if (iconP2_2x != null)
            iconP2_2x.active = true;
        if (iconP2_2y != null)
            iconP2_2y.active = true;
    }

    function beat1()
    {
        game.iconP2.angle = funnies2;
        iconP2ANG = FlxTween.tween(game.iconP2, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.angle = funnies2;
        iconP1ANG = FlxTween.tween(game.iconP1, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.scale.x = nuhuhx;
        game.iconP1.scale.y = nuhuhy;
        game.iconP2.scale.x = nuhuhx;
        game.iconP2.scale.y = nuhuhy;

        iconP1_1x = FlxTween.tween(game.iconP1.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP1_1y = FlxTween.tween(game.iconP1.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1x = FlxTween.tween(game.iconP2.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1y = FlxTween.tween(game.iconP2.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
    }

    function beat2()
    {
        game.iconP2.angle = -funnies2;
        iconP2ANG = FlxTween.tween(game.iconP2, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.angle = -funnies2;
        iconP1ANG = FlxTween.tween(game.iconP1, {angle: 0}, funnies, {ease: FlxEase.expoOut});

        game.iconP1.scale.x = nuhuhx;
        game.iconP1.scale.y = nuhuhy;
        game.iconP2.scale.x = nuhuhx;
        game.iconP2.scale.y = nuhuhy;

        iconP1_1x = FlxTween.tween(game.iconP1.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP1_1y = FlxTween.tween(game.iconP1.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1x = FlxTween.tween(game.iconP2.scale, {x: 1}, funnies64, {ease: FlxEase.expoOut});
        iconP2_1y = FlxTween.tween(game.iconP2.scale, {y: 1}, funnies64, {ease: FlxEase.expoOut});
    }

    public override function onBeatHit() {
        super.onBeatHit();

        if (curBeat % 1 == 0)
        {
            cancelTweens();
            beat1();
        }
        if (curBeat % 2 == 0)
        {
            cancelTweens();
            beat2();
        }
    }

    public override function onSongStart() {
        super.onSongStart();

        beat2();
    }

    public override function onPause() {
        super.onPause();

        pauseTweens();
    }

    public override function onResume() {
        super.onResume();

        resumeTweens();
    }
}

class Keystrokes extends BaseScript
{
    public function new() super('UE Show Keystrokes');

    public var coolkeystrokeanimation:Bool = true;
    public var keystrokegoanim:Int = 10;
    public var keystrokecomebackanim:Float = 1.5;

    /**
     * Seperated by direction
     * 
     * 0 - Left / 1 - Up / 2 - Down / 3 - Right
     */
    public var keyColors:Array<Int> = [
        0xFFC24B99,
        0xFF12FA05,
        0xFF00FFFF,
        0xFFF9393F
    ];
    
    public var leftButton:FlxSprite;
    public var upButton:FlxSprite;
    public var downButton:FlxSprite;
    public var rightButton:FlxSprite;

    public override function onCreatePost() {
        super.onCreatePost();

        upButton = new FlxSprite(UEkeyXPos, UEkeyYPos).makeGraphic(44, 44, keyColors[1]);
        upButton.cameras = [camOther];
        upButton.alpha = UEkeyA;
        add(upButton);

        downButton = new FlxSprite(UEkeyXPos, UEkeyYPos + 47).makeGraphic(44, 44, keyColors[2]);
        downButton.cameras = [camOther];
        downButton.alpha = UEkeyA;
        add(downButton);

        leftButton = new FlxSprite(UEkeyXPos - 47, UEkeyYPos + 47).makeGraphic(44, 44, keyColors[0]);
        leftButton.cameras = [camOther];
        leftButton.alpha = UEkeyA;
        add(leftButton);

        rightButton = new FlxSprite(UEkeyXPos + 47, UEkeyYPos + 47).makeGraphic(44, 44, keyColors[3]);
        rightButton.cameras = [camOther];
        rightButton.alpha = UEkeyA;
        add(rightButton);
    }


    public var KSleftButtonthingx:FlxTween;
    public var KSupButtonthingy:FlxTween;
    public var KSdownButtonthingy:FlxTween;
    public var KSrightButtonthingx:FlxTween;

    public var leftFade:FlxTween;
    public var upFade:FlxTween;
    public var downFade:FlxTween;
    public var rightFade:FlxTween;

    public var leftFadeBot:FlxTween;
    public var upFadeBot:FlxTween;
    public var downFadeBot:FlxTween;
    public var rightFadeBot:FlxTween;
    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (controls.NOTE_LEFT)
        {
            leftButton.alpha = 1;
            if (leftFade != null)
                leftFade.cancel();

            if (coolkeystrokeanimation)
            {
                if (KSleftButtonthingx != null)
                    KSleftButtonthingx.cancel();

                leftButton.x = UEkeyXPos - 47 - keystrokegoanim;
                KSleftButtonthingx = FlxTween.tween(leftButton, {x: UEkeyXPos - 47}, keystrokecomebackanim, {ease: FlxEase.expoOut});
            }
        }
        else
        {
            if (leftFade != null)
                leftFade.cancel();
            leftFade = FlxTween.tween(leftButton, {alpha: UEkeyA}, UEkeyFT, {ease: FlxEase.linear});
        }

        if (controls.NOTE_RIGHT)
        {
            rightButton.alpha = 1;
            if (rightFade != null)
                rightFade.cancel();

            if (coolkeystrokeanimation)
            {
                if (KSrightButtonthingx != null)
                    KSrightButtonthingx.cancel();

                rightButton.x = UEkeyXPos + 47 + keystrokegoanim;
                KSrightButtonthingx = FlxTween.tween(rightButton, {x: UEkeyXPos + 47}, keystrokecomebackanim, {ease: FlxEase.expoOut});
            }
        }
        else
        {
            if (rightFade != null)
                rightFade.cancel();
            rightFade = FlxTween.tween(rightButton, {alpha: UEkeyA}, UEkeyFT, {ease: FlxEase.linear});
        }

        if (controls.NOTE_UP)
        {
            upButton.alpha = 1;
            if (upFade != null)
                upFade.cancel();

            if (coolkeystrokeanimation)
            {
                if (KSupButtonthingy != null)
                    KSupButtonthingy.cancel();

                upButton.y = UEkeyYPos - keystrokegoanim;
                KSupButtonthingy = FlxTween.tween(upButton, {y: UEkeyYPos}, keystrokecomebackanim, {ease: FlxEase.expoOut});
            }
        }
        else
        {
            if (upFade != null)
                upFade.cancel();
            upFade = FlxTween.tween(upButton, {alpha: UEkeyA}, UEkeyFT, {ease: FlxEase.linear});
        }

        if (controls.NOTE_DOWN)
        {
            downButton.alpha = 1;
            if (downFade != null)
                downFade.cancel();

            if (coolkeystrokeanimation)
            {
                if (KSdownButtonthingy != null)
                    KSdownButtonthingy.cancel();

                downButton.y = UEkeyYPos + 47 + keystrokegoanim;
                KSdownButtonthingy = FlxTween.tween(downButton, {y: UEkeyYPos + 47}, keystrokecomebackanim, {ease: FlxEase.expoOut});
            }
        }
        else
        {
            if (downFade != null)
                downFade.cancel();
            downFade = FlxTween.tween(downButton, {alpha: UEkeyA}, UEkeyFT, {ease: FlxEase.linear});
        }

        if (!PlayState.instance.cpuControlled)
        {
            if (leftFadeBot != null)
                leftFadeBot.cancel();
            leftFadeBot = FlxTween.tween(leftButton, {alpha: UEkeyFT}, 0.5, {ease: FlxEase.linear});
            if (upFadeBot != null)
                upFadeBot.cancel();
            upFadeBot = FlxTween.tween(upButton, {alpha: UEkeyFT}, 0.5, {ease: FlxEase.linear});
            if (downFadeBot != null)
                downFadeBot.cancel();
            downFadeBot = FlxTween.tween(downButton, {alpha: UEkeyFT}, 0.5, {ease: FlxEase.linear});
            if (rightFadeBot != null)
                rightFadeBot.cancel();
            rightFadeBot = FlxTween.tween(rightButton, {alpha: UEkeyFT}, 0.5, {ease: FlxEase.linear});
        }
    }
}

class TauntOnGo extends BaseScript
{
    public function new() super('Taunt on go');

	public override function onCountdownTick(tick:Int) {
        super.onCountdownTick(tick);

        if (tick == 3)
        {
            try {
                if (boyfriend.animation.exists('hey'))
                    boyfriend.playAnim('hey');
                else if (boyfriend.animation.exists('cheer'))
                    boyfriend.playAnim('cheer');
                else if (boyfriend.animation.exists('singUP'))
                    boyfriend.playAnim('singUP');
            }
            catch(e:Dynamic) {}

            try {
                if (gf.animation.exists('hey'))
                    gf.playAnim('hey');
                else if (gf.animation.exists('cheer'))
                    gf.playAnim('cheer');
                else if (gf.animation.exists('singUP'))
                    gf.playAnim('singUP');
            }
            catch(e:Dynamic) {}

            try {
                if (dad.animation.exists('hey'))
                    dad.playAnim('hey');
                else if (dad.animation.exists('cheer'))
                    dad.playAnim('cheer');
                else if (dad.animation.exists('singUP'))
                    dad.playAnim('singUP');
            }
            catch(e:Dynamic) {}
        }
    }

    public override function onSongStart() {
        super.onSongStart();

        try
        {
            boyfriend.playAnim('idle');
        }
        catch(e:Dynamic) {}

        try
        {
            gf.playAnim('idle');
        }
        catch(e:Dynamic) {}

        try
        {
            dad.playAnim('idle');
        }
        catch(e:Dynamic) {}
            
    }
}