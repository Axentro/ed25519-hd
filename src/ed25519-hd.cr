require "monocypher"

module ED25519::HD
  ED25519_CURVE = "ed25519 seed"

  struct Crypto
    def self.get_keys(seed : String, key : String) : Keys
      digest = uninitialized UInt8[64]
      message = seed.hexbytes
      LibMonocypher.hmac_sha512(digest, key, key.bytesize, message, message.bytesize)
      private_key = digest.to_slice[0, 32].hexstring
      chain_code = digest.to_slice[32, 32].hexstring

      Keys.new(private_key, chain_code)
    end
  end

  HARDENED_OFFSET = 0x80000000

  struct Keys
    getter private_key : String
    getter chain_code : String

    def initialize(@private_key : String, @chain_code : String); end
  end

  struct KeyRing
    def self.get_master_key_from_seed(seed : String) : Keys
      Crypto.get_keys(seed, ED25519_CURVE)
    end

    def self.ckd_priv(keys : Keys, index : Int32) : Keys
      seed = Slice(UInt8).new(37)
      seed[1..32].copy_from(keys.private_key.hexbytes)
      seed[0] = 0x00
      seed[33] = index.to_u8

      puts seed.hexstring
      Crypto.get_keys(seed.hexstring, keys.chain_code)
    end

    def self.get_public_key(private_key : String) : String
      ""
    end

    def self.is_valid_path(path : String) : Bool
      false
    end

    def self.derive_path(path : String, seed : String) : Keys
      Keys.new("", "")
    end
  end
end
