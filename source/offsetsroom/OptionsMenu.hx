package offsetsroom;

import niz_tools.Lang;
import flixel.FlxG;
import flixel.FlxSubState;
import sys.FileSystem;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;


class OptionsMenu extends MusicBeatState {
  var optionsShit:Array<String> = [];
  var resultsShit:Array<String> = [];
  public static var isLangEdit:Bool = false;

  var grpTxt = new FlxTypedGroup<Alphabet>();

  var curSelected:Int = 0;
  override function create(){
    add(grpTxt);
    super.create();
    if (isLangEdit){
      optionsShit = [Lang.getTr(1),Lang.getTr(1),Lang.getTr(1),Lang.getTr(1),Lang.getTr(1)];
    } else {
      optionsShit = ['gameplay','misc','appearance'];
    }
    for (i in 0...optionsShit.length){
      if (resultsShit[i] == null){
        resultsShit[i] = getShit('${optionsShit[curSelected]}');
      }
      var text:Alphabet = new Alphabet(0, (70 * i) + 30, '${optionsShit[curSelected]} ${resultsShit[curSelected]}', true, false);
      text.isMenuItem = true;
      text.targetY = i;
      grpTxt.add(text);
  }
  }
  function getShit(int:String):String {
    var r:String = 'couldnt found ' + int;
    var st:Dynamic = null;
     switch (int.toLowerCase()){
      case 'gameplay','misc','appearance': st ='';
      case 'downscroll':st = FlxG.save.data.downScroll;
      case 'middlescroll': st = FlxG.save.data.mid;
      case 'idiom','idioma': st = Lang.get();// FlxG.save.data.curLang;
    }
    if (st != null)
      r = Std.string(st);
    return r;
  }
  function resetTxt(){
    for (i in 0...grpTxt.length){
			grpTxt.remove(grpTxt.members[0],true);
		}
    for (i in 0...optionsShit.length){
      resultsShit[i] = getShit('${optionsShit[curSelected]}');
      var text:Alphabet = new Alphabet(0, (70 * i) + 30, '${optionsShit[curSelected]} ${resultsShit[curSelected]}', true, false);
      text.isMenuItem = true;
      text.targetY = i;
      grpTxt.add(text);
  }
      var bullShit:Int = 0;
      for (item in grpTxt.members)
          {
              item.targetY = bullShit - curSelected;
              bullShit++;
  
              item.alpha = 0.6;
  
              if (item.targetY == 0)
              {
                  item.alpha = 1;
              }
          }
  }
  override function update(e:Float){
    super.update(e);
    if (FlxG.keys.justPressed.ENTER){
      switch(optionsShit[curSelected]){
        default:
          if (optionsShit[curSelected] ==Lang.getTr(1)){
            Lang.curLang ++;
            if (Lang.curLang >= Lang.maxLang)
              Lang.curLang = 0;
          optionsShit[curSelected] =Lang.getTr(1);

            resetTxt();
          }
        case 'appearance':
          optionsShit = [Lang.getTr(1)];
          resetTxt();

        case 'gameplay':
          optionsShit = ['downscroll','middlescroll'];
          resetTxt();

      }
    }   
    if (FlxG.keys.justPressed.ESCAPE){
      switch(optionsShit[curSelected]){
        default:
          if (isLangEdit){
            FlxG.switchState(new TitleState());
            resetTxt();
          } else {
          optionsShit = ['gameplay','misc','appearance'];
          resetTxt();
        }
        case 'gameplay','misc','appearance':
          switchTo(new MainMenuState());
      }
    }
    if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.UP){
      curSelected += FlxG.keys.justPressed.DOWN ? 1 : -1;
      if (curSelected < 0)
          curSelected = optionsShit.length - 1;
      if (curSelected >= optionsShit.length)
          curSelected = 0;
      var bullShit:Int = 0;
      for (item in grpTxt.members)
          {
              item.targetY = bullShit - curSelected;
              bullShit++;
  
              item.alpha = 0.6;
  
              if (item.targetY == 0)
              {
                  item.alpha = 1;
              }
          }
  }
  }  
  function _updateTxt() {
      var we:Array<Dynamic> = [];

    grpTxt.forEach(function (al:Alphabet){
      if (al.targetY == 0){
        we = [al.y,al.targetY];
			grpTxt.remove(al,true);
    }
    });

      var songText:Alphabet = new Alphabet(0, we[0], '${optionsShit[curSelected]} ${resultsShit[curSelected]}', true, false);
      songText.isMenuItem = true;
      songText.targetY = we[1];
      grpTxt.add(songText);
  }

}
