package offsetsroom;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.*;

class StageEditor extends MusicBeatState {
    var player1:String;
    var player2:String;
    var gfVersion:String;
    var gfVisible:Bool;
    public function new(player1:String,player2:String,gfVersion:String,gfVisible:Bool = true){
        super();
        this.player1 = player1;
        this.player2 = player2;
        this.gfVersion = gfVersion;
        this.gfVisible = gfVisible;


    }
    var stagesBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    var dad:Character;
    var gf:Character;
    var bf:Boyfriend;
    var camFol:FlxObject = new FlxObject(0,0,1,1);
  override function create() {
    super.create();
    add(stagesBG);
    dad = new Character(0,0,player2);
    gf = new Character(0,0,gfVersion);
    bf = new Boyfriend(0,0,player1);
    add(gf);
    add(dad);
    gf.visible = gfVisible;
    add(bf);
    dad.updateHitbox();
    bf.updateHitbox();
    gf.updateHitbox();

    switch (PlayState.SONG.stage){
    case 'crimen':
        var bgstoload = ['colasbg','cuchillosbg','prisasbg-1'];

            for (i in 0...bgstoload.length){
                var bg = new FlxSprite().loadGraphic('assets/images/stages/crimenes/'+ bgstoload[i] + '.png');
                bg.ID = i;
                bg.visible = true;
                bg.antialiasing = true;
                bg.scrollFactor.set(0.9, 0.9);
                bg.active = false;
                stagesBG.add(bg);
            }
        }
        FlxG.camera.follow(camFol);
  }
  var curVisible:Int = 0;
  override function update(ele:Float){
    super.update(ele);
    
    var ms = FlxG.mouse;
    bf.offset.set();
    gf.offset.set();
    dad.offset.set();
    if(FlxG.keys.pressed.J)
        camFol.velocity.x = -200;
    if (FlxG.keys.pressed.K)
        camFol.velocity.y = -200;
    if (FlxG.keys.pressed.I)
        camFol.velocity.y = 200;
    if (FlxG.keys.pressed.K)
        camFol.velocity.x = 200;
    if (!FlxG.keys.pressed.J && !FlxG.keys.pressed.K && !FlxG.keys.pressed.I && !FlxG.keys.pressed.L)
        camFol.velocity.set();
    if ((ms.overlaps(bf) && ms.pressed) || FlxG.keys.pressed.S)
        bf.setPosition(ms.x,ms.y);
    if ((ms.overlaps(dad) && ms.pressed) || FlxG.keys.pressed.D)
        dad.setPosition(ms.x,ms.y);
    if ((ms.overlaps(gf) && ms.pressed) || FlxG.keys.pressed.F)
        gf.setPosition(ms.x,ms.y);  
    if (FlxG.keys.justPressed.Z)
        FlxG.camera.zoom -= 0.05;
    else if (FlxG.keys.justPressed.X)
        FlxG.camera.zoom += 0.05;   

    FlxG.watch.addQuick('gfPos',[gf.x,gf.y]);
    FlxG.watch.addQuick('bfPos',[bf.x,bf.y]);
    FlxG.watch.addQuick('dadPos',[dad.x,dad.y]);
    FlxG.watch.addQuick('zoom',FlxG.camera.zoom);
    if (FlxG.keys.justPressed.Q)
        curVisible ++;
    if (FlxG.keys.justPressed.E)
        curVisible --;

    if (curVisible < 0)
        curVisible = stagesBG.members.length - 1;
    if (curVisible >=stagesBG.members.length)
        curVisible = 0;
    stagesBG.forEachAlive(function (spr:FlxSprite){
        spr.visible =spr.ID == curVisible;
    });
  }

}