package;

import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;
typedef DialogueJson = {
  
  var dialogues:Array<Dialogue_ANIM>;
  var speechBubble:String;
}
typedef CharAnims = {
  var visible:Bool;
  var animation:String;
  var name:String;
}
typedef Dialogue_ANIM = {
  var content:String;
  var leftChar:CharAnims;
  var rightChar:CharAnims;
  var payAttentionTo:Dynamic; // true = dad, false = bf, bf = bf, dad = dad, gf = gf
}
typedef Anim = {
  var AnimName:String;
  var AnimPrefix:String; 
  var FrameRate:Int; 
  var Looped:Bool;
  var flipX:Bool;
  var flipY:Bool;
  var offsets:Array<Float>;
  var speechBubbleAnim:String;
}
typedef Char_JSON = {
  var flipX:Bool;
  var flipY:Bool;
  var soundPath:String;
  var name:String; // unused shit;
  var animations:Array<Anim>;
  var path:String;
  var position:Array<Float>;

}
class DialogueCharacter extends FlxSprite  {
  public var name:String;
	public var animOffsets:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();

  public function new (charname:String = 'bf'){
    name = charname;
    super();

    var existsFile:Bool = #if windows sys.FileSystem.exists('assets/data/dialogueChars/$charname.json') #else false #end;
    if (existsFile){
      // redo!
    } else {
      switch(name){
        default:
        frames = Paths.getSparrowAtlas('dialogue/bf_assets','shared');
        animation.addByPrefix('idle', 'bf-idle');
        x = 500;
        y = 80;
      }
    }

  }
  public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
    {
      animation.play(AnimName, Force, Reversed, Frame);
  
      var daOffset = animOffsets.get(AnimName);
      if (animOffsets.exists(AnimName))
      {
        offset.set(daOffset[0], daOffset[1]);
      }
      else
        offset.set(0, 0);
    }
  
    public function addOffset(name:String, x:Float = 0, y:Float = 0)
    {
      animOffsets[name] = [x, y];
    }
}
class SpeechBubble extends FlxSprite {
  public var name:String;
	public var animOffsets:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();

  public function new (y:Float,?charname:String = 'bf'){
    name = charname;
    super(0,y);

    var existsFile:Bool = #if sys sys.FileSystem.exists('assets/data/dialogueSpeechBubble/$charname.json') #else false #end;
    if (existsFile){
      // redo!
    } else {
      var tex = Paths.getSparrowAtlas('speech_bubble_talking','shared');
      frames = tex;
      animation.addByPrefix('open','Speech Bubble Normal Open');
      animation.addByPrefix('idle','speech bubble normal'); 

    }
    screenCenter(X);

  }
  public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
    {
      animation.play(AnimName, Force, Reversed, Frame);
  
      var daOffset = animOffsets.get(AnimName);
      if (animOffsets.exists(AnimName))
      {
        offset.set(daOffset[0], daOffset[1]);
      }
      else
        offset.set(0, 0);
    }
  
    public function addOffset(name:String, x:Float = 0, y:Float = 0)
    {
      animOffsets[name] = [x, y];
    }
}
class Dialogue extends FlxSpriteGroup {
  public var curDia:Int = -1;
  public var dialogue:DialogueJson = null;
  var dia:Dialogue_ANIM = null;
  public var speechBubble:SpeechBubble;
  public var left_char:DialogueCharacter;
  public var right_char:DialogueCharacter;
  public var vinieta:FlxSprite;
  var dialogueShit:FlxTypeText;
  var docseoTEXT:FlxTypeText = new FlxTypeText(10,10,400,'',30);

  public static var onComplete:Void->Void;
  public function new (int:DialogueJson, ?camera:FlxCamera, xd:Void->Void){
    super();

    onComplete = xd;
    camera.alpha = 1;

    cameras = [camera];
    dialogue = int;
    
    vinieta = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
    vinieta.screenCenter();
    vinieta.alpha = 0;
    add(vinieta);
    speechBubble = new SpeechBubble(290,'oooooo');
    add(speechBubble);
    
    docseoTEXT.font = 'assets/fonts/vcr.ttf';
		docseoTEXT.color = FlxColor.fromRGB(200,200,200,255)/*initial color*/;
		add(docseoTEXT);
		dialogueShit = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		dialogueShit.font = 'assets/fonts/vcr.ttf';
		dialogueShit.color = FlxColor.fromRGB(0,0,0,255)/*initial color*/;
		dialogueShit.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(dialogueShit);
    next();
  }
var enD:Bool = false;
  public function skip():Void {
    onComplete();
    enD = true;

    FlxTween.tween(dialogueShit, {alpha: 0}, 1);
    FlxTween.tween(left_char, {alpha: 0}, 1);
    FlxTween.tween(right_char, {alpha: 0}, 1);
    FlxTween.tween(speechBubble, {alpha: 0}, 1);

    FlxTween.tween(vinieta, {alpha: 0}, 1,{onComplete: function (_){
      kill();
    }});

  }
  public function next():Void {
    curDia++;
    
    if (curDia >= dialogue.dialogues.length){
      curDia = dialogue.dialogues.length - 1;
      skip();
      return;
    }
    dia = dialogue.dialogues[curDia];
    if (left_char != null)
      left_char.kill();
        if (right_char != null)
      right_char.kill();
  
      left_char = new DialogueCharacter(dia.leftChar.name);
      left_char.visible = dia.leftChar.visible;
      left_char.playAnim(dia.leftChar.animation);
  
      right_char = new DialogueCharacter(dia.rightChar.name);
      right_char.visible = dia.rightChar.visible;
      right_char.playAnim(dia.rightChar.animation);
      switch(dia.payAttentionTo){
        case 'bf',true,0:
          left_char.alpha = 0.8;
          right_char.alpha = 1;
        case 'dad',false,1:
          left_char.alpha = 1;
          right_char.alpha = 0.8;
      }
      if (FlxG.random.bool(50))
      dia.content = 'Hello world. testttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttt';
      else
        dia.content = 'Goodbye world. testttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttttestttttttttttttttttttttttttttttttttt';
      dialogueShit.resetText(dia.content);
      dialogueShit.start(0.04, true);
  }
  var docseo:Bool = false;
 override function update(elapsed:Float){
    if (vinieta.alpha <= 0.6)
      vinieta.alpha += 0.1 * elapsed;
    else
      vinieta.alpha = 0.6;

    if (speechBubble != null && speechBubble.animation.curAnim != null){
      if (speechBubble.animation.curAnim.name == 'open' && speechBubble.animation.curAnim.finished) {
        speechBubble.playAnim('idle');
      }
    }
    super.update(elapsed);
    if (FlxG.keys.justPressed.ENTER && !enD)
      next();
    if (FlxG.keys.justPressed.SPACE && !enD)
      skip();
    if (FlxG.keys.justPressed.D && !docseo && #if debug true #else false #end) {
      trace('docseo = allow');
      docseo = true;
    }
    if (docseo)
      docseoTEXT.text = haxe.Json.stringify(dia,null,'').replace('{', '<').replace('}','>');
  }

}