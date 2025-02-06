package vschar.backend.uescripts;

import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;

class Options extends BaseScript {}
class UEHud extends BaseScript
{
    public function new() super('Hud');
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
    }

    function formatTime(milliseconds:Float):String
    {
        var seconds:Float = Math.floor(milliseconds / 1000);

        return FlxStringUtil.formatTime(seconds);
    }
}