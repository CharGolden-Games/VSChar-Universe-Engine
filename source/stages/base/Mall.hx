package stages.base;

class Mall extends BaseStage
{
	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;
    override function create() {
        super.create();
			
        var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
        bg.setGraphicSize(Std.int(bg.width * 0.8));
        bg.updateHitbox();
        add(bg);

        if (!ClientPrefs.data.lowQuality)
        {
            upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
            upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
            upperBoppers.updateHitbox();
            add(upperBoppers);

            var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
            bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
            bgEscalator.updateHitbox();
            add(bgEscalator);
        }

        var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
        add(tree);

        bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
        bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
        bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
        bottomBoppers.updateHitbox();
        add(bottomBoppers);

        var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
        add(fgSnow);

        santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
        add(santa);
        precacheSound('Lights_Shut_off');
    }

    override function startCountdown() {
        super.startCountdown();
        
		if (!ClientPrefs.data.lowQuality)
            upperBoppers.dance(true);
    
        bottomBoppers.dance(true);
        santa.dance(true);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (heyTimer > 0)
        {
            heyTimer -= elapsed;
            if (heyTimer <= 0)
            {
                bottomBoppers.dance(true);
                heyTimer = 0;
            }
        }
    }

    override function beatHit() {
        super.beatHit();
        
		if (!ClientPrefs.data.lowQuality)
            {
                upperBoppers.dance(true);
            }

            if (heyTimer <= 0)
                bottomBoppers.dance(true);
            santa.dance(true);
    }

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>) {
        super.eventCalled(eventName, value1, value2, flValue1, flValue2);

        var time:Float = Std.parseFloat(value2);
        if (Math.isNaN(time) || time <= 0)
            time = 0.6;
        var value:Int = 2;
        switch (value1.toLowerCase().trim())
        {
            case 'bf' | 'boyfriend' | '0':
                value = 0;
            case 'gf' | 'girlfriend' | '1':
                value = 1;
        }

        if (eventName == 'Hey!' && value != 0)
        {
            bottomBoppers.animation.play('hey', true);
            heyTimer = time;
        }
    }
}

class MallEvil extends BaseStage
{
    override function create() {
        super.create();
        
		var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
		bg.setGraphicSize(Std.int(bg.width * 0.8));
		bg.updateHitbox();
		add(bg);

		var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
		add(evilTree);

		var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
		add(evilSnow);
    }
}