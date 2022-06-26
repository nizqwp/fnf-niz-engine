package niz_tools;

import lime.utils.Assets;
import sys.io.File;
import sys.FileSystem;
import flixel.FlxG;
using StringTools;
typedef LangJson = {
    var spMX:Idiom;
    var enEN:Idiom;
    var ptBR:Idiom;

}
typedef Idiom  = {
    var name:String;
    var trans:Array<Dynamic>;

}
class Lang {
    static var lib:String = 'id/';
    static var trs:String = 'lang.json';
    public static var curLang:Int = -2147483647;
    public static var maxLang:Int = 2147483647;
    public static var voiceLang:Int = 0; // hehe
    static var langs:Array<String> = ['English','Español','Português'];
    static var _init:Bool = false;
    static var _leng:LangJson;
    static var creditsTranslation:Array<String> = [
        'bruh',
        'Traducido por JesúsDev alías Niz.',
        'Traduzido por JesusDev alias Niz, e sem revisão xd.'
    ];
    public static function update(elapsed:Float){
        if (_init)
            FlxG.save.data.cur_lang = curLang;
    }
    public static function getTr(int:Int,?specific:Int = -1){
        if (specific <= -1){
            specific = curLang;
        }
        var shit:Idiom = null;
        switch(specific){
            case 0: shit = _leng.enEN;
            case 1: shit = _leng.spMX;
            case 2: shit = _leng.ptBR;
        }
        var rp:String = Std.string(shit.trans[int]);
        rp = rp.replace('#BIND:SPACE','SPACEBAR').replace('#BIND:ESC','ESC');
        return rp;
    }
    public static function get(curLan:Int = -2147483647, ?desc:Bool = false):String{
        if (!_init)
            init();
        if (curLan <= -1)
            curLan = curLang;

        return desc ? creditsTranslation[curLan] : langs[curLan];
    }
    public static function getEnd(){
        var ola = '';
        switch(curLang){
            case 1: ola ='-sp';
            case 2: ola ='-pt';
        }
        return ola;
    }
    public static function init(){
        if (_init){
            trace('this its already init!');
            return;
        }
        if (FlxG.save.data.cur_lang == null){
            FlxG.save.data.cur_lang = 0; // english
        }
        curLang = FlxG.save.data.cur_lang;
        maxLang = langs.length;
        if (Assets.exists(lib+trs)){
            trace('trying set lang-trs');
            _leng = cast haxe.Json.parse(Assets.getText(lib+trs));
            Trace.rel('the langs loaded!');

            if (_leng.spMX != null)
                Trace.rel('Español México/Latam fue cargado correctamente');
            if (_leng.ptBR != null) 
                Trace.rel('Portugues brasil, foi carregado corretamente');
            if (_leng.enEN != null) 
                Trace.rel('English, si');

        }
        _init = true;

    }
}