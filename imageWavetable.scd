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
// how long should the sound be in seconds?
~length = 60;

// fundamental frequency of oscillations on the x axis
~xFrequency = 50;

// calculats how many samples it should be
~numSamples = ~length * s.sampleRate;


// a function(t), where we read the image on the x axis (normalized, 0 to 1)
~xFunction = {|t|
	(t * 2pi * ~xFrequency).sin * 0.5 + 0.5;
};

~yFunction = {|t|
	(t / ~length);
	// 1.0 - (t / ~length);
};

)


(
// free buffers if we have already allocated them ...

~buffer.free;

// we create a Buffer (in a sense a series of values) for each of the lines in the image
~array = Array.newClear(~numSamples);

"might take a while ...".postln;
~numSamples.do {|n|
	// calculate time for each sample
	var t = n / s.sampleRate;

	// calculate where we should read from in the image
	var x = (~xFunction.value(t).max(0).min(1) * ~image.width).floor;
	var y = (~yFunction.value(t).max(0).min(1) * ~image.height).floor;

	// retreive our pixel from the image
	var pixelIndex = (y * ~image.width + x).asInteger;
	var pixelValue = ~image.pixels[pixelIndex];
	pixelValue.isNil.if {
		pixelValue = 0.5;
	};

	// scale it for playback
	~array[n] = pixelValue * 2.0 - 1.0;
};

~buffer = Buffer.loadCollection(s, ~array);

"... done!".postln;
)


// we can plot the buffer
~buffer.plot;

// and play it!
{LeakDC.ar(PlayBuf.ar(1, ~buffer, 1, doneAction: 2).dup * 0.2)}.play


// will start recording a file
s.record;

// will stop recording a file
// see in the post window where it is saved!
s.stopRecording

