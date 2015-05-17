package com.pplive.p2p.struct
{
	import de.polygonal.ds.Comparable;
	import flash.net.registerClassAlias;
	
	public class Piece extends Object implements Comparable
	{
		
		private static var hasRegisterClassAlias:Boolean = false;
		
		public var blockIndex:uint;
		
		public var pieceIndex:uint;
		
		public var subPieceIndex:uint;
		
		public function Piece(param1:uint = 0, param2:uint = 0, param3:uint = 0)
		{
			super();
			registerClassAlias();
			this.blockIndex = param1;
			this.pieceIndex = param2;
			this.subPieceIndex = param3;
		}
		
		private static function registerClassAlias() : void
		{
			if(!hasRegisterClassAlias)
			{
				registerClassAlias("com.pplive.p2p.struct.Piece",Piece);
				hasRegisterClassAlias = true;
			}
		}
		
		public static function createPieceFromOffset(param1:uint) : Piece
		{
			return new Piece(param1 / Constants.BLOCK_SIZE,param1 % Constants.BLOCK_SIZE / Constants.PIECE_SIZE,param1 % Constants.PIECE_SIZE / Constants.SUBPIECE_SIZE);
		}
		
		public function get pieceIndexInResource() : uint
		{
			return this.blockIndex * Constants.PIECE_NUM_PER_BLOCK + this.pieceIndex;
		}
		
		public function getOffset() : uint
		{
			return this.blockIndex * Constants.BLOCK_SIZE + this.pieceIndex * Constants.PIECE_SIZE + this.subPieceIndex * Constants.SUBPIECE_SIZE;
		}
		
		public function getFirstSubPiece() : SubPiece
		{
			return new SubPiece(this.blockIndex,this.pieceIndex * Constants.SUBPIECE_NUM_PER_PIECE + this.subPieceIndex);
		}
		
		public function getNthSubPiece(param1:uint) : SubPiece
		{
			return new SubPiece(this.blockIndex,this.pieceIndex * Constants.SUBPIECE_NUM_PER_PIECE + param1);
		}
		
		public function compare(param1:Object) : int
		{
			var _loc2:Piece = param1 as Piece;
			if(this.blockIndex < _loc2.blockIndex)
			{
				return -1;
			}
			if(this.blockIndex > _loc2.blockIndex)
			{
				return 1;
			}
			if(this.pieceIndex < _loc2.pieceIndex)
			{
				return -1;
			}
			if(this.pieceIndex > _loc2.pieceIndex)
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
		
		public function moveToNextPiece() : void
		{
			this.pieceIndex++;
			this.subPieceIndex = 0;
			if(this.pieceIndex == Constants.PIECE_NUM_PER_BLOCK)
			{
				this.blockIndex++;
				this.pieceIndex = 0;
			}
		}
		
		public function toString() : String
		{
			return "Piece(" + this.blockIndex + "|" + this.pieceIndex + "|" + this.subPieceIndex + ")";
		}
	}
}
