package com.pplive.p2p.struct
{
	import de.polygonal.ds.Comparable;
	import flash.net.registerClassAlias;
	
	public class SubPiece extends Object implements Comparable
	{
		
		private static var hasRegisterClassAlias:Boolean = false;
		
		private var _blockIndex:uint;
		
		private var _subPieceIndex:uint;
		
		private var _offset:uint;
		
		public function SubPiece(param1:uint = 0, param2:uint = 0)
		{
			super();
			this.registerClassAlias();
			this._blockIndex = param1;
			this._subPieceIndex = param2;
			this.updateOffset();
		}
		
		public static function createSubPieceFromOffset(param1:uint) : SubPiece
		{
			return new SubPiece(param1 / Constants.BLOCK_SIZE,param1 % Constants.BLOCK_SIZE / Constants.SUBPIECE_SIZE);
		}
		
		private function registerClassAlias() : void
		{
			if(!hasRegisterClassAlias)
			{
				registerClassAlias("com.pplive.p2p.struct.SubPiece",SubPiece);
			}
		}
		
		public function get blockIndex() : uint
		{
			return this._blockIndex;
		}
		
		public function get subPieceIndex() : uint
		{
			return this._subPieceIndex;
		}
		
		public function get offset() : uint
		{
			return this._offset;
		}
		
		public function get subPieceIndexInResource() : uint
		{
			return this._blockIndex * Constants.SUBPIECE_NUM_PER_BLOCK + this._subPieceIndex;
		}
		
		public function set blockIndex(param1:uint) : void
		{
			this._blockIndex = param1;
			this.updateOffset();
		}
		
		public function set subPieceIndex(param1:uint) : void
		{
			this._subPieceIndex = param1;
			this.updateOffset();
		}
		
		private function updateOffset() : void
		{
			this._offset = this.blockIndex * Constants.BLOCK_SIZE + this.subPieceIndex * Constants.SUBPIECE_SIZE;
		}
		
		public function getSize(param1:uint) : uint
		{
			if(this.compare(StructUtil.getLastSubPieceByFileLength(param1)) == 0)
			{
				return StructUtil.getLastSubPieceSizeByFileLength(param1);
			}
			return Constants.SUBPIECE_SIZE;
		}
		
		public function getPiece() : Piece
		{
			return new Piece(this.blockIndex,this.subPieceIndex / Constants.SUBPIECE_NUM_PER_PIECE);
		}
		
		public function moveToNextSubPiece() : void
		{
			this._subPieceIndex++;
			if(this._subPieceIndex == Constants.SUBPIECE_NUM_PER_BLOCK)
			{
				this._blockIndex++;
				this._subPieceIndex = 0;
			}
			this.updateOffset();
		}
		
		public function compare(param1:Object) : int
		{
			var _loc2:SubPiece = param1 as SubPiece;
			if(this.blockIndex < _loc2.blockIndex)
			{
				return -1;
			}
			if(this.blockIndex > _loc2.blockIndex)
			{
				return 1;
			}
			if(this.subPieceIndex < _loc2.subPieceIndex)
			{
				return -1;
			}
			if(this.subPieceIndex > _loc2.subPieceIndex)
			{
				return 1;
			}
			return 0;
		}
		
		public function toString() : String
		{
			return "SubPiece(" + this.blockIndex + "|" + this.subPieceIndex + ":" + this.offset + ")";
		}
	}
}
