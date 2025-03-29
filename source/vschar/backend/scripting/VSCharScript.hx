package vschar.backend.scripting;

import vschar.backend.scripting.vschar_scripts.UniversalTriggers;
import vschar.backend.scripting.vschar_scripts.CharOptions.RotBop;
import vschar.backend.scripting.vschar_scripts.CharOptions.HudType;
import vschar.backend.scripting.vschar_scripts.CharOptions.BFasOpp;
import vschar.backend.scripting.vschar_scripts.CharOptions.ExtendHealthbar;
import vschar.backend.scripting.vschar_scripts.CharOptions.VCIconBop;

import ue.uescripts.Force.Fire;
import ue.UEScript;
import ue.uescripts.Options.IconBop;

class VSCharScript extends UEScript {

    public override function onCreatePost() {
        super.onCreatePost();

        Fire.baseTitle = ExtendedMeta.updateTitle();

        PlayState.instance.healthBar.x += 4;
        PlayState.instance.healthBar.y += 4;
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
        if (UEiconBop)
            array.push(new VCIconBop());

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