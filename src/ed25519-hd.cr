require "monocypher"

module ED25519::HD
  ED25519_CURVE = "ed25519 seed"

  HARDENED_OFFSET = 0x80000000

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

    def self.ckd_priv(keys : Keys, index : Int32) : Keys
      seed = Slice(UInt8).new(37)
      seed[1..32].copy_from(keys.private_key.hexbytes)
      seed[0] = 0x00
      seed[33] = index.to_u8
      get_keys(seed, keys.chain_code.hexbytes)
    end

    def self.get_public_key(private_key : String, with_zero_byte : Bool = true) : String
      secret_key = Crypto::SecretKey.new(private_key)
      bytes = Crypto::Ed25519PublicSigningKey.new(secret: secret_key).to_slice
      if with_zero_byte
        key = Slice(UInt8).new(33)
        key[0] = 0x00
        key[1..32].copy_from(bytes)
        key.hexstring
      else
        bytes.hexstring
      end
    end

    def self.is_valid_path(path : String) : Bool
      false
    end

    def self.derive_path(path : String, seed : String) : Keys
      Keys.new("", "")
    end
  end
end
