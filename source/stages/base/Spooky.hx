package stages.base;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class Spooky extends BaseStage 
{
	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
    var camZooming(get, null):Bool;
    function get_camZooming():Bool return PlayState.instance.camZooming;
    override function create() {
        super.create();
        
				if (!ClientPrefs.data.lowQuality)
                    {
                        halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
                    }
                    else
                    {
                        halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
                    }
                    add(halloweenBG);
    
                    halloweenWhite = new BGSprite(null, -800, -400, 0, 0);
                    halloweenWhite.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
                    halloweenWhite.alpha = 0;
                    halloweenWhite.blend = ADD;
    
                    // PRECACHE SOUNDS
                    precacheSound('thunder_1');
                    precacheSound('thunder_2');
    }

    override function createPost() {
        super.createPost();

        add(halloweenWhite);
    }

    override function beatHit() {
        super.beatHit();

        
		if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
        {
            lightningStrikeShit();
        }
    }
    
	function lightningStrikeShit():Void
        {
            FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
            if (!ClientPrefs.data.lowQuality)
                halloweenBG.animation.play('halloweem bg lightning strike');
    
            lightningStrikeBeat = curBeat;
            lightningOffset = FlxG.random.int(8, 24);
    
            if (boyfriend.animOffsets.exists('scared'))
            {
                boyfriend.playAnim('scared', true);
            }
    
            if (gf != null && gf.animOffsets.exists('scared'))
            {
                gf.playAnim('scared', true);
            }
    
            if (ClientPrefs.data.camZooms)
            {
                FlxG.camera.zoom += 0.015;
                camHUD.zoom += 0.03;
    
                if (!camZooming)
                { // Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
                    FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
                    FlxTween.tween(camHUD, {zoom: 1}, 0.5);
                }
            }
    
            if (ClientPrefs.data.flashing)
            {
                halloweenWhite.alpha = 0.4;
                FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
                FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
            }
        }
}