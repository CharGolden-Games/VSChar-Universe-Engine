package stages.base;

import Note.EventNote;

class Philly extends BaseStage
{
	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var phillyWindowEvent:BGSprite;
	var trainSound:FlxSound;

	var phillyGlowGradient:PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlowParticle>;
	var curLight:Int = -1;
	var curLightEvent:Int = -1;
    override function create() {
        super.create();
        
		if (!ClientPrefs.data.lowQuality)
            {
                var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
                add(bg);
            }

            var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
            city.setGraphicSize(Std.int(city.width * 0.85));
            city.updateHitbox();
            add(city);
    
            phillyLightsColors = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
            phillyWindow = new BGSprite('philly/window', city.x, city.y, 0.3, 0.3);
            phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 0.85));
            phillyWindow.updateHitbox();
            add(phillyWindow);
            phillyWindow.alpha = 0;
    
            if (!ClientPrefs.data.lowQuality)
            {
                var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
                add(streetBehind);
            }
    
            phillyTrain = new BGSprite('philly/train', 2000, 360);
            add(phillyTrain);
    
            trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
            FlxG.sound.list.add(trainSound);
    
            phillyStreet = new BGSprite('philly/street', -40, 50);
            add(phillyStreet);
    }

    override function eventPushed(event:EventNote) {
        super.eventPushed(event);

        if (event.event == 'Philly Glow')
        {
			blammedLightsBlack = new FlxSprite(FlxG.width * -0.5,
				FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			blammedLightsBlack.visible = false;
			insert(members.indexOf(phillyStreet), blammedLightsBlack);

			phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
			phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 0.85));
			phillyWindowEvent.updateHitbox();
			phillyWindowEvent.visible = false;
		    insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);

			phillyGlowGradient = new PhillyGlowGradient(-400, 225); // This shit was refusing to properly load FlxGradient so fuck it
			phillyGlowGradient.visible = false;
			insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);
			if (!ClientPrefs.data.flashing)
				phillyGlowGradient.intendedAlpha = 0.7;

			precacheImage('philly/particle'); // precache particle image
			phillyGlowParticles = new FlxTypedGroup<PhillyGlowParticle>();
			phillyGlowParticles.visible = false;
			insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        
		if (trainMoving)
		{
			trainFrameTiming += elapsed;

			if (trainFrameTiming >= 1 / 24)
			{
				updateTrainPos();
				trainFrameTiming = 0;
			}
		}
		phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;

		if (phillyGlowParticles != null)
		{
			var i:Int = phillyGlowParticles.members.length - 1;
			while (i > 0)
			{
				var particle = phillyGlowParticles.members[i];
				if (particle.alpha < 0)
				{
					particle.kill();
					phillyGlowParticles.remove(particle, true);
					particle.destroy();
				}
				--i;
			}
		}
    }
    
    override function beatHit() {
        super.beatHit();
        
		if (!trainMoving)
			trainCooldown += 1;

		if (curBeat % 4 == 0)
		{
			curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
			phillyWindow.color = phillyLightsColors[curLight];
			phillyWindow.alpha = 1;
		}

		if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
		{
			trainCooldown = FlxG.random.int(-4, 0);
			trainStart();
		}
    }
    
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if (gf != null)
		{
			gf.danced = false; // Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>) {
        super.eventCalled(eventName, value1, value2, flValue1, flValue2);
        
        if (eventName == 'Philly Glow')
        {
				var lightId:Int = Std.parseInt(value1);
				if (Math.isNaN(lightId))
					lightId = 0;

				var doFlash:Void->Void = function()
				{
					var color:FlxColor = FlxColor.WHITE;
					if (!ClientPrefs.data.flashing)
						color.alphaFloat = 0.5;

					FlxG.camera.flash(color, 0.15, null, true);
				};

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch (lightId)
				{
					case 0:
						if (phillyGlowGradient.visible)
						{
							doFlash();
							if (ClientPrefs.data.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
						}

					case 1: // turn on
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length - 1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if (!phillyGlowGradient.visible)
						{
							doFlash();
							if (ClientPrefs.data.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if (ClientPrefs.data.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.25;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						var charColor:FlxColor = color;
						if (!ClientPrefs.data.flashing)
							charColor.saturation *= 0.5;
						else
							charColor.saturation *= 0.75;

						for (who in chars)
						{
							who.color = charColor;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						color.brightness *= 0.5;
						phillyStreet.color = color;

					case 2: // spawn particles
						if (!ClientPrefs.data.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlowParticle = new PhillyGlowParticle(-400
										+ width * i
										+ FlxG.random.float(-width / 5, width / 5),
										phillyGlowGradient.originalY
										+ 200
										+ (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

        }
    }
}