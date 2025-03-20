package vschar.stages;

class CharIsleStreets extends BaseStage
{
    var curBop:Int = 1;
    var tBop:BGSprite;
    var pBop:BGSprite;
    var sin:BGSprite;
    var bg:BGSprite;
    var sky:FlxSprite;

    var basePath:String = 'vschar_stages/streets/images';

    override function create() {
        super.create();

        tBop = new BGSprite('$basePath/trevorBop', -600, 150, 1, 1, ['TrevorBop']);
        pBop = new BGSprite('$basePath/plexiBopStatic', 400, 20);
        sin = new BGSprite('$basePath/sin', 800, -40);
        bg = new BGSprite('$basePath/bg');
        bg.setGraphicSize(bg.width * 1.5);
        bg.updateHitbox();
        bg.x = -900;
        bg.y = -350;
        sky = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF0088FF);
        sky.scrollFactor.set(0, 0);
        sky.screenCenter();
        
        add(sky);
        add(bg);
        add(sin);
        add(pBop);
        add(tBop);
    }

    override function createPost() {
        super.createPost();
    }

    override function startSong() {
        super.startSong();

        charBop();
    }

    function charBop()
    {
        if (curBop == 1)
        {
            tBop.animation.play('TrevorBop', true);
            // pBop.animation.play('PlexiBop', true);
            curBop = 2;
        }
        else
        {
            tBop.animation.play('TrevorBop', true); // Remember to make this 'TrevorBopUp' when that anim is finished.
            // pBop.animation.play('PlexiBop', true);
            curBop = 1;
        }
    }

    override function beatHit() {
        super.beatHit();

        charBop();
    }

    override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        /* if (noteType == 'Hey!')
        {
            tBop.animation.play('hey', true);
            pBop.animation.play('hey', true);
        }
        */
    }

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>) {
        super.eventCalled(eventName, value1, value2, flValue1, flValue2);

        /* if (eventName == 'Hey!')
        {
            tBop.animation.play('hey', true);
            pBop.animation.play('hey', true);
        }
        */
    }
}