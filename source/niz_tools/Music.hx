package niz_tools;

import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.FlxG;

class MusicSTATE extends FlxState {
  var testMusic:Music;
  override function create(){
    super.create();
    testMusic = new Music();
    // testMusic.play('assets/musi')
  }
}
class Music {
  public var music:FlxSound;
  public var loadMusic:FlxSound;
  public var bpm:Int= 100;
  public var onFinish:Void->Void = null;
  public var songList:Array<String> = [];
  public var length:Float = 0;
  public var time:Float = 0;
  public var finish:Bool = true;
  public var nextBPM:Int = 100;
  public var loop:Bool = false;
  public function new(){
    music = new FlxSound();
		FlxG.sound.list.add(music);

  }
  public function loadSong(name:String, ?vol:Float = 1, ?bp:Int,?loop:Bool){
    loadMusic = FlxG.sound.load(name);
    nextBPM = bp;
    // LoadState.loaded ++;
  }
  public function checkIfMusicExists(){
      return (loadMusic != null);
    }
  public function setMusic(){
    music = loadMusic;
    trace('eso tilin');
    loadMusic = null;
    bpm = nextBPM;
    nextBPM = 100;
    pause();
    music.time = 0;
  }
  public function onComplete():Void {
    if (loop){
      music.time = 0;
    } else {
    if (onFinish != null)
      onFinish();
    
    if (songList[0] != null){
    songList.remove(songList[0]);
      play(songList[0],1);
    }
  }
  }
  public function setPlaylist(array:Array<String>){
    songList = array;
  }
  public function play(name:String, ?vol:Float = 1, ?bp:Int,?lop:Bool){
    if (checkIfMusicExists()){
      setMusic();
    } else {
      music.loadEmbedded(name);
      pause();
      music.volume = vol;
      loop = lop;
      bpm = bp;
    }
  }
  public function stop(){
    if (music != null)
      music.stop();    
  }
  public function pause(){
    if (music != null)
      music.pause();
  }
  public function resume(){
    if (music != null){
    music.play();
    }
  }
  public function update(f:Float){
    if (music != null){
    music.onComplete = onComplete;
    if (music.time < time)
      music.time = time;
    else
      time = music.time;

    length = music.length;
  }
  }
}