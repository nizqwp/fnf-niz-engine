package notevenmod;

import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
class Sprite extends FlxSprite {
  public var spritePath:String;
  public var name:String;

  public function createGraphic(isGraphic:Bool = true, ?data:Dynamic, ?width_:Float, ?height_:Float){
    var is_:String = '';

    if (data is String) is_ = 'string';
    else if (data is FlxColor)is_ = 'color';
    else if (data is Array<Int>) is_ = 'rgb_color';
    else is_ = 'null';

    if (is_ != null && is_ != 'null'){
      if (isGraphic){
        var color:FlxColor;
        switch (is_){
          case 'string': color = FlxColor.fromString(data);
          case 'color': color = data;
          case 'rgb_color': color = FlxColor.fromRGB(data[0],data[1],data[2]);
        }
        makeGraphic(Std.int(width_),Std.int(height_),color);
        name = Std.string(this);

      }
    }
    
  }
}
class SpriteGroup extends FlxSpriteGroup {
  public var spritesNames:Array<String>;
  public function new() {
    super();
  }
  public function push(s:Dynamic){
    add(s);
    spritesNames.push(Std.string(s));
  }
}