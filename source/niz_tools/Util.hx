package niz_tools;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import sys.io.FileOutput;
import sys.FileStat;
import openfl.net.FileReference;
import sys.io.FileSeek;
import openfl.net.FileFilter;
import hscript.Expr.FieldAccess;
import haxe.display.Protocol.FileParams;
import sys.io.FileInput;
import sys.io.File;
import flixel.FlxG;
import lime.utils.Assets;
#if desktop
import sys.FileSystem;
#end

class Util {
  public static function setMyFormat(s:FlxText = null) {
    s.setFormat('assets/fonts/PMel.ttf', 50, FlxColor.BLACK, CENTER);
    s.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 2, 4);
  }
  public static var con:Map<String, Dynamic> = new Map<String, Dynamic>();
  public static var recentLog:Array<Dynamic> = ['Log del día ' + Date.now().getDay()];
  public static var x:Array<String> = ['easy', 'normal', 'hard'];
  public static var day:Array<String> = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
  public static function setDay(){
    return day[Date.now().getDay()];
  }
  public static function genCalled(data:Dynamic){
    var path = 'mods/crash/called-'  + Date.now().getDay() + 1 + '-' + Date.now().getHours() +  '.txt';
    FileSystem.createDirectory('mods/crash');
      File.saveContent(path, data);
  }
  public static function genLog(){
    var path = 'mods/crash/log-'  + Date.now().getDay() + 1 + '-' + Date.now().getHours() +  '.txt';
    FileSystem.createDirectory('mods/crash');
    if(FileSystem.exists(path)){
      new FlxTimer().start(1,function (s:FlxTimer){
        File.saveContent(path, arraytostring(recentLog));
      });
    } else {
      File.saveContent(path, arraytostring(recentLog));
    }
  }
  public static function arraytostring(data:Array<Dynamic>){
    var s = '';
    for (i in data){
      s += i + '\n';
    }
    return s;
  }
  public static function pushLog(data:Dynamic){
    recentLog.push(data +'    ' + Date.now().getHours() +':'+ Date.now().getMinutes() +':' + Date.now().getSeconds());
    genLog();
  }
  public static function load():Void
    {
      if (FlxG.save.data.con != null)
      {
        con = FlxG.save.data.con;
      }
    }
    public static function copy()
      {
        return con;
      }
    static function setCon(song:String, value:Dynamic):Void
      {
        // Reminder that I don't need to format this song, it should come formatted!
        con.set(song, value);
        FlxG.save.data.con = con;
        FlxG.save.flush();
      }
    public static function getCon(op:String):Dynamic
      {
        if (!con.exists(op))
          setCon(op, null);

        return con.get(op);
      }
    /* es lo contrario a existir, ejemplo: si existe la sprite, 
		* dirá que es false, en caso contrario dirá que es true, 
		* ¿Por qué?, es para en casos de evitar el crash que hará el juego lo posible para no hacerlo.
    */
  public static function doNoExists(x:String) {
    if(Util.exists(x)) {
      return false;
    } else {
      return true;
    }
  }
  /*
  * es solo para definir en los mods si existe y en assets de lime
  * xd
  */
  public static function exists(x:String):Bool{
    if(Assets.exists(x)){
      return true;
    } 
    else {
      #if desktop
      if(FileSystem.exists('mods/'+ x)){
        return true;
      } else {
      return false;
      }
      #else 
        return false;
      #end
    }
  }
  public static function returnSong(s:String, ?d:Int = 1) {
    return s + (d != 1 ? '-' + x[d].toLowerCase() : '');
  }
}