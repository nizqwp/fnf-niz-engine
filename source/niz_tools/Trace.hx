package niz_tools;

import flixel.FlxG;

class Trace {
  static var message:Dynamic;
  public function new(message:Dynamic,?type:String = 'normal', ?jose:Bool = true){
    rel(message,type,jose);
  }
  public static function rel(memsgssage:Dynamic,?type:String = 'normal', ?jose:Bool = true){
    message = memsgssage;
    switch(type){
      case 'warn': log_warn();
      case 'notice': log_notice();
      case 'clear': clearLogs();
      case 'error': log_error();
      default:
        log_add();
    }

  }
  static function log_add(){
    FlxG.log.add(message);
    trace(message);

  }
  static function log_error() {
    FlxG.log.error(message);
    trace('[ERROR]: $message');
  }
  static function log_warn(){
    FlxG.log.warn(message);
    trace('[WARNING]: $message');
  }
  static function log_notice(){
    FlxG.log.notice(message);
    trace('[NOTICE]: $message');
  }
  static function clearLogs() {
    FlxG.log.clear();
    trace('cleaning...');
    trace('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
  }
}