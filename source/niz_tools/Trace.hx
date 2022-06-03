package niz_tools;

import flixel.FlxG;

class Trace {
  var message:Dynamic;
  public function new(message:Dynamic,?type:String = 'normal', ?jose:Bool = true){
    this.message = message;
    switch(type){
      case 'warn': log_warn();
      case 'notice': log_notice();
      case 'clear': clearLogs();
      case 'error': log_error();
      default:
        log_add();
    }
  }
  function log_add(){
    FlxG.log.add(message);
    trace(message);

  }
  function log_error() {
    FlxG.log.error(message);
    trace('[ERROR]: $message');
  }
  function log_warn(){
    FlxG.log.warn(message);
    trace('[WARNING]: $message');
  }
  function log_notice(){
    FlxG.log.notice(message);
    trace('[NOTICE]: $message');
  }
  function clearLogs() {
    FlxG.log.clear();
    trace('cleaning...');
    trace('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
  }
}