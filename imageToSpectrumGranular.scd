(
// prepare things, boot the server, set paths

s.boot;

// load some functions
"functions/loadImage.scd".loadRelative;

// put an image into the img folder, then specify the file name here:
~imagePath = "trametes.png";
)

(
// to see what is going on

s.meter;
s.scope;
)


(
// load the image

~image = ~loadImageGray.value(Document.current.dir +/+ "img" +/+ ~imagePath);
("Image loaded: " + ~image.width + "x" + ~image.height + " pixels ...").postln;
)

(
// we create a Buffer (in a sense a series of values) for each of the lines in the image

~lines = Array.newClear(~image.height);

~image.height.do {|y|
	var array = Array.newClear(~image.width);
	~image.width.do {|x|
		array[x] = ~image.pixels[y * ~image.width + x];
		// invert:
		// array[x] = 1.0 - ~image.pixels[y * ~image.width + x];
	};
	~lines[y] = array;
};
)


// we can inspect the lines as curves
~lines[~image.height/2].plot

(
// a simple sound grain with a short sine wave

SynthDef(\spectralGrain, {|freq=440, amp=0.01, buffer=0, length=0.001, pan=0, out=0, phase=0|
	var env = EnvGen.ar(Env.sine(length), doneAction: 2);
	var sig = SinOsc.ar(freq, phase) * amp * env;
	OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;
)

// let us test a single grain
(instrument: \spectralGrain, freq: 440, length: 0.01).play;

// a longer one!
(instrument: \spectralGrain, freq: 440, length: 0.2).play;


(
// how we map y-position to frequency

~lowFreq = 60;
~highFreq = 20000;

// the function
~freqMap = {|y|
	// invert y axis; top lines should be highest freqs
	y = ~image.height - y;
	y.linexp(0, ~image.height, ~lowFreq, ~highFreq);
	// linear to exponential mapping has a more balanced spectrum (towards the low notes)
	// y.linexp(0, ~image.height, ~lowFreq, ~highFreq);
};
)



(
// let's listen in!

var currentTime = 0;
~length = 200; // how long should the audio be in seconds?

Tdef(\grainSpectrum, {
	{currentTime < ~length}.while {
		// never put this to 0!!! or to numbers smaller than 0.0002
		var waitTime = 0.0005.rand;

		// take a random line
		var y = ~image.height.rand;

		// see at which x position we currently are
		var x = ((currentTime / ~length) * ~image.width).asInteger;

		var value = ~lines[y][x];

		// get an amplitude (and map linear to exponential)
		var amp = value.linexp(0, 1, 0.01, 0.25);

		// slightly panned by frequency
		var pan = y.linlin(0, ~image.height.rand, -1, 1) * 0.4;

		var grainLength = 0.002;

		// a grainLength related to the pixel value
		grainLength = value.linlin(0, 1, 0.00004, 0.005);

		(value > 0).if {
			(
				instrument: \spectralGrain,
				freq: ~freqMap.value(y),
				length: grainLength,
				pan: pan,
				amp: amp,
				phase: 2pi.rand
			).play;
		};

		currentTime = currentTime + waitTime;
		waitTime.wait;
	};
	"done!".postln;
}).play;
)

// enough of that!
Tdef(\grainSpectrum).stop;

// will start recording a file
s.record;

// will stop recording a file
// see in the post window where it is saved!
s.stopRecording