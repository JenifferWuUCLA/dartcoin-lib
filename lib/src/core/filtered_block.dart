part of dartcoin.core;

class FilteredBlock extends Object with BitcoinSerialization {
  /** The protocol version at which Bloom filtering started to be supported. */
  static const int MIN_PROTOCOL_VERSION = 70000;
  
  Block _header;
  
  PartialMerkleTree _merkle;
  // cached list of tx hashes
  List<Hash256> _hashes;
  
  Map<Hash256, Transaction> _txs;
  
  FilteredBlock(Block header, PartialMerkleTree merkleTree, [List<Hash256> hashes]) {
    if(header == null || merkleTree == null)
      throw new ArgumentError("header or merkleTree is null");
    _header = header;
    _merkle = merkleTree;
    _hashes = hashes;
    this.params = header.params;
  }
  
  // required for serialization
  FilteredBlock._newInstance();
  
  factory FilteredBlock.deserialize(Uint8List bytes, {int length, bool lazy, bool retain, NetworkParameters params, BitcoinSerialization parent}) => 
          new BitcoinSerialization.deserialize(new FilteredBlock._newInstance(), bytes, length: length, lazy: lazy, retain: retain, params: params, parent: parent);
  
  Block get header {
    _needInstance();
    if(!_header.isHeader)
      _header.cloneAsHeader();
    return _header;
  }

  Hash256 get hash {
    _needInstance();
    return _header.hash;
  }
  
  PartialMerkleTree get merkleTree {
    _needInstance();
    return _merkle;
  }
  
  /**
   * Number of transactions in this block, before it was filtered.
   */
  int get transactionCount => merkleTree.transactionCount;
  
  List<Hash256> get transactionHashes {
    if(_hashes == null) {
      _needInstance();
      List<Hash256> hashes = new List<Hash256>();
      if(_header.merkleRoot == _merkle.getTxnHashAndMerkleRoot(hashes)) {
        _hashes = hashes;
      } else {
        throw new Exception("Merkle root of block header does not match merkle root of partial merkle tree.");
      }
    }
    return new UnmodifiableListView(_hashes);
  }
  
  // the following two methods are used to fill this block with relevant transactions
  
  /**
   * Provide this FilteredBlock with a transaction which is in its merkle tree
   * @returns false if the tx is not relevant to this FilteredBlock
   */
  bool provideTransaction(Transaction tx) {
    _needInstance();
    if(_txs == null) 
      _txs = new Map<Hash256, Transaction>();
    Hash256 hash = tx.hash;
    if(_hashes.contains(hash)) {
      _txs[hash] = tx;
      return true;
    } else
      return false;
  }
  
  /**
   * Gets the set of transactions which were provided using provideTransaction() which match in getTransactionHashes()
   */
  Map<Hash256, Transaction> get associatedTransactions {
    _needInstance();
    return new UnmodifiableMapView(_txs);//TODO something changed in the collection package
  }
  
  // serialization

  @override
  void _serialize(ByteSink sink) {
    if(_header.isHeader)
      _writeObject(sink, _header);
    else
      _writeObject(sink, _header.cloneAsHeader());
    _writeObject(sink, _merkle);
  }

  @override
  void _deserialize() {
    _header = _readObject(new Block._newInstance(), length: Block.HEADER_SIZE);
    _merkle = _readObject(new PartialMerkleTree._newInstance());
  }

  @override
  void _deserializeLazy() {
    _serializationCursor += Block.HEADER_SIZE;
    _readObject(new PartialMerkleTree._newInstance(), lazy: true);
  }
  
}





