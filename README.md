# ed25519-hd

[![Linux CI](https://github.com/Axentro/ed25519-hd/actions/workflows/linux-ci.yml/badge.svg)](https://github.com/Axentro/ed25519-hd/actions/workflows/linux-ci.yml)

This provides [SLIP-0010](https://github.com/satoshilabs/slips/blob/master/slip-0010.md) specification support. 

This can be used to generate a master keypair and child public/private keypairs from a secure seed. 

It is based on:

  * Hierarchical Deterministic Wallets [BIP-0032](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) 
  * Multi-Account Hierarchy for Deterministic Wallets [BIP-0044](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ed25519-hd:
       github: axentro/ed25519-hd
   ```

2. Run `shards install`

## Usage

```crystal
require "ed25519-hd"
include ED25519::HD

seed = "000102030405060708090a0b0c0d0e0f"
path = "m/0'"

keys = KeyRing.derive_path(path, seed, HARDENED_BITCOIN)

keys.private_key                         # 68e0fe46dfb67e368c75379acec591dad19df3cde26e63b93a8e704f1dade7a3
keys.chain_code                          # 8b59aa11380b624e81507a27fedda59fea6d0b779a778918a2fd3590e16e9c69
KeyRing.get_public_key(keys.private_key) # 008c8a13df77a28f3445213a0f432fde644acaa215fc72dcdf300d5efaa85d350c
```

## Contributing

1. Fork it (<https://github.com/axentro/ed25519-hd/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kingsley Hendrickse](https://github.com/kingsleyh) - creator and maintainer
