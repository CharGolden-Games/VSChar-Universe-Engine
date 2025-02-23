package ue;

import ue.uescripts.Events;
import ue.uescripts.Force.DifficultyLVL;
import ue.uescripts.Force.SongName;
import ue.uescripts.Force.Fire;
import ue.uescripts.Force.Baldi;
import ue.uescripts.Force.DiscordRPCScript;
import ue.uescripts.Force.TrailDoubleNote;

import ue.uescripts.Options.UEHud as HudScript;
import ue.uescripts.Options.IconBop;
import ue.uescripts.Options.Keystrokes;

class UEScript extends BaseScript
{
    public static var FORCE:Array<BaseScript> = [];
    public static var OPTIONS:Array<BaseScript> = [];
    public static var GP:Array<BaseScript> = [];

    public static var totalScripts(get, null):Int = 0;
    static function get_totalScripts():Int
    {
        return FORCE.length + OPTIONS.length + GP.length;
    }
    public static var instance:UEScript;

    public function new()
    {
        super('UEScript');

        instance = this;
    }

    public override function initialize():Void
    {
        super.initialize();

        if (FORCE.length > 0 || OPTIONS.length > 0 || GP.length > 0)
        {
            // Shouldn't be more then 0, but if it is, clear scripts!
            #if debug trace('RESETTING LOADED SCRIPTS'); #end

            var clearedScripts:Int = 0;

            for (script in FORCE) {
                #if debug trace('CLEARING "${script.name}".'); #end
                script.onDestroy();
            }
            clearedScripts += FORCE.length;
            FORCE = [];

            for (script in OPTIONS) {
                #if debug trace('CLEARING "${script.name}".'); #end
                script.onDestroy();
            }
            clearedScripts += OPTIONS.length;
            OPTIONS = [];

            for (script in GP) {
                #if debug trace('CLEARING "${script.name}".'); #end
                script.onDestroy();
            }
            clearedScripts += GP.length;
            GP = [];

            #if debug trace('CLEARED $clearedScripts SCRIPTS'); #end
        }

        trace('LOADING SCRIPTS INTO ARRAYS');

        pushScripts(getForcedScripts(), FORCE);
        pushScripts(getOptionScripts(), OPTIONS);
        pushScripts(getGPScripts(), GP);

        trace('SCRIPTS LOADED: $totalScripts');

        for (script in FORCE) {
            #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
        }
        for (script in OPTIONS) {
            #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
        }
        for (script in GP) {
             #if debug trace('INITIALIZING ${script.name}'); #end
            script.initialize();
        }

        trace ('ALL SCRIPTS INITIALIZED');
    }

    function getForcedScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [
            new DifficultyLVL(),
            new SongName(),
            new Fire(),
            new Baldi(),
            new DiscordRPCScript(),
            new TrailDoubleNote(),
            new Events()
        ];

        return array;
    }

    function getOptionScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [];

        if (hudStyle == 'Universe Engine') //if (UEHud)
            array.push(new HudScript());
        if (UEiconBop)
            array.push(new IconBop());
        if (UEkeystrokes)
            array.push(new Keystrokes());

        return array;
    }
    
    function getGPScripts():Array<BaseScript>
    {
        var array:Array<BaseScript> = [];
        
        return array;
    }

    static var scriptsLoaded:FlxText;

    public override function onCreatePost() {
        super.onCreatePost();

        for (script in FORCE)
            script.onCreatePost();
        for (script in OPTIONS)
            script.onCreatePost();
        for (script in GP)
            script.onCreatePost();


        
        if (ClientPrefs.data.showLoadedScripts)
        {
            var FORCE:Array<BaseScript> = UEScript.FORCE;
            var OPTIONS:Array<BaseScript> = UEScript.OPTIONS;
            var GP:Array<BaseScript> = UEScript.GP;
            
            var scriptNames_FORCE:Array<String> = [];
            for (script in FORCE)
                scriptNames_FORCE.push(script.name);
            var scriptNames_OPTIONS:Array<String> = [];
            for (script in OPTIONS)
                scriptNames_OPTIONS.push(script.name);
            var scriptNames_GP:Array<String> = [];
            for (script in GP)
                scriptNames_GP.push(script.name);

            scriptsLoaded = new FlxText(0,0,FlxG.width, 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP', 10);
            scriptsLoaded.alpha = 0.8;
            scriptsLoaded.cameras = [game.camOther]; // camOther so it always stays in the game widnow!
            scriptsLoaded.borderStyle = OUTLINE;
            scriptsLoaded.borderColor = 0xFF000000;
            if (UEhudpos == 'LEFT')
                scriptsLoaded.alignment = RIGHT; // Lets you see the HUD along with the loaded scripts!
            scriptsLoaded.y = FlxG.height - (scriptsLoaded.height + 5);
            add(scriptsLoaded);
        }
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        for (script in FORCE)
            script.goodNoteHit(id, direction, noteType, isSustainNote);
        for (script in OPTIONS)
            script.goodNoteHit(id, direction, noteType, isSustainNote);
        for (script in GP)
            script.goodNoteHit(id, direction, noteType, isSustainNote);
    }

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        for (script in FORCE)
            script.onNoteMiss(id, direction, noteType, isSustainNote);
        for (script in OPTIONS)
            script.onNoteMiss(id, direction, noteType, isSustainNote);
        for (script in GP)
            script.onNoteMiss(id, direction, noteType, isSustainNote);
    }

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);

        for (script in FORCE)
            script.opponentNoteHit(id, direction, noteType, isSustainNote);
        for (script in OPTIONS)
            script.opponentNoteHit(id, direction, noteType, isSustainNote);
        for (script in GP)
            script.opponentNoteHit(id, direction, noteType, isSustainNote);
    }

    public override function onDestroy() {
        super.onDestroy();

        for (script in FORCE)
            script.onDestroy();
        for (script in OPTIONS)
            script.onDestroy();
        for (script in GP)
            script.onDestroy();
    }

    public override function onSongStart() {
        super.onSongStart();

        for (script in FORCE)
            script.onSongStart();
        for (script in OPTIONS)
            script.onSongStart();
        for (script in GP)
            script.onSongStart();
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        for (script in FORCE)
                script.onUpdate(elapsed);
        for (script in OPTIONS)
                script.onUpdate(elapsed);
        for (script in GP)
                script.onUpdate(elapsed);
    }

    public override function onUpdatePost(elapsed:Float) {
        super.onUpdatePost(elapsed);

        for (script in FORCE)
                script.onUpdatePost(elapsed);
        for (script in OPTIONS)
                script.onUpdatePost(elapsed);
        for (script in GP)
                script.onUpdatePost(elapsed);
    }

    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
        super.onEvent(name, value1, value2, strumTime);

        for (script in FORCE)
            script.onEvent(name, value1, value2, strumTime);
        for (script in OPTIONS)
            script.onEvent(name, value1, value2, strumTime);
        for (script in GP)
            script.onEvent(name, value1, value2, strumTime);
    }

    public override function onBeatHit() {
        super.onBeatHit();

        for (script in FORCE)
            script.onBeatHit();
        for (script in OPTIONS)
            script.onBeatHit();
        for (script in GP)
            script.onBeatHit();
    }

    public override function onPause() {
        super.onPause();

        
        for (script in FORCE)
            script.onPause();
        for (script in OPTIONS)
            script.onPause();
        for (script in GP)
            script.onPause();
    }

    public override function onResume() {
        super.onResume();

        
        for (script in FORCE)
            script.onResume();
        for (script in OPTIONS)
            script.onResume();
        for (script in GP)
            script.onResume();
    }

    function pushScripts(scripts:Array<BaseScript>, array:Array<BaseScript>):Array<BaseScript>
    {
        for (script in scripts)
        {
            array.push(script);
            trace('LOADED SCRIPT: "${script.name}".');
        }

        return array;
    }

    public static function removeScript(name:String):Void
    {
        var totalScripts:Array<Array<BaseScript>> = [
            FORCE,
            OPTIONS,
            GP
        ];

        var pos:Int = -1;
        var found:Bool = false;

        for (scripts in totalScripts)
        {
            pos++;

            var arrayName:String = '';

            if (pos == 1)
            {
                arrayName = 'OPTIONS';
            }
            else if (pos == 2)
            {
                arrayName = 'GP';
            }
            else
            {
                arrayName = 'FORCE';
            }

            for (script in scripts)
            {
                if (script.name == name)
                {
                    trace('SCRIPT "${script.name}" FOUND, REMOVING');
                    trace('OLD ARRAY FOR "$arrayName" `$scripts`');
                    scripts.remove(script);
                    script.onDestroy();
                    var errored:Bool = false;
                    for (script2 in scripts)
                    {
                        // Check if it is still left in the array.
                        if (script2.name == name)
                        {
                            trace('ERROR REMOVING SCRIPT!');
                            errored = true;
                        }
                    }
                    if (!errored)
                    {
                        trace('SUCCESSFULLY REMOVED ${script.name}');
                        trace('NEW ARRAY FOR "$arrayName" `$scripts`');
                    }
                }
            }

        }
        if (!found)
        {
            trace('COULD NOT FIND A SCRIPT WITH THE NAME OF "$name", CHECK THAT IS SPELLED CORRECTLY.');
        }
        if (ClientPrefs.data.showLoadedScripts)
        {
            try
            {
                var scriptNames_FORCE:Array<String> = [];
                for (script in FORCE)
                    scriptNames_FORCE.push(script.name);
                var scriptNames_OPTIONS:Array<String> = [];
                for (script in OPTIONS)
                    scriptNames_OPTIONS.push(script.name);
                var scriptNames_GP:Array<String> = [];
                for (script in GP)
                    scriptNames_GP.push(script.name);
                scriptsLoaded.text = 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP';
            }
            catch(e:Dynamic){}
        }
    }

    public static function pushScript(script:BaseScript, array:Array<BaseScript>):Array<BaseScript>
    {
        array.push(script);
        trace('LOADED SCRIPT: "${script.name}".');

        trace('THE NEW ARRAYS ARE `$FORCE` `$OPTIONS` `$GP`');
        
        if (ClientPrefs.data.showLoadedScripts)
        {
            try
            {
                var scriptNames_FORCE:Array<String> = [];
                for (script in FORCE)
                    scriptNames_FORCE.push(script.name);
                var scriptNames_OPTIONS:Array<String> = [];
                for (script in OPTIONS)
                    scriptNames_OPTIONS.push(script.name);
                var scriptNames_GP:Array<String> = [];
                for (script in GP)
                    scriptNames_GP.push(script.name);
                scriptsLoaded.text = 'Scripts Loaded: $totalScripts\nFORCE: $scriptNames_FORCE\nOPTIONS: $scriptNames_OPTIONS\nGameplay Settings: $scriptNames_GP';
            }
            catch(e:Dynamic){}
        }

        return array;
    }
}