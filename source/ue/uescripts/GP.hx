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

class PlayBothSides extends BaseScript
{
    public function new() super('Play Both Sides');

     var arrowSwitching:Bool = false; // Arrow switching between singers (Doesn't work if MiddleScroll is enabled)
     var oppnoanim:Bool = true; // self explain
     var arrowGone:Bool = false; // opp notes gone
     var middlescrollye:Bool = true; // self elxpain
     var mode:String = 'Extreme';
     // Play mode:
     // Extreme - plays all of the notes in the chart, can be unfair due to overlapping hold notes
     // Camera - plays only the notes of who camera is focusing at the moment

     var cameraBotTime:Float = 0.3;

     var hasMiss:Bool = false;
     var playerNoteTime:Float = -1000;
     var opponentNoteTime:Float = -1000;
     var arrowMode:Int = 0;
     var curFocus:String;

    function changeNotes()
    {
        for (i in 0...notes.length - 1)
        {
            notes.members[i].mustPress = !notes.members[i].mustPress;
            notes.members[i].noAnimation = !notes.members[i].noAnimation;
            if (notes.members[i].mustPress && (notes.members[i].strumTime - Conductor.songPosition <= cameraBotTime * 1000))
            {
                notes.members[i].mustPress = false;
                notes.members[i].noAnimation = true;
            }
        }
        for (i in 0...unspawnNotes.length - 1)
        {
            unspawnNotes[i].mustPress = !unspawnNotes[i].mustPress;
            unspawnNotes[i].noAnimation = !unspawnNotes[i].noAnimation;
        }
    }

    public override function onCreatePost() {
        super.onCreatePost();

        if (mode.lower() == 'extreme' && mode.lower() != 'camera')
        {
            mode = 'Extreme';
        }
        hasMiss = boyfriend.hasMissAnimations;
        for (i in 0...unspawnNotes.length - 1)
        {
            if (!unspawnNotes[i].mustPress)
            {
                unspawnNotes[i].mustPress = true;
                unspawnNotes[i].noAnimation = true;
            }
        }
        dad.singDuration = 999;
        boyfriend.singDuration = 999;
    }

    public override function onSongStart() {
        super.onSongStart();
        curFocus = mustHitSection ? 'bf' : 'dad';
    }

    public override function onUpdatePost(elapsed:Float)
    {
        super.onUpdatePost(elapsed);

        if (middlescrollye)
        {
            noteTweenX("NoteMove1", 4, 415, 0.5, 'cubeInOut');
            noteTweenX("NoteMove2", 5, 525, 0.5, 'cubeInOut');
            noteTweenX("NoteMove3", 6, 635, 0.5, 'cubeInOut');
            noteTweenX("NoteMove4", 7, 745, 0.5, 'cubeInOut');

            noteTweenAngle("NoteAngle1", 4, -360, 0.5, 'cubeInOut');
            noteTweenAngle("NoteAngle2", 5, -360, 0.5, 'cubeInOut');
            noteTweenAngle("NoteAngle3", 6, -360, 0.5, 'cubeInOut');
            noteTweenAngle("NoteAngle4", 7, -360, 0.5, 'cubeInOut');

            noteTweenAlpha("NoteMove5", 0, 0, 0.5, 'cubeInOut');
            noteTweenAlpha("NoteMove6", 1, 0, 0.5, 'cubeInOut');
            noteTweenAlpha("NoteMove7", 2, 0, 0.5, 'cubeInOut');
            noteTweenAlpha("NoteMove8", 3, 0, 0.5, 'cubeInOut');
        }

        if (opponentStrums.members[3].alpha != 0 && mode.lower() != 'camera')
        {
            noteTweenAlpha('die1', 0, 0, 0.3, 'linear');
            noteTweenAlpha('die2', 1, 0, 0.3, 'linear');
            noteTweenAlpha('die3', 2, 0, 0.3, 'linear');
            noteTweenAlpha('die4', 3, 0, 0.3, 'linear');
        }
        else if (mode.lower() == 'camera')
        {
            opponentStrums.members[0].x = playerStrums.members[0].x;
            opponentStrums.members[1].x = playerStrums.members[1].x;
            opponentStrums.members[2].x = playerStrums.members[2].x;
            opponentStrums.members[3].x = playerStrums.members[3].x;

            if (arrowGone)
            {
                noteTweenAlpha('live1', 0, 0.2, 0.3, 'linear');
                noteTweenAlpha('live2', 1, 0.2, 0.3, 'linear');
                noteTweenAlpha('live3', 2, 0.2, 0.3, 'linear');
                noteTweenAlpha('live4', 3, 0.2, 0.3, 'linear');
            } 
        }
        playerNoteTime = -1000;
        opponentNoteTime = -1000;
        for (i in 0...notes.members.length - 1)
        {
            if (notes.members[i].mustPress && !notes.members[i].noAnimation)
            {
                if (playerNoteTime == -1000 || notes.members[i].strumTime < playerNoteTime)
                {
                    playerNoteTime = notes.members[i].strumTime;
                }
            }
            else
            {
                if (opponentNoteTime == -1000 || notes.members[i].strumTime < opponentNoteTime)
                    {
                        opponentNoteTime = notes.members[i].strumTime;
                    }
            }
        }
        if (arrowSwitching && !middlescroll)
        {
            if (arrowMode == 2)
            {
                for (i in newIterator(4, 7, 1))
                {
                    noteTweenX('ok$i', i, 42 + FlxG.width / 2 + ((i - 3) * Note.swagWidth), 0.5, 'linear');
                }
            }
            if (arrowMode == 1)
            {
                for (i in newIterator(4, 7, 1))
                {
                    noteTweenX('ok$i', i, 42 + ((i - 3) * Note.swagWidth), 0.5, 'linear');
                }
            }
            if (arrowMode == 0)
            {
                for (i in newIterator(4, 7, 1))
                {
                    noteTweenX('ok$i', i, -330 + FlxG.width / 2 + ((i - 3) * Note.swagWidth), 0.5, 'linear');
                }
            }
        }
    }

    public override function onMoveCamera(focus:String)
    {
        super.onMoveCamera(focus);
    
        if (curStep > -1 && curFocus != focus && mode.lower() != 'camera')
        {
            curFocus = focus;
            changeNotes();
        }
    }

    public override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        if (oppnoanim)
        {
            if (notes.members[id].noAnimation)
            {
                switch (direction)
                {
                    case 0:
                        try
                        {
                            dad.playAnim('singLEFT');
                        }
                        catch(e:Dynamic) {}

                    case 1:
                        try
                        {
                            dad.playAnim('singDOWN');
                        }
                        catch(e:Dynamic) {}

                    case 2:
                        try
                        {
                            dad.playAnim('singUP');
                        }
                        catch(e:Dynamic) {}

                    case 3:
                        try
                        {
                            dad.playAnim('singRIGHT');
                        }
                        catch(e:Dynamic) {}
                }
            }
        }
    }

    public override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);

        if (oppnoanim)
        {
            if (notes.members[id].noAnimation)
            {
                switch (direction)
                {
                    case 0:
                        try
                        {
                            boyfriend.playAnim('singLEFT');
                        }
                        catch(e:Dynamic) {}

                    case 1:
                        try
                        {
                            boyfriend.playAnim('singDOWN');
                        }
                        catch(e:Dynamic) {}

                    case 2:
                        try
                        {
                            boyfriend.playAnim('singUP');
                        }
                        catch(e:Dynamic) {}

                    case 3:
                        try
                        {
                            boyfriend.playAnim('singRIGHT');
                        }
                        catch(e:Dynamic) {}
                }
            }
        }
    }

    public override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        if (oppnoanim)
        {
            if (notes.members[id].noAnimation)
            {
                if (hasMiss)
                {
                    boyfriend.hasMissAnimations = false;
                    try
                    {
                        boyfriend.playAnim('idle');
                    }
                    catch(e:Dynamic) {}
                }
                if (dad.hasMissAnimations)
                {
                    switch (direction)
                    {
                        case 0:
                            try
                            {
                                dad.playAnim('singLEFT');
                            }
                            catch(e:Dynamic) {}
    
                        case 1:
                            try
                            {
                                dad.playAnim('singDOWNmiss');
                            }
                            catch(e:Dynamic) {}
    
                        case 2:
                            try
                            {
                                dad.playAnim('singUPmiss');
                            }
                            catch(e:Dynamic) {}
    
                        case 3:
                            try
                            {
                                dad.playAnim('singRIGHTmiss');
                            }
                            catch(e:Dynamic) {}
                    }
                }
            }
            else
            {
                if (!boyfriend.hasMissAnimations)
                {
                    boyfriend.hasMissAnimations = true;
                    switch (direction)
                    {
                        case 0:
                            try
                            {
                                boyfriend.playAnim('singLEFTmiss');
                            }
                            catch(e:Dynamic) {}
    
                        case 1:
                            try
                            {
                                boyfriend.playAnim('singDOWNmiss');
                            }
                            catch(e:Dynamic) {}
    
                        case 2:
                            try
                            {
                                boyfriend.playAnim('singUPmiss');
                            }
                            catch(e:Dynamic) {}
    
                        case 3:
                            try
                            {
                                boyfriend.playAnim('singRIGHTmiss');
                            }
                            catch(e:Dynamic) {}
                    }
                }
            }
        }
    }
}