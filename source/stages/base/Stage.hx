package stages.base;

import Note.EventNote;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Stage extends BaseStage {
	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleSmokes:FlxSpriteGroup;

    override function create() {
        super.create();
        
		var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
		add(bg);

		var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);
		if (!ClientPrefs.data.lowQuality)
		{
			var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			add(stageLight);
			var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			stageLight.flipX = true;
			add(stageLight);

			var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			add(stageCurtains);
		}
		dadbattleSmokes = new FlxSpriteGroup(); // troll'd
    }


    override function eventPushed(event:EventNote) {
        super.eventPushed(event);

        if (event.event == 'Dadbattle Spotlight')
        {
            dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
            dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
            dadbattleBlack.alpha = 0.25;
            dadbattleBlack.visible = false;
            add(dadbattleBlack);

            dadbattleLight = new BGSprite('spotlight', 400, -400);
            dadbattleLight.alpha = 0.375;
            dadbattleLight.blend = ADD;
            dadbattleLight.visible = false;

            dadbattleSmokes.alpha = 0.7;
            dadbattleSmokes.blend = ADD;
            dadbattleSmokes.visible = false;
            add(dadbattleLight);
            add(dadbattleSmokes);

            var offsetX = 200;
            var smoke:BGSprite = new BGSprite('smoke', -1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
            smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
            smoke.updateHitbox();
            smoke.velocity.x = FlxG.random.float(15, 22);
            smoke.active = true;
            dadbattleSmokes.add(smoke);
            var smoke:BGSprite = new BGSprite('smoke', 1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
            smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
            smoke.updateHitbox();
            smoke.velocity.x = FlxG.random.float(-15, -22);
            smoke.active = true;
            smoke.flipX = true;
            dadbattleSmokes.add(smoke);
        }
    }

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>) {
        super.eventCalled(eventName, value1, value2, flValue1, flValue2);

        if (eventName == 'Dadbattle Spotlight')
        {
            switch (flValue1)
            {
                case 1, 2, 3: // enable and target dad
                    if (flValue1 == 1) // enable
                    {
                        dadbattleBlack.visible = true;
                        dadbattleLight.visible = true;
                        dadbattleSmokes.visible = true;
                        defaultCamZoom += 0.12;
                    }

                    var who:Character = dad;
                    if (flValue1 > 2)
                        who = boyfriend;
                    // 2 only targets dad
                    dadbattleLight.alpha = 0;
                    new FlxTimer().start(0.12, function(tmr:FlxTimer)
                    {
                        dadbattleLight.alpha = 0.375;
                    });
                    dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);

                default:
                    dadbattleBlack.visible = false;
                    dadbattleLight.visible = false;
                    defaultCamZoom -= 0.12;
                    FlxTween.tween(dadbattleSmokes, {alpha: 0}, 1, {
                        onComplete: function(twn:FlxTween)
                        {
                            dadbattleSmokes.visible = false;
                        }
                    });
            }
        }
    }
}