package vschar.backend.scripting.vschar_scripts;

class UniversalTriggers extends BaseScript {
    public function new() super('Universal Triggers Event Script');

    public override function initialize() {
        super.initialize();
    }

    function getSongTriggers(song:String):String
    {
        switch(Paths.formatToSongPath(song))
        {
            case 'paranoia':
                return 'Triggers Paranoia';
        }

        return 'Universal Triggers';
    }

    /**
     * Compares 2 strings and returns a string filled with hyphens that is 2 hypens longer then the longest string
     * @param string1 
     * @param string2 
     * @return String
     */
    function textLengthToHyphens(string1:String, string2:String):String
    {
        if (string1.length > string2.length)
        {
            var finalString = '';
            for (i in 0...string1.length)
            {
                finalString += '-';
            }
            finalString += '--';
            return finalString;
        }
        else
        {
            var finalString = '';
            for (i in 0...string2.length)
            {
                finalString += '-';
            }
            finalString += '--';
            return finalString;
        }

        return '';
    }

    var songTitle:FlxText;
    var songTitleFadeIn:FlxTween;
    var songTitleFadeOut:FlxTween;

    function doSongTitle(title:String, artist:String, textColor:Int = 0xFFFFFFFF, borderColor:Int = 0xFF000000)
    {
        if (songTitleFadeIn != null)
            songTitleFadeIn.cancel();
        if (songTitleFadeOut != null)
            songTitleFadeOut.cancel();

        if (songTitle != null)
            songTitle.destroy();

        songTitle = new FlxText(0, 0, FlxG.width, '$title\n' + textLengthToHyphens(title, artist) + '\n$artist');
        songTitle.setFormat(Paths.font('funkin.ttf'), 60, textColor, CENTER, OUTLINE, borderColor);
        songTitle.borderSize = 5;
        songTitle.alpha = 0;
        songTitle.screenCenter(Y);
        songTitle.cameras = [camOther];
        add(songTitle);

        songTitleFadeIn = FlxTween.tween(songTitle, {alpha: 1}, 0.5, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
            var timer:FlxTimer = new FlxTimer().start(5, function(tmr:FlxTimer){
                songTitleFadeOut = FlxTween.tween(songTitle, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) songTitle.destroy()});
            });
        }});
    }

    public override function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
        super.onEvent(name, value1, value2, strumTime);
		var flValue1:Null<Float> = Std.parseFloat(value1);
		var flValue2:Null<Float> = Std.parseFloat(value2);
		if(Math.isNaN(flValue1)) flValue1 = null;
		if(Math.isNaN(flValue2)) flValue2 = null;

        if (name == 'Song Triggers')
        {
            switch (getSongTriggers(songName))
            {
                case 'Triggers Paranoia':
                    switch (flValue1)
                    {
                        case 0:
                            doSongTitle('Paranoia', 'Sandi (Ft. KennyL)', 0xFFFF0000, 0xFF220000);
                    }
            }
        }
    }
}