package lastitools;


class PabloUtil {
  public static function parseBool(t:String):Bool {
    trace("PASSING STRING TO BOOL '"+'$t'+"'");
    trace("now is " + (t == 'true' ? 'true' : 'false'));
    return (t == 'true' ? true : false); 
  }
}