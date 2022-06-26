package lastitools ;

import openfl.media.Sound;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.Font;
import cpp.NativeFile;
import openfl.display.BitmapData;
import flixel.system.FlxAssets;
import flixel.graphics.frames.FlxAtlasFrames;
import sys.io.File;
import sys.FileSystem;
import openfl.utils.Assets as OpenFlASs;
import haxe.Json;
import flixel.FlxG;
class Get {
  inline public static var ext:String = #if web 'mp3' #else 'ogg' #end;

	inline static public function file(key:String, isOlo:Bool = false){
		trace('getting file from: mods/' + (isOlo ? '' : 'assets/')  + key);
	FlxG.log.add('[nul util data]: getting file from: mods/' + key);
		return 'mods/' + (isOlo ? '' : 'assets/') + key;
	}
	inline static public function txt(key:String, ?s:Bool = false) {
		if (lastitools.Util.exists(file(key, s)))
			return NativeFile.file_contents_string(file(key,s));
		else
			return null;
	}
	inline static public function font(key:String = ''){
		if (lastitools.Util.exists(file('fonts/$key')))
			return Font.fromFile(file('fonts/$key'));
		else
			return null;
	}
	inline static public function image(key:String):flixel.system.FlxGraphicAsset
	{
		if (lastitools.Util.exists(file('images/$key.png')))
			return BitmapData.fromFile(file('images/$key.png'));
		else
			return null;
	}
	inline static function sn(key:String = ''){
		if (lastitools.Util.exists(file('$key.$ext')))
			return Sound.fromFile(file('$key.$ext'));
		else
			return null;
	}

	inline static public function sound(key:String = '')
		return sn('sounds/$key');
	inline static public function music(key:String = '')
		return sn('music/$key');
	inline static public function song(key:String, s:String)
		return sn('songs/${key.toLowerCase()}/${s}.$ext');
	inline static public function fileTXT(key:String)
		return txt(key, true);
	inline static public function xml(key:String)
		return txt('images/$key.xml');
	inline static public function json(key:String)
		return txt('data/$key.json');
	inline static public function data(key:String)
		return txt('data/$key');
	inline static public function sparrow(key:String)
		return FlxAtlasFrames.fromSparrow(image(key), xml(key));
}