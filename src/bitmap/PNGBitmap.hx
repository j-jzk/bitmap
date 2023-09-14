package bitmap;

import haxe.io.Output;
import bitmap.*;
import bitmap.support.ZipSupport;
import bitmap.Types.PixelFormat;
import format.png.*;

@:expose class PNGBitmap extends AbstractBitmap {
	override public function load(input:haxe.io.Input, ?f:PixelFormat) {
		if (f == null) {
			f = PixelFormat.RGBA;
		}
		if (f != PixelFormat.RGBA && f != PixelFormat.ARGB) {
			throw "Image format not supported";
		}
		var d = new format.png.Reader(input).read();
		var hdr = Tools.getHeader(d);
		width = hdr.width;
		height = hdr.height;
		format = f;
		data = Tools.extract32(d);
		Tools.reverseBytes(data);
		if (format == PixelFormat.RGBA) {
			PixelFormatUtil.argbToRgba(data);
		}
	}

	override public function save(output:Output):Void {
		ZipSupport.haxeZipCompressJsSupport();
		var copy = data.sub(0, data.length);
		if (format == null || format == PixelFormat.RGBA) {
			copy = PixelFormatUtil.rgbaToArgb(copy);
		}
		/*
		9 = 3660 ms
		7 = 1429 ms
		5 = 1365 ms
		3 =  980 ms
		1 =  957 ms
		0 = 8094 ms (!)
		-1 (?) = 1566 ms
		*/
		var data = Tools.build32ARGB(width, height, copy, 3);
		new Writer(output).write(data);
	}

	public static function create(input:haxe.io.Input, ?format:PixelFormat) {
		var bitmap = new PNGBitmap();
		bitmap.load(input, format);
		return bitmap;
	}

	override public function copy(r:Types.Rectangle):Bitmap {
		if (r == null) {
			r = bounds();
		}
		var b = new PNGBitmap(r.width, r.height);
    b.noRangeCheck=noRangeCheck;
		b.copyFrom(this, {x:r.x,y:r.y}, {x:0,y:0,width: r.width, height:r.height});
		return b;
	}
}
