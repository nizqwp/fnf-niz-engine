package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSubState;
import flixel.*;
class Modif extends FlxSubState {
  var sola:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
  var curANY:Dynamic = [
    null,
    0,
    null,
  ];
  var mods:Array<{
    var name:String;
    var desc:String;
    var value:Dynamic;
    var onExecute:Dynamic->Dynamic ->Void ;
  }> = [];
   var _mds:Array<{
    var name:String;
    var desc:String;
    var value:Dynamic;
    var onExecute:Dynamic->Dynamic ->Void ;
  }> = [];

  public function new(){
    super();
    if (FlxG.save.data.showBotRating == null)
			FlxG.save.data.showBotRating = false;
		if (FlxG.save.data.downScroll)
			FlxG.save.data.downScroll = true;
		if (FlxG.save.data.mid == null)
			FlxG.save.data.mid = false;
		if (FlxG.save.data.showBlackBG_n == null) 
			FlxG.save.data.showBlackBG_n = false;
    if (PlayState.mods == null)
      if (FlxG.save.data.mods_con != null){
        PlayState.mods = FlxG.save.data.mods_con;
      } else {
      PlayState.mods = {
        notes_from: "bf",
        tugofwar: false
      }
    }
    mods = [    
    {
      name: 'Tug of war',
      desc: 'Si el enemigo canta, se te restará vida.',
      value: PlayState.mods.tugofwar,
      onExecute: function (cur,f){
        PlayState.mods.tugofwar = !PlayState.mods.tugofwar;
        mods[0].value = PlayState.mods.tugofwar;
      }
    },
    {
      name: 'Notes para',
      desc: 'dad: las notas de dad se irán contigo y las de bf se irán hacía dad, Bf: normal, paLosDos: se irán todas para tí (de paso estará en middleScroll).',
      value: PlayState.mods.notes_from,
      onExecute: function (cur,f){
        var can = ['bf','dad','paLosDos'];
        // var cur = curANY[1];
        if (f)
          cur --;
        else
          cur ++;
        if (cur < 0)
          cur = 2;
        if (cur >= 3)
          cur = 0;
        curANY[1] = cur;
        PlayState.mods.notes_from = can[cur];
        mods[1].value =  PlayState.mods.notes_from;
      }
    },
    {
      name: 'MidScroll',
      desc: 'Las notas pal medio',
      value: FlxG.save.data.mid,
      onExecute: function (cur,f){
        FlxG.save.data.mid = !FlxG.save.data.mid;
        // PlayState.mods.mid = !PlayState.mods.mid;
        mods[2].value = FlxG.save.data.mid;

      }
    },
    {
      name: 'downScroll',
      desc: 'Las notas pa abajo o arriba (true para abajo, false para arriba)',
      value: FlxG.save.data.downScroll,
      onExecute: function (cur,f){
        FlxG.save.data.downScroll = !FlxG.save.data.downScroll;
        mods[3].value = FlxG.save.data.downScroll;

      }
    },
    {
      name: 'black strums',
      desc: 'aparece un cuadro de color negro para si te obstruye algo no lo haga más',
      value: FlxG.save.data.showBlackBG_n,
      onExecute: function (cur,f){
        FlxG.save.data.showBlackBG_n = !FlxG.save.data.showBlackBG_n;
        mods[4].value = FlxG.save.data.showBlackBG_n;

      }
    },
    {
      name: 'Show enemy rating',
      desc: 'Muestra el rating del enemigo (para modificar las probabilidades ve a options)',
      value: FlxG.save.data.showBotRating,
      onExecute: function (cur,f){
        FlxG.save.data.showBotRating = !FlxG.save.data.showBotRating;
        mods[5].value = FlxG.save.data.showBotRating;

      }
    },
    {
      name: 'Practice mode',
      desc: 'Muestra el rating del enemigo (para modificar las probabilidades ve a options)',
      value: FlxG.save.data.practice,
      onExecute: function (cur,f){
        FlxG.save.data.practice = !FlxG.save.data.practice;
        FlxG.save.data.botPlay = false;
        mods[6].value = FlxG.save.data.practice;
        mods[7].value = FlxG.save.data.botPlay;


      }
    },
    {
      name: 'BotPlay',
      desc: 'Muestra el rating del enemigo (para modificar las probabilidades ve a options)',
      value: FlxG.save.data.showBotRating,
      onExecute: function (cur,f){
        FlxG.save.data.botPlay = !FlxG.save.data.botPlay;
        FlxG.save.data.practice = false;

        mods[7].value = FlxG.save.data.botPlay;
        mods[6].value = FlxG.save.data.practice;


      }
    },
  ];
  _mds = mods;
    var bg = new FlxSprite().makeGraphic(1280,720,FlxColor.BLACK);
    bg.scrollFactor.set();
    bg.alpha = 0.5;
    bg.screenCenter();
    add(bg);

    for (i in 0...mods.length){
      var flxTexto =new FlxText(30,(i*50) + 40,0,mods[i].name);
      flxTexto.size = 20;
      flxTexto.ID = i;
      add(flxTexto);
      sola.add(flxTexto);
    }
  }
  var curS:Int = 0;
  override function update(e:Float){
    var keys = FlxG.keys.justPressed;
    if (keys.BACKSPACE){
      close();

    }
    if (keys.LEFT || keys.RIGHT){
      mods[curS].onExecute(curANY[curS],keys.LEFT);
    }
    FlxG.watch.addQuick('sdfkjsdfhj',curANY[curS]);
    if (keys.UP)
      curS --;
    if (keys.DOWN)
      curS ++;
    sola.forEach(function (s:FlxText){
      s.alpha = (s.ID == curS ? 1 : 0.5);
        s.text = '${mods[s.ID].name} - ${mods[s.ID].value}';
    });

    if(curS < 0)
      curS = 0;
    if (curS >= mods.length)
      curS = mods.length - 1;
    
  }
}