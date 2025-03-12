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

/**
 * Basically Application.current.meta but better because you can add new shit to it HAHAHAHAH
 */
class ExtendedMeta {
    static var meta:Map<String, String> = new Map<String, String>();
    static var isEmpty:Bool = true;
    static var curSong:String = '';

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

    static function checkMeta()
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
                    meta.set(key, value);
                    meta.set('funkinVersion', value);
                }
            }

            isEmpty = false;
        }
        if (appMetaFail)
        {
            isEmpty = true;
            appMetaFail = false;
        }

        meta.set('modVersion', getModVersion_VersionOnly());
        meta.set('modVersionString', getModVersion());
        meta.set('modTitle', getModTitle());
        meta.set('psychVer', '0.6.3');
        meta.set('ueVer', '0.5.5');
        meta.set('vsCharVersion', 'Unreleased [0.1b-Dev]');
        meta.set('charEngineVersion', 'Unreleased [inDev]');
        meta.set('curSong', '');
        meta.set('ExtendedMetaJsonVer', '1.0');
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

    public static function updateTitle()
    {
        if (get('curSong') != curSong)
            meta.set('curSong', curSong); // pls work pls pls pls

        var title:String = get('modTitle');

        if (title == 'null')
            return;

        if (curSong != '')
            title = title.replace('{curSong}',
            '| ${curSong.FUL()}').replace('{curArtist}',
            '').replace('{curAssetArtist}', '');
        else
            title = title.replace('{curSong}', 
        '').replace('{curArtist}',
        '').replace('{curAssetArtist}', '');

        title = title.replace('{vsCharVersion}',
        get('vsCharVersion', true)).replace('{engineVersion_Char}',
        get('charEngineVersion', true)).replace('{engineVersion_Psych}',
        get('psychVer', true)).replace('{engineVersion_UE}', 
        get('ueVer', true)).replace('{modVersion}', get('modVersion', true));

        openfl.Lib.application.window.title = title;
    }

    static inline function getModVersion()
    {
        var text = getModVerText();

        if (text == 'None|N/A')
            return text; // Don't modify it if it didn't find anything, or if the modVer text isn't changed

        var splitVer = text.split('|');

        var finalString = '${splitVer[0]} - v${splitVer[1]}';
        return finalString;
    }
    static inline function getModVersion_VersionOnly()
    {
        var text = getModVerText();

        var splitVer = text.split('|');
        return splitVer[1];
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

    public static function set(key:String, value:String)
    {
        checkMeta();
        if (key == 'curSong'){
            curSong = value;
            meta.remove('curSong'); // PLEASE.
            meta.set('curSong', curSong);
            flushToFile();
            updateTitle();
            return;
        }

        meta.set(key, value);
    }
    
    /**
     * Gets the value of `key`
     * @param key 
     * @param noNull whether to return represent null as the string `"null"`
     * @return Null<String>
     */
    public static function get(key:String, noNull:Bool = false):Null<String>
    {
        checkMeta();
        if (noNull)
            if (!exists(key))
                return 'null';
        return meta.get(key);
    }

    public static function exists(key:String):Bool
    {
        checkMeta();
        return meta.exists(key);
    }

    public static function initialize()
    {
        checkMeta();
    }

    /**
     * For checking that the app meta is correct.
     */
    public static function flushToFile()
    {
        checkMeta();
        #if sys
		if (!FileSystem.exists('curAppMeta'))
			FileSystem.createDirectory('curAppMeta');
		File.saveContent('curAppMeta/meta.json', buildFile());
        #end
    }

    /**
     * Converts from map<String, String> to JSON.
     * @return String
     */
    static function buildFile():String
    {
        return Json.stringify(meta, '\t');
    }
}