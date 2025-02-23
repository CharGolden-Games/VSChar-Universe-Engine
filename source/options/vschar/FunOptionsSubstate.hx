package options.vschar;

class FunOptionsSubstate extends BaseOptionsMenu {
    public function new() {
        title = 'Char Engine Settings';
		rpcTitle = 'Char Engine Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Sticky Notes', //Name
			'Not what you\'re thinking of, but if checked, sticks the notes to Boyfriend\'s head :D', //Description
			'stickyNotes', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		super();
    }
}