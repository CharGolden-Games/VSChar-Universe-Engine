package vschar.backend.scripting;

import vschar.backend.scripting.vschar_scripts.UniversalTriggers;
import vschar.backend.scripting.vschar_scripts.CharOptions.RotBop;
import vschar.backend.scripting.vschar_scripts.CharOptions.HudType;
import vschar.backend.scripting.vschar_scripts.CharOptions.BFasOpp;
import vschar.backend.scripting.vschar_scripts.CharOptions.ExtendHealthbar;
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

    override function getGPScripts():Array<BaseScript> {
        var array:Array<BaseScript> = super.getGPScripts();
        
        if (ClientPrefs.getGameplaySetting('BFasOpp', false) == true)
            array.push(new BFasOpp());
        if (ClientPrefs.getGameplaySetting('BFasOpp', false) == true || ClientPrefs.getGameplaySetting('ExtendHealth', false) == true)
            array.push(new ExtendHealthbar());

        return array;
    }
}