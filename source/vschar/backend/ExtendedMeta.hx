package vschar.backend;

import haxe.Json;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import lime.app.Application;
import openfl.Assets;

using StringTools;
using ue.backend.ExtendedStringTools;

class ModMetaExists {
    public var metaExists:Bool = false;
    public var modMetaExists:Bool = false;


    public function new(mExists:Bool, mmExists:Bool)
    {
        metaExists = mExists;
        modMetaExists = mmExists;
    }
}

/**
 * Basically Application.current.meta but better because you can add new shit to it HAHAHAHAH
 */
class ExtendedMeta {
    static var meta:Map<String, String> = new Map<String, String>();
    static var modMeta:Map<String, String> = null;
    /**
     * Whether Application.current.meta was successfully gotten.
     */
    static var isEmpty:Bool = true;
    /**
     * Meant to function similar to `var name(default, null):String;`.
     */
    static var unSettableKeys:Array<String> = [];

    static var appMetaFail:Bool = false;
    static var appMeta(get, null):Map<String, String>;
    static function get_appMeta():Map<String, String> 
    {
        try
        {
            return Application.current.meta;
        }
        catch(e:Dynamic)
        {
            appMetaFail = true;
            return new Map<String, String>();
        }
    }

    public function new()
    {
        checkMeta();
    }

    public static function remove(key:String)
    {
        checkMeta();
        meta.remove(key);
    }

    @:noPrivateAccess static function checkMeta()
    {
        if (isEmpty)
        {
            for (key => value in appMeta)
            {
                if (key != 'version')
                {
                    meta.set(key, value);
                }
                else
                {
                    // This lets you set the version string WITHOUT overwriting the funkin version string.
                    meta.set(key, value);
                    meta.set('funkinVersion', value);
                }
            }

            isEmpty = false;
            
            // Version shit
            meta.set('modVersion', getModVersion(true));
            meta.set('modVersionString', getModVersion());

            meta.set('psychVer', '0.6.3');
            meta.set('ueVer', '0.5.5');

            meta.set('vsCharVersion', 'Unreleased [0.1b-Dev]');
            meta.set('charEngineVersion', 'Unreleased [inDev]');

            meta.set('ExtendedMetaJsonVer', '1.0.2');
            meta.set('LuaCallbackVer', 'Revision 1.1');

            unSettableKeys = [
                'psychVer',
                'ueVer',
                'vsCharVersion',
                'charEngineVersion',
                'ExtendedMetaJsonVer',
                'LuaCallbackVer'
            ];

            // Song shit.
            meta.set('curSong', '');
            meta.set('songArtist', '');
            meta.set('songAssetArtist', '');

            // Other shit
            meta.set('modTitle', getModTitle());
        }
        if (appMetaFail)
        {
            isEmpty = true;
            appMetaFail = false;
        }
        if (modMeta != null)
        {
            for (key => value in meta)
            {
                modMeta.set(key, value);
            }
        }
    }

    static inline function getModTitle()
    {
        if (pathExists('extendedMeta/title.txt'))
            #if sys
                if (!Assets.exists('extendedMeta/title.txt'))
                    return File.getContent('extendedMeta/title.txt');
                else
            #end
                return Assets.getText('extendedMeta/title.txt');
        else
            return 'null';
    }

    public static function updateTitle():String
    {
        checkMeta();
        var title:String = get('modTitle');

        if (title == 'null')
            return get('name');

        if (get('curSong') != '')
            title = title.replace('{curSong}', '| ' + get('curSong').replace('\n', '  '));
        else
            title = title.replace('{curSong}', '');

        if (get('songArtist') != '')
            title = title.replace('{curArtist}', '| Composer: ' + get('songArtist').replace('\n', '  '));
        else
            title = title.replace('{curArtist}', '');

        if (get('songAssetArtist') != '')
            title = title.replace('{curAssetArtist}', '| Artist: ' + get('songAssetArtist').replace('\n', '  '));
        else
            title = title.replace('{curAssetArtist}', '');

        title = title.replace('{vsCharVersion}', get('vsCharVersion', true));
        title = title.replace('{engineVersion_Char}', get('charEngineVersion', true));
        title = title.replace('{engineVersion_Psych}', get('psychVer', true));
        title = title.replace('{engineVersion_UE}', get('ueVer', true));
        title = title.replace('{modVersion}', get('modVersion', true));

        return openfl.Lib.application.window.title = title;
    }

    static inline function getModVersion(verOnly:Bool = false)
    {
        var text = getModVerText();

        if (text == 'None|N/A')
            return text; // Don't modify it if it didn't find anything, or if the modVer text isn't changed

        var splitVer = text.split('|');

        var finalString = '${splitVer[0]} - v${splitVer[1]}';
        if (verOnly)
            return finalString;
        else
            return splitVer[1];
    }

    static function checkPathsExist()
    {
        if (!pathExists('extendedMeta'))
        {
            #if sys
            FileSystem.createDirectory('extendedMeta');
            File.saveContent('extendedMeta/title.txt', 'null');
            File.saveContent('extendedMeta/modVersion.txt', 'None|N/A');
            File.saveContent('extendedMeta/readme.txt', Assets.getText('assets/embed/extendedMetaReadme.txt'));
            #end
        }
        
        if (!pathExists('extendedMeta/title.txt'))
        {
            if (!pathExists('extendedMeta'))
            {
                #if sys
                FileSystem.createDirectory('extendedMeta');
                #else
                trace('Are you even on desktop?');
                #end
            }
            #if sys
            File.saveContent('extendedMeta/title.txt', 'null');
            #else
            trace('Are you even on desktop?');
            #end
        }
        
        if (!pathExists('extendedMeta/modVersion.txt'))
        {
            if (!pathExists('extendedMeta'))
            {
                #if sys
                FileSystem.createDirectory('extendedMeta');
                #else
                trace('Are you even on desktop?');
                #end
            }
            #if sys
            File.saveContent('extendedMeta/modVersion.txt', 'None|N/A');
            #else
            trace('Are you even on desktop?');
            #end
        }
        
        if (!pathExists('extendedMeta/readme.txt'))
        {
            if (!pathExists('extendedMeta'))
            {
                #if sys
                FileSystem.createDirectory('extendedMeta');
                #else
                trace('Are you even on desktop?');
                #end
            }
            #if sys
            File.saveContent('extendedMeta/readme.txt', Assets.getText('assets/embed/extendedMetaReadme.txt'));
            #else
            trace('Are you even on desktop?');
            #end
        }
    }

    static inline function getModVerText():String
    {
        if (pathExists('extendedMeta/modVersion.txt'))
            #if sys
                if (!Assets.exists('extendedMeta/modVersion.txt'))
                    return File.getContent('extendedMeta/modVersion.txt');
                else
            #end
                return Assets.getText('extendedMeta/modVersion.txt');
        else
            return 'None|N/A';
    }

    static inline function pathExists(path:String)
    {
        return (#if sys FileSystem.exists(path) || #end Assets.exists(path));
    }

    public static function set(key:String, value:String, isLua:Bool = false)
    {
        if (!isLua)
        {
            metaSet(key, value);
        }
        else
        {
            #if LUA_ALLOWED // stupid workaround
            if (get(key) != null)
            {
                metaSet(key, value);
            }
            modSet(key, value);
            #else
            metaSet(key, value);
            #end
        }
    }

    @:noPrivateAccess static function metaSet(key:String, value:String)
    {
        checkMeta();
        #if LUA_ALLOWED
        if (modMeta != null) // KEEP THAT SHIT UP TO DATE.
        {
            modMeta.set(key, value);
        }
        #end
        if (key == 'curSong'){
            meta.set('curSong', value);
            updateTitle();
            flushToFile();
            return;
        }
        // NOPE
        if (unSettableKeys.contains(key)) // if for some reason you try to overwrite a version string, it adds `_mod` to it
        {
            key += '_mod';
        }

        meta.set(key, value);
    }

    @:noPrivateAccess static function modSet(key:String, value:String)
    {
        if (modMeta == null)
            modMeta = meta;

        if (exists(key))
            metaSet(key, value);
        else
            modMeta.set(key, value);
    }
    
    /**
     * Gets the value of `key`
     * @param key 
     * @param noNull whether to return represent null as the string `"null"`
     * @return Null<String>
     */
    public static function get(key:String, noNull:Bool = false, isLua:Bool = false):Null<String>
    {
        checkMeta();
        if (!isLua)
        {
            #if LUA_ALLOWED
            if (!exists(key) && exists(key, true))
                return modGet(key, noNull);
            #end
            return metaGet(key, noNull);
        }
        else
        {
            #if LUA_ALLOWED // Stupid workaround
            if (meta.get(key) != null)
                return metaGet(key, noNull);

            return modGet(key, noNull);
            #else
            return metaGet(key, noNull);
            #end
        }
    }

    @:noPrivateAccess static function modGet(key:String, noNull:Bool)
    {
        if (modMeta == null)
            modMeta = meta;

        if (noNull)
            if (!exists(key, true)){
                if (!exists(key))
                    return 'null';
                else
                    return meta.get(key);
            }
        return modMeta.get(key);
    }

    @:noPrivateAccess static function metaGet(key:String, noNull:Bool)
    {
        if (noNull)
            if (!exists(key))
                return 'null';
        return meta.get(key);
    }

    public static function exists(key:String, isLua:Bool = false):Bool
    {
        checkMeta();
        #if LUA_ALLOWED
        if (modMeta == null)
            modMeta = meta;

        var result:ModMetaExists = new ModMetaExists(meta.exists(key), modMeta.exists(key));
        if (isLua)
            return result.modMetaExists;
        else
            return result.metaExists;
        #else
        return meta.exists(key);
        #end
    }

    public static function initialize()
    {
        checkMeta();
        modMeta = null;
    }

    /**
     * For checking that the app meta is correct.
     */
    public static function flushToFile()
    {
        #if debug
            #if sys
                checkMeta();
                if (!FileSystem.exists('curAppMeta'))
                    FileSystem.createDirectory('curAppMeta');
                File.saveContent('curAppMeta/meta.json', buildFile());
            #end
        #else
            #if ANNOYING_TRACES
                trace(buildFile());
            #end
        #end
    }

    /**
     * Converts from map<String, String> to JSON.
     * @return String
     */
    @:noPrivateAccess static function buildFile():String
    {
        #if LUA_ALLOWED
        if (modMeta == null)
            modMeta = meta;

        return Json.stringify(modMeta, '\t');
        #else
        return Json.stringify(meta, '\t');
        #end
    }
}