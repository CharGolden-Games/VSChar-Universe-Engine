package stages;

import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.addons.ui.U as FlxU;

using StringTools;
class BGSpriteAlt extends FlxSprite 
{
    var stagePath:String = '';
    public function new(x:Float = 0, y:Float = 0, ?stageName:String)
    {
        super(x, y);

        if (stageName != null)
            stagePath = 'stage_assets/$stageName/';
    }

    /**
     * Makes a new sprite.
     * @param image The image (or color to use.)
     * @param width 
     * @param height 
     * @return BGSprite
     */
    public function newSprite(image:String, ?width:Float, ?height:Float):BGSpriteAlt
    {

        if (FlxColor.fromString('#${(image.trim()).toUpperCase()}') != null)
        {
            if (width == null)
            {
                trace('Width null! using 100.');
                width = 100;
            }
            if (height == null)
            {
                trace('Height null! using 100.');
                height = 100;
            }
            makeGraphic(Std.int(width), Std.int(height), FlxColor.fromString(image));
            antialiasing = ClientPrefs.data.globalAntialiasing;
        }
        else
        {
            var graphic:FlxGraphic = Paths.image(stagePath + image);
            loadGraphic(graphic);
            antialiasing = ClientPrefs.data.globalAntialiasing;
            if (width != null)
            {
                if (height != null)
                    setGraphicSize(width, height);
                else
                    setGraphicSize(width);
            }
            updateHitbox();
        }

        return this;
    }
}