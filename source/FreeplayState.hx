package;

import flixel.FlxSubState;
import sys.FileSystem;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var posibleDif:Array<String> = [];
	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		// addSong('tutorial',0,'gf');
		for (i in 0...StoryMenuState.weekData.length){
			var daWeek = StoryMenuState.weekData[i];
			var daChars = StoryMenuState.weekCharacters[i][0];
			addWeek(daWeek,i,[daChars]);
		}
		// addNewSong("tutorial");


		// if (mapa.get('el pepe')) // cambia esto por tu canción
		// 	addSong('el pepe',0,'bf');




		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		super.create();
	}
// public function addNewSong(song:String){
// 	addSong(song, 0, checkIcon(song));
// }
// public function checkIcon(s:String):String {
// 	var icon:String = 'bf';
// 	switch (s.toLowerCase()){
// 		case 'tutorial': icon = 'gf';
// 		case 'boopebo','fresh','dadbattle':icon = "dad";
// 		case 'spookeez','south': icon = 'spooky';
// 		case 'pico','philly','blammed': icon = 'pico';


// 	}
// 	return icon;
// }
	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}
	// var canMove = true;
	override function openSubState(s:FlxSubState){
		super.openSubState(s);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// if (FlxG.keys.justPressed.O){
		// 	FlxG.save.data.songs_.clear();
		// }
		if (FlxG.keys.justPressed.CONTROL){
			openSubState(new Modif());
		}
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.1 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;


		if (FlxG.keys.justPressed.UP)
		{
			changeSelection(-1);
		}
		if (FlxG.keys.justPressed.DOWN)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.L) {
		var 	poop = 'freedom dive';
		if (FileSystem.exists('assets/data/$poop/$poop.json'))
			PlayState.SONG = Song.loadFromJson(poop, poop.toLowerCase());
		else
			PlayState.SONG =  {
				song: songs[curSelected].songName.toLowerCase(),
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				speed: 1,
				validScore: false
			};

		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		PlayState.storyWeek = songs[curSelected].week;
		trace('CUR WEEK' + PlayState.storyWeek);
		niz_tools.LoadState.load(new PlayState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			var poop:String = songs[curSelected].songName.toLowerCase();
			if (posibleDif.length > 1){
			switch(posibleDif[curDifficulty].toLowerCase()){
				case 'hard':
					poop = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), 2);
				case 'easy':
					poop = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), 0);
				case 'normal':
					poop = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), 1);
				default:
					poop = '${songs[curSelected].songName.toLowerCase()}-${posibleDif[curDifficulty].toLowerCase()}';
			}
		} else {
			if (posibleDif[curDifficulty].toLowerCase().startsWith('hard')){
				poop = '${songs[curSelected].songName.toLowerCase()}-hard';
			} else if (posibleDif[curDifficulty].toLowerCase().startsWith('easy')){
				poop = '${songs[curSelected].songName.toLowerCase()}-easy';
			} else if (posibleDif[curDifficulty].toLowerCase().startsWith('normal')){
				poop = '${songs[curSelected].songName.toLowerCase()}';
			} else {
				poop = '${songs[curSelected].songName.toLowerCase()}-${posibleDif[curDifficulty].toLowerCase()}';

			}
			
		}

			trace(poop);
			if (FileSystem.exists('assets/data/${songs[curSelected].songName.toLowerCase()}/$poop.json'))
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			else
				PlayState.SONG =  {
					song: songs[curSelected].songName.toLowerCase(),
					notes: [],
					bpm: 150,
					needsVoices: true,
					player1: 'bf',
					player2: 'dad',
					speed: 1,
					validScore: false
				};
				PlayState.songID = curSelected;

			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			niz_tools.LoadState.load(new PlayState());
		}
	
	}

	function changeDiff(change:Int = 0)
	{
		var song = songs[curSelected].songName.toLowerCase();

		if (FileSystem.exists('assets/data/$song')){
		posibleDif = [];
		var s = FileSystem.readDirectory('assets/data/${songs[curSelected].songName.toLowerCase()}');
		var itsJustOne = false;
		var song = songs[curSelected].songName.toLowerCase();
		if (FileSystem.exists('assets/data/$song/$song-easy.json')){
			if (s.length > 1)
				posibleDif.push('EASY');
			else
				posibleDif.push('EASY - but null cuz its a only diff');
		} 
		if (FileSystem.exists('assets/data/$song/$song.json')) {
			if (s.length > 1)
				posibleDif.push('NORMAL');
			else
				posibleDif.push('NORMAL - but null cuz its a only diff');

		}
		if (FileSystem.exists('assets/data/$song/$song-hard.json')) {
			if (s.length > 1)
				posibleDif.push('HARD');
			else
				posibleDif.push('HARD - but null cuz its a only diff');
		}
		if (s.length > 1){

			for (i in 0...s.length){
				s[i] = s[i].replace('.json','');
				
				var si = (s[i].split('${songs[curSelected].songName.toLowerCase()}-')[1]);
				if (si!= 'hard' && s[i] != '$song' && si != 'easy'){
					posibleDif.push(si);
				}
			}
		} else {
			s[0] = s[0].replace('.json','');
				
			var si = (s[0].split('${songs[curSelected].songName.toLowerCase()}-')[1]);
			if (si!= 'hard' && s[0] != '$song' && si != 'easy'){
				posibleDif.push(si);
				itsJustOne = true;
				
			}
		} 
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = posibleDif.length - 1;
		if (curDifficulty >= posibleDif.length)
			curDifficulty = 0;

		FlxG.watch.addQuick('si', curDifficulty);
		FlxG.watch.addQuick('sint', change);
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		if (posibleDif[curDifficulty].endsWith('- but null cuz its a only diff') || itsJustOne){
			diffText.text = '';
			scoreText.y = 25;
	} else {
		diffText.text = posibleDif[curDifficulty].toUpperCase() #if debug +  ' - debug' #end;
		scoreText.y = 5;

	}
	} else {
		diffText.text = 'épico la song es null';
		scoreText.y = 5;

	}

	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end
		changeDiff(0);
		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
