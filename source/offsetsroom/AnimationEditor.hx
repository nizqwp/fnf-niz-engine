package offsetsroom;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.utils.Assets;
using StringTools;
/**
	*DEBUG MODE
 */
class AnimationEditor extends MusicBeatState
{
	var char:Character;
	var dad:Character;
	var textAnim:FlxText;
	var seteo:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		// FlxG.sound.music.stop();
		// FlxG.sound.music.time = 0;
		var song:String = 'triple-trouble';
		if (PlayState.SONG != null)
			song = PlayState.SONG.song.toLowerCase();
		FlxG.sound.playMusic('songs:assets/songs/$song/Inst.ogg');
		// FlxG.sound.music.looped = true;
		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);
		add(seteo);

		dad = new Character(0, 0, daAnim);
		dad.screenCenter();
		dad.debugMode = true;
		add(dad);

		char = /*dad*/ new Character(dad.x,dad.y,daAnim);
		char.alpha = 0.6;
		seteo.add(char);


		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{


		if (pushList){
		var daLoop:Int = 0;
		updateTexts();
		for (anim => offsets in dad.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.ID = daLoop;
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	} else {
		dumbTexts.forEach(function(text:FlxText)
			{
				text.text = animList[text.ID] + ": " + Std.string(dad.animOffsets.get(animList[text.ID]));
			});
	}
	}

	function updateTexts():Void
	{
		// while(dumbTexts.length > 0){
		// 	dum
		// }
		dumbTexts.forEach(function(text:FlxText)
		{
			text.visible = false;
			text.kill();
			text.destroy();
			dumbTexts.remove(text, true);
		});
	}
	override function beatHit(){
		super.beatHit();
		if (curBeat % 4 == 0){
			// FlxG.camera.zoom += 0.15;
			dad.playAnim(animList[curAnim]);

			// updateTexts();
			// genBoyOffsets(false);
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.U){
			FlxG.switchState(new AnimationEditor(Assets.getText('assets/data/anim.txt').split('\n')[0].replace('\r','')));
		}
		// FlxG.camera.zoom  = FlxMath.lerp(1,	FlxG.camera.zoom, 0.95)
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		textAnim.text = dad.animation.curAnim.name;

		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom += 0.01;
		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom -= 0.01;
		if (	FlxG.camera.zoom  >= 2){
			FlxG.camera.zoom = 1;
		}
		if (	FlxG.camera.zoom  <= 0.25){
			FlxG.camera.zoom = 2;
		}

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			dad.playAnim(animList[curAnim]);

			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			if (upP)
				dad.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				dad.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				dad.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				dad.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			genBoyOffsets(false);
			dad.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}
