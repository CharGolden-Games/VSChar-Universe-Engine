package vschar.states;

class WarnState extends MusicBeatState
{
    public static var leftState:Bool = false;

    override function create() {
        super.create();

        var warnText = new FlxText(0, 0, FlxG.width, 'WARNING:\n\nTHIS MOD USES A WIP ENGINE, I HAVE NOT FINISHED PORTING ALL OF UE\'S SCRIPTS TO SOURCE\n\nMANY OPTIONS DO NOTHING\n\nTHE GALLERY STATE ONLY HAS 1 COMPLETE PAGE\n\n\nPress ENTER to continue.');
        warnText.setFormat(Paths.font('vcr.ttf'), 30, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        add(warnText);
        warnText.screenCenter(Y);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            leftState = true;
            MusicBeatState.switchState(new TitleState());
        }
    }
}