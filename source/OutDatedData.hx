package;

import niz_tools.Lang;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
using StringTools;
typedef GitData = {
	var nameVer:String;
	var theVer:String;
	var changes:String;
}
class OutDatedData
{
	public static var desc:String = '';
	public static var isOldVer:Bool = false;
	static var gitdata:GitData = null;
	public static function getTitle(){
		var turn:String;
		if (gitdata.nameVer != null)
			turn = gitdata.nameVer;
		else
			turn = gitdata.theVer;
		return turn;
	}
	public static function getChanges(){
		var turn:String = '';
		if (gitdata.nameVer != null)
			turn = gitdata.changes;
		return turn;
	}
	public static function check():Void {
		var http = new haxe.Http("https://raw.githubusercontent.com/nizako/fnf-niz-engine/main/update.dat?token=GHSAT0AAAAAABVHLUMFQ4RTT7WW6UJNPO4CYVP3XRQ");

		http.onData = function(data:String)
		{
			trace(data);

			gitdata = cast haxe.Json.parse(data);
			trace(gitdata);
			isOldVer = !Main.verE.contains(gitdata.theVer);
		}

		http.onError = function(error)
		{
			trace('error: $error');
		}

		http.request();
		desc = Lang.getTr(5);

	}
}
