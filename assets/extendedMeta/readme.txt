Char Engine Extended Meta Feature Documentation:

___________________________________ modVersion.txt: ___________________________________

Replace the text in modVersion.txt with your mod's name and it's version seperated by "|"
(i.e. 'VS Char Revitalized!|0.1.5b - DevBuild')

______________________________________ title.txt: ______________________________________

Change the text in title.txt to set a custom title!

Specific text modifiers

	Version strings:
		"{modVersion}": Uses the version from modVersion.txt
		"{vsCharVersion}": (Specific to VS Char) uses the vsCharVersion meta variable. [REMOVE THIS FROM DOCUMENTATION FOR ENGINE ONLY RELEASE.]
		"{engineVersion_UE}": The version of UE used
		"{engineVersion_Psych}": The version of Psych Engine used
		"{engineVersion_Char}": The version of Char Engine used
	
	Song strings:
		"{curSong}": Gets replaced with the current song being played (i.e the title "Friday Night Funkin' {curSong}" becomes "Friday Night Funkin' | Stress")
		"{curArtist}": Gets replaced with the current song's artist (if the song has an artist specified)
		"{curAssetArtist}": Gets replaced with the current song's asset artist (if the song has an artist specified)