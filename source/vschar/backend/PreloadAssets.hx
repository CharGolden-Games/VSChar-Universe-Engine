package vschar.backend;

import flixel.ui.FlxBar;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;

typedef Path = {
    public var path:String;
    @:optional public var library:String;
}

class CacheAssetType
{
    public var path:String;
    public var library:Null<String>;
    public var type:String;

    public function new(path:String, ?library:Null<String>, type:String)
    {
        this.path = path;
        this.library = library;
        this.type = type;
    }
}

class PreloadPaths 
{
    public static var paths:Array<Array<Path>> = [
        // Images
        [
            {
                path: 'vschar_stages/streets/images/bg'
            },
            {
                path: 'vschar_stages/streets/images/plexiBopStatic'
            },
            {
                path: 'vschar_stages/streets/images/sin'
            },
            {
                path: 'vschar_stages/streets/images/trevorBop'
            },
            {
                path: 'characters/char',
                library: 'shared'
            },
            {
                path: 'characters/trevor',
                library: 'shared'
            },
            {
                path: 'characters/plexi',
                library: 'shared'
            }
        ],
        // Sounds
        [],
        // Sparrow Atlases
        [
            {
                path: 'vschar_stages/streets/images/trevorBop'
            }
        ]
        ];

        public function new():Void {}
}

class PreloadAssets {
    
    public static var images:Map<String, FlxGraphic>;
    public static var sound:Map<String, Sound>;
    public static var sparrowAtlases:Map<String, FlxAtlasFrames>;
    public static var paths(get, null):Array<Array<Path>>;
    static function get_paths():Array<Array<Path>>
    {
        return PreloadPaths.paths;
    }

    public static var totalToLoad:Int = 0;
    static var curLoading:Int = 1;
    public static var totalLoaded:Int = 0;
    public static var loadedPercent(get, null):Float;

    public static var curAsset:CacheAssetType = null;

    static function get_loadedPercent()
    {
        return totalLoaded / totalToLoad;
    }

    public function new()
    {
        images = new Map<String, FlxGraphic>();
        sound = new Map<String, Sound>();
        sparrowAtlases = new Map<String, FlxAtlasFrames>();
        totalLoaded = 0;
        totalToLoad = 0;

        initialize();
    }

    static function preloadImages()
    {
        for (p in paths[0])
        {
            trace('Trying to load `${p.path}`!');
            new FlxTimer().start(2 * curLoading, function (tmr:FlxTimer)
            {
                var path:String = p.path;
                var library:Null<String> = p.library;
                curAsset = new CacheAssetType(path, library, 'image');
                images.set(path, Paths.image(path, library));
                totalLoaded++;
            });
            curLoading++;
        }

        preloadSounds();
    }

    static function preloadSounds()
    {
        for (p in paths[1])
        {
            trace('Trying to load `${p.path}`!');
            new FlxTimer().start(2 * curLoading, function (tmr:FlxTimer)
            {
                var path:String = p.path;
                var library:Null<String> = p.library;
                curAsset = new CacheAssetType(path, library, 'sound');
                sound.set(path, Paths.sound(path, library));
                totalLoaded++;
            });
            curLoading++;
        }

        preloadAtlases();
    }

    static function preloadAtlases()
    {
        for (p in paths[2])
        {
            trace('Trying to load `${p.path}`!');
            new FlxTimer().start(2 * curLoading, function (tmr:FlxTimer)
            {
                var path:String = p.path;
                var library:Null<String> = p.library;
                curAsset = new CacheAssetType(path, library, 'atlas');
                sparrowAtlases.set(path, Paths.getSparrowAtlas(path, library));
                totalLoaded++;
            });
            curLoading++;
        }
    }

    static function initialize()
    {
        for (path in paths)
        {
            for (subPath in path)
                totalToLoad++;
        }

        preloadImages();
    }
}

class CacheAssetState extends MusicBeatState
{
    var bg:FlxSprite;
    var loadBar:FlxBar;
    var loadText:FlxText;
    var lastPercent:Float = -1;
    public static var leftState:Bool = false;
    static var curAsset:CacheAssetType;

    var displayPercent(get, null):Int;
    function get_displayPercent():Int
    {
        return Math.floor(lastPercent * 100);
    }

    static var timeout:Int = 10;
    var timeoutTimer:FlxTimer;

    override function create() {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('aboutMenu'));
        bg.scrollFactor.set();
        add(bg);

        loadBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 600, 19, this, 'lastPercent', 0, 1);
        loadBar.screenCenter();
        loadBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
        add(loadBar);

        
        if (curAsset == null)
            {
                @:privateAccess {
                    curAsset = new CacheAssetType(PreloadAssets.paths[0][0].path, PreloadAssets.paths[0][0].library, 'image');
                }
            }

        loadText = new FlxText(0, 0, FlxG.width, 'loading the ${curAsset.type}: '
        + '`${formatAsPath(curAsset.path, curAsset.library)}`');
        loadText.setFormat(Paths.font('vcr.ttf'), 30, 0xFFFFFF, CENTER, OUTLINE, 0xFF000000);
        loadText.borderSize = 3;
        loadText.y = loadBar.y - loadText.height;
        add(loadText);

        new PreloadAssets();
    }

    function formatAsPath(path:String, ?library:String)
    {
        if (library != null)
            path = library + ':' + path;

        return path;
    }

    function checkIfOutOfBounds(array:Array<Dynamic>, index:Int):Bool
    {
        if (index > array.length - 1)
        {
            return true;
        }

        return false;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (lastPercent != PreloadAssets.loadedPercent)
        {
            try
            {
                curAsset = PreloadAssets.curAsset;
                lastPercent = PreloadAssets.loadedPercent;
                loadText.text = 'loading the ${curAsset.type}: '
                + '`${formatAsPath(curAsset.path, curAsset.library)}`'
                + '\n\nCurrently Loaded:\n$displayPercent% (${PreloadAssets.totalLoaded} / ${PreloadAssets.totalToLoad})';
                loadText.y = loadBar.y - loadText.height;
                if (timeoutTimer != null)
                    timeoutTimer.cancel();

                timeoutTimer = new FlxTimer().start(timeout, function(tmr:FlxTimer) {
                    lime.app.Application.current.window.alert('Timed out after ${timeout}s!', 'Caching Timed Out!');
                    leave(true);
                });
            }
            catch(e:Dynamic) {}
        }

        if (lastPercent == 1)
        {
            leave();
        }
    }

    public static function resetLocalTrackedAssets()
    {
        for (asset => graphic in PreloadAssets.images)
        {
            var path = '$asset.png';
            Paths.excludeAsset(path);
        }

        for (asset => sound in PreloadAssets.sound)
            {
                var path = '$asset.${Paths.SOUND_EXT}';
                Paths.excludeAsset(path);
            }

        for (asset => atlas in PreloadAssets.sparrowAtlases)
            {
                var path = '$asset.xml';
                Paths.excludeAsset(path);
            }
    }

    function leave(timedOut:Bool = false)
    {
        if (!timedOut)
            resetLocalTrackedAssets();
        leftState = true;
        MusicBeatState.switchState(new TitleState());
    }
}

class ConfigState extends MusicBeatState
{
    var bg:FlxSprite;
    var text:FlxText;
    public static var leftState:Bool = false;

    override function create() {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('aboutMenu'));
        bg.scrollFactor.set();
        add(bg);

        text = new FlxText(0, 0, FlxG.width, 
            'Hey buddy!
            \nThis game uses a caching system!
            \n
            \nPress Y to use it, or press N to disable it.'
            );
        text.setFormat(Paths.font('vcr.ttf'), 20, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        text.screenCenter(Y);
        add(text);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.Y)
        {
            ClientPrefs.data.preCache = true;
            ClientPrefs.saveSettings();
            MusicBeatState.switchState(new CacheAssetState());
        }
        else
        {
            ClientPrefs.data.preCache = false;
            ClientPrefs.saveSettings();
            MusicBeatState.switchState(new TitleState());
        }
    }
}