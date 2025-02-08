package options.vschar;

class EngineSubstate extends BaseOptionsMenu {
    public function new() {
        title = 'Char Engine Settings';
		rpcTitle = 'Char Engine Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Do Rotation Bop', //Name
			'If checked, allows the screen to rotate onBeatHit', //Description
			'rotBop', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		super();
    }
}