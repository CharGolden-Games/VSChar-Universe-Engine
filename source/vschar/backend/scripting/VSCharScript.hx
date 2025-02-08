package vschar.backend.scripting;

import vschar.backend.scripting.vschar_scripts.UniversalTriggers;
import vschar.backend.scripting.vschar_scripts.CharOptions.RotBop;

class VSCharScript extends ue.UEScript {
    public override function getForcedScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getForcedScripts();

        array.push(new UniversalTriggers());

        return array;
    }

    override function getOptionScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getOptionScripts();

        if (rotBop)
            array.push(new RotBop());

        return array;
    }
}