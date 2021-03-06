require "./spec_helper"

describe ED25519::HD do
  describe "Vector 1" do
    it "should have valid keys for vector 1 seed hex (chain m)" do
      keys = KeyRing.get_master_key_from_seed(vector_1.seed)
      keys.private_key.should eq("2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7")
      keys.chain_code.should eq("90046a93de5380a72b5e45010748567d5ea02bbf6522f979e05c0d8d8ca9fffb")
    end
    it "should be valid for vector path" do
      vector_1.vectors.each do |v|
        keys = KeyRing.derive_path(v.path, vector_1.seed, HARDENED_BITCOIN)
        keys.private_key.should eq(v.key)
        keys.chain_code.should eq(v.chain_code)
        KeyRing.get_public_key(v.key).should eq(v.public_key)
      end
    end
  end

  it "should get a child private key" do
    master_keys = KeyRing.get_master_key_from_seed(vector_1.seed)
    child_keys = KeyRing.ckd_priv(master_keys, 1, HARDENED_BITCOIN)
    child_keys.private_key.should eq("ec285aca282cde2c5bf7243fb6533280a4e50b1b81497c99dd44516b7d25f0c1")
    child_keys.chain_code.should eq("bf4de1e4e4d07c4aff77aad54df5161ad0e763624b25d2c28c0070348a4cc3bc")
  end

  it "should get a public key from the private key (with zero byte)" do
    master_keys = KeyRing.get_master_key_from_seed(vector_1.seed)
    KeyRing.get_public_key(master_keys.private_key).should eq("00a4b2856bfec510abab89753fac1ac0e1112364e7d250545963f135f2a33188ed")
  end

  it "should get a public key from the private key (no with zero byte)" do
    master_keys = KeyRing.get_master_key_from_seed(vector_1.seed)
    KeyRing.get_public_key(master_keys.private_key, false).should eq("a4b2856bfec510abab89753fac1ac0e1112364e7d250545963f135f2a33188ed")
  end

  describe "Vector 2" do
    it "should have valid keys for vector 2 seed hex" do
      keys = KeyRing.get_master_key_from_seed(vector_2.seed)
      keys.private_key.should eq("171cb88b1b3c1db25add599712e36245d75bc65a1a5c9e18d76f9f2b1eab4012")
      keys.chain_code.should eq("ef70a74db9c3a5af931b5fe73ed8e1a53464133654fd55e7a66f8570b8e33c3b")
    end
    it "should be valid for vector path" do
      vector_2.vectors.each do |v|
        keys = KeyRing.derive_path(v.path, vector_2.seed, HARDENED_BITCOIN)
        keys.private_key.should eq(v.key)
        keys.chain_code.should eq(v.chain_code)
        KeyRing.get_public_key(v.key).should eq(v.public_key)
      end
    end
  end
end
