package lastitools;


import flixel.FlxState;
import flixel.FlxGame;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.input.gamepad.FlxGamepad;
#if desktop
import Discord.DiscordClient;
#end
import lastitools.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;
class LastiEngineCredits extends MusicBeatState {
  var credits:Array<Array<Dynamic>> = [];
  var cam:FlxObject;
  var bg:FlxSprite;
  var oldColor:FlxColor;
  var newColor:FlxColor;
  var textOnPantalla:FlxTypedGroup<FlxText>;
  var textOnPantalla3:FlxTypedGroup<FlxText>;
  var iconOnPantalla:FlxTypedGroup<lastitools.Icon>;
  var cs:Int = 0;
  var desc:FlxText;
  var omitedInt:Array<Int> = [];
  var canSel:Array<Bool> = [];

  var lastiEngineCredits:Array<Array<Dynamic>> = [ // 0 1 2 3 5
    ['LASTI ENGINE TEAM'],
    [
      'nizako', 
      'mamon', 
      'Main Programmer, Project leader, Un Tremendo femboy', 
      'https://www.youtube.com/channel/UC9jN5X9A852hRSqOnqtDdXQ', 
      [0,0,0],
    ],
    ['manux', 'Manux', 'Programmer', 'https://www.youtube.com/c/llManuxAGll', [188,75,48],],
    ['liz', 'savente', 'Co-owner of lasti engine, Programmer', 'NOHAYRED', [188,75,48],],
    ['Primo de niz (ams)', 'amsdev', 'Beta tester, logo art, primo de niz', 'https://www.youtube.com/channel/UCLiN7NfSI61E7Fm6g-isUGA', [48,148,156],],
    [''],
    ['CONTRIBUTORS'],
    ['MDC', 'mdc el papu', 'Nosé gracias a su server me resolvieron gente ayuda.', 'https://www.youtube.com/c/mdcpe', [255,255,255],],
    ['ManuelCrack483', 'manu', 'Beta tester, manuel el pro wuwuwuw', 'https://www.youtube.com/c/ManuelCrack483', [95,255,97],],  ];
  function femboy(u:Int = 0){
    cs += u;
    if (cs < 0)
      cs = credits.length - 1;
    if (cs >= credits.length)
      cs = 0;
    switch(credits[cs][0]){
    case "", "LASTI ENGINE TEAM":
      if(credits[cs][0] == '') cs += 1;
      if (u == -1 && credits[cs][0] == 'LASTI ENGINE TEAM') cs = credits.length - 1;
      if (u == 1) cs += 1;
      
    case "CONTRIBUTORS":
      cs -= 3;
    }
  trace(credits[cs][0]); //  0    1    2    3    4
    oldColor = newColor; // [name,icon,desc,link,color]
    newColor = FlxColor.fromRGB(credits[cs][4][0], credits[cs][4][1], credits[cs][4][2]);
    desc.text = credits[cs][2];
      FlxTween.color(bg,1, oldColor, newColor);
    textOnPantalla.forEach(function (f:FlxText){
        f.alpha = 0.6;
        if (f.size >= 60) {f.alpha = 1;}
      if (cs == f.ID) {
        f.alpha = 1;
        cam.y = f.getGraphicMidpoint().y;
      }
  });
    iconOnPantalla.forEach(function (f:Icon){
      f.spr = textOnPantalla.members[f.ID];
      f.alpha = textOnPantalla.members[f.ID].alpha;
    });
  }
  override function update(e:Float) {
    super.update(e);
 
    if (FlxG.keys.justPressed.DOWN)
      femboy(1);
    if (FlxG.keys.justPressed.UP)
      femboy(-1);

    FlxG.watch.addQuick('cs', cs);
    FlxG.watch.addQuick('txt', credits[cs]);
  }

 override function create() {
    super.create();


    bg = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
    bg.scrollFactor.set();
    bg.screenCenter();
    add(bg);

    bg.color = FlxColor.GRAY;

    credits = lastiEngineCredits;
    newColor = FlxColor.fromRGB(credits[1][4][0],credits[1][4][1],credits[1][4][2]);

    textOnPantalla3 = new FlxTypedGroup<FlxText>();
    add(textOnPantalla3);
    textOnPantalla = new FlxTypedGroup<FlxText>();
    add(textOnPantalla);
    cam = new FlxObject(0,0,1,1);
    iconOnPantalla  = new  FlxTypedGroup<lastitools.Icon>();
    add(iconOnPantalla);
    desc = new FlxText(0,670, 0, '');
    desc.setFormat('assets/fonts/vcr.ttf', 25, FlxColor.WHITE,CENTER);
    desc.setBorderStyle(OUTLINE,FlxColor.BLACK, 2, 3);
    desc.scrollFactor.set();
    add(desc);
    for (i in 0...credits.length){
      checkToDaSection(i);
      trace(i);

      canSel[i] = credits[i][5];

      var efe = new FlxText(20, (i * 120) + 80, 0, credits[i][0]);
      efe.ID = i;
      efe.setFormat('assets/fonts/PMel.ttf', 50, FlxColor.WHITE, CENTER);
      if (credits[i][1] != null)
        efe.color = FlxColor.BLACK;
      else
        efe.size = 60;
      
      textOnPantalla.add(efe);


    if (credits[i][0] != credits[i][0].toUpperCase() || (credits[i][0] == 'MDC'  && credits[i][1] !=null  && credits[i][0] != "NOICON"))  {
    var efe_ele_ekisicono = new lastitools.Icon('icons/${credits[i][1]}');
    if (credits[i][0] == 'MDC') {efe_ele_ekisicono.setGraphicSize(Std.int(efe_ele_ekisicono.width * 0.8));}
    efe_ele_ekisicono.ID = i;
    iconOnPantalla.add(efe_ele_ekisicono);
  }
    }
    cam.x = 612;
    FlxG.camera.follow(cam, null, 0.6);
    femboy();
  }
  function checkToDaSection(yo:Int) {
    var s = credits[yo];
    credits[yo] = [
    s[0], 
    (s[1] != null ? s[1] : null), 
    (s[2] != null ? s[2] : 'a'),    
    (s[3] != null ? s[3] : "NOHAYRED"),
    (s[4] != null ? s[3] : [0,0,0]),
    (s[5] != null ? true : false),
    ];
      trace('owo');

  }

}