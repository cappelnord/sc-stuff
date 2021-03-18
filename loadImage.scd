~loadImageRGB = {|file|
	var image = Image.open(file);

	var pixels = image.pixels;
	var array = Array.newClear(pixels.size);

	pixels.do {|c, i|
		var color = Image.pixelToColor(c);
		array[i] = [color.red, color.green, color.blue];
	};

	(pixels: array, width: image.width, height: image.height);
};

~loadImageGray = {|file|
	var image = Image.open(file);

	var pixels = image.pixels;
	var array = Array.newClear(pixels.size);

	pixels.do {|c, i|
		var color = Image.pixelToColor(c);
		array[i] = (0.3 * color.red) + (0.59 * color.green) + (0.11 * color.blue);
	};

	(pixels: array, width: image.width, height: image.height);
};
