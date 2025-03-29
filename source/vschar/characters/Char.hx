package vschar.characters;

import BaseStage.Countdown;

class Char extends ScriptedCharacter
{
    var swappedHands:Bool = false;

    public function new(type:String = 'bf') super(type);

    override function createPost() {
        super.createPost();

        if (type == 'bf')
        {
            GameOverSubstate.characterName = 'char-dead';
        }
    }

    override function countdownTick(count:Countdown, num:Int)
    {
        super.countdownTick(count, num);

        switch (count)
        {
            case THREE:
                character.playAnim('countThree');
            case TWO:
                character.playAnim('countTwo');
            case ONE:
                character.playAnim('countOne');
            case GO:
                doNothing();
            case START:
                character.playAnim('hey', true);
        }
    }

    function doNothing():Void {}

    override function opponentNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.opponentNoteHit(id, direction, noteType, isSustainNote);
        if (!swappedHands && curSection <= 5 && type == 'bf')
            swapHands(ClientPrefs.data.char_curSkin);

        if (swappedHands && ClientPrefs.data.char_curSkin == 'remix')
        {
            if (type == 'dad')
                character.playAnim('sing${NoteDirection.getDirection(direction)}-swapped', true);
        }
    }

    function swapHands(curSkin:String)
    {
        if (curSkin == 'remix')
        {
            if (FlxG.random.bool(50))
            {
                character.playAnim('swapHands');
                swappedHands = true;
            }
        }
    }

    override function goodNoteHit(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.goodNoteHit(id, direction, noteType, isSustainNote);

        if (!swappedHands && curSection <= 5 && type == 'dad')
            swapHands(ClientPrefs.data.char_curSkin);

        if (swappedHands && ClientPrefs.data.char_curSkin == 'remix')
        {
            if (type == 'bf')
                character.playAnim('sing${NoteDirection.getDirection(direction)}-swapped', true);
        }
    }

    override function onNoteMiss(id:Int, direction:Float, noteType:String, isSustainNote:Bool) {
        super.onNoteMiss(id, direction, noteType, isSustainNote);

        if (!swappedHands && curSection <= 5 && type == 'dad')
            swapHands(ClientPrefs.data.char_curSkin);

        if (swappedHands && ClientPrefs.data.char_curSkin == 'remix')
        {
            if (type == 'bf')
                character.playAnim('sing${NoteDirection.getDirection(direction)}miss-swapped', true);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (character.animation.curAnim.name.endsWith('miss-swapped') && character.animation.curAnim.finished)
			{
				character.playAnim('idle', true, false, 10);
			}
    }
}

abstract NoteDirection(Int) from Int to Int
{
    public static function getDirection(inDir:Float):String
    {
        if ([1.0, 5.0].contains(inDir))
            return 'DOWN';
        else if ([2.0, 6.0].contains(inDir))
            return 'UP';
        else if ([3.0, 7.0].contains(inDir))
            return 'RIGHT';

        // if none of the above, probs left, or some out of range number, either way return as LEFT.
        return 'LEFT';
    }
}