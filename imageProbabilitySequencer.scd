(
// start up the audio system

"functions/mc-engine.scd".loadRelative;
~initWorld.();

// Use some Brian-Eno style synths as sounds
"functions/mc-eno.scd".loadRelative;
~out = ~initEnoOut.();

// Use this if you want to play out to some MIDI device
// ~out = ~initMIDIOut.("Microsoft GS Wavetable Synth");
// ~out = ~initMIDIOut.("Yamaha USB-MIDI-1");

)

(
// initialize our image agents

~filename = "trametes-small-gray.png";

~initLoadFungus.(Document.current.dir ++ "/img/" ++ ~filename);

// how many agents should run
~initAgents.(32);
)

(
// the functions that should be used

var activeAgents = 32;
var fungusKey = ~filename.split($.).first;

~storeAllAgents.();

~wAgents.do {|agent, i|
	// {|x, y, agent| 1.0 }

	var p = ~pFungus.(fungusKey).pow(2);

	// try other scales: Scale.chromatic, Scale.major, Scale.lydian, ...
	// Scale.directory

	p = p * (~pScale.(Scale.minorPentatonic,2));

	// there are numerous shaping functions still to be documented ...
	// this shapes the propability, rolling off super low notes and super high notes.
	p = p - (~pSineWindow.(0, 0.1) + (~pSineWindow.(1, 0.2) * 0.25));

	agent[\pPlay] = p;

	agent[\durMap] = Prand([1, 0.5, 0.25, 0.75], inf) * 1;
	agent[\velMap] = ~defaultVelMap * 1 + {[0, 0, 0, 0, 0, 10 + 5.rand].choose};
	agent[\quant] = 2;

	// never let this be 1 or close to 1 ...
	agent[\pRetry] = {|x, y, agent| 0.9 };

	agent[\lenMap] = Prand([0.125, 0.5, 1, 0.75], inf) * 2;


	agent[\act] = ~eno;
	agent[\echo] = false;
	agent[\active] = i < activeAgents;
};
)

(
// PLAY IT (might take a while to start, depending on how black the image is at the beginning)

~length = 60 * 4; // in seconds or minutes (if you multiply by 60)
~runAgents.(~length, {|i| i * 0.325});
)

// will start recording a file
s.record;

// will stop recording a file
// see in the post window where it is saved!
s.stopRecording
