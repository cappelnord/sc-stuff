// prepare things, boot the server, set paths
(
s.options.numBuffers = 2**16;
s.boot;

// load some functions
"loadImage.scd".loadRelative;

// put an image into the img folder, then specify the file name here:
~imagePath = "trametes-small-gray.png";
)

// to see what is going on
(
s.meter;
s.scope;
)


(
// load the image
~image = ~loadImageGray.value(Document.current.dir +/+ "img" +/+ ~imagePath);
("Image loaded: " + ~image.width + "x" + ~image.height + " pixels ...").postln;
)

(
// free buffers if we have already allocated them ...
~buffers.do {|b|
	b.free;
};

// we create a Buffer (in a sense a series of values) for each of the lines in the image
~buffers = Array.newClear(~image.height);

"might take a while ...".postln;
~image.height.do {|y|
	var array = Array.newClear(~image.width);
	~image.width.do {|x|
		array[x] = ~image.pixels[y * ~image.width + x];
		// invert:
		// array[x] = 1.0 - ~image.pixels[y * ~image.width + x];
	};
	~buffers[y] = Buffer.loadCollection(s, array, 1);
};
"... done!".postln;
)

// we can inspect the lines as curves
~buffers[~image.height/2].plot

(
// This 'instrument' will play a sine oscillator at a certain frequency and will
// read its amplitude out of one of the buffers ...

SynthDef(\spectralComponent, {|freq=440, amp=0.01, buffer=0, length=10, pan=0, out=0, phase= 0|
	var bufferAmp = BufRd.ar(1, buffer, Line.ar(0, BufFrames.ir(buffer), length, doneAction: 2));
	var sig = SinOsc.ar(freq, phase) * amp * bufferAmp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

// let us test a single spectral component!
(instrument: \spectralComponent, amp: 0.2, buffer: ~buffers[~image.height/2], length: 20, freq: 440).play

(
~lowFreq = 20;
~highFreq = 20000;

// how we map y coordinate to frequency
~freqMap = {|y|
	// invert y axis; top lines should be highest freqs
	y = ~image.height - y;
	y.linlin(0, ~image.height, ~lowFreq, ~highFreq);
	// linear to exponential mapping has a more balanced spectrum (towards the low notes)
	// y.linexp(0, ~image.height, ~lowFreq, ~highFreq);
};
)



(
// PLAY TIME!

~length = 20; // how long should the audio be in seconds?

~image.height.do {|y|
	var freq = ~freqMap.value(y);
	var phase = 2pi.rand; // decorrelate phase, set to 0.0 for correlated phase
	var pan = 1.0.rand2; // distribute each spectral component randomly in stereo panorama
	(instrument: \spectralComponent, amp: 1.0 / ~image.height, buffer: ~buffers[y], length: ~length, freq: freq, pan: pan, phase: phase).play;
};
)


// will start recording a file
s.record;

// will stop recording a file
// see in the post window where it is saved!
s.stopRecording

