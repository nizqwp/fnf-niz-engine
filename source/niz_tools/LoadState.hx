package niz_tools;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxState;
import niz_tools.*;

class LoadState extends MusicBeatState {
  var onCompleteSwitch:FlxState;
  var stopMusic:Bool;
  var loaded:Int = 1;
  var maxToLoad:Int = 0;
  public function new(onCompleteSwitch:FlxState, ?stopMusic:Bool){
   super();
   this.onCompleteSwitch = onCompleteSwitch;
   this.stopMusic = stopMusic;
 }
  override function create(){
    super.create();

    PlayState.inst = new Music();
    PlayState.voices = new Music();
     if (PlayState.SONG != null) {
       FlxG.autoPause = true;
       trace('trying load song ');
       maxToLoad += 1;
       var song = PlayState.SONG;
    new Trace('loading ${song.song.toLowerCase()}.Inst - songs:assets/songs/${song.song.toLowerCase()}/Inst.ogg');
    loaded++;
         PlayState.inst.loadSong('songs:assets/songs/${song.song.toLowerCase()}/Inst.ogg');
       if (song.needsVoices){
       maxToLoad += 1;

    new Trace('loading ${song.song.toLowerCase()}.Voices - songs:assets/songs/${song.song.toLowerCase()}/Voices.ogg');
    loaded++;
         PlayState.voices.loadSong('songs:assets/songs/${song.song.toLowerCase()}/Voices.ogg');
        }
LoadingState.loadAndSwitchState(onCompleteSwitch,stopMusic);

      } else {
    FlxG.switchState(onCompleteSwitch);

      }
    
  }
  override function update(e:Float){
    super.update(e);
    if (FlxG.keys.justPressed.S){
      loaded = maxToLoad;
    }
    if (loaded == maxToLoad){
      // loaded = 0;
LoadingState.loadAndSwitchState(onCompleteSwitch,stopMusic);
    // FlxG.switchState(onCompleteSwitch);
    // break;
    // return;

    }
  }

  public static function load(onCompleteSwitch:FlxState, ?stopMusic:Bool){
    new Trace('trying load');
    FlxG.switchState(new LoadState(onCompleteSwitch,stopMusic));
  }
}