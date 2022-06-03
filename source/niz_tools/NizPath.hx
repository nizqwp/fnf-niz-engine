package niz_tools;

import openfl.events.VideoTextureEvent;
import openfl.display3D.textures.VideoTexture;
import openfl.media.Video;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem as Assets;
using StringTools;
class NizPath {
  static inline var sx:String = #if web '.mp3' #else '.ogg'#end;

   static inline function setPath(key:String){
    if (Assets.exists('assets/$key'))
      return 'assets/$key';
    // if (Assets.exists('assets/week${PlayState.storyWeek}/$key')) when eliminas mamadas
    //   return 'assets/week${PlayState.storyWeek}/$key';

    if (Assets.exists(key))
      return key;
    else
      if (key.endsWith('.png'))
        return 'missingTexture.png';
      else if (key.endsWith(sx) || key.endsWith('.wav'))
        return 'missingSound.ogg';
      else
        return 'missingPath';
  }
  static inline function setSoundPath(key:String){
    var finalReturn:String = '';
    if (Assets.exists(setPath('sounds/$key$sx')) || Assets.exists(setPath('sounds/$key.wav')))
      {
        var ext = sx;
        if (Assets.exists(setPath('sounds/$key.wav')))
          ext = '.wav';

        finalReturn = setPath('sounds/$key$ext');
      } else if (Assets.exists(setPath('music/$key$sx')) || Assets.exists(setPath('music/$key.wav')))
      {
        var ext = sx;
        if (Assets.exists(setPath('music/$key.wav')))
          ext = '.wav';
        finalReturn = setPath('music/$key$ext');
      } else {
        finalReturn ='missingSound.ogg';
      }
      return finalReturn;
  }
  public static inline function getVideo(o:String){
    return 'assets/videos/$o.mp4'; // no pude hacer algo ricolino :,v
    /*
    this.currentDisplayVideo = o;
    var returnedData:Dynamic;
    var video = openfl.Video.fromFile('assets/videos/$o.mp4');
    if (video == null)
      returnedData = new FlxSprite().makeGraphic;
    else
      returnedData = video;

    if (this != NizPath){
      try {
        video = Video.fromFile(getText('assets/videos/$o.mp4'));
        returnedData = video;
      } catch() {
      returnedData = new FlxSprite().makeGraphic;
      }
    }
      return returnedData;
    */
  }
  public static inline function getSoud(path:String)
    return Sound.fromFile(setSoundPath(path));
  public static inline function getInst(song){
    song = song.toLowerCase();
    return Sound.fromFile(setPath('songs/$song/Inst$sx'));
  }
  public static inline function getVoi(song){
    song = song.toLowerCase();
    return Sound.fromFile(setPath('songs/$song/Voices$sx'));
  }
  public static inline function getImage(path)
    return BitmapData.fromFile(setPath(path));
  
  // static inline function tryPutExt(){ if}
}