require "monocypher"

module ED25519::HD
  ED25519_CURVE = "ed25519 seed"

  HARDENED_TESTNET = 0x80000001
  HARDENED_BITCOIN = 0x80000000
  HARDENED_SUSHI   = 0x80000276
  PATH_REGEX       = /^(m\/)?(\d+'?\/)*\d+'?$/

  struct Keys
    getter private_key : String
    getter chain_code : String

    def initialize(@private_key : String, @chain_code : String); end
  end

  struct KeyRing
    def self.get_keys(seed : Slice(UInt8), key : Slice(UInt8)) : Keys
      digest = uninitialized UInt8[64]
      message = seed
      LibMonocypher.hmac_sha512(digest, key, key.bytesize, message, message.bytesize)
      private_key = digest.to_slice[0, 32].hexstring
      chain_code = digest.to_slice[32, 32].hexstring

      Keys.new(private_key, chain_code)
    end

    def self.get_master_key_from_seed(seed : String) : Keys
      get_keys(seed.hexbytes, ED25519_CURVE.to_slice)
    end

    def self.ckd_priv(keys : Keys, index : Int32, hardened_offset : Int64 = HARDENED_TESTNET) : Keys
      seed = IO::Memory.new(37)
      seed.write_byte(0x00)
      seed.write_utf8(keys.private_key.hexbytes)
      seed.write_bytes(index.to_u32 + hardened_offset, IO::ByteFormat::BigEndian)
      get_keys(seed.to_slice, keys.chain_code.hexbytes)
    end

    def self.get_public_key(private_key : String, with_zero_byte : Bool = true) : String
      secret_key = Crypto::SecretKey.new(private_key)
      bytes = Crypto::Ed25519PublicSigningKey.new(secret: secret_key).to_slice
      if with_zero_byte
        key = IO::Memory.new(33)
        key.write_byte(0x00)
        key.write_utf8(bytes)
        key.to_slice.hexstring
      else
        bytes.hexstring
      end
    end

    def self.derive_path(path : String, seed : String, hardened_offset : Int64 = HARDENED_TESTNET) : Keys
      raise "Invalid derivation path. Expected BIP32 format" if PATH_REGEX.match(path).nil?
      master_keys = get_master_key_from_seed(seed)
      path.gsub("'", "").split("/")[1..-1].map { |v| v.to_i }.reduce(master_keys) { |parent_keys, segment|
        ckd_priv(parent_keys, segment, hardened_offset)
      }
    end
  end
end
