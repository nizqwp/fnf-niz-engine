package niz_tools;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;


class NizState extends FlxGroup {
  public var keys:Dynamic;
  
  public function new(){
    create();
    super();
  }
  public function create() {
  // create();

  }

  override public function update (elapsedTime:Float){
    super.update(elapsedTime);
    keys =  FlxG.keys;


  }
}