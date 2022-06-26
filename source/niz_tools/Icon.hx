package lastitools;

using StringTools;
class Icon extends LastiSprite {
  public var spr:flixel.FlxSprite;

  public var inS:String = 'icons/mamon';
  public var daIcon:String = 'mamon';
  /*
  * THIS ITS JUST ONLY A ICON FOR LASTIENGINECREDITS
  * DA IDEA FUE POR NIZ
  * MANUEL TE AMO OWO
  */
  public function new (inS:String = 'icons/mamon') {
    super();
    this.inS = inS;
    if (lastitools.Util.doNoExists('assets/images/${inS}.png')) {
      inS = 'icons/savente';
    }
    var splitted = inS.split('/');
    var s = splitted.length - 1;
    daIcon = splitted[s];
    loadGraphic('assets/images/${inS}.png');
		antialiasing = !daIcon.endsWith('-pixel');
    
    var ola = lastitools.FlxSprTRKTamano.gettamanoFromIMG(inS);
    setGraphicSize(Std.int(width * ola[0] / 150));
  }
  override function update(elapsed:Float)
    {
      super.update(elapsed);
  
      if (spr != null)
        setPosition(spr.x + spr.width + 10, spr.y - 30);
    }
}