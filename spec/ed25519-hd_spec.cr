require "./spec_helper"

describe ED25519::HD do
  describe "Vector 1" do
    it "should have valid keys for vector 1 seed hex" do
      keys = KeyRing.get_master_key_from_seed(vector_1.seed)
      keys.key.should eq("2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7")
      keys.chain_code.should eq("90046a93de5380a72b5e45010748567d5ea02bbf6522f979e05c0d8d8ca9fffb")
    end
    it "should be valid for vector path" do 
      vector_1.vectors.each do |v|
        keys = KeyRing.derive_path(v.path, vector_1.seed)
        keys.key.should eq(v.key)
        keys.chain_code.should eq(v.chain_code)
        KeyRing.get_public_key(v.key).should eq(v.public_key)
      end
    end
  end
end
