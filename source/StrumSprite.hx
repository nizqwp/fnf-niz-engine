package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

using StringTools;

class StrumSprite extends FlxSpriteGroup {
  var midSuma:Float = 280;
  public function new(lineY:Float,?player:Int){
    super();

    midSuma =  player == 1 ? 280 : 360;
    for (i in 0...4)
      {
        // FlxG.log.add(i);
        var babyArrow:FlxSprite = new FlxSprite(0, lineY);
    
        switch (PlayState.curStage)
        {
          case 'school' | 'schoolEvil':
            babyArrow.loadGraphic(Paths.image('UI/pixelUI/arrows-pixels'), true, 17, 17);
            babyArrow.animation.add('green', [6]);
            babyArrow.animation.add('red', [7]);
            babyArrow.animation.add('blue', [5]);
            babyArrow.animation.add('purplel', [4]);
  
            babyArrow.setGraphicSize(Std.int(babyArrow.width * PlayState.daPixelZoom));
            babyArrow.updateHitbox();
            babyArrow.antialiasing = false;
  
            switch (Math.abs(i))
            {
              case 0:
                babyArrow.x += Note.swagWidth * 0;
                babyArrow.animation.add('static', [0]);
                babyArrow.animation.add('pressed', [4, 8], 12, false);
                babyArrow.animation.add('confirm', [12, 16], 24, false);
              case 1:
                babyArrow.x += Note.swagWidth * 1;
                babyArrow.animation.add('static', [1]);
                babyArrow.animation.add('pressed', [5, 9], 12, false);
                babyArrow.animation.add('confirm', [13, 17], 24, false);
              case 2:
                babyArrow.x += Note.swagWidth * 2;
                babyArrow.animation.add('static', [2]);
                babyArrow.animation.add('pressed', [6, 10], 12, false);
                babyArrow.animation.add('confirm', [14, 18], 12, false);
              case 3:
                babyArrow.x += Note.swagWidth * 3;
                babyArrow.animation.add('static', [3]);
                babyArrow.animation.add('pressed', [7, 11], 12, false);
                babyArrow.animation.add('confirm', [15, 19], 24, false);
            }
  
          default:
            babyArrow.frames = Paths.getSparrowAtlas('UI/NOTE_assets');
            babyArrow.animation.addByPrefix('green', 'arrowUP');
            babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
            babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
            babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
  
            babyArrow.antialiasing = true;
            babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
  
            switch (Math.abs(i))
            {
              case 0:
                babyArrow.x += Note.swagWidth * 0;
                babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
              case 1:
                babyArrow.x += Note.swagWidth * 1;
                babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
              case 2:
                babyArrow.x += Note.swagWidth * 2;
                babyArrow.animation.addByPrefix('static', 'arrowUP');
                babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
              case 3:
                babyArrow.x += Note.swagWidth * 3;
                babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
            }
        }
  
        babyArrow.updateHitbox();
        babyArrow.scrollFactor.set();
        babyArrow.x += 50;
        babyArrow.x += ((FlxG.width / 2) * player);

        babyArrow.x += (FlxG.save.data.mid ? midSuma: 0);

        if (!PlayState.isStoryMode)
        {
          babyArrow.y -= 30;
          babyArrow.alpha = 0;
          babyArrow.x -= 30;
          FlxTween.tween(babyArrow, {x: babyArrow.x + 30,y: babyArrow.y + 30, alpha: (player != 1) ? (FlxG.save.data.mid ? 0.5 : 1) : 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
        }
  
        babyArrow.ID = i;
  
  
  
        babyArrow.animation.play('static');
  
  
        add(babyArrow);
      }
  }
  public function playAnim(){

  }
  public function move(asTween:Bool,data:Dynamic,ID:Dynamic){
    if (ID is Int){
    var spr = this.members[ID];
    if (asTween){
      FlxTween.tween(spr,{x:spr.x + data.x,y: spr.y + data.y},data.vel);
    } else {
      spr.x = data.x;
      spr.y = data.y;
    }
  } else {
    this.forEach(function (spr:FlxSprite){
      if (asTween){
        FlxTween.tween(spr,{x:spr.x + data.x,y: spr.y + data.y},data.vel);
      } else {
        spr.x = data.x;
        spr.y = data.y;
      }
    });
  }
  }
  public function getX(note:Dynamic = 0):{x:Float,y:Float,ID:Int}{
    if (note is Int){
      var spr = this.members[note];
      return {x:spr.x,y:spr.y,ID:spr.ID};
    } else {
      var spr = this.members[note.ID];
      return {x:spr.x,y:spr.y,ID:spr.ID};
    }
  
  }
  var isBot = false;
  public function press(note:Note,isBoto:Bool){
    this.forEach(function (spr:FlxSprite){
      if (note.ID == spr.ID)
        {
  
          isBot = isBoto;
          if (!isBot){
          spr.animation.play('confirm', true);
 
    
          if (spr.animation.curAnim.name == 'confirm' && !PlayState.curStage.startsWith('school'))
            {
              spr.centerOffsets();
              spr.offset.x -= 13;
              spr.offset.y -= 13;
            }
            else
              spr.centerOffsets();
        } else {
      spr.animation.play('confirm');
      if (spr.animation.curAnim.name == 'confirm' && !PlayState.curStage.startsWith('school'))
        {
          spr.centerOffsets();
          spr.offset.x -= 13;
          spr.offset.y -= 13;
        }
        else
          spr.centerOffsets();
        }
      }
    });
   
  }
  var moveDebug = false;
  override function update(seo:Float){
    super.update(seo);
    if (FlxG.keys.justPressed.U){
      moveDebug = !moveDebug;
    }
    this.forEach(function (spr:FlxSprite){

 
      if (moveDebug) {
        if (FlxG.keys.pressed.LEFT)
          spr.x -= 10;
        if (FlxG.keys.pressed.UP)
          spr.y -= 10;
        if (FlxG.keys.pressed.DOWN)
          spr.y += 10;
        if (FlxG.keys.pressed.RIGHT)
          spr.x += 10;
      }
    if (isBot ){
    if (spr.animation.curAnim.finished){

      if (spr.animation.curAnim.name == 'confirm' && !PlayState.curStage.startsWith('school'))
      {
        spr.centerOffsets();
        spr.offset.x -= 13;
        spr.offset.y -= 13;
      }
      else
        spr.centerOffsets();
      new FlxTimer().start(1,function (tmr){
        if (spr.animation.curAnim.finished){
          new FlxTimer().start( 3 / 60, function (_){
            if (spr.animation.curAnim.name == 'confirm'){
            spr.animation.play('static');
            spr.centerOffsets();

          } else {
            spr.animation.play('static');
            spr.centerOffsets();
          }
        });
      } else {
        tmr.reset();
      }

      });
    }

  }
});

  }

}