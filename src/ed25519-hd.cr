module ED25519::HD
  HARDENED_OFFSET = 0x80000000

  struct Keys
    getter key : String
    getter chain_code : String

    def initialize(@key : String, @chain_code : String); end
  end

  struct KeyRing
    def self.get_master_key_from_seed(seed : String) : Keys
      Keys.new("", "")
    end

    def self.ckd_priv(keys : Keys, index : Int32) : Keys
      Keys.new("", "")
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
