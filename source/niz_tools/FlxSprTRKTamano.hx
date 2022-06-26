package lastitools;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import flixel.FlxObject;
import flixel.FlxSprite;

class FlxSprTRKTamano {
  public static function gettamanoFromIMG(owo) {
    var w = BitmapData.fromFile('assets/images/' + owo + '.png');
    var s = new FlxSprite().loadGraphic(cast w);
    return gettamano(s);
  }

  public static function gettamano(da:FlxSprite) {
    da.updateHitbox();
    return [da.width,da.height];
  }
}