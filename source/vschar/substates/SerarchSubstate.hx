package vschar.substates;

import flixel.addons.ui.FlxInputText;
import flixel.FlxCamera;

using StringTools;

class SerarchSubstate extends MusicBeatSubstate {
    public static var items:Array<String> = [];
    public static var baseItems:Array<String> = [];

    public static var callback:String->Void = function(str:String) return;

    public static var blockInput:Bool = false;
    public static var blockEnter:Bool = false;
    public static var firstInput:Bool = true;

    public function new(itemList:Array<String>)
    {
        super();

        items = itemList;
        baseItems = itemList;
    }

    var bg:FlxSprite;
    var searchInput:FlxInputText;
    var grpOptions:FlxTypedGroup<Alphabet>;
    var sortBy:String = 'Alphabetical';
    var curSelected:Int = 0;
    var camBG:FlxCamera;
    var camItem:FlxCamera;
    var camFollow:FlxObject;

    public override function create() {
        super.create();

        FlxG.mouse.visible = true;

        camItem = new FlxCamera();
        camBG = new FlxCamera();
        FlxG.cameras.add(camBG);
        FlxG.cameras.add(camItem, false);
        camItem.bgColor.alpha =0;
        camFollow = new FlxObject();
        camFollow.x = (FlxG.width * 0.5);

        bg =  new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
        bg.alpha = 0.6;
        bg.screenCenter(X);
        add(bg);

        searchInput = new FlxInputText(0, 0, 200, "Search Here", 12);
        searchInput.callback = onInput;
        add(searchInput);
        searchInput.x = FlxG.width - (searchInput.width + 5);
        searchInput.focusGained = function() blockInput = true;
        searchInput.focusLost = function() blockInput = false;

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);
        grpOptions.cameras = [camItem];

        for (string in items)
        {
            var text:Alphabet = new Alphabet(20, 150 * grpOptions.length, string, true);
            if (grpOptions.length > 0)
                text.alpha = 0.6;

            grpOptions.add(text);
        }
        camItem.follow(camFollow, LOCKON, 0.06);
        var timer:FlxTimer = new FlxTimer().start(0.2, function(tmr:FlxTimer) {
            blockEnter = false;
            blockInput = false;
        });
    }

    function onInput(string:String, enter:String):Void
    {
        if (enter == 'enter')
        {
            searchInput.hasFocus = false;
            blockInput = false;
            blockEnter = false;
            return;
        }
        for (i in 0...grpOptions.length)
        {
            //grpOptions.members[i].destroy();
            grpOptions.remove(grpOptions.members[i], true);
        }

        for (item in baseItems)
        {
            if (item.startsWith(string))
            {
                var text:Alphabet = new Alphabet(20, 150 * grpOptions.length, item, true);
                if (grpOptions.length > 0)
                    text.alpha = 0.6;

                grpOptions.add(text);
            }
        }

        if (grpOptions.members.length == 0)
        {
            var text:Alphabet = new Alphabet(20, 150, "No Results Found!", true);
            grpOptions.add(text);
            blockEnter = true;
        }
        else
        {
            blockEnter = false;
        }
        curSelected = 0;
        changeSelection();
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (!blockInput)
        {
            if (!blockEnter)
            {
                if (controls.ACCEPT)
                {
                    doCallback(items[curSelected]);
                }
            }
            if (controls.UI_DOWN_P)
            {
                changeSelection(1);
            }
            if(controls.UI_UP_P)
            {
                changeSelection(-1);
            }
            if (controls.BACK)
            {
                close();
            }
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected > grpOptions.members.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = grpOptions.members.length - 1;

        for (i in 0...grpOptions.members.length)
        {
            if (curSelected != i)
            {
                grpOptions.members[i].alpha = 0.6;
            }
            else
            {
                grpOptions.members[i].alpha = 1;
            }

        }
            camFollow.y = grpOptions.members[curSelected].y;
    }

    public override function destroy() {
        super.destroy();

        FlxG.cameras.remove(camItem);
        FlxG.cameras.remove(camBG);
        FlxG.mouse.visible = false;
    }

    public static function doCallback(string:String):Void
    {
        callback(string);
    }
}