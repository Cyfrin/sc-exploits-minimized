## SC Exploits Minimized

Smart Contract exploits, minimized for your learning pleasure. 

- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
  - [Test](#test)
    - [Running a single test](#running-a-single-test)
    - [Running a FV test](#running-a-fv-test)
- [Remix, CTFs, \& Challenge Examples](#remix-ctfs--challenge-examples)
- [Invariants](#invariants)
  - [Formal Verification](#formal-verification)
    - [Halmos cheat sheet](#halmos-cheat-sheet)
    - [Fuzzers vs Formal Verificaion cheat sheet](#fuzzers-vs-formal-verificaion-cheat-sheet)
- [Thank you!](#thank-you)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`


## Quickstart

```
git clone https://github.com/Cyfrin/sc-exploits-minimized
cd sc-exploits-minimized
make
```

## Test

```
forge test
```

### Running a single test

```
forge test --mt test_reenter
```

### Running a FV test

To run [halmos](https://github.com/a16z/halmos/tree/main) test, you'll need to have Halmos installed. 

```
halmos --function check_hellFunc_doesntRevert
```


# Remix, CTFs, & Challenge Examples

A set of examples where you can see the attack in remix or practice it in a gameified way. 

- The `Remix` links will bring you to a minimal example of the exploit.
- The `Ethernaut` links will bring you to a challenge where that exploit exists in a "capture the flag". 
- The `Damn Vulnerable DeFi` links will bring you to a challenge where that exploit exists in a difficult DeFi/OnChain Finance related "capture the flag". 

<table border="1" style="border-collapse: collapse;">
    <thead>
        <tr>
            <th>Exploit</th>
            <th>Remix 🎧</th>
            <th>Ethernaut 👩🏻‍🚀</th>
            <th>Damn Vulnerable DeFi 💰</th>
            <th>Case Studies 🔎</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Reentrancy</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/reentrancy/Reentrancy.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/10" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Re-entrancy</a>
            </td>
            <td>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/side-entrance/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Side Entrance</a>
            </td>
            <td>
            <a href="https://github.com/pcaversaccio/reentrancy-attacks" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">The Ultimate List </a>
            </td>
        </tr>
        <tr>
            <td>Arithmetic</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/arithmetic/OverflowAndUnderflow.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/5" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Token</a>
            </td>
            <td>
            None
            </td>
            <td>
            Coming Soon...
            </td>
        </tr>
        <tr>
            <td>Denial Of Service (DoS)</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/denial-of-service/DoS.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/20" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Denial</a>
            </td>
            <td>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/unstoppable/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Unstoppable</a>
            </td>
            <td>
            Coming Soon...
            </td>
        </tr>
        <tr>
            <td>Mishandling Of Eth</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/mishandling-of-eth/MishandlingOfEth.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix (Not using push over pull)</a>
            </br>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/mishandling-of-eth/SelfDestructMe.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix (Vulnerable to selfdestruct)</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/9" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">King</a>
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://samczsun.com/two-rights-might-make-a-wrong/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Sushi Swap</a>
            </td>
        </tr>
        <tr>
            <td>Weak Randomness</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/weak-randomness/WeakRandomness.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/3" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Coin Flip</a>
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://forum.openzeppelin.com/t/understanding-the-meebits-exploit/8281" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Meebits</a>
            </td>
        </tr>
        <tr>
            <td>Missing Access Controls</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/missing-access-controls/MissingAccessControls.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/2" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Fallout</a>
            </td>
            <td>
            None
            </td>
            <td>
            Coming Soon...
            </td>
        </tr>
        <tr>
            <td>Centralization</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/centralization/Centralization.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/compromised/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Compromised</a>
            </td>
            <td>
            <a href="https://medium.com/@observer1/uk-court-ordered-oasis-to-exploit-own-security-flaw-to-recover-120k-weth-stolen-in-wormhole-hack-fcadc439ca9d" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Oasis</a>
            And every rug pull ever.
            </td>
        </tr>
        <tr>
            <td>Failure to initialize</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/failure-to-initialize/FailureToInitialize.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/25 " target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Motorbike</a>
            </td>
            <td>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/wallet-mining/ " target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Wallet Mining</a>
            </td>
            <td>
            <a href="https://github.com/openethereum/parity-ethereum/issues/6995 " target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Parity Wallet</a>
            </td>
        </tr>
        <tr>
            <td>Storage Collision</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/storage-collision/StorageCollision.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/16" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Preservation</a>
            </td>
            <td>
            None
            </td>
            <td>
            Coming Soon...
            </td>
        </tr>
        <tr>
            <td>Oracle/Price Manipulation</td>
            <td>
            (Click all of these)
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/oracle-manipulation/OracleManipulation.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">OracleManipulation.sol</a>
            </br>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/oracle-manipulation/BadExchange.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">BadExchange.sol</a>
            </br>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/oracle-manipulation/FlashLoaner.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">FlashLoaner.sol</a>
            </br>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/oracle-manipulation/IFlashLoanReceiver.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">IFlashLoanReceiver.sol</a>
            </td>
            <td>
            <a href="https://ethernaut.openzeppelin.com/level/23" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Dex 2</a>
            </td>
            <td>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/puppet/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Puppet</a>
            </br>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/puppet-v2/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Puppet V2</a>
            </br>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/puppet-v3/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Puppet V3</a>
            </br>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/the-rewarder/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">The Rewarder</a>
            </br>
            <a href="https://www.damnvulnerabledefi.xyz/challenges/selfie/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Selfie</a>
            </td>
            <td>
            <a href="https://rekt.news/cream-rekt-2/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Cream Finance</a>
            </td>
        </tr>
        <tr>
            <td>Signature Replay</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/signature-replay/SignatureReplay.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            N/A
            </td>
            <td>
            Coming soon...
            </td>
            <td>
            Coming soon...
            </td>
        </tr>
        <tr>
            <td>Opcode Support/EVM Compatibility</td>
            <td>
            Coming Soon...
            </td>
            <td>
            None
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://medium.com/coinmonks/gemstoneido-contract-stuck-with-921-eth-an-analysis-of-why-transfer-does-not-work-on-zksync-era-d5a01807227d" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">zkSync/GEM</a>
            </td>
        </tr>
        <tr>
            <td>Governance Attack</td>
            <td>
            Coming Soon...
            </td>
            <td>
            None
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://rekt.news/tornado-gov-rekt/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Tornado Cash</a>
            </td>
        </tr>
        <tr>
            <td>Stolen Private Keys</td>
            <td>
            Coming Soon...
            </td>
            <td>
            None
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://rekt.news/vulcan-forged-rekt/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Vulcan Forged</a>
            <a href="https://rekt.news/mixin-rekt/" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Mixin</a>
            </td>
        </tr>
        <tr>
            <td>MEV</td>
            <td>
            <a href="https://remix.ethereum.org/#url=https://github.com/Cyfrin/sc-exploits-minimized/blob/main/src/MEV/Frontran.sol&lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.20+commit.a1b79de6.js" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Remix</a>
            </td>
            <td>
            None
            </td>
            <td>
            None
            </td>
            <td>
            <a href="https://blockworks.co/news/curve-suffers-exploit" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Vyper Attack</a>
            </td>
        </tr>
        <tr>
            <td>Invariant Break (Other exploits can cause this)</td>
            <td>
            Doesn't work great in remix
            </td>
            <td>
            N/A
            </td>
            <td>
            N/A
            </td>
            <td>
            <a href="https://www.coinbase.com/blog/euler-compromise-investigation-part-1-the-exploit" target="_blank" style="display: inline-block; padding: 10px 15px; font-size: 16px; cursor: pointer; text-align: center; text-decoration: none; outline: none; color: #fff; background-color: #4CAF50; border: none; border-radius: 15px; box-shadow: 0 5px #999;" target="_blank">Euler</a>
            </td>
        </tr>
    </tbody>
</table>

# Invariants

Now, "Invariant Breaks" isn't exactly a class of bug, however it's important to know about and use when it comes to hacks. We look at 3 different methods for attempting to break invariants.

1. Stateless Fuzzing (Easiest)
2. Stateful Fuzzing - Open / Unguided (A little harder)
2. Stateful Fuzzing - Handler method / Guided (Harder)
3. Formal Verification w/ [Halmos](https://github.com/a16z/halmos/tree/main) (Hardest)

See more in [./src/invariant-break/README.md](./src/invariant-break/README.md)

## Formal Verification

We are using the following tools to do Formal Verification (FV) / Symbolic execution (SE). :
- [halmos](https://github.com/a16z/halmos) 
- [certora](https://www.certora.com/)
- [kontrol](https://docs.runtimeverification.com/kontrol/overview/readme)

Not used, with rationale:
- [hevm](https://github.com/ethereum/hevm): I had a very hard time setting it up. It's likely I didn't spend enough time.
- [EthBMC](https://github.com/RUB-SysSec/EthBMC): Unclear if it's still maintained.
- [manticore](https://github.com/trailofbits/manticore): No longer maintained.
- [mythril](https://github.com/Consensys/mythril): It's unclear to me if it performs better than the Solidity SMT Checker.

### Halmos cheat sheet

- Use `assert`, don't `revert` or `require`
- `vm.assume()` works better than `bound()` or `clamp()`
- halmos looks for `check_` by default so it's easier to have separate fuzz and symbolic tests. You can name it `test_` if you want to run both halmos and foundry (`halmos --function test_`)

### Fuzzers vs Formal Verificaion cheat sheet

- Fuzzers try a bunch of pseudo-random data to try to break an invariant
- FV/Symbolic Execution convert
- Fuzzers are best at finding "simple" bugs (issues well spread out over a domain space that is not crazy large)
- Formal Verification/Halmos is currently best at showing the absence of bugs. You can have assurance you _don't_ have a bug rather than wondering how long to run a fuzzer. 
- FV is perfect for 100% equivalence tests 👌

# Thank you!

Follow us!

- [Cyfrin](https://www.cyfrin.io/)
- [Cyfrin Updraft](https://www.updraft.cyfrin.io/)
- [The Red Guild](https://theredguild.org/)
- [CodeHawks](https://codehawks.com/)
- [Solodit](https://solodit.xyz/)
- [Cyfrin Twitter](https://twitter.com/CyfrinAudits)
- [Patrick Collins YouTube](https://www.youtube.com/c/patrickcollins)
