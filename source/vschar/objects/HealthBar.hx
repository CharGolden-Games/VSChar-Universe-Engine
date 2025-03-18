package vschar.objects;

import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxColor;

class HealthBar extends FlxTypedSpriteGroup<FlxSprite>
{
    public var healthBarBG:AttachedSprite;
    public var healthBar:FlxBar;

    public var min:Float = 0;
    public var max:Float = 2;
    public var direction:FlxBarFillDirection = RIGHT_TO_LEFT;
    public var variableFunction:Void->Float = function() return 1;
    public var healthVar(get, null):Float;
    public var percent(get, null):Float;

    function get_percent():Float
    {
        if (healthBar != null)
            return healthBar.percent;
        else
            return 50;
    }
    function get_healthVar():Float return variableFunction();

    public var image(default, set):String;

    public var leftColor:Int = 0xFFFF0000;
    public var rightColor:Int = 0xFF00FF00;

    function set_image(s:String):String
    {
        if (healthBarBG != null)
        {
            healthBarBG.sprTracker = null;
            healthBarBG.loadGraphic(Paths.image(s));
            resetHealthBar();
        }

        return image = s;
    }

    public function new(x:Float, y:Float, image:String = 'healthBar', ?direction:FlxBarFillDirection = RIGHT_TO_LEFT, ?variableFunction:Void->Float, min:Float = 0, max:Float = 2)
    {
        super(x, y);
        this.image = image;
        this.direction = direction;
        if (variableFunction != null)
            this.variableFunction = variableFunction;
        this.min = min;
        this.max = max;

        healthBarBG = new AttachedSprite(image);
		healthBarBG.visible = !ClientPrefs.data.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;

        healthBar = new FlxBar(0, 0, this.direction, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'healthVar', min, max);
		healthBar.visible = !ClientPrefs.data.hideHud;
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;
        healthBar.createFilledBar(leftColor, rightColor);
		healthBarBG.sprTracker = healthBar;
		if (ClientPrefs.data.lhpbgb)
		{
			add(healthBarBG);
			add(healthBar);
		}
		else
		{
			add(healthBar);
			add(healthBarBG);
		}
    }
    /**
     * Resizes le healthBar.
     * @param width 
     * @param height 
     */
    public function resizeHealthBar(width:Float = 0, height:Float = 0)
    {
        healthBarBG.sprTracker = null;
        healthBarBG.setGraphicSize(width, height);
        healthBarBG.updateHitbox();
        resetHealthBar();
    }

    /**
     * Less precise version of `resizeHealthBar`.
     * @param x 
     * @param y 
     */
    public function scaleHealthBar(x:Float = 1, y:Float = 1)
    {
        healthBarBG.sprTracker = null;
        healthBarBG.scale.set(x, y);
        healthBarBG.updateHitbox();
        resetHealthBar();
    }

    public function changeMin(min:Float)
    {
        this.min = min;
        resetHealthBar();
    }

    public function changeMax(max:Float)
    {
        this.max = max;
        PlayState.instance.maxHealth = max;
        resetHealthBar();
    }

    function resetHealthBar()
    {
        healthBarBG.sprTracker = null;
        healthBar.destroy();
        healthBar = new FlxBar(0, 0, this.direction, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'healthVar', min, max);
		healthBar.visible = !ClientPrefs.data.hideHud;
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;
        healthBar.createFilledBar(leftColor, rightColor);
		healthBarBG.sprTracker = healthBar;
        if (ClientPrefs.data.lhpbgb)
            insert(0, healthBar);
        else
            insert(1, healthBar);
    }

    public function changeColors(?left:Int, ?right:Int)
    {
        if (left != null)
            leftColor = left;
        if (right != null)
            rightColor = right;
        healthBar.createFilledBar(leftColor, rightColor);
        healthBar.updateBar();
    }

    // FlxBar shortcuts to allow for healthBar replacement
    public function createFilledBar(empty:FlxColor, fill:FlxColor, showBorder:Bool = false, border:FlxColor = FlxColor.WHITE):FlxBar
    {
        return healthBar.createFilledBar(empty, fill, showBorder, border);
    }

    public function updateBar():Void healthBar.updateBar();
}