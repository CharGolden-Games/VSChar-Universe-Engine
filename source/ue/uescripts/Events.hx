package ue.uescripts;

class Events {
    public static function onEvent(name:String, value1:String, value2:String)
    {
        switch (name)
        {
            case 'fuckyou :3':
                trace('DIE');
        }
    }
}