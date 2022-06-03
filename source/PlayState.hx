package;

import shaders.Shader_parse.Shader_parser;
import sys.FileSystem;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;
import niz_tools.Music;
typedef Mods = {
	var tugofwar:Bool;
	var notes_from:String;
	// va
}
class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var playIn:Float = 0;
	public static var mods:Mods = null;

	public static var songID:Int = 0;
	public static var move:Bool = false;
	var detto:Int = 0;

	public static var inst:Music;
	public static var voices:Music;
	var midSumabf:Float = 280;
	var midSumadad:Float = 360;
	private var dad:Character;
	private var gf:Character;
	private var bf:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var text:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();


	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;


	private var strumLineNotes:FlxTypedGroup<StrumSprite>;
	private var playerStrums:StrumSprite;
	private var enemyStrums:StrumSprite;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;

	private var combo:Int = 0;
	private var acc:Float = 0.00;
	var totalPlayed:Float = 0;
	var noteHitted:Float = 0;
	function updateAcc(){
		totalPlayed += 1;
		acc = FlxMath.roundDecimal(noteHitted / totalPlayed * 100, 2);
		if (acc >= 100)
			acc = 100.00;
		if (acc < 0)
			acc = 0.00;
	}
	private var noteHits:Int = 0;
	private var miss:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;

	static var noteHitscap:Int = 0;
	static var misscap:Int = 0;
	static var sickscap:Int = 0;
	static var goodscap:Int = 0;
	static var badscap:Int = 0;
	static var shitscap:Int = 0;
	

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	// var isPlayer:Bool = true;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	
	var strumCamera:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var text_:FlxText;
	/**
	*  DEFAULT BG SHIT
	*/
	var stageBG:FlxSprite;
	var stageFloor:FlxSprite;
	var stageFG:FlxSprite;
	/**
	*  WEEK 2 SHIT
	*/
	var halloweenBG:FlxSprite;
	/**
	*  WEEK 3 SHIT
	*/
	 
	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	function trainStart():Void
		{
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	
		var startedMoving:Bool = false;
	
		function updateTrainPos():Void
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;
				gf.playAnim('hairBlow');
			}
	
			if (startedMoving)
			{
				phillyTrain.x -= 400;
	
				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;
	
					if (trainCars <= 0)
						trainFinishing = true;
				}
	
				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}
	
		function trainReset():Void
		{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	
	/**
	*  WEEK 4 SHIT
	*/

	/**
	*  WEEK 5 SHIT
	*/

	/**
	*  WEEK 6 SHIT
	*/
	 
	 
	/**
	*  WEEK 7 SHIT
	*/
	 var tankSky:FlxSprite;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end
	var originalSONG:SwagSong;
	var frontBG:FlxSprite = new FlxSprite();
	var calification:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	override public function create()
	{
		originalSONG = SONG;
		if (FlxG.save.data.showBotRating == null)
			FlxG.save.data.showBotRating = false;
		if (FlxG.save.data.downScroll)
			FlxG.save.data.downScroll = true;
		if (FlxG.save.data.mid == null)
			FlxG.save.data.mid = false;
		if (FlxG.save.data.showBlackBG_n == null) 
			FlxG.save.data.showBlackBG_n = false;



		if (PlayState.mods == null)
      if (FlxG.save.data.mods_con != null){
        PlayState.mods = FlxG.save.data.mods_con;
      } else {
      PlayState.mods = {
        notes_from: "bf",
        tugofwar: false
      }
    }
		// FlxG.save.data.botPlay = false;
			detto = mods.notes_from == 'dad' ? 2 : 0;
			FlxG.save.data.mods_con = mods;
			if (mods == null){
				mods = {
					notes_from: "bf",
					tugofwar: false
				}
			}
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		strumCamera = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		strumCamera.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(strumCamera);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;
		inst = new Music();
		voices = new Music();

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');


		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}
	

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end
		switch(SONG.stage){
			case 'spooky':
				curStage = 'spooky';

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = Paths.getSparrowAtlas('stages/spooky/halloween_bg');
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case 'philly':
				curStage = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

							var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
								var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win' + i));
								light.scrollFactor.set(0.3, 0.3);
								light.visible = false;
								light.setGraphicSize(Std.int(light.width * 0.85));
								light.updateHitbox();
								light.antialiasing = true;
								phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
				add(street);
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				stageBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/stageback'));
				stageBG.antialiasing = true;
				stageBG.scrollFactor.set(0.9, 0.9);
				stageBG.active = false;
				add(stageBG);
		
				stageFloor= new FlxSprite(-650, 600).loadGraphic(Paths.image('stages/stagefront'));
				stageFloor.setGraphicSize(Std.int(stageFloor.width * 1.1));
				stageFloor.updateHitbox();
				stageFloor.antialiasing = true;
				stageFloor.scrollFactor.set(0.9, 0.9);
				stageFloor.active = false;
				add(stageFloor);
		
				stageFG = new FlxSprite(-500, -300).loadGraphic(Paths.image('stages/stagecurtains'));
				stageFG.setGraphicSize(Std.int(stageFG.width * 0.9));
				stageFG.updateHitbox();
				stageFG.antialiasing = true;
				stageFG.scrollFactor.set(1.3, 1.3);
				stageFG.active = false;
				add(stageFG);
		
		}
		var gfVersion:String = 'gf';
	
		switch (SONG.song.toLowerCase())
		{
			case 'knockout':
				
			default:
		}


		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		gf = new Character(400, 130, gfVersion);
		bf = new Boyfriend(770, 450, SONG.player1);
		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
		}


		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'spooky':
				dad.y += 250;
			case 'philly':
				dad.y += 100;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				bf.x += 200;
				bf.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);
		add(dad);
		add(bf);
		bf.canMiss = false;
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, FlxG.save.data.downScroll ? FlxG.height - 150 : 55).makeGraphic(Std.int(FlxG.width * 4), 30);
		strumLine.scrollFactor.set();
		strumLine.alpha= 0.01;
		// strumLine.y = ;

		#if debug add(strumLine); #end
		strumLineNotes = new FlxTypedGroup<StrumSprite>();
		add(strumLineNotes);


		// calification
		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		if (FlxG.save.data.downScroll){
			healthBarBG.y = FlxG.height * 0.1;
		}
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);
	

		scoreTxt = new FlxText(healthBarBG.x, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		scoreTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK, 2,2);
		scoreTxt.scrollFactor.set();

		text_ = new FlxText(0, 0, 0, "", 20);
		text_.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		text_.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK, 2,2);
		text_.scrollFactor.set();
		text_.screenCenter(X);
		text_.y = (FlxG.save.data.downScroll) ?healthBarBG.y + 60 : healthBarBG.y - 60;
		text_.cameras = [camHUD];

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		add(scoreTxt);
		add(text_);

		strumLineNotes.cameras = [strumCamera];
		notes.cameras = [strumCamera];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		camHUD.alpha = 0.8;

		startingSong = true;
		add(text);

		text.cameras = [camHUD];
			switch (curSong.toLowerCase())
			{
				case 'ugh':
					tryAndOpenVideo('ughCutscene',startCountdown);
				case 'guns':
					tryAndOpenVideo('gunsCutscene',startCountdown);
				case 'stress':
					tryAndOpenVideo('stressCutscene',startCountdown);

				case 'bopeebo':
					tryAndOpenDialogue(konoCountDown);
				default:
					startCountdown();
			}
		frontBG.makeGraphic(FlxG.width * 10,FlxG.height * 10,FlxColor.BLACK);
		frontBG.screenCenter();
		frontBG.scrollFactor.set();
		super.create();
		var shader = new Shader_parser('vcr');
		var shaderFilter = new ShaderFilter(shader);
		FlxG.camera.setFilters([shaderFilter]);
	}

	function tryAndOpenVideo(name:String, ?onComplete:Void->Void):Void {
		var path = 'assets/video/${name}.mp4';
		enemyStrums = new StrumSprite(0);
		playerStrums = new StrumSprite(0);
			add(frontBG);
			(new FlxVideo(path)).finishCallback = function () { 
			realOnComplete(onComplete);
			};
	}
	function realOnComplete(c:Void->Void){
		// playerStrums.kill();
		// enemyStrums.kill();
		if (c != null)
				c();
		if (frontBG != null)
			FlxTween.tween(frontBG, {alpha: 0},0.6);	
	}
	var dialoguesLoaded:Int = -1;
	function tryAndOpenDialogue(onComplete:Void->Void){
		inCutscene = true;
		dialoguesLoaded ++;
		var path = 'assets/data/${SONG.song.toLowerCase()}/dialogue'+ (dialoguesLoaded == 0 ? '' : '-$dialoguesLoaded') +'.json';
		var fileExits = Assets.exists(path);
		if (fileExits){
		var ola = Assets.getText(path);
		var lel = Json.parse(ola);
		var dia = new Dialogue(lel,camHUD,onComplete);
		dia.scrollFactor.set();
		add(dia);

	  } else {
			FlxG.log.warn('Couldnt find video file: ' + path);

			onComplete();
		}
	}
	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	var omittedCount:Bool = false;
	function konoCountDown():Void
		{
			canPause = false;

			inCutscene = false;
	
			generateStaticArrows(0);
			generateStaticArrows(1);
	
			talking = false;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;

			var coolText = new FlxText(10,20,0,'${SONG.song.replace('-',' ')} - NullAlbum OST\nby: Niz(o null en todo caso)\n');
			coolText.alpha = 0;
			coolText.size = 20;
			coolText.color = FlxColor.BLACK;
			var coolTextBG = new FlxSprite(10,20).makeGraphic(200,200);
			coolTextBG.alpha = 0;
			coolTextBG.scrollFactor.set();
			coolText.scrollFactor.set();
			var swagCounter:Int = 0;
			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				dad.dance();
				gf.dance();
				bf.dance();
				var startSuffix = '';
				var endSuffix = '';
				var endSoundSuffix = '';
	
				if (curStage == 'megStage'){
					startSuffix = 'megumin/';
					endSuffix = '-sprite';
					endSoundSuffix = '-meg';
				} // puta la wea no hay sprites xd
	
				switch (swagCounter)
				{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					add(coolTextBG);

					add(coolText);
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					FlxTween.tween(coolText, {alpha: 1});
					FlxTween.tween(coolTextBG, {alpha: 1});
										FlxTween.tween(coolText, {alpha:0, x: -1280}, 1, {startDelay:2});
					FlxTween.tween(coolTextBG, {alpha: 1, x: -1280},1, {startDelay:2});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
			startedCountdown = true;
			canPause = true;

				}
	
				swagCounter ++;
			}, 4);
		}
	
	function startCountdown():Void
	{
		inCutscene = false;
		startedCountdown = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			bf.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['UI/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['UI/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
		startedCountdown = true;

			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	// var maxLoops:Int = 0;
	// var curLoop:Int = 0;
	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;
		FlxG.save.data.loopSong = true;
		if (!paused)
			inst.play(Paths.inst(PlayState.SONG.song), 1, FlxG.save.data.loopSong);
			inst.time = playIn;
			inst.onFinish = endSong;
			voices.music.time = inst.music.time;
			voices.resume();
			inst.resume();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = inst.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;
		if (SONG.needsVoices)
			voices.play(Paths.voices(PlayState.SONG.song));


		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					sustainNote.notePara = 'normal';
					switch(mods.notes_from){
						default: sustainNote.mustPress = gottaHitNote;
						case 'dad': sustainNote.mustPress = !gottaHitNote;
					case 'paLosDos':  sustainNote.mustPress  = true;
					sustainNote.notePara = (gottaHitNote ? 'bf' : 'dad');
				}
				

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}

				}
				swagNote.notePara = 'normal';
				switch(mods.notes_from){
					default: swagNote.mustPress = gottaHitNote;
					case 'dad': swagNote.mustPress = !gottaHitNote;
					case 'paLosDos':  swagNote.mustPress  = true;
					swagNote.notePara = (gottaHitNote ? 'bf' : 'dad');
			}
			
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}

	

			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		var bg_arrow = new FlxSprite().makeGraphic(500,Std.int(FlxG.height * 4), FlxColor.BLACK);
		bg_arrow.alpha = 0.5;
		bg_arrow.visible = 	FlxG.save.data.showBlackBG_n;
		bg_arrow.scrollFactor.set();
		bg_arrow.screenCenter(X);
		bg_arrow.ID = 5;
		switch(player){
			case 0:
		enemyStrums = new StrumSprite(strumLine.y,player);
		strumLineNotes.add(enemyStrums);
			default:
		playerStrums = new StrumSprite(strumLine.y,player);
		strumLineNotes.add(playerStrums);
		}
	
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (inst != null)
			{
				inst.pause();
				voices.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (inst.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		voices.pause();
		inst.pause();

		inst.resume();
		Conductor.songPosition = inst.music.time;
		voices.music.time = Conductor.songPosition;
		voices.resume();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var gostoTrapin:Bool = true; 
	var nextIsDadMiss:Bool = false;
	var onTween:Array<FlxTween> = [];
	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end
				switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}
		// if ()
		// if ()
		inst.update(elapsed);
		voices.update(elapsed);
		Conductor.songPosition = inst.music.time;
		voices.music.time = Conductor.songPosition;

		strumCamera.zoom = camHUD.zoom;

#if debug
if (FlxG.keys.justPressed.O){
	// forceBFmiss = true;
	// nextIsDadMiss = true;
	combo ++;
	noteHits ++;
	if (FlxG.keys.pressed.P){
		combo += 200;
		noteHits += 200;
	}
	if (FlxG.keys.pressed.I){
		combo = (combo * 2) * (FlxG.keys.pressed.P ? 1 : 4);
		noteHits = (noteHits * 2) * (FlxG.keys.pressed.P ? 1 : 4);
	}
	if (combo >= 999999)
		combo = 999999;
	if (noteHits >= 999999)
		noteHits = 999999;
	// totalNoteHt
	popUpScore(0,true);

}

#end
if (combo >= 999999)
	combo = 999999;
if (noteHits >= 999999)
	noteHits = 999999;
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}
		// if ()
		if (generatedMusic && SONG.notes[Std.int(curStep / 16)] != null && !gostoTrapin)
			{
				bf.canMiss = SONG.notes[Std.int(curStep / 16)].mustHitSection;
			}
			if (playerStrums != null){
		notes.forEach(function (n:Note){
			if (!n.mustPress && FlxG.save.data.mid){
				n.alpha = 0.1;
			}
			if (n.mustPress){
				n.x = playerStrums.getX(n).x  + (n.isSustainNote ? 50 : 0);
			} else {
				n.x = enemyStrums.getX(n).x + (n.isSustainNote ? 50 : 0);
			}

		});
		strumLine.y = playerStrums.getX(0).y;
		strumLine.x = playerStrums.getX(0).x;
	}

		super.update(elapsed);

		scoreTxt.text =  'Score: $songScore | Misses: $miss | Note hits: $noteHits | Accuracy: $acc';
		if (FlxG.save.data.botPlay)
			FlxG.save.data.practice = false;
		var ofdsfjskdf = '';
		if (FlxG.save.data.botPlay && !FlxG.save.data.practice)
			ofdsfjskdf = 'BOTPLAY';
		if (!FlxG.save.data.botPlay && FlxG.save.data.practice)
			ofdsfjskdf = 'PRACTICE MODE';
		text_.text = (FlxG.save.data.botPlay || FlxG.save.data.practice) ? ofdsfjskdf : '';

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(bf.getScreenPosition().x, bf.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new offsetsroom.ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (health < 0)
			health = 0;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new offsetsroom.AnimationEditor(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition && playIn <= 0)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
				} else {
				playIn = 0;

				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					voices.music.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != bf.getMidpoint().x - 100)
			{
				camFollow.setPosition(bf.getMidpoint().x - 100, bf.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = bf.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = bf.getMidpoint().y - 200;
					case 'school':
						camFollow.x = bf.getMidpoint().x - 200;
						camFollow.y = bf.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = bf.getMidpoint().x - 200;
						camFollow.y = bf.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
			}
		}

		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}
		var det:Bool = false;
		if (detto == 2)
			det = health >= detto;
		else 
			det = health <= detto;
		if (det && !FlxG.save.data.practice)
		{
			health = detto;
			bf.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			voices.stop();
			inst.stop();

			openSubState(new GameOverSubstate(bf.getScreenPosition().x, bf.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(bf.getScreenPosition().x, bf.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];

				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				

				var caidaType = FlxG.save.data.downScroll;
				if (strumLine.y <= 200)
					caidaType = false;
				if (caidaType){
									
							daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
							if (daNote.isSustainNote
							&& daNote.y - daNote.offset.y <= strumLine.y + Note.swagWidth / 2
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, strumLine.y - Note.swagWidth / 2 + daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y /= daNote.scale.y;
							swagRect.height -= swagRect.y;
		
							daNote.clipRect = swagRect;
						}
		
				}
				else {
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
							if (daNote.isSustainNote
							&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y /= daNote.scale.y;
							swagRect.height -= swagRect.y;
		
							daNote.clipRect = swagRect;
						}
		
				}

				// i am so fucking sorry for this if condition


				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					 pressBot(daNote);
				}
				if (FlxG.keys.justPressed.U && daNote.mustPress){
				}
			
				// var press = (daNote.y <= 30 && !FlxG.save.data.downScroll) || (daNote.y >= 590 && FlxG.save.data.downScroll); 
				if (FlxG.save.data.botPlay && daNote.mustPress && canPress(daNote,caidaType))
					{
						goodNoteHit(daNote);
					}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				if (daNote.mustPress){
				if (caidaType){

				if (daNote.y > strumLine.y + 170)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						voices.music.volume = 0;
						noteMiss(daNote.noteData, daNote);

					}
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				} 
		} else {
			if (daNote.y < strumLine.y  - 170)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						voices.music.volume = 0;
						noteMiss(daNote.noteData, daNote);

					}
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				} 
		 }
		} 
			});

		}

		if (!inCutscene && !FlxG.save.data.botPlay)
			keyShit();
	

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}
		var botCombo:Int = 0;
		var lastNote:Note = null;
		var skillIssue = [0,4];
		var skillShit = 0;
		function pressBot(daNote:Note){
			if (nextIsDadMiss){
				nextIsDadMiss = false;

				missBot(daNote);
				return;
			}
			if (daNote == lastNote && !daNote.isSustainNote)
				return;
			if (SONG.song != 'Tutorial')
				camZooming = true;

			// skillShit = FlxG.random.int(skillIssue[0],skillIssue[1]);
			var altAnim:String = "";

			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].altAnim)
					altAnim = '-alt';
			}
			if (mods.tugofwar){
				if (mods.notes_from == 'dad')
					health -= 0.04;
				else {
					health += 0.04;
				}
			}
			switch(daNote.notePara){
				default:
					if (mods.notes_from == 'dad'){
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								bf.playAnim('singLEFT' + altAnim, true);
							case 1:
								bf.playAnim('singDOWN' + altAnim, true);
							case 2:
								bf.playAnim('singUP' + altAnim, true);
							case 3:
								bf.playAnim('singRIGHT' + altAnim, true);
						}
					} else {
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}
			}



			if (!daNote.isSustainNote){
				popUpScoreBot(daNote);

			}
			dad.holdTimer = 0;
			
			enemyStrums.press(daNote,true);

			lastNote = daNote;
			if (SONG.needsVoices)
				voices.music.volume = 1;
				if (daNote.isSustainNote){
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				
				} else {
				if (skillShit == 4){
					new FlxTimer().start(4, function(tmr:FlxTimer){
					if (daNote.y > FlxG.height){
						trace('oh no miss');
						FlxTween.tween(daNote, {alpha: 0}, 1,{onComplete: function (_){
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						
						}});
						} else {
							tmr.reset();	
						}
					
					});
				}else {
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}


		}
	function missBot(n:Note){
		if (dad.canMiss){
		health += 0.04;
		if (botCombo > 10 && gf.animOffsets.exists('sad'))
		{
			gf.playAnim('sad');
		}
		botCombo = 0;
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.45, 0.5));
		var direction = n.noteData;

		switch (direction)
		{
			case 0:
				if (dad.animOffsets.exists('singLEFTmiss'))
				dad.playAnim('singLEFTmiss', true);
			case 1:
				if (dad.animOffsets.exists('singDOWNmiss'))
				dad.playAnim('singDOWNmiss', true);
			case 2:
				if (dad.animOffsets.exists('singUPmiss'))
				dad.playAnim('singUPmiss', true);
			case 3:
				if (dad.animOffsets.exists('singRIGHTmiss'))
				dad.playAnim('singRIGHTmiss', true);
		}
		return;
	}
	popUpScoreBot(n);
	}
	function popUpScoreBot( n:Note){
		var rating:FlxSprite = new FlxSprite();
		var placement:String = Std.string(combo);

		var calificacion:Int = 0;
		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.20;

		var daRating:String = "sick";
		if (FlxG.save.data.ignore_cal == null)
			FlxG.save.data.ignore_cal = 50;
		if (FlxG.save.data.bot_rat == null)
			FlxG.save.data.bot_rat  = [0,1];
		calificacion = FlxG.random.int(FlxG.save.data.bot_rat[0],FlxG.save.data.bot_rat[1]);	
		var ignorecal =FlxG.random.bool(FlxG.save.data.showBotRating);
		calificacion = ignorecal ? 0 : calificacion;
		skillShit = calificacion;

		// noteHits ++;
		switch(calificacion){
			case 0: // sick
			case 1:
				daRating = 'good';
			case 2:
				daRating = 'bad';
			case 3:
				daRating = 'shit';
			case 4:
				daRating = 'combo';

				missBot(n);
				return;
		}

		botCombo ++;
		
		if (!FlxG.save.data.showBotRating)
			return;

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.scrollFactor.set(0,0);
		rating.color = FlxColor.fromRGB(255,0,0);
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.cameras = [camHUD];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.scrollFactor.set(0,0);
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.color = rating.color;
		comboSpr.cameras = [camHUD];

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();
		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(botCombo / 100));
		seperatedScore.push(Math.floor((botCombo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(botCombo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;
			numScore.scrollFactor.set(0,0);
			numScore.color = rating.color;
			numScore.cameras = [camHUD];

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (botCombo >= 10){
				add(numScore);
				add(comboSpr);
			}

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	function endSong():Void
	{
		// if (curLoop != maxLoops){
			// SONG = originalSONG;
			// curLoop ++;
			// generateSong(SONG.song);
			// return startCountdown();
		// } 
		// if (isStoryMode && songID == 0){
		// // 	switch(storyWeek){
		// // 		case 0:
		// // 		case 1: songID = 1;
		// // 		case 2: songID
		// // 	}
		// // 	// songID  = 
		// // }
		// // if (FlxG.save.data.songs_ == null)
		// // 	FlxG.save.data.songs_ = new Array<String>();
		// // 	// FlxG.save.data.songs_ = new Map<String, Bool>();

		// FlxG.save.data.songs_.insert(songID,SONG.song);
		
		canPause = false;
		inst.music.volume = 0;
		voices.music.volume = 0;
		if (SONG.validScore && (!FlxG.save.data.botPlay || !FlxG.save.data.practice))
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
				FlxG.autoPause = false;

				FlxG.switchState(new StoryMenuState());

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore && !FlxG.save.data.botPlay && !FlxG.save.data.practice)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				inst.stop();
				FlxG.autoPause = true;

				niz_tools.LoadState.load(new PlayState());

			}
		}
		else
		{
			FlxG.autoPause = false;

			FlxG.switchState(new FreeplayState());
		}
	}


		// var rating:FlxSprite = null;
		// var oldRat = 'nulo';
		var endingSong:Bool = false;
		// var comboSpr:FlxSprite = null;

	private function popUpScore(strumtime:Float, ?forceSick:Bool = false):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// bf.playAnim('hey');
		voices.music.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.80;
		//

		var score:Int = 350;

		var daRating:String = "sick";

		noteHits ++;
		if (FlxG.save.data.botPlay || forceSick){
			sicks ++;
			sickscap ++;
			noteHitted += 1;
		}else{
		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			noteHitted += 0.1;
			daRating = 'shit';
			score = 50;
			shits ++;
			miss ++;
			shitscap ++;
			misscap ++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			noteHitted += 0.4;
			daRating = 'bad';
			score = 100;
			bads ++;
			badscap ++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			noteHitted += 0.6;
			daRating = 'good';
			score = 200;
			goods ++;
			goodscap ++;
		} else if (noteDiff > Conductor.safeZoneOffset * 0.1){
			sicks ++;
			sickscap ++;
			noteHitted += 1;
			// trace(strumtime);
		}}

		updateAcc();
		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		// if (rating == null && oldRat != daRating){
		var	rating = new FlxSprite();
		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.color = FlxColor.fromRGB(0,255,0);
		rating.scrollFactor.set();
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.cameras = [camHUD];
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.updateHitbox();

	
	// }

			// if (comboSpr == null){
				var comboSpr = new FlxSprite();
				comboSpr.loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
				comboSpr.screenCenter();
				comboSpr.x = coolText.x;
				comboSpr.acceleration.y = 600;
				comboSpr.scrollFactor.set();
				comboSpr.velocity.y -= 150;
				comboSpr.color = rating.color;
				comboSpr.cameras = [camHUD];
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.velocity.x += FlxG.random.int(1, 10);
		comboSpr.updateHitbox();


		// }
		// if (rating!= null && oldRat != daRating){
		add(rating);
		// }
		var comboButString = Std.string(combo);
		var separe = comboButString.split('');


		// var seperatedScore:Array<Int> = [];

		// seperatedScore.push(Math.floor(combo / 100));
		// seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		// seperatedScore.push(combo % 10);

		for (i in 0...separe.length)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + separe[i] + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * i) - 90;
			numScore.y += 80;
			numScore.color = FlxColor.fromRGB(0,255,0);
			numScore.scrollFactor.set();
			numScore.cameras = [camHUD];

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10){
				add(numScore);
			if (comboSpr != null ){
				add(comboSpr);
			}
			}

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		// coolText.text = Std.string(seperatedScore);
		// add(coolText);
		if (rating != null){

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});
	}
	if (comboSpr != null){
		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				if (comboSpr != null)
				comboSpr.destroy();
				if (rating != null)
				rating.destroy();
				
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

		curSection += 1;
	}
	function canPress(note:Note,ola:Bool){
		return (note.y <= strumLine.y - 20 && (!ola)) || (note.y >= strumLine.y + 30 && (ola) );
	}

	private function keyShit():Void
	{

		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !bf.stunned && generatedMusic)
		{
			bf.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				// if (perfectMode)
					// noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList){
									badNoteCheck(gostoTrapin,coolNote);
								}
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}

			}
			else
			{
				badNoteCheck(gostoTrapin,null);
			}
		}

		if ((up || right || down || left) && !bf.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (bf.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (bf.animation.curAnim.name.startsWith('sing') && !bf.animation.curAnim.name.endsWith('miss'))
			{
				bf.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.ID != 5 && !FlxG.save.data.botPlay){
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
				}
		});
	}

	function noteMiss(direction:Int = 1, ?daNote:Note):Void
	{
		if (FlxG.save.data.botPlay){
		
			return;
		}
		if (!bf.stunned)
		{
			if (combo > 10 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;
			miss ++;
			misscap ++;
			noteHitted -= 0.5;
			updateAcc();
			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			bf.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				bf.stunned = false;
			});
			if (mods.notes_from == 'dad'){
			health += 0.04;

				switch (direction)
				{
					case 0:
						dad.playAnim('singLEFTmiss', true);
					case 1:
						dad.playAnim('singDOWNmiss', true);
					case 2:
						dad.playAnim('singUPmiss', true);
					case 3:
						dad.playAnim('singRIGHTmiss', true);
				}
			} else {
			health -= 0.04;

				switch (direction)
				{
					case 0:
						bf.playAnim('singLEFTmiss', true);
					case 1:
						bf.playAnim('singDOWNmiss', true);
					case 2:
						bf.playAnim('singUPmiss', true);
					case 3:
						bf.playAnim('singRIGHTmiss', true);
				}
			}

		
		}
		
	}

	function badNoteCheck(ignore:Bool, daNote:Note)
	{
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		if (!ignore){
		if (leftP)
			noteMiss(0,daNote);
		if (downP)
			noteMiss(1,daNote);
		if (upP)
			noteMiss(2,daNote);
		if (rightP)
			noteMiss(3,daNote);
	}
	
	}

	
	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck(true,note);
		}	
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
					popUpScore(note.strumTime);

				combo += 1;
			}



			switch(note.notePara){
				case 'dad':

			switch (note.noteData)
				{
					case 0:
						dad.playAnim('singLEFT', true);
					case 1:
						dad.playAnim('singDOWN', true);
					case 2:
						dad.playAnim('singUP', true);
					case 3:
						dad.playAnim('singRIGHT', true);
				}
				case 'bf':
					health += 0.04;

				switch (note.noteData)
				{
					case 0:
						bf.playAnim('singLEFT', true);
					case 1:
						bf.playAnim('singDOWN', true);
					case 2:
						bf.playAnim('singUP', true);
					case 3:
						bf.playAnim('singRIGHT', true);
				}
				default:
				if (mods.notes_from == 'dad'){
							
			health -= 0.04;
				switch (note.noteData)
				{
					case 0:
						dad.playAnim('singLEFT', true);
					case 1:
						dad.playAnim('singDOWN', true);
					case 2:
						dad.playAnim('singUP', true);
					case 3:
						dad.playAnim('singRIGHT', true);
				}
				}else {
			health += 0.04;

				switch (note.noteData)
				{
					case 0:
						bf.playAnim('singLEFT', true);
					case 1:
						bf.playAnim('singDOWN', true);
					case 2:
						bf.playAnim('singUP', true);
					case 3:
						bf.playAnim('singRIGHT', true);
				}
	
			}
			}


			playerStrums.press(note,FlxG.save.data.botPlay);

			note.wasGoodHit = true;
			voices.music.volume = 1;

				note.kill();
				notes.remove(note, true);
				note.destroy();
		}
	}

	var fastCarCanDrive:Bool = true;


	override function stepHit()
	{
		super.stepHit();
		if (SONG.event == null)
			SONG.event = [];
		if (SONG.event[curStep] != null){
			
			var ev = SONG.event[curStep];
			var realArgs = ev.eventArgs.replace(' ','').split(',');

			switch(ev.eventName){
				// case 'c'
				case 'move-player-strums','mps','0':
					playerStrums.move(realArgs[0] == 'true',{x:Std.parseFloat(realArgs[1]),y:Std.parseFloat(realArgs[2]),vel:Std.parseFloat(realArgs[3])},realArgs[4].toLowerCase() == 'all' ? realArgs[4].toUpperCase() : Std.parseInt(realArgs[4]));
				case 'move-enemy-strums','mes','1':
					enemyStrums.move(realArgs[0] == 'true',{x:Std.parseFloat(realArgs[1]),y:Std.parseFloat(realArgs[2]),vel:Std.parseFloat(realArgs[3])},realArgs[4].toLowerCase() == 'all' ? realArgs[4].toUpperCase() : Std.parseInt(realArgs[4]));
			  case 'change char','2':
					switch(realArgs[0]){
						case 'dad','1':
							dad.kill();
							dad = new Character(dad.x,dad.y,realArgs[1]);
							add(dad);
						case 'boyfriend','bf','0':
							bf.kill();
							bf = new Boyfriend(bf.x,bf.y,realArgs[1]);
							add(bf);
						case 'gf','2':
							gf.kill();
							gf = new Character(gf.x,gf.y,realArgs[1]);
							add(gf);
					}
				case 'camera flash','3':
					var color_ = realArgs[0].split('.');
					var color = FlxColor.fromRGB(Std.parseInt(color_[0]),Std.parseInt(color_[1]),Std.parseInt(color_[2]));
					FlxG.camera.flash(color,Std.parseFloat(realArgs[1]));
				case 'makeText','4':
					// posX, posY, width, text, font, size, borderSize, alpha
					var posX:Float = 0;
					var posY:Float = 0;
					var o = realArgs;

					if (o[0] != 'sc') // should center???
					posX =  Std.parseFloat(o[0]);
					if (o[1] != 'sc') // should center???
					posY =  Std.parseFloat(o[1]);
					var s = new FlxText(posX,posY,Std.parseFloat(o[2]),o[3],Std.parseInt(o[5]));
					// if ()
					if (o[1] == 'sc' && o[0] == 'sc')
						s.screenCenter();
					else {
					if (o[0] == 'sc' && o[1] != 'sc') // should center???
						s.screenCenter(X);
					if (o[1] == 'sc' && o[0] != 'sc') // should center???
						s.screenCenter(Y);
				}
					if (o[4] != 'default')
						s.font = 'assets/fonts/' + o[4];
					s.borderSize = Std.parseInt(o[6]);
					s.alpha = Std.parseFloat(o[7]);
					trace(text.length);
					s.ID = text.length;
					text.add(s);
					// var graphic = new FlxSpri
				case 'changeText','5':
					var o = realArgs;
					// posX, posY, text, ID
					var posX:Float = 0;
					var posY:Float = 0;
					if (o[0] != 'sc') // should center???
						posX =  Std.parseFloat(o[0]);
					if (o[1] != 'sc') // should center???
						posY =  Std.parseFloat(o[1]);
					var ide = Std.parseInt(o[3]);
					text.forEach(function (_text:FlxText){
						if (_text.ID == ide){
						if (o[1] == 'sc' && o[0] == 'sc')
							_text.screenCenter();
						else {
						if (o[0] == 'sc' && o[1] != 'sc') // should center???
							_text.screenCenter(X);
						if (o[1] == 'sc' && o[0] != 'sc') // should center???
							_text.screenCenter(Y);
					}
					if (o[1] != 'sc' && o[0] != 'sc'){
						_text.x = posX;
						_text.y = posY;
					}
					_text.text = o[2];
				}
					});
				case 'kill text', '6':
					var o = realArgs[0];
					// ID
					text.forEach(function (_text:FlxText){
						if (_text.ID == Std.parseInt(o)){
							text.remove(_text,true);
						}});
				default:

					// null event????
			}
		}
	
		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();
		// if (curBeat == 50){
			// playerStrums.move(true,{x: -800,y:0,vel:0.5},"ALL");
		// }
		FlxG.watch.addQuick('spookyBeat', curBeat % 30  );
		if (curStage == 'philly'){
		if (!trainMoving)
			trainCooldown += 1;

		if (curBeat % 4 == 0)
		{
			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			var curLight = FlxG.random.int(0, phillyCityLights.length - 1);

			phillyCityLights.members[curLight].visible = true;
			// phillyCityLights.members[curLight].alpha = 1;
		}

		if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
		{
			trainCooldown = FlxG.random.int(-4, 0);
			trainStart();
		}
	}
		if (curBeat % 30 == 0){
			if (curStage == 'spooky')
				{
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					halloweenBG.animation.play('lightning');
			
					lightningStrikeBeat = curBeat;
					lightningOffset = FlxG.random.int(8, 24);
			
					bf.playAnim('scared', true);
					gf.playAnim('scared', true);
				}
		}
		if (generatedMusic)
		{
			
			var caidaType = FlxG.save.data.downScroll;
			if (strumLine.y < 200)
				caidaType = false;
			notes.sort(FlxSort.byY, caidaType ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}
		wiggleShit.update(Conductor.crochet);

		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}
		if (curBeat % 4 == 0){
			if(FlxG.save.data.botPlay || !bf.animation.curAnim.name.startsWith('sing'))
			bf.dance();
			dad.dance();
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			bf.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			bf.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

	}

}
