package lastitools;

typedef Event = {
  var stepHit:Array<Hit>;
  var beatHit:Array<Hit>;
}
typedef Hit = {
  var cur:Int;
  var type:String;
  var data:String;
}
class EventsSupport {
  public function set(a:String, ?DIFF:Int) {
    var s = lastitools.Get.txt('data/songs/event');
  }
}