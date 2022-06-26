package lastitools;

import flixel.util.FlxColor;
class FlxNewColor {
/*
  public function changeColor(type:String, DATA:Dynamic) {
    var sexo:FlxColor;
    switch (type) {
      case 'fromRGB': sexo = FlxColor.fromRGB(DATA[0],DATA[1],DATA[2],255); trace(DATA);
    }
    return sexo;
  }*/
  public static function x(type:Array<Int>) {
    return FlxColor.fromRGB(type[0], type[1], type[2], 255);
  }
}