package vschar.states;

import vschar.backend.Constants;
import vschar.backend.Constants.SongMetadata;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.U as FlxU;
import flixel.FlxState;

class ErrorSubstate extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var error:FlxText;
    var message:String;
    var wasUpdated:Bool = false;

    var camError:FlxCamera;

    public function new(message:String, previousState:FlxState)
    {
        super();

        this.message = message;
        if (!previousState.persistentUpdate)
        {
            previousState.persistentUpdate = true;
        }
        else
        {
            wasUpdated = true;
        }
    }

    static var closeTween:FlxTween;

    override function create()
    {
        camError = new FlxCamera();
        camError.bgColor.alpha = 0;
        FlxG.cameras.add(camError, false);

        bg = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
        bg.alpha = 0.6;
        bg.cameras = [camError];
        add(bg);

        error = new FlxText(0, 0, FlxG.width, 'AN ERROR OCCURED! "$message"', 12);
        error.screenCenter(Y);
        error.alignment = CENTER;
        error.cameras = [camError];
        add(error);

        if (closeTween != null)
            closeTween.cancel();
        closeTween = FlxTween.tween(error, {alpha: 0}, 3, {ease: FlxEase.quartOut, onComplete: endTween});
    }

    function endTween(twn:FlxTween)
    {
        FlxG.cameras.remove(camError);
        close();
    }
}

class CustomFreeplayState extends MusicBeatState
{
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
    var grid:FlxBackdrop;

    static var instance:CustomFreeplayState;

    public function new()
    {
        super();
    }

    override function create():Void
    {
        super.create();

        instance = this;

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

        grid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
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
        MusicBeatState.blockReset = true;
        changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.blockReset = false;
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
        if (controls.ACCEPT)
        {
            goToSong();
        }
        if (FlxG.keys.justPressed.SEVEN)
        {
            LoadingState.loadAndSwitchState(new editors.ChartingState());
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
        if (songs[curSelected].songName == 'paranoia')
        {
            curSongText.color = 0xFFFF0000;
            grid.color = 0x33FF0000;
        }
        else
        {
            curSongText.color = 0xFFFFFFFF;
            grid.color = 0x33FFFFFF;
        }
		var newColor:Int = songs[curSelected].color;
		if (newColor != intendedColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
		}

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
        for (song in songs)
        {
            #if debug
            trace('song ${song.songName}\'s art is under "freeplay/songArt/${song.songArt}.png"');
            #end
        }
    }

    function goToSong()
    {
        var songFolder:String = Paths.formatToSongPath(songs[curSelected].songName.toLowerCase());
        var songThing:String = songFolder;
        if (songLists[curPage] == 'Erect Songs')
        {
            songThing += '-erect';
        }
        else
        {
            songThing += '-hard';
        }
        try {
            PlayState.SONG = Song.loadFromJson(songThing, songFolder);
        }
        catch(e:Dynamic)
        {
            openSubState(new ErrorSubstate(Std.string(e), instance));
            return;
        }

        PlayState.isStoryMode = false;
        PlayState.storyDifficulty = 0;
        CoolUtil.difficulties = ['hard'];
        if (songLists[curPage] == 'Erect Songs')
        {
            CoolUtil.difficulties = ['erect', 'nightmare'];
            PlayState.storyDifficulty = 0;
        }
        if (FlxG.keys.pressed.SHIFT)
        {
            LoadingState.loadAndSwitchState(new editors.ChartingState());
        }
        else
        {
            LoadingState.loadAndSwitchState(new PlayState());
        }

        FlxG.sound.music.volume = 0;
    }
}