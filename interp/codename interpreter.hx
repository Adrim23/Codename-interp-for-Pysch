import backend.ClientPrefs;

var gameArr:Array<BitmapFilter> = [];
var hudArr:Array<BitmapFilter> = [];
var otherArr:Array<BitmapFilter> = [];

//interpreter

function onCreate(){
    game.setOnHScript('inst', game.inst);
    game.setOnHScript('voices', game.vocals);
    game.callOnHScript('create');
} function onCreatePost(){
    game.setOnHScript('FlxAxes', getVar('FXA'));
    game.setOnHScript('Options', getVar('OptionsCN'));
    game.setOnHScript('PlayState', getVar('PSCN'));
    game.setOnHScript('stage', getVar('stageCN'));
    game.setOnHScript('missesTxt', game.scoreTxt);
    game.setOnHScript('accuracyTxt', game.scoreTxt);
    game.setOnHScript("stageCheck", (valueXML:String) -> return (StringTools.contains(stage.stageXML, valueXML)) ? true : false);
    game.callOnHScript('postCreate');
} function onUpdate(elapsed){
    game.callOnHScript('update', [elapsed]);
} function onUpdatePost(elapsed){
    game.callOnHScript('postUpdate', [elapsed]);
} function onStepHit(){
    game.callOnHScript('stepHit');
} function onBeatHit(){
    game.callOnHScript('beatHit');
} function onSpawnNote(note){
    game.callOnHScript('onNoteCreation', [note]);
    new FlxTimer().start(0.05, function(t:FlxTimer){
        game.callOnHScript('onPostNoteCreation', [note]);
    });
} function goodNoteHit(note){
    setVar('lastGoodHit', note);
} function opponentNoteHit(note){
    setVar('lastOPHit', note);
} function noteMiss(note){
    if (!PlayState.opponentMode)
        setVar('lastMiss', note);
} function opponentNoteMiss(note){
    if (PlayState.opponentMode)
            setVar('lastMiss', note);
} function onPause(){
    game.callOnHScript('onGamePause');
} function onSpawnNote(note){
    setVar('lastSpawn', note);
} function onStartCountdown(){
    for (i in 0...8){
        var event = getVar('SCPre');
        event.strum = game.strumLineNotes.members[i];
        new FlxTimer().start(0.05, function(t:FlxTimer){
        event.sprite = game.strumLineNotes.members[i].texture;
        game.callOnHScript('onStrumCreation', [event]);
        });
    }
} function onDestroy(){
    game.callOnHScript('destroy');
}

function cameraFromString(cam:String):FlxCamera {
    switch(cam.toLowerCase()) {
        case 'camhud' | 'hud': return PlayState.instance.camHUD;
        case 'camother' | 'other': return PlayState.instance.camOther;
    }
    return PlayState.instance.camGame;
}