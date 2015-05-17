package com.pplive.p2p
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.BlockMap;
	import com.pplive.p2p.struct.SubPiece;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.struct.Piece;
	import com.pplive.p2p.struct.StructUtil;
	import flash.utils.Dictionary;
	
	public class ResourceCache extends Monitable
	{
		
		private static var logger:ILogger = getLogger(ResourceCache);
		
		private var _length:uint;
		
		private var _headLength:uint;
		
		private var _resource:ByteArray;
		
		private var _subpieceMarks:Vector.<Boolean>;
		
		private var _pieces:Vector.<uint>;
		
		private var _blocks:Vector.<uint>;
		
		private var _blockBitmap:BlockMap;
		
		private var _stat:Stat;
		
		private var _subpieceCount:uint = 0;
		
		private var _drmDecoder:DRMDecoder;
		
		public function ResourceCache(param1:uint, param2:uint)
		{
			this._resource = new ByteArray();
			this._subpieceMarks = new Vector.<Boolean>();
			this._pieces = new Vector.<uint>();
			this._blocks = new Vector.<uint>();
			this._stat = new Stat();
			super("resource");
			this._length = param1;
			this._headLength = param2;
			this._resource.length = this._length;
			this._subpieceMarks.length = StructUtil.getSubPieceCountByFileLength(this._length);
			this._pieces.length = StructUtil.getPieceCountByFileLength(this._length);
			this._blocks.length = StructUtil.getBlockCountByFileLength(this._length);
			this._blockBitmap = new BlockMap(this._blocks.length);
		}
		
		public function get length() : uint
		{
			return this._length;
		}
		
		public function get headLength() : uint
		{
			return this._headLength;
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function get subpieceCount() : uint
		{
			return this._subpieceCount;
		}
		
		public function get memUsed() : uint
		{
			return this._length;
		}
		
		public function get fullPercent() : Number
		{
			return this._subpieceCount / this._subpieceMarks.length;
		}
		
		public function get blockBitmap() : BlockMap
		{
			return this._blockBitmap;
		}
		
		public function get isHeadComplete() : Boolean
		{
			return this.getFirstSubPieceMissed(0).offset >= this._headLength;
		}
		
		public function set drmDecoder(param1:DRMDecoder) : void
		{
			this._drmDecoder = param1;
		}
		
		public function get isDrmSetup() : Boolean
		{
			return !(this._drmDecoder == null);
		}
		
		public function isComplete(param1:uint = 0) : Boolean
		{
			return param1 == 0?this._subpieceCount >= this._subpieceMarks.length:this.getFirstSubPieceMissed(param1).offset >= this._length;
		}
		
		public function destroy() : void
		{
			this._resource.length = 0;
			this._resource = null;
			this._subpieceMarks.length = 0;
			this._subpieceMarks = null;
			this._pieces.length = 0;
			this._pieces = null;
			this._blocks.length = 0;
			this._blocks = null;
			this._stat = null;
		}
		
		public function addSubPiece(param1:SubPiece, param2:ByteArray) : Boolean
		{
			var _loc4:uint = 0;
			var _loc3:uint = param1.subPieceIndexInResource;
			if(_loc3 < this._subpieceMarks.length)
			{
				if(!this._subpieceMarks[_loc3])
				{
					this._subpieceMarks[_loc3] = true;
					this._resource.position = _loc3 * Constants.SUBPIECE_SIZE;
					this._resource.writeBytes(param2);
					_loc4 = _loc3 / Constants.SUBPIECE_NUM_PER_PIECE;
					this._pieces[_loc4]++;
					this._blocks[param1.blockIndex]++;
					if(this.hasBlock(param1.blockIndex))
					{
						this._blockBitmap.setBlock(param1.blockIndex);
					}
					this._subpieceCount++;
					return true;
				}
				logger.debug("add subpiece exist");
				return false;
			}
			logger.debug("add subpiece, out of range: " + this._subpieceMarks.length + ", " + _loc3);
			return false;
		}
		
		public function hasSubPiece(param1:SubPiece) : Boolean
		{
			var _loc2:uint = param1.subPieceIndexInResource;
			return _loc2 < this._subpieceMarks.length && (this._subpieceMarks[_loc2]);
		}
		
		public function hasPiece(param1:Piece) : Boolean
		{
			var _loc5:uint = 0;
			var _loc2:uint = param1.pieceIndexInResource;
			if(_loc2 >= this._pieces.length)
			{
				return false;
			}
			var _loc3:uint = StructUtil.getSubPieceCountInPiece(this._length,param1);
			if(this._pieces[_loc2] == _loc3)
			{
				return true;
			}
			if(_loc3 - param1.subPieceIndex > this._pieces[_loc2])
			{
				return false;
			}
			var _loc4:uint = param1.subPieceIndex;
			while(_loc4 < _loc3)
			{
				_loc5 = _loc2 * Constants.SUBPIECE_NUM_PER_PIECE + _loc4;
				if(_loc5 >= this._subpieceMarks.length || !this._subpieceMarks[_loc5])
				{
					return false;
				}
				_loc4++;
			}
			return true;
		}
		
		public function hasBlock(param1:uint) : Boolean
		{
			return param1 < this._blocks.length && this._blocks[param1] == StructUtil.getSubPieceCountInBlock(this._length,param1);
		}
		
		public function getSubPiece(param1:SubPiece) : ByteArray
		{
			var _loc3:ByteArray = null;
			var _loc4:uint = 0;
			var _loc2:uint = param1.subPieceIndexInResource;
			if(_loc2 < this._subpieceMarks.length && (this._subpieceMarks[_loc2]))
			{
				_loc3 = new ByteArray();
				_loc4 = _loc2 + 1 == this._subpieceMarks.length && (this._length % Constants.SUBPIECE_SIZE)?this._length % Constants.SUBPIECE_SIZE:Constants.SUBPIECE_SIZE;
				this._resource.position = _loc2 * Constants.SUBPIECE_SIZE;
				this._resource.readBytes(_loc3,0,_loc4);
				_loc3.position = 0;
				return this._drmDecoder?this._drmDecoder.decode(param1,_loc3):_loc3;
			}
			return null;
		}
		
		public function getFirstSubPieceMissed(param1:uint) : SubPiece
		{
			var _loc2:SubPiece = SubPiece.createSubPieceFromOffset(param1);
			if(!this.hasSubPiece(_loc2))
			{
				return _loc2;
			}
			while(this.hasBlock(_loc2.blockIndex))
			{
				_loc2.blockIndex++;
				_loc2.subPieceIndex = 0;
			}
			var _loc3:Piece = _loc2.getPiece();
			while(this.hasPiece(_loc3))
			{
				_loc3.moveToNextPiece();
				_loc2 = _loc3.getFirstSubPiece();
			}
			while(this.hasSubPiece(_loc2))
			{
				_loc2.moveToNextSubPiece();
			}
			return _loc2;
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["size"] = this._length;
			if(this._subpieceCount * Constants.SUBPIECE_SIZE >= this._length)
			{
				param1["finished-percent"] = 100;
			}
			else
			{
				param1["finished-percent"] = uint(this._subpieceCount * Constants.SUBPIECE_SIZE / this._length * 100);
			}
			param1["droppable"] = this._stat.droppable;
			param1["is_downloading"] = this._stat.isDownloading;
			param1["upload_speed"] = this._stat.uploadSpeed.getRecentSpeedInKBPS();
		}
	}
}

import com.pplive.p2p.SpeedMeter;

class Stat extends Object
{
	
	public var isDownloading:Boolean = false;
	
	public var isPlaying:Boolean = false;
	
	public var droppable:Boolean = true;
	
	public var uploadSpeed:SpeedMeter;
	
	function Stat()
	{
		this.uploadSpeed = new SpeedMeter();
		super();
		this.uploadSpeed.resume();
	}
}
