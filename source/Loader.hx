package;

import flixel.text.FlxText;
import niz_tools.Lang;
import flixel.FlxG;
class Loader extends MusicBeatState {
    override function create(){
        PlayerSettings.init();

        super.create();


		FlxG.save.bind('funkin', 'niz');
		FlxG.autoPause = false;

		Highscore.load();
        Lang.init();
        if (FlxG.save.data.lang_seted == null || !FlxG.save.data.lang_seted){
            var toto = new FlxText (0,0,FlxG.width);
            toto.text = Lang.getTr(0,0) + '\n\n' + Lang.getTr(0,1) + '\n\n' + Lang.getTr(0,2) + '\n\n\n';
            toto.alignment = CENTER;
            toto.size = 15;
            toto.screenCenter();
            add(toto);
        } else {
            switchTo(new TitleState());
        }
    }
    override function update(cl:Float){
        super.update(cl);
        if (FlxG.save.data.lang_seted == null || !FlxG.save.data.lang_seted){
            if (FlxG.keys.justPressed.SPACE){
                offsetsroom.OptionsMenu.isLangEdit =true;
                FlxG.switchState(new offsetsroom.OptionsMenu());
            }
        }
    }
}