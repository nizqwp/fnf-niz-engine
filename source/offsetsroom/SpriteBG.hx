package #if niz offsetsroom #end;

import flixel.*;
class SpriteBG extends flixel.group.FlxSpriteGroup {
  // override function create(){
  //   super.create();
  // }
  public function new(sprite:String){
    super();

    for (i in 0...5) /* screen*/{
      var yea = new FlxSprite().loadGraphic(sprite);
      yea.x = i * FlxG.width;
      yea.y = i * FlxG.height;
      // yea.
      yea.setGraphicSize(FlxG.width,FlxG.height);
      yea.ID = i;
      add(yea);
    }
  }
  override function update(elapsed){
    super.update(elapsed);
    this.forEach(function (ola:FlxSprite) {
      ola.x += FlxG.elapsed;
      ola.y -= FlxG.elapsed;
      if (ola.y <= FlxG.width && ola.x >= FlxG.height){
        ola.x = ola.ID * FlxG.width;
        ola.y = ola.ID * FlxG.height;
      }

    });

  }
}