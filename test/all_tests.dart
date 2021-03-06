library dartcoin.test.all;

import "core/address_test.dart" as address;
import "core/base58check_test.dart" as base58check;
import "core/block_test.dart" as block;
import "core/filtered_block_and_partial_merkle_tree_test.dart" as filtered_block_and_partial_merkle_tree;
import "core/keypair_test.dart" as keypair;
import "core/sha256hash_test.dart" as sha256hash;

import "core/utils_test.dart" as utils;

// crypto
import "crypto/key_crypter_scrypt_test.dart" as key_crypter_scrypt;
import "crypto/mnemonic_code_test.dart" as mnemonic_code;

// scripts
import "script/script_test.dart" as script;

// serialization
import "serialization/byte_sink_test.dart" as byte_sink;
import "serialization/varint_test.dart" as varint;

// wire
import "wire/bloom_filter_test.dart" as bloom_filter;
import "wire/message_serialization_test.dart" as message_serialization;
import "wire/peer_address_test.dart" as peer_address;

import "wire/messages/alert_message_test.dart" as alert_message;
import "wire/messages/version_message_test.dart" as version_message;


void main() {
  // core
  address.main();
  base58check.main();
  block.main();
  filtered_block_and_partial_merkle_tree.main();
  keypair.main();
  sha256hash.main();
  
  utils.main();
  // crypto
  key_crypter_scrypt.main(); // TODO not yet working
  mnemonic_code.main();
  // script
  script.main();
  // serialization
  byte_sink.main();
  varint.main();
  // wire
  bloom_filter.main();
  message_serialization.main();
  peer_address.main();
  // messages
  alert_message.main();
  version_message.main();
}

