package vschar.states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import options.SelectThing;
import WeekData.WeekFile;

class CustomMainMenu extends MusicBeatState
{
    var bg:FlxSprite;
    var camTracker:FlxSprite;
    var selecter:AttachedSprite;
    var selecter2:AttachedSprite;

    var grpOptions:FlxTypedGroup<Alphabet>;

    var camMenu:FlxCamera;
    var curSelected:Int = 0;

    var camBar:FlxCamera;
    var bottomBar:FlxSprite;
    var bottomText:FlxText;

    var options:Array<String> = [
        'Play Demo',
        'Options',
        'Gallery',
        'Credits',
        'Swag',
        'Original Main Menu'
    ];

    var debug_1:Array<FlxKey> = [];
    var debug_2:Array<FlxKey> = [];
    var debug_3:Array<FlxKey> = [];

    var selected:Bool = false;

    override function create()
    {
        super.create();

        debug_1 = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
        debug_2 = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
        debug_3 = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_3'));

        camMenu = new FlxCamera();
        FlxG.cameras.add(camMenu);
        camMenu.zoom = 1.5;

        bg = new FlxSprite().loadGraphic(Paths.image('aboutMenu'));
        bg.color = 0xFFFF8800;
        bg.screenCenter();
        bg.scrollFactor.set();

        camTracker = new FlxSprite(300, 0).makeGraphic(10, 10, 0x00000000);
        add(camTracker);
        camMenu.follow(camTracker, LOCKON, 0.06);
        add(bg);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        selecter = new AttachedSprite('mainMenu/selcter1');
        selecter.sprTracker = camTracker;
        selecter.xAdd = -450;
        selecter.yAdd = -50;
        selecter.copyAlpha = false;
        add(selecter);

        selecter2 = new AttachedSprite('mainMenu/selcter2');
        selecter2.sprTracker = camTracker;
        selecter2.xAdd = -450;
        selecter2.yAdd = -50;
        selecter2.copyAlpha = false;
        selecter2.alpha = 0;
        add(selecter2);

        for (option in options)
        {
            var text:Alphabet = new Alphabet(20, 120 * grpOptions.length, option, true);
            grpOptions.add(text);
        }

        camBar = new FlxCamera();
        camBar.bgColor.alpha = 0;

        FlxG.cameras.add(camBar, false);

        bottomBar = new FlxSprite().makeGraphic(FlxG.width, 30, 0xFF000000);
        bottomBar.alpha = 0.6;
        bottomBar.y = FlxG.height - bottomBar.height;
        bottomBar.cameras = [camBar];
        add(bottomBar);

       bottomText = new FlxText(0, 0, FlxG.width, "Press " + keysToString(debug_1)
        + " to go to a WIP Freeplay State! | Press "
        + '${keysToString(debug_2)} and ${keysToString(debug_3)}' + " To see some secrets!", 16);
        bottomText.setFormat(Paths.font('vcr.ttf'), 16, 0xFFFFFFFF, RIGHT, OUTLINE, 0xFF000000);
        bottomText.y = FlxG.height - bottomText.height;
        bottomText.cameras = [camBar];
        add(bottomText);

        changeSelection();
    }

    var blockInput:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        selecter.alpha = selected ? 0 : 1;
        selecter2.alpha = selected ? 1 : 0;

        blockInput = selected;
        if (!blockInput)
        {
            if (controls.ACCEPT)
            {
                selected = true;
                FlxG.sound.play(Paths.sound('confirmMenu'));
                new FlxTimer().start(0.2, function(tmr:FlxTimer){
                    goToState(options[curSelected]);
                });
            }
            if (controls.UI_DOWN_P)
            {
                changeSelection(1);
            }
            if (controls.UI_UP_P)
            {
                changeSelection(-1);
            }
            if (FlxG.keys.anyJustPressed(debug_1))
            {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                selected = true;
                goToState('DEBUG_KEY1');
            }
            if (FlxG.keys.anyJustPressed(debug_2))
            {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                goToState('DEBUG_KEY2');
            }
            if (FlxG.keys.anyJustPressed(debug_3))
            {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                goToState('DEBUG_KEY3');
            }
        }
    }

    function keysToString(keys:Array<FlxKey>):String
    {
        var finalString = '';
        var ks:Array<String> = [];
        for (key in keys)
        {
            ks.push(key.toString());
        }

        finalString = Std.string(ks);
        return finalString;
    }

    function goToState(option:String)
    {
        switch (option)
        {
            case 'Play Demo':
                Paths.change_songFolderRedirect('vschar');
                MusicBeatState.blockReset = true;
                loadSong();
            case 'Options':
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
                SelectThing.vsCharMenu = true;
                MusicBeatState.switchState(new SelectThing());
            case 'Gallery':
                MusicBeatState.switchState(new GalleryState());
            case 'Credits':
                CreditsState.vsCharMenu = true;
                MusicBeatState.switchState(new CreditsState());
            case 'Swag':
                CoolUtil.browserLoad('https://vschar-official.com/swag');
                selected = false;
            case 'Original Main Menu':
                SelectThing.vsCharMenu = false;
                CreditsState.vsCharMenu = false;
                if (ClientPrefs.data.fm)
                {
                    MusicBeatState.switchState(new CoolMenuState());
                }
                else
                {
                    MusicBeatState.switchState(new MainMenuState());
                }

            case 'DEBUG_KEY1':
                MusicBeatState.switchState(new vschar.states.CustomFreeplayState());
            case 'DEBUG_KEY2':
                CoolUtil.browserLoad('https://www.youtube.com/watch?v=fC7oUOUEEi4'); // GET STICK BUGGED LMAO
            case 'DEBUG_KEY3':
                CoolUtil.browserLoad('https://youtu.be/MgEV2VokiNw?si=R-bEaB5jeumRgP-S'); // tbh autism creature explodes #shorts #memes #meme | Thanks cosmer :3c
        }
    }

    /**
     * 
		var weekFile:WeekFile = {
			songs: [
				["Bopeebo", "dad", [146, 113, 253]],
				["Fresh", "dad", [146, 113, 253]],
				["Dad Battle", "dad", [146, 113, 253]]
			],
			weekCharacters: ['dad', 'bf', 'gf'],
			weekBackground: 'stage',
			weekBefore: 'tutorial',
			storyName: 'Your New Week',
			weekName: 'Custom Week',
			freeplayColor: [146, 113, 253],
			startUnlocked: true,
			hiddenUntilUnlocked: false,
			hideStoryMode: false,
			hideFreeplay: false,
			difficulties: ''
		};
     */
    function loadSong()
    {
        PlayState.SONG = Song.loadFromJson('paranoia-hard', 'paranoia');
        PlayState.storyPlaylist = ['paranoia'];
        PlayState.isStoryMode = true;
        PlayState.campaignScore = 0;
        PlayState.campaignMisses = 0;
        FreeplayState.destroyFreeplayVocals();
        WeekData.weeksList = ['aprilFoolsDemo'];
        PlayState.storyWeek = 0;
        WeekData.weeksLoaded.set('aprilFoolsDemo', new WeekData({
            songs: [
                ["Paranoia", 'char', [256, 48, 0]]
            ],
            weekCharacters: ['', '', ''],
			weekBackground: '',
			weekBefore: '',
			storyName: 'APRIL FOOLS',
			weekName: 'APRIL FOOLS',
			freeplayColor: [256, 48, 0],
			startUnlocked: true,
			hiddenUntilUnlocked: false,
			hideStoryMode: false,
			hideFreeplay: false,
			difficulties: 'hard'
        }, 'aprilFoolsEmbeddedWeek.json'));
        
        LoadingState.loadAndSwitchState(new PlayState(), true);
    }

    var camTween:FlxTween;
    var isZooming:Bool = false;
    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected > options.length -1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.length -1;

        FlxG.sound.play(Paths.sound('scrollMenu'));

        if (camTween != null)
            camTween.cancel();

        for (i in 0...grpOptions.members.length)
        {
            var text:Alphabet = grpOptions.members[i];
            if (i != curSelected)
            {
                text.alpha = 0.6;
            }
            else
            {
                text.alpha = 1;
                camTracker.y = text.y;
                if (text.text == 'Original Main Menu')
                {
                    camTween = FlxTween.tween(camMenu, {zoom: 1.05}, 0.5, {ease: FlxEase.quadOut});
                }
                else
                {
                    if (camMenu.zoom != 1.5)
                    {
                        camTween = FlxTween.tween(camMenu, {zoom: 1.5}, 0.5, {ease: FlxEase.quadIn});
                    }
                }
            }
        }
    }
}