package;

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

class Menu extends MusicBeatSubstate {
    var curSelected:Int = 0;
    var text:Array<String> = [
        'leftKey','downKey','upKey','rightKey',
        'leftKey alt','downKey alt','upKey alt','rightKey alt',
        'resetKey'
    ];
    var stat:String = 'n';
    var grpTxt = new FlxTypedGroup<Alphabet>();
    var sp:FlxSprite;
    override function create(){
        super.create();
		add(grpTxt);
        if (FlxG.save.data.keyBinds == null)
            FlxG.save.data.keyBinds = ['A','S','W','D','LEFT','DOWN','LEFT','RIGHT','R'];
        for (i in 0...text.length){
            var text:Alphabet = new Alphabet(0, (70 * i) + 30, '${text[i]} ${FlxG.save.data.keyBinds[i]}', true, false);
			text.isMenuItem = true;
			text.targetY = i;
			grpTxt.add(text);
        }
        sp = new FlxSprite().loadGraphic('niz.png');
        sp.screenCenter();
        add(sp);

    }
    var reset:Float = 0;
    override function update(e:Float) {
        super.update(e);
        if (FlxG.keys.pressed.R){
            reset += 0.01;
        } 
        FlxG.watch.addQuick('alpha', sp.alpha);
        FlxG.watch.addQuick('reset', reset);
        FlxG.watch.addQuick('binds', FlxG.save.data.keyBinds);
        sp.alpha = reset / 2;
        if (sp.alpha >= 1){
            sp.alpha = 1;
            reset = 0;
            FlxG.save.data.keyBinds = ['A','S','W','D','LEFT','DOWN','LEFT','RIGHT','R'];

        }
        switch(stat){
            case 's':
            if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.ENTER)
                setKey(FlxG.keys.getIsDown()[0].ID.toString());
            default:
                if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.UP){
                    curSelected += FlxG.keys.justPressed.DOWN ? 1 : -1;
                    if (curSelected < 0)
                        curSelected = text.length;
                    if (curSelected >= text.length)
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
                if (FlxG.keys.justPressed.ENTER){
                    stat = 's';
            var bullShit:Int = 0;

                    for (item in grpTxt.members)
                        {
                            item.targetY = bullShit - curSelected;
                            bullShit++;
                
                            item.alpha = 0.2;
                
                            if (item.targetY == 0)
                            {
                                item.alpha = 0.6;
                            }
                        }
                }
                if (FlxG.keys.justPressed.BACKSPACE){
                    FlxG.resetState();
                }
        }
 
    }

    function setKey(o:String = 'A'){

        var keyNotAllowed:Array<String> = [];
  
        if (FlxG.save.data.keyBinds == null)
            FlxG.save.data.keyBinds = ['A','S','W','D','LEFT','DOWN','LEFT','RIGHT','R'];
        keyNotAllowed = FlxG.save.data.keyBinds.copy();
        keyNotAllowed.push('ESCAPE');
        keyNotAllowed.push('BACKSPACE');
        for (i in keyNotAllowed){
            if (o == i){
                stat = 'n';
                trace('the key named as #keyboard.get[0].$o it current exists.');
                #if !debug
                return;
                
                #end
                trace('con debug todo se puede por que si xd');
                trace(keyNotAllowed);
            }
        }
        FlxG.save.data.keyBinds[curSelected] = o;
		for (i in 0...grpTxt.length){
			grpTxt.remove(grpTxt.members[0],true);
		}
		for (i in 0...text.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, '${text[i]} ${FlxG.save.data.keyBinds[i]}', true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpTxt.add(songText);
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
		PlayerSettings.player1.controls.setKeyboardScheme(Duo(true));

    }
}