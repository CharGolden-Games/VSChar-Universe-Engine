package options.vschar;

class ModOptionsSubstate extends BaseOptionsMenu {
    public function new() {
        title = 'VS Char Settings';
		rpcTitle = 'VS Char Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Fake Option', //Name
			'There are no actual options here.', //Description
			'placeHolder', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		super();
    }
}