package lastitools;

using StringTools;
class Mods extends MusicBeatState {
  public function new(){
    super();
  }
  override function create(){
    super.create();
  }
  public static function getCHAnimData(?path:String = 'bf') {
    var rawFile:String = Get.txt('data/custom char mod/' + path + '.lf');
    trace(path);
    trace(rawFile);

    var rawArray:Array<String> = rawFile.trim().split('\n');
		for (i in 0...rawArray.length)
		{
			rawArray[i] = rawArray[i].trim();
		}
    return rawArray;
  }
}