package lastitools;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;

class CoolBox extends LastiSprite {
  public var curAnim:String = null;
  public var imSelectring:Bool = false;
  public var im:String = '';
  public function new(?x:Float = 0,?y:Float = 0) {
    super(x,y);
    frames = FlxAtlasFrames.fromSparrow('assets/images/options/checkboxThingie.png', 'assets/images/options/checkboxThingie.xml');

    addAnim('idle-unselected', 'Check Box unselected', true, 24, [0,0]);
    addAnim('idle-selected', 'Check Box Selected Static', true, 24, [0,0]);
    addIAnim('selecting', 'Check Box selecting animation', [0,1,2,3,4,5,6,7,8,9,10], false, 24, [0,0]);
    addIAnim('unselecting', 'Check Box selecting animation', [10,9,8,7,6,5,4,3,2,1,0], false, 24, [0,0]); 
    changeState('idle');  
  }
  public function changeState(comanmeunwebo:String){
    var end:String = '';
    var start:String = '';
    if(imSelectring) {
      switch(comanmeunwebo){
        case 'idle':
          start = '';
          end = '-selected';
        case 'sel':
          start = '';
          end = '';
      } 
    } else {
      switch(comanmeunwebo){
        case 'idle':
          start = '';
          end = '-unselected';
        case 'sel':
          start = 'un';
          end = '';
      } 
    }
    var finalS:String = start + comanmeunwebo + end;
    curAnim = finalS;
    playAnim(finalS);
  }
  override function update(e:Float){
    super.update(e);
  
  }
}
class LastiSprite extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;
		public var tex:FlxAtlasFrames;
    public var sprTracker:FlxSprite;
  public function new(?x:Float = 0, ?y:Float = 0){
    super(x,y);
		animOffsets = new Map<String, Array<Dynamic>>();
    antialiasing = true;

  }
  override function update(e:Float){
    super.update(e);
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
  }
  public function addIAnim(n:String, na:String, i:Array<Int>, ?l:Bool = false, ?f:Int = 24, ?a:Array<Float>){
    if(a == null){
      a.push(0);
      a.push(0);
    }
    animation.addByIndices(n,na, i,"",f,l);

    addOffset(n, a[0], a[1]);

  }
  public function addAnim(n:String, na:String, ?l:Bool = false, ?f:Int = 24, ?a:Array<Float>){
    if(a == null){
      a.push(0);
      a.push(0);
    }
    animation.addByPrefix(n,na,f,l);
    addOffset(n, a[0], a[1]);

  }
  public function addOffset(name:String, x:Float = 0, y:Float = 0)
    {
      animOffsets[name] = [x, y];
    }
  public function playAnim(AnimName:String, ?Force:Bool = false, ?Reversed:Bool = false, ?Frame:Int = 0):Void
    {
      if (animexists(AnimName)) {
      animation.play(AnimName, Force, Reversed, Frame);
  
  
      var daOffset = animOffsets.get(AnimName);
      if (animOffsets.exists(AnimName))
      {
        offset.set(daOffset[0], daOffset[1]);
      }
      else
        offset.set(0, 0);
      }
    }
  public function animexists(s:String) {
		return (animation.getByName(s) != null ? true : false);
	}
}