package ue.uescripts;

import flixel.util.FlxStringUtil;
import openfl.Lib;
import flixel.math.FlxMath;
import animateatlas.AtlasFrameMaker;

class Force extends BaseScript {}

class DifficultyLVL extends BaseScript
{
    static var UEdifficultyLVL:FlxText;
    public static var diffNumText:String = '???';

    public static var instance:DifficultyLVL;

    public override function onCreatePost():Void
    {
        super.onCreatePost();

        UEdifficultyLVL = new FlxText(960, 30, 500, "???", 31);
        UEdifficultyLVL.setFormat(Paths.font('funkin.ttf'), 31, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        UEdifficultyLVL.alpha = 0;
        UEdifficultyLVL.cameras = [game.camOther];
        add(UEdifficultyLVL);
    }

    var UEdifficultyLVL_A:FlxTween;
    var UEdifficultyLVL_AT:FlxTimer;

    public override function onSongStart() {
        super.onSongStart();

        UEdifficultyLVL_A = FlxTween.tween(UEdifficultyLVL, {alpha: 1}, 1, {ease: FlxEase.linear});
        UEdifficultyLVL_AT = new FlxTimer().start(3, function(tmr:FlxTimer){
            UEdifficultyLVL_A = FlxTween.tween(UEdifficultyLVL, {alpha: 0}, 3, {ease: FlxEase.linear});
        });
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (UEdifficultyLVL != null)
        {
            if(UEdifficultyLVL.text != diffNumText) // Only need to update the text when. yknow. it... updates.
                UEdifficultyLVL.text = diffNumText;
        }
    }

    public function new()
    {
        super('DifficultyLVL');

        instance = this;
    }
}


class SongName extends BaseScript {
    var UEtheypopup:Int = 160;
    var UEtheygone:Int = 570;
    var UEtheypopuphi:Int = 1;
    var UEtheypopuppos:Int = 10;

    var UE_song_name_popup:FlxText;
    var UE_info_1:FlxText;
    var UE_info_2:FlxText;

    public function new() super('Song Name');

    public override function onCreatePost() {
        super.onCreatePost();

        UE_song_name_popup = new FlxText(-1000, UEtheypopup, 
            0, '$songName\n$difficultyName\n$bpm BPM', 31);
        UE_song_name_popup.setFormat(Paths.font('funkin.ttf'), 31, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UE_song_name_popup.cameras = [game.camOther];
        add(UE_song_name_popup);

        UE_info_1 = new FlxText(-1000, UEtheypopup + 110, 0, "", 21);
        UE_info_1.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UE_info_1.cameras = [game.camOther];
        add(UE_info_1);

        UE_info_2 = new FlxText(-1000, UEtheypopup + 135, 0, "", 21);
        UE_info_2.setFormat(Paths.font('funkin.ttf'), 21, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
        UE_info_2.cameras = [game.camOther];
        add(UE_info_2);
    }

    var UE_they_go_bye:FlxTimer;
    var UE_text_remove_bye:FlxTimer;

    var UE_song_name_popup_hi:FlxTween;
    var UE_info_1_hi:FlxTween;
    var UE_info_2_hi:FlxTween;

    public override function onSongStart() {
        super.onSongStart();

        UE_song_name_popup_hi = FlxTween.tween(UE_song_name_popup, {x:UEtheypopuppos}, UEtheypopuphi, {ease: FlxEase.expoOut});
        UE_info_1_hi = FlxTween.tween(UE_info_1, {x:UEtheypopuppos}, UEtheypopuphi, {ease: FlxEase.expoOut});
        UE_info_2_hi = FlxTween.tween(UE_info_2, {x:UEtheypopuppos}, UEtheypopuphi, {ease: FlxEase.expoOut});

        UE_they_go_bye = new FlxTimer().start(3, function(tmr:FlxTimer){
            UE_song_name_popup_hi = FlxTween.tween(UE_song_name_popup, {x:-1000}, UEtheypopuphi, {ease: FlxEase.expoIn});
            UE_info_1_hi = FlxTween.tween(UE_info_1, {x:-1000}, UEtheypopuphi, {ease: FlxEase.expoIn});
            UE_info_2_hi = FlxTween.tween(UE_info_2, {x:-1000}, UEtheypopuphi, {ease: FlxEase.expoIn});
        });

        UE_text_remove_bye = new FlxTimer().start(10, function(tmr:FlxTimer){
            remove(UE_song_name_popup);
            remove(UE_info_1);
            remove(UE_info_2);
        });
    }

    public override function onEvent(name:String, value1:String, value2:String) {
        super.onEvent(name, value1, value2);

        if (name == "Song Name Info")
            {
                UE_info_1.text = '   $value1';
                UE_info_2.text = '    $value2';
            }
    }
}

class Fire extends BaseScript
{
    public function new() super('fire');

    /**
     * Change this to change the title that it gets set back to duh.
     */
    public static var baseTitle:String = "Friday Night Funkin': Universe Engine";

    var fireinthehole:FlxSprite;

    public override function initialize() {
        super.initialize();

        Paths.returnGraphic('normal');

        fireinthehole = new FlxSprite(1200, 1200).loadGraphic(Paths.image('normal'));
        if (ClientPrefs.cm)
            fireinthehole.loadGraphic(Paths.image('hehehehehhe'));
        fireinthehole.cameras = [game.camOther];
        fireinthehole.scale.set(0.25, 0.25);
        fireinthehole.alpha = 0;
        fireinthehole.screenCenter();
        add(fireinthehole);

        if (ClientPrefs.hitsoundVolume > 0 && ClientPrefs.ht == 'Fire in the hole') {
            Lib.application.window.title = 'FIRE IN THE HOLE';
        }
    }

    public override function onDestroy() {
        super.onDestroy();

        Lib.application.window.title = baseTitle;
    }

    var fireinthehole_bye:FlxTween;
    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        if (!isSustainNote)
        {
            if (ClientPrefs.ht == 'Fire in the hole')
            {
                if(fireinthehole_bye != null)
                {
                    fireinthehole_bye.cancel();
                }
                fireinthehole.alpha = ClientPrefs.hitsoundVolume;
                fireinthehole_bye = FlxTween.tween(fireinthehole, {alpha: 0}, 1, {ease: FlxEase.linear});
            }
        }
    }
}

/**
* BASICALLY A DIRECT COPY BECAUSE I AINT TYPIN ALLAT.
*/
class Baldi extends BaseScript
{
    public function new() super('baldi');

    static var totalhit:Int = 0;

    public override function initialize() {
        super.initialize();

        precacheSound("baldi/oh");
        precacheSound("baldi/hi");
        precacheSound("baldi/welcome");
        precacheSound("baldi/to");
        precacheSound("baldi/my");
        precacheSound("baldi/school");
        precacheSound("baldi/house");
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        var hitsoundvolume = ClientPrefs.hitsoundVolume;

        if (!isSustainNote)
        {
            if (ClientPrefs.ht == 'Baldi') { // Fun fact I forgot to do this when I finished this port of the script lmao.
                switch (totalhit)
                {
                    case 0:
                        playSound("baldi/oh", hitsoundvolume, "oh");
                        totalhit = 1;
                        stopSound("hi");
                        stopSound("welcome");
                        stopSound("to");
                        stopSound("my");
                        stopSound("school");
                        stopSound("house");

                    case 1:
                        playSound("baldi/hi", hitsoundvolume, "hi");
                        totalhit = 2;
                        stopSound("oh");
                        stopSound("welcome");
                        stopSound("to");
                        stopSound("my");
                        stopSound("school");
                        stopSound("house");
                    
                    case 2:
                        playSound("baldi/welcome", hitsoundvolume, "welcome");
                        totalhit = 3;
                        stopSound("oh");
                        stopSound("hi");
                        stopSound("to");
                        stopSound("my");
                        stopSound("school");
                        stopSound("house");

                    case 3:
                        playSound("baldi/to", hitsoundvolume, "to");
                        totalhit = 4;
                        stopSound("oh");
                        stopSound("hi");
                        stopSound("welcome");
                        stopSound("my");
                        stopSound("school");
                        stopSound("house");

                    case 4:
                        playSound("baldi/my", hitsoundvolume, "my");
                        totalhit = 5;
                        stopSound("oh");
                        stopSound("hi");
                        stopSound("welcome");
                        stopSound("to");
                        stopSound("school");
                        stopSound("house");

                    case 5:
                        playSound("baldi/school", hitsoundvolume, "school");
                        totalhit = 6;
                        stopSound("oh");
                        stopSound("hi");
                        stopSound("welcome");
                        stopSound("to");
                        stopSound("my");
                        stopSound("house");

                    case 6:
                        playSound("baldi/house", hitsoundvolume, "house");
                        totalhit = 0;
                        stopSound("oh");
                        stopSound("hi");
                        stopSound("welcome");
                        stopSound("to");
                        stopSound("my");
                        stopSound("school");
                }
            }
        }
    }
}

/**
 * uwenalil | Made the original format in the LUA script.
 */
class DiscordRPCScript extends BaseScript
{
    public function new() super('DiscordRPC');

    function formatTime(milliseconds:Float):String
    {
        var seconds:Float = Math.floor(milliseconds / 1000);

        return FlxStringUtil.formatTime(seconds);
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (hits < 1)
        {
            changePresence('Score: 0 • Misses: 0 • Rating: ?' 
            + ' • ${formatTime(songPosition - noteOffset)} - ${formatTime(songLength)} • $songName ($difficultyName)');
        }
        if (hits > 0 || misses > 1)
        {
            changePresence('Score: $score • Misses: $misses • Rating: ${FlxMath.roundDecimal(rating * 100, 2)}% ($ratingFC)'
            + ' • ${formatTime(songPosition - noteOffset)} - ${formatTime(songLength)} • $songName ($difficultyName)');
        }
    }
}

/**
-- by cjred
-- modified by an ammar
-- modified by uwenalil
-- modified by baranmuzu
-- source port by char
 */
class TrailDoubleNote extends BaseScript
{
    public function new() super('Trail Double Note');

    var boyfriendTrailExists:Bool = false;
    var dadTrailExists:Bool = false;

    public override function onCreatePost() {
        super.onCreatePost();

        createBoyfriendTrail();
        createDadTrail();
    }

    var boyfriendTrail:ModchartSprite;
    var dadTrail:ModchartSprite;

    var pastFrameName:String = null;
    var pastFrameX:Float = 0;
    var pastFrameY:Float = 0;

    var pastDadFrameName:String = null;
    var pastDadFrameX:Float = 0;
    var pastDadFrameY:Float = 0;

    function createBoyfriendTrail()
    {
        boyfriendTrail = makeAnimatedSprite('boyfriendTrail', boyfriend.imageFile, boyfriend.x, boyfriend.y);
        addBehindBF(boyfriendTrail);
        boyfriendTrail.scale.x = boyfriend.scale.x;
        boyfriendTrail.scale.y = boyfriend.scale.y;
        boyfriendTrail.flipX = boyfriend.flipX;
        boyfriendTrail.color = boyfriend.color;
        boyfriendTrail.alpha = 0;
    }

    function createDadTrail()
    {
        dadTrail = makeAnimatedSprite('dadTrail', dad.imageFile, dad.x, dad.y);
        addBehindDad(dadTrail);
        dadTrail.scale.x = dad.scale.x;
        dadTrail.scale.y = dad.scale.y;
        dadTrail.flipX = dad.flipX;
        dadTrail.color = dad.color;
        dadTrail.alpha = 0;
    }

    var boyfriendTrailAlpha:FlxTween;
    var boyfriendTrailMoveX:FlxTween;

    var dadTrailAlpha:FlxTween;
    var dadTrailMoveX:FlxTween;

    var framingnt:FlxTimer;
    var framingntDad:FlxTimer;

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        if (!isSustainNote)
        {
            if (!boyfriendTrailExists)
            {
                createBoyfriendTrail();
                boyfriendTrailExists = true;
            }

            if (pastFrameName != null)
            {
                if (boyfriendTrailAlpha != null)
                    boyfriendTrailAlpha.cancel();
                boyfriendTrail.animation.frameName = pastFrameName;
                boyfriendTrail.offset.set(pastFrameX, pastFrameY);
                boyfriendTrail.alpha = 1;
                if (framingnt != null)
                    framingnt.cancel();
                boyfriendTrailAlpha = FlxTween.tween(boyfriendTrail, {alpha: 0}, 0.4);
                boyfriendTrailMoveX = FlxTween.tween(boyfriendTrail.offset, {x: pastFrameX - 50}, 0.4, {ease: FlxEase.quadOut});
            }

            pastFrameName = boyfriend.animation.frameName;
            pastFrameX = boyfriend.offset.x;
            pastFrameY = boyfriend.offset.y;
            framingnt = new FlxTimer().start(0.03, function(tmr:FlxTimer){
                pastFrameName = null;
            });
        }
    }

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);

        if (!isSustainNote)
        {
            if (!dadTrailExists)
            {
                createDadTrail();
                dadTrailExists = true;
            }

            if (pastDadFrameName != null)
            {
                if (dadTrailAlpha != null)
                    dadTrailAlpha.cancel();
                dadTrail.animation.frameName = pastDadFrameName;
                dadTrail.offset.set(pastDadFrameX, pastDadFrameY);
                dadTrail.alpha = 1;
                if (framingntDad != null)
                    framingntDad.cancel();
                dadTrailAlpha = FlxTween.tween(dadTrail, {alpha: 0}, 0.4);
                dadTrailMoveX = FlxTween.tween(dadTrail.offset, {x: pastDadFrameX + 50}, 0.4, {ease: FlxEase.quadOut});
            }
            
            pastDadFrameName = dad.animation.frameName;
            pastDadFrameX = dad.offset.x;
            pastDadFrameY = dad.offset.y;
            framingntDad = new FlxTimer().start(0.03, function(tmr:FlxTimer){
                pastDadFrameName = null;
            });
        }
    }

    public override function onEvent(name:String, value1:String, value2:String) {
        super.onEvent(name, value1, value2);

        if (name == 'Change Character') // Add code to re-generate the trail next dual note hit since the character is different
        {
            boyfriendTrailExists = false;
            dadTrailExists = false;
        }
    }
}