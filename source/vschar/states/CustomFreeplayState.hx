package vschar.states;

import vschar.backend.Constants;
import vschar.backend.Constants.SongMetadata;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.U as FlxU;

class CustomFreeplayState extends MusicBeatState
{
    var songNameText:FlxText;
    var bg:FlxSprite;
    var songLists:Array<String> = [
        'VS Char',
        'Legacy Content',
        #if BASE_ASSETS 'Base Game',
        'Erect Songs' #end
    ];
    var curPage:Int = 0;
    var curSelected:Int = 0;
    var songs:Array<SongMetadata> = [];
    var curSongText:Alphabet;

	var colorTween:FlxTween;
    var intendedColor:Int;
    var songArt:FlxSprite;

    public function new()
    {
        super();
    }

    override function create():Void
    {
        super.create();

		if (ClientPrefs.darkmode)
            {
                bg = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
                bg.antialiasing = ClientPrefs.globalAntialiasing;
                add(bg);
                bg.screenCenter();
            }
            else
            {
                bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
                bg.antialiasing = ClientPrefs.globalAntialiasing;
                add(bg);
                bg.screenCenter();
            }

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(20, 20);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

        var switchTabs:FlxText = new FlxText(0, 0, 150, "Press TAB to switch tabs");
        switchTabs.x = FlxG.width - 150; 
        add(switchTabs);

        updateSongList();

        curSongText = new Alphabet(0, 50, formatSongName(songs[curSelected].songName), true);
        add(curSongText);

		bg.color = songs[curSelected].color;
        intendedColor = bg.color;

        songArt = new FlxSprite().loadGraphic(Paths.image('freeplay/songArt/placeholder'));
        songArt.screenCenter();
        songArt.y += 100;
        add(songArt);

        Paths.change_songFolderRedirect('vschar');
        changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new FreeplayState());
        }
        if (controls.UI_LEFT_P)
        {
            changeSelection(-1);
        }
        if (controls.UI_RIGHT_P)
        {
            changeSelection(1);
        }
        if (FlxG.keys.justPressed.TAB)
        {
            changeTabs();
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected > songs.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = songs.length - 1;

        curSongText.text = formatSongName(songs[curSelected].songName);

        if (songLists[curPage] == 'Erect Songs')
            curSongText.text += ' Erect';

        FlxG.sound.play(Paths.sound('scrollMenu'));
        bg.color = songs[curSelected].color;

        change_songArt();
    }

    function change_songArt()
    {
        songArt.loadGraphic(Paths.image('freeplay/songArt/${songs[curSelected].songArt}'));
        songArt.setGraphicSize(500, 500);
        songArt.updateHitbox();
        songArt.screenCenter();
        songArt.y += 100;
    }

    function changeTabs()
    {
        curPage += 1;
        if (curPage > songLists.length - 1)
            curPage = 0;
        if (curPage < 0)
            curPage = 0;

        updateSongList();

        switch (songLists[curPage])
        {
            case 'VS Char':
                Paths.change_songFolderRedirect('vschar');

            case 'Legacy Content':
                Paths.change_songFolderRedirect('vschar/legacy');

            case 'Erect Songs':
                Paths.change_songFolderRedirect('basegame');

            case 'Base Game':
                Paths.change_songFolderRedirect('basegame');
                
            default:
                Paths.change_songFolderRedirect('');
        }

        changeSelection();
    }

    function formatSongName(name:String):String
    {
        return FlxU.FUL(name.replace('-', ' '));
    }

    function updateSongList()
    {
        songs = Constants.songMetadata[songLists[curPage]];
    }
}