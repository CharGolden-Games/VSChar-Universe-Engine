package vschar.backend;

import FreeplayState.SongMetadata as FSongMetadata;

class SongMetadata extends FSongMetadata
{
    /**
     * Specifies the song art to use, if nothing is specified, will use the song name.
     */
    public var songArt:String = '';

    public function new(song:String, week:Int, songCharacter:String, color:Int, songArt:String)
    {
        super(song, week, songCharacter, color);
        this.songArt = songArt;
        if (songArt == '')
            this.songArt = song;
    }
}

class Constants {
    public static var vschar_songs:Array<String> = [
        'saloon-troubles',
        'conflicting-views',
        'ambush',
        'obligatory-bonus-song',
        'origins',
        'high-ground',
        'beat-battle', // To be removed, but it's in the folder so yknow.
        'blubber',
        'triple-trouble',
        'junkyard'
    ];
    
    public static var vscharLegacy_songs:Array<String> = [
        'high-ground-old',
        'too-slow',
        'you-cant-run',
        'triple-trouble-old',
        'endless',
        'iason-mason',
        'vesania',
        'shenanigans'
    ];

    public static var songMetadata:Map<String, Array<SongMetadata>> = [
        'VS Char' => [
            new SongMetadata('saloon-troubles', 0, 'anny', 0xFF8800FF, 'saloonWeek'),
            new SongMetadata('conflicting-views', 0, 'anny', 0xFF8800FF, 'saloonWeek'),
            new SongMetadata('ambush', 0, 'igni', 0xFF474753, 'saloonWeek'),

            new SongMetadata('obligatory-bonus-song', 1, 'char', 0xFFFF8800, 'bonus'),

            new SongMetadata('origins', 2, 'igni', 0xFF474753, 'bonus'),

            new SongMetadata('triple-trouble', 3, 'char', 0xFFFF8800, 'exe'),
            new SongMetadata('paranoia', 4, 'micheal-virtual', 0xFF880000, '')
        ],
        'Legacy Content' => [
            new SongMetadata('too-slow', 0, 'char-old', 0xFFFF8800, 'exe'),
            new SongMetadata('you-cant-run', 0, 'char-old', 0xFFFF8800, 'exe'),
            new SongMetadata('triple-trouble-old', 0, 'char-old', 0xFFFF8800, 'exe'),

            new SongMetadata('endless', 1, 'char-old', 0xFFFF8800, ''),

            new SongMetadata('iason-mason', 2, 'char-neg', 0xFFFF8800, ''),

            new SongMetadata('vesania', 3, 'char-retro-old', 0xFFFF8800, ''),

            new SongMetadata('shenanigans', 4, 'char-old', 0xFFFF8800, 'bonus')
        ],
        'Base Game' => [
            new SongMetadata('tutorial', 0, 'gf', 0xFFA5004D, 'volume1'),

            new SongMetadata('bopeebo', 1, 'dad', 0xFFAF66CE, 'volume1'),
            new SongMetadata('fresh', 1, 'dad', 0xFFAF66CE, 'volume1'),
            new SongMetadata('dad-battle', 1, 'dad', 0xFFAF66CE, 'volume1'),

            new SongMetadata('spookeez', 2, 'spooky', 0xFFD57E00, 'volume1'),
            new SongMetadata('south', 2, 'spooky', 0xFFD57E00, 'volume1'),

            new SongMetadata('pico', 3, 'pico', 0xFFB7D855, 'volume1'),
            new SongMetadata('philly-nice', 3, 'pico', 0xFFB7D855, 'volume1'),
            new SongMetadata('blammed', 3, 'pico', 0xFFB7D855, 'volume1'),

            new SongMetadata('satin-panties', 4, 'mom', 0xFFD8558E, 'volume1'),
            new SongMetadata('high', 4, 'mom', 0xFFD8558E, 'volume1'),
            new SongMetadata('milf', 4, 'mom', 0xFFD8558E, 'volume1'),
            
            new SongMetadata('cocoa', 5, 'parents', 0xFFAF66CE, 'volume1'),
            new SongMetadata('eggnog', 5, 'parents', 0xFFAF66CE, 'volume1'),
            new SongMetadata('winter-horrorland', 5, 'monster', 0xFFF3FF6E, 'volume1'),
            
            new SongMetadata('senpai', 6, 'senpai-pixel', 0xFFFFAA6F, 'volume2'),
            new SongMetadata('roses', 6, 'senpai-pixel', 0xFFFFAA6F, 'volume2'),
            new SongMetadata('thorns', 6, 'spirit-pixel', 0xFFFF3C6E, 'volume2'),

            new SongMetadata('ugh', 7, 'tankman', 0xFFFFFFFF, 'volume2'),
            new SongMetadata('guns', 7, 'tankman', 0xFFFFFFFF, 'volume2'),
            new SongMetadata('stress', 7, 'tankman', 0xFFFFFFFF, 'volume2')
        ],
        'Erect Songs' => [
            new SongMetadata('bopeebo', 0, 'dad', 0xFFAF66CE, 'volume3'),
            new SongMetadata('fresh', 0, 'dad', 0xFFAF66CE, 'volume3'),
            new SongMetadata('dad-battle', 0, 'dad', 0xFFAF66CE, 'volume3'),

            new SongMetadata('spookeez', 1, 'spooky', 0xFFD57E00, 'volume3'),
            new SongMetadata('south', 1, 'spooky', 0xFFD57E00, 'volume3'),

            new SongMetadata('pico', 2, 'pico', 0xFFB7D855, 'volume3'),
            new SongMetadata('philly-nice', 2, 'pico', 0xFFB7D855, 'volume3'),
            new SongMetadata('blammed', 2, 'pico', 0xFFB7D855, 'volume3'),

            new SongMetadata('satin-panties', 3, 'mom', 0xFFD8558E, 'expansion1'),
            new SongMetadata('high', 3, 'mom', 0xFFD8558E, 'volume3'),
            
            new SongMetadata('cocoa', 4, 'parents', 0xFFAF66CE, 'expansion2'),
            new SongMetadata('eggnog', 4, 'parents', 0xFFAF66CE, 'expansion1'),
            
            new SongMetadata('senpai', 5, 'senpai-pixel', 0xFFFFAA6F, 'volume3'),
            new SongMetadata('roses', 5, 'senpai-pixel', 0xFFFFAA6F, 'volume3'),
            new SongMetadata('thorns', 5, 'spirit-pixel', 0xFFFF3C6E, 'volume3'),

            new SongMetadata('ugh', 6, 'tankman', 0xFFFFFFFF, 'expansion2')
        ]
    ];
}