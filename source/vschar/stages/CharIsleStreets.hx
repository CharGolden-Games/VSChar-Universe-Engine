package vschar.stages;

class CharIsleStreets extends BaseStage
{
    var curBop:Int = 1;
    var tBop:BGSprite;
    var pBop:BGSprite;
    var sin:BGSprite;
    var bg:BGSprite;

    var basePath:String = 'vschar_stages/streets/images';

    override function create() {
        super.create();

        tBop = new BGSprite('$basePath/trevorBop', -800, 40, 1, 1, ['TrevorBop']);
        pBop = new BGSprite('$basePath/plexiBopStatic', 400, 20);
        sin = new BGSprite('$basePath/sin', 500, 10);
        bg = new BGSprite('$basePath/bg', 0, 0, 0.2, 0.2);
        bg.setGraphicSize(bg.width * 1.2);
        bg.updateHitbox();
        bg.screenCenter(X);

        add(bg);
        add(sin);
        add(pBop);
        add(tBop);
    }

    override function createPost() {
        super.createPost();
    }

    override function beatHit() {
        super.beatHit();

        if (curBop == 1)
        {
            tBop.animation.play('TrevorBop', true);
            curBop = 2;
        }
        else
        {
            tBop.animation.play('TrevorBop', true); // Remember to make this 'TrevorBopUp' when that anim is finished.
            curBop = 1;
        }
    }
}