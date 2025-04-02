package vschar.states;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class GalleryState extends MusicBeatState {
    public static var bg:FlxSprite;
    var options:Array<String> = ['Character Profiles', 'Extra', 'Shit Posts!'];
    var grpOptions:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;
    var camMenu:FlxCamera;
    var camFollow:FlxObject;
    var blockInput:Bool = false;
    override function create() {
        super.create();

        camMenu = new FlxCamera();
        FlxG.cameras.add(camMenu);

        camFollow = new FlxObject();
        camFollow.screenCenter(X);
        camMenu.follow(camFollow, LOCKON, 0.06);

		if (ClientPrefs.data.darkmode)
            {
                bg = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
                bg.antialiasing = ClientPrefs.data.globalAntialiasing;
                add(bg);
                bg.screenCenter();
            }
            else
            {
                bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
                bg.antialiasing = ClientPrefs.data.globalAntialiasing;
                add(bg);
                bg.screenCenter();
            }

        bg.scrollFactor.set(0, 0);
        bg.color = 0xFFFF8888;

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(20, 20);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        for (option in options)
        {
            var text:Alphabet = new Alphabet(20, 150 * grpOptions.length, option, true);
            text.screenCenter(X);
            grpOptions.add(text);
        }

        persistentUpdate = true;

        changeSelection();
    }

    static var colorTween:FlxTween;

    public static function tweenBGColor(color:Int)
    {
        if (colorTween != null)
            colorTween.cancel();

        colorTween = FlxTween.color(bg, 2, bg.color, color, {ease:FlxEase.linear, onComplete: function(twn:FlxTween){
            if (colorTween != null)
                colorTween = null;
        }});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!blockInput)
        {
            if (controls.UI_UP_P)
            {
                changeSelection(-1);
            }
            if (controls.UI_DOWN_P)
            {
                changeSelection(1);
            }
            if (controls.ACCEPT)
            {
                goToGallery();
            }
            if (controls.BACK)
            {
                MusicBeatState.switchState(new CustomMainMenu());
            }
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;
        if (curSelected > options.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.length - 1;
        
        FlxG.sound.play(Paths.sound('scrollMenu'));

        var pos:Int = -1;
        for (text in grpOptions.members)
        {
            pos++;
            if (curSelected != pos)
            {
                text.alpha = 0.6;
            }
            else
            {
                text.alpha = 1;
                camFollow.y = text.y;
            }
        }
    }

    function goToGallery()
    {
        grpOptions.visible = false;
        blockInput = true;
        switch(options[curSelected])
        {
            case 'Character Profiles':
                openSubState(new ProfileGallerySubstate());

            default:
                grpOptions.visible = true;
                blockInput = false;
        }
    }

    override function closeSubState() {
        super.closeSubState();

        grpOptions.visible = true;
        blockInput = false;
        tweenBGColor(0xFFFFFFFF);
    }
}


class ProfileGallerySubstate extends MusicBeatSubstate
{
    var characterArt:FlxSprite;
    var characterDesc:FlxText;
    var characterName:FlxText;
    var camArt:FlxCamera;
    var curSelected:Int = 3;

    var characters:Array<String> = [
        'char',
        'trevor',
        'plexi',
        'micheal',
        'anny',
        'sear',
        'igni'
    ];

    var characterOffsets:Array<Array<Int>> = [
        [0, 0],
        [0, 0],
        [0, 0],
        [Std.int(FlxG.width - 419), Std.int(FlxG.height - 419)],
        [0, 0],
        [0, 0],
        [0, 0]
    ];

    var characterColors:Array<Int> = [
        0xFFFF8800,
        0xFF88BBFF,
        0xFFFF7788,
        0xFF882200,
        0xFFCC0088,
        0xFF884422,
        0xFF474753
    ];

    override function create() {
        super.create();

        camArt = new FlxCamera();
        camArt.bgColor.alpha = 0;
        FlxG.cameras.add(camArt, false);

        cameras = [camArt];

        characterArt = new FlxSprite().loadGraphic(Paths.image('gallery/portraits/${characters[curSelected]}'));
        characterArt.x = characterOffsets[curSelected][0];
        characterArt.y = characterOffsets[curSelected][1];
        add(characterArt);

        //GalleryState.bg.color = characterColors[curSelected];
        GalleryState.tweenBGColor(characterColors[curSelected]);

        characterName = new FlxText(0, 40, FlxG.width, idToName(characters[curSelected]));
        characterName.setFormat(Paths.font('funkin.ttf'), 60, 0xFFFFFFFF, CENTER, 0xFF000000);
        add(characterName);

        characterDesc = new FlxText(0, 200, 500, idToDesc(characters[curSelected]));
        characterDesc.setFormat(Paths.font('funkin.ttf'), 24, 0xFFFFFFFF, LEFT, 0xFF000000);
        add(characterDesc);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
        {
            close();
        }
        if (controls.UI_LEFT_P)
        {
            changeChar(-1);
        }
        if (controls.UI_RIGHT_P)
        {
            changeChar(1);
        }
    }

    function changeChar(change:Int = 0)
    {
        curSelected += change;

        if (curSelected > characters.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = characters.length - 1;

        characterArt.loadGraphic(Paths.image('gallery/portraits/${characters[curSelected]}'));
        characterArt.x = characterOffsets[curSelected][0];
        characterArt.y = characterOffsets[curSelected][1];
        GalleryState.tweenBGColor(characterColors[curSelected]);
        characterName.text = idToName(characters[curSelected]);
        characterDesc.text = idToDesc(characters[curSelected]);

        if (characters[curSelected] == 'sear')
        {
            characterName.setFormat(Paths.font('funkin.ttf'), 40, 0xFFFFFFFF, CENTER, 0xFF000000);
        }
        else
        {
            characterName.setFormat(Paths.font('funkin.ttf'), 60, 0xFFFFFFFF, CENTER, 0xFF000000);
        }

        if (characters[curSelected] == 'igni')
        {
            /*
            if (hasBeatenSaloonWeek)
            {
                characterArt.loadGraphic(Paths.image('gallery/portraits/igni2'));
            }
            */
        }
    }

    function idToName(id:String):String
    {
        switch (id)
        {
            case 'char':
                return 'Char Grilled Cheese\nFounder of Char Isle';
            case 'trevor':
                return 'Trevor the Tridite';
            case 'plexi':
                return 'Plexi the Protogen';
            case 'micheal':
                return 'Micheal';
            case 'anny':
                return 'Anny\nSheriff of Milton\'s Creaks';
            case 'sear':
                return 'Sear\nBartender/Owner of Milton\'s Creaks\' Saloon';
            case 'igni':
                //if (!hasBeatenSaloonWeek)
                    return 'Igni\nSheriff of Milton\'s Creaks';
                //else
                //  return 'Igni\nCEO(?) of Entity Based Pest Control (ENBPC)';
            default:
                return 'NAME IN PROGRESS';
        }
    }

    override function close() {
        super.close();

        FlxG.cameras.remove(camArt);
    }

    function idToDesc(id:String):String
    {
        switch (id)
        {
            case 'micheal':
                return 'Micheal is a shapeshifting prankster who constantly messes with Char and his friends.\nIt all started when Char, Plexi, and Trevor encountered the very first portal to his forest, scaring the shit out of them by making it seem like there were messed up clones in front of them. \nOr at least that\'s what he wanted to happen, as Char was too stupid to understand what was actually happening.\n   He has since mellowed out a bit with his antics but still gives them heck from time to time.';
            case 'char':
                return 'He a dumbass :3';
            default:
                return 'DESC IN PROGRESS';
        }
    }
}