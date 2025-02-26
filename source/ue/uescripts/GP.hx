package ue.uescripts;

import ue.UEScript.MasterScript;

class GP extends MasterScript 
{
    public function new(?script:String)
    {
        super('GP Master Class');

        if (script != null)
            callScript(script);
    }
}

class CrashOnMiss /**HAHAHAHAH**/ extends BaseScript
{
    public function new() super('Crash On Miss');

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        throw 'You missed, bye! (You chose to crash on miss!)';
    }
}

class SusAsOneNote extends BaseScript
{
    public function new() super('Sustains as one note');

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);
        
        if (UEhealthDrain)
            {
                if (isSustainNote)
                {
                    health = (health + 0.023) * healthLossMult;
                }
            }
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        
        if (isSustainNote)
            {
                health = (health - 0.023) * healthGainMult;
            }
    }

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        if (isSustainNote)
            {
                health = (health + 0.0475) * healthLossMult;
            }
    }
}

class HealthDrain extends BaseScript
{
    public function new() super('Health Drain');

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);

        if (health > 0.05)
            health -= (0.023 * healthLossMult);
    }
}

class HealthDrainPT2 extends BaseScript
{
    public function new() super('Health Drain Part 2');

    var healthDrain:Float = 0;

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        healthDrain += 0.002;
    }

    public override function onUpdate(elapsed:Float) {
        super.onUpdate(elapsed);

        if (healthDrain < 0)
            healthDrain = 0;

        if (health > 0.05)
            health -= healthDrain;
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        healthDrain -= 0.002;
    }
}