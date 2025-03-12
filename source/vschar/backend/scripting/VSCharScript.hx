package vschar.backend.scripting;

import vschar.backend.scripting.vschar_scripts.UniversalTriggers;
import vschar.backend.scripting.vschar_scripts.CharOptions.RotBop;
import vschar.backend.scripting.vschar_scripts.CharOptions.HudType;
import ue.uescripts.Force.Fire;
import ue.UEScript;

class VSCharScript extends UEScript {

    public override function onCreatePost() {
        super.onCreatePost();

        Fire.baseTitle = ExtendedMeta.updateTitle();
    }

    public override function getForcedScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getForcedScripts();

        array.push(new UniversalTriggers());

        return array;
    }

    override function getOptionScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getOptionScripts();

        if (rotBop)
            array.push(new RotBop());
        if (hudStyle != 'Universe Engine')
            array.push(new HudType());

        return array;
    }
}