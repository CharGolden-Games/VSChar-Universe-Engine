package vschar;

#if !macro
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import FunkinLua.ModchartSprite;
import vschar.backend.ExtendedMeta;
import vschar.backend.Constants;
import vschar.objects.ScriptedCharacter;

using StringTools;
using ue.backend.ExtendedStringTools;
#end