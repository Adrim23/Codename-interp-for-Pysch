local dkjson = require("mods/scripts/json/dkjson")
foundBF = false
foundDAD = false

--Options interp
local Options = {
 downscroll = false,
 ghostTapping = true,
 flashingMenu = true,
 camZoomOnBeat = true,
 fpsCounter = true,
 autoPause = true,
 antialiasing = true,
 gameplayShaders = true,
 lowMemoryMode = true,
 songOffset = 0,
 framerate = 60,
}

--NoteHitEvent
local eventHit = {
    misses = false,
    countAsCombo = true,
    countScore = true,
    character = '',
    player = false,
    noteType = '',
    animSuffix = '',
    direction = 0,
    healthGain = 0,
    rating = 'sick',
    showRating = true,
    note = {
        pyschNote = '',
        wasGoodHit = false,
        canBeHit = false,
        tooLate = false,
        avoid = false,
        isSustainNote = false,
        sustainLength = 0,
        noteType = '',
        scrollSpeed = 1,
        noteAngle = 0,
        swagWidth = 0,
        animSuffix = 0,
        earlyPressWindow = 1,
        latePressWindow = 1,
    }
}

--NoteMissEvent
local eventMiss = {
    misses = false,
    character = '',
    player = false,
    noteType = '',
    animSuffix = '',
    direction = 0,
    healthGain = 0,
    note = {
        pyschNote = '',
        wasGoodHit = false,
        canBeHit = false,
        tooLate = false,
        avoid = false,
        isSustainNote = false,
        sustainLength = 0,
        noteType = '',
        scrollSpeed = 1,
        noteAngle = 0,
        swagWidth = 0,
        animSuffix = 0,
        earlyPressWindow = 1,
        latePressWindow = 1,
    }
}

--PlayState interp
local PlayState = 
{
    instance = {
        'PlayState.hx here'
    },
    SONG = {
        strumLines = {
            characters = {'bf', 'dad'}
        },
        meta = {
            name = songName,
            bpm = curBpm,
            displayName = songName,
            needsVoices = true,
        }
    },
    difficulty = difficultyName,
    isStoryMode = isStoryMode,
    storyWeek = 'tutorial',
    chartingMode = false,
    opponentMode = leftSide,
    stage = curStage,
    scrollSpeed = scrollSpeed,
}

--interp strums
local strumEvent = {
    strum = '',
    sprite = '',
}

--interp NoteCreationEvent
local creationEvent = {
    note = {
        pyschNote = '',
        noteType = '',
        scrollSpeed = 1,
        noteAngle = 0,
        swagWidth = 0,
        animSuffix = 0,
        earlyPressWindow = 1,
        latePressWindow = 1,
    },
    noteType = '',
    mustHit = true,
    noteSprite = '',
    noteScale = '',
    animSuffix = '',
}

--interp stage
local stage = {
    stageXML = ''
}

--interp for FlxAxes
local FlxAxes = {
 X = 0x01,
 Y = 0x10,
 XY = 0x11,
}

function onCreate()
    setVar('FXA', FlxAxes)
    stagejson = dkjson.decode(getTextFromFile('stages/'..curStage..'.json', false), 1, nil)
    PlayState = 
    {
        instance = {
            'PlayState.hx here'
        },
        SONG = {
            strumLines = {
                characters = {'bf', 'dad'}
            },
            meta = {
                name = songName,
                bpm = curBpm,
                displayName = songName,
                needsVoices = true,
            }
        },
        difficulty = difficultyName,
        isStoryMode = isStoryMode,
        storyWeek = 'tutorial',
        chartingMode = false,
        opponentMode = leftSide,
        stage = curStage,
        scrollSpeed = scrollSpeed,
    }

    stage = {
        stageXML = stagejson
    }

 setVar('OptionsPre', Options)
 setVar('PSPre', PlayState)
 setVar('SCPre', strumEvent)
 setVar('stageCN', stage)
 runHaxeCode([[
    import backend.ClientPrefs;
    var toChange = getVar('OptionsPre');
    toChange.downscroll = ClientPrefs.data.downScroll;
    toChange.ghostTapping = ClientPrefs.data.ghostTapping;
    toChange.flashingMenu = ClientPrefs.data.flashing;
    toChange.camZoomOnBeat = ClientPrefs.data.camZooms;
    toChange.fpsCounter = ClientPrefs.data.showFPS;
    toChange.autoPause = ClientPrefs.data.autoPause;
    toChange.gameplayShaders = ClientPrefs.data.shaders;
    toChange.lowMemoryMode = ClientPrefs.data.lowQuality;
    toChange.songOffset = ClientPrefs.data.noteOffset;
    toChange.framerate = ClientPrefs.data.framerate;
    setVar('OptionsCN', toChange);

    var toChangePS = getVar('PSPre');
    toChangePS.instance = PlayState;
    toChangePS.SONG.strumLines.characters[0] = game.boyfriend;
    toChangePS.SONG.strumLines.characters[1] = game.dad;
    toChangePS.SONG.meta.needsVoices = PlayState.SONG.needsVoices;
    toChangePS.storyWeek = PlayState.storyWeek;
    toChangePS.chartingMode = PlayState.chartingMode;
    setVar('PSCN', toChangePS);
 ]])

 for i = 1,#directoryFileList(currentModDirectory..'/songs') do
    if stringEndsWith(directoryFileList(currentModDirectory..'/songs')[i], ".hx") then
        addHScript(i)
    end
 end
 for i = 1,#directoryFileList(currentModDirectory..'/songs/'..songName..'/scripts') do
    if stringEndsWith(directoryFileList(currentModDirectory..'/songs/'..songName..'/scripts')[i], ".hx") then
        addHScript(i)
    end
 end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    setVar('eventPre', eventHit)
    runTimer('delayLuaPH', 0.01)
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
  setVar('eventPreDad', eventHit)
  runTimer('delayLuaDH', 0.01)
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
  if not leftSide then
  setVar('eventMissPre', eventMiss)
  runTimer('delayLuaPM', 0.01)
  end
end

function opponentNoteMiss(membersIndex, noteData, noteType, isSustainNote)
  if leftSide then
  setVar('eventMissPre', eventMiss)
  runTimer('delayLuaDM', 0.01)
  end
end

function onSpawnNote()
    setVar('eventNCPre', creationEvent)
    runTimer('delayLuaNC', 0.01)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'delayLuaPH' then
        runHaxeCode([[
            var event = getVar('eventPre');
            event.misses = getVar('lastGoodHit').missed;
            event.countAsCombo = getVar('lastGoodHit').ignoreNote;
            event.showRating = !getVar('lastGoodHit').ratingDisabled;
            event.rating = getVar('lastGoodHit').rating;
            event.character = (getVar('lastGoodHit').gfNote) ? gf.curCharacter : boyfriend.curCharacter;
            event.player = getVar('lastGoodHit').mustPress;
            event.noteType = getVar('lastGoodHit').noteType;
            event.animSuffix = getVar('lastGoodHit').animSuffix;
            event.direction = getVar('lastGoodHit').noteData;
            event.healthGain = (getVar('lastGoodHit').missed) ? -getVar('lastGoodHit').hitHealth : getVar('lastGoodHit').hitHealth;
            event.note.pyschNote = getVar('lastGoodHit');
            event.note.wasGoodHit = getVar('lastGoodHit').wasGoodHit;
            event.note.avoid = getVar('lastGoodHit').hitCausesMiss;
            event.note.canBeHit = getVar('lastGoodHit').canBeHit;
            event.note.tooLate = getVar('lastGoodHit').tooLate;
            event.note.isSustainNote = getVar('lastGoodHit').isSustainNote;
            event.note.sustainLength = getVar('lastGoodHit').sustainLength;
            event.note.scrollSpeed = getVar('lastGoodHit').multSpeed;
            event.note.noteAngle = getVar('lastGoodHit').offsetAngle;
            event.note.swagWidth = getVar('lastGoodHit').swagWidth;
            event.note.animSuffix = getVar('lastGoodHit').animSuffix;
            event.note.earlyPressWindow = getVar('lastGoodHit').earlyHitMult;
            event.note.latePressWindow = getVar('lastGoodHit').lateHitMult;
            game.callOnHScript('onPlayerHit', [event]);
            game.callOnHScript('onNoteHit', [event]);
           ]])
    end

    if tag == 'delayLuaDH' then
        runHaxeCode([[
            var event = getVar('eventPreDad');
            event.misses = getVar('lastOPHit').missed;
            event.countAsCombo = getVar('lastOPHit').ignoreNote;
            event.showRating = !getVar('lastOPHit').ratingDisabled;
            event.rating = getVar('lastOPHit').rating;
            event.character = (getVar('lastOPHit').gfNote) ? gf.curCharacter : boyfriend.curCharacter;
            event.player = getVar('lastOPHit').mustPress;
            event.noteType = getVar('lastOPHit').noteType;
            event.animSuffix = getVar('lastOPHit').animSuffix;
            event.direction = getVar('lastOPHit').noteData;
            event.healthGain = (getVar('lastOPHit').missed) ? -getVar('lastOPHit').hitHealth : getVar('lastOPHit').hitHealth;
            event.note.pyschNote = getVar('lastOPHit');
            event.note.wasGoodHit = getVar('lastOPHit').wasGoodHit;
            event.note.avoid = getVar('lastOPHit').hitCausesMiss;
            event.note.canBeHit = getVar('lastOPHit').canBeHit;
            event.note.tooLate = getVar('lastOPHit').tooLate;
            event.note.isSustainNote = getVar('lastOPHit').isSustainNote;
            event.note.sustainLength = getVar('lastOPHit').sustainLength;
            event.note.scrollSpeed = getVar('lastOPHit').multSpeed;
            event.note.noteAngle = getVar('lastOPHit').offsetAngle;
            event.note.swagWidth = getVar('lastOPHit').swagWidth;
            event.note.animSuffix = getVar('lastOPHit').animSuffix;
            event.note.earlyPressWindow = getVar('lastOPHit').earlyHitMult;
            event.note.latePressWindow = getVar('lastOPHit').lateHitMult;
            game.callOnHScript('onDadHit', [event]);
            game.callOnHScript('onNoteHit', [event]);
          ]])
    end

    if tag == 'delayLuaPM' then
        runHaxeCode([[
            var event = getVar('eventMissPre');
            event.misses = getVar('lastMiss').missed;
            event.character = (getVar('lastMiss').gfNote) ? gf.curCharacter : boyfriend.curCharacter;
            event.player = getVar('lastMiss').mustPress;
            event.noteType = getVar('lastMiss').noteType;
            event.animSuffix = getVar('lastMiss').animSuffix;
            event.direction = getVar('lastMiss').noteData;
            event.healthGain = (getVar('lastMiss').missed) ? -getVar('lastMiss').hitHealth : getVar('lastMiss').hitHealth;
            event.note.pyschNote = getVar('lastMiss');
            event.note.wasGoodHit = getVar('lastMiss').wasGoodHit;
            event.note.avoid = getVar('lastMiss').hitCausesMiss;
            event.note.canBeHit = getVar('lastMiss').canBeHit;
            event.note.tooLate = getVar('lastMiss').tooLate;
            event.note.isSustainNote = getVar('lastMiss').isSustainNote;
            event.note.sustainLength = getVar('lastMiss').sustainLength;
            event.note.scrollSpeed = getVar('lastMiss').multSpeed;
            event.note.noteAngle = getVar('lastMiss').offsetAngle;
            event.note.swagWidth = getVar('lastMiss').swagWidth;
            event.note.animSuffix = getVar('lastMiss').animSuffix;
            event.note.earlyPressWindow = getVar('lastMiss').earlyHitMult;
            event.note.latePressWindow = getVar('lastMiss').lateHitMult;
            game.callOnHScript('onPlayerMiss', [event]);
           ]])
    end

    if tag == 'delayLuaDM' then
        runHaxeCode([[
            var event = getVar('eventMissPre');
            event.misses = getVar('lastMiss').missed;
            event.character = (getVar('lastMiss').gfNote) ? gf.curCharacter : boyfriend.curCharacter;
            event.player = getVar('lastMiss').mustPress;
            event.noteType = getVar('lastMiss').noteType;
            event.animSuffix = getVar('lastMiss').animSuffix;
            event.direction = getVar('lastMiss').noteData;
            event.healthGain = (getVar('lastMiss').missed) ? -getVar('lastMiss').hitHealth : getVar('lastMiss').hitHealth;
            event.note.pyschNote = getVar('lastMiss');
            event.note.wasGoodHit = getVar('lastMiss').wasGoodHit;
            event.note.avoid = getVar('lastMiss').hitCausesMiss;
            event.note.canBeHit = getVar('lastMiss').canBeHit;
            event.note.tooLate = getVar('lastMiss').tooLate;
            event.note.isSustainNote = getVar('lastMiss').isSustainNote;
            event.note.sustainLength = getVar('lastMiss').sustainLength;
            event.note.scrollSpeed = getVar('lastMiss').multSpeed;
            event.note.noteAngle = getVar('lastMiss').offsetAngle;
            event.note.swagWidth = getVar('lastMiss').swagWidth;
            event.note.animSuffix = getVar('lastMiss').animSuffix;
            event.note.earlyPressWindow = getVar('lastMiss').earlyHitMult;
            event.note.latePressWindow = getVar('lastMiss').lateHitMult;
            game.callOnHScript('onPlayerMiss', [event]);
           ]])
    end

    if tag == 'delayLuaNC' then
        runHaxeCode([[
            var event = getVar('eventNCPre');
            event.mustHit = !getVar('lastSpawn').ignoreNote;
            event.noteType = getVar('lastSpawn').noteType;
            event.noteSprite = getVar('lastSpawn').texture;
            event.noteScale = getVar('lastSpawn').scale;
            event.animSuffix = getVar('lastSpawn').animSuffix;
            event.note.pyschNote = getVar('lastGoodHit');
            game.callOnHScript('onNoteCreation', [event]);
            new FlxTimer().start(0.05, function(t:FlxTimer){game.callOnHScript('onPostNoteCreation', [event]);});
           ]])
    end
end