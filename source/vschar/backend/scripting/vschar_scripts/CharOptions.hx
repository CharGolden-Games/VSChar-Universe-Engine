package vschar.backend.scripting.vschar_scripts;

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

    public override function onEvent(name:String, value1:String, value2:String) {
        super.onEvent(name, value1, value2);
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