package vschar.backend.scripting;

import vschar.backend.scripting.vschar_scripts.UniversalTriggers;
import vschar.backend.scripting.vschar_scripts.CharOptions.RotBop;
import vschar.backend.scripting.vschar_scripts.CharOptions.HudType;
import ue.uescripts.Force.Fire;
import ue.UEScript;

class VSCharScript extends UEScript {

    public override function onCreatePost() {
        super.onCreatePost();

        if (ClientPrefs.data.vsCharCustomizations)
            Fire.baseTitle = "Friday Night Funkin': Funkin' with Char!"; // VS Char customization.
    }

    public override function getForcedScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getForcedScripts();

        array.push(new UniversalTriggers());
        array.push(new HudType());

        return array;
    }

    override function getOptionScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getOptionScripts();

        if (rotBop)
            array.push(new RotBop());

        return array;
    }
}