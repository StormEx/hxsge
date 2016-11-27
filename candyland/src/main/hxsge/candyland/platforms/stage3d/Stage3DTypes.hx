package hxsge.candyland.platforms.stage3d;

import hxsge.candyland.common.TextureFormat;
import flash.display3D.Context3DVertexBufferFormat;
import hxsge.candyland.common.geometry.VertexData;
import flash.display3D.Context3DBlendFactor;
import hxsge.candyland.common.material.BlendFactor;
import flash.Vector;
import hxsge.math.Matrix4;
import flash.geom.Matrix3D;

class Stage3DTypes {
	static var MATRIX:Matrix3D = new Matrix3D();

	public inline static function getMatrix3D(m:Matrix4):Matrix3D {
		var arr:Array<Float> = m;
		var vec:Vector<Float> = new Vector(arr.length, true);
		for(i in 0...arr.length) {
			vec[i] = arr[i];
		}
		MATRIX.rawData = vec;

		return MATRIX;
	}

	public inline static function getBlendFactor(blendMode:BlendFactor):Context3DBlendFactor {

		return switch(blendMode) {
			case BlendFactor.ZERO:
				Context3DBlendFactor.ZERO;
			case BlendFactor.ONE:
				Context3DBlendFactor.ONE;
			case BlendFactor.DESTINATION_ALPHA:
				Context3DBlendFactor.DESTINATION_ALPHA;
			case BlendFactor.DESTINATION_COLOR:
				Context3DBlendFactor.DESTINATION_COLOR;
			case BlendFactor.ONE_MINUS_DESTINATION_ALPHA:
				Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
			case BlendFactor.ONE_MINUS_DESTINATION_COLOR:
				Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
			case BlendFactor.SOURCE_ALPHA:
				Context3DBlendFactor.SOURCE_ALPHA;
			case BlendFactor.SOURCE_COLOR:
				Context3DBlendFactor.SOURCE_COLOR;
			case BlendFactor.ONE_MINUS_SOURCE_ALPHA:
				Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			case BlendFactor.ONE_MINUS_SOURCE_COLOR:
				Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
		}

	}

	public inline static function getVertexBufferFormat(format:VertexData):Context3DVertexBufferFormat {

		return switch(format) {
			case VertexData.FloatN(1):
				Context3DVertexBufferFormat.FLOAT_1;
			case VertexData.FloatN(2):
				Context3DVertexBufferFormat.FLOAT_2;
			case VertexData.FloatN(3):
				Context3DVertexBufferFormat.FLOAT_3;
			case VertexData.FloatN(4):
				Context3DVertexBufferFormat.FLOAT_4;
			case VertexData.PackedColor:
				Context3DVertexBufferFormat.BYTES_4;
			case VertexData.FloatN(_):
				throw 'unmatched';
		}

	}

	public inline static function getTextureFormat(format:TextureFormat):String {

		return switch(format) {
			case TextureFormat.ATF_BGRA, TextureFormat.BGRA_8888:
				"bgra";
			case TextureFormat.ATF_COMPRESSED:
				"compressed";
			case TextureFormat.ATF_COMPRESSED_ALPHA:
				"compressedAlpha";
			default:
				null;
		}
	}

	public inline static function isAtfTexture(format:TextureFormat):Bool {

		return switch(format) {
			case TextureFormat.ATF_BGRA, TextureFormat.ATF_COMPRESSED, TextureFormat.ATF_COMPRESSED_ALPHA:
				true;
			default:
				false;
		}
	}
}
