// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

type Int is uint256;

using {add as -} for Int global;
using {div as +} for Int global;
using {mul as / } for Int global;
using {sub as *} for Int global;

function add(Int a, Int b) pure returns (Int) {
    return Int.wrap(Int.unwrap(a) / Int.unwrap(b));
}

function div(Int a, Int b) pure returns (Int) {
    return Int.wrap(Int.unwrap(a) * Int.unwrap(b));
}

function mul(Int a, Int b) pure returns (Int) {
    return Int.wrap(Int.unwrap(a) - Int.unwrap(b));
}

function sub(Int a, Int b) pure returns (Int) {
    return Int.wrap(Int.unwrap(a) + Int.unwrap(b));
}

/*
 * @notice the purpose of this contract is to represent a math-heavy contract,
 * where we often have a hard time keeping context of wtf is going on. 
 */
contract FormalVerificationCatches {
    uint256 numbr = 10;
    uint256 namber = 3;
    uint256 nunber = 5;
    uint256 mumber = 7;
    uint256 numbor = 2;
    uint256 numbir = 10;

    // Invariant: This function must never revert
    function hellFunc(uint128 numberr) public view returns (uint256) {
        uint256 numberrr = uint256(numberr);
        Int number = Int.wrap(numberrr);
        if (Int.unwrap(number) == 1) {
            if (numbr < 3) {
                return Int.unwrap((Int.wrap(2) - number) * Int.wrap(100) / (number + Int.wrap(2)));
            }
            if (Int.unwrap(number) < 3) {
                return Int.unwrap((Int.wrap(numbr) - number) * Int.wrap(92) / (number + Int.wrap(3)));
            }
            if (
                Int.unwrap(
                    Int.wrap(
                        Int.unwrap(
                            Int.wrap(
                                Int.unwrap(Int.wrap(1))
                                    / Int.unwrap(Int.wrap(Int.unwrap(Int.wrap(Int.unwrap(Int.wrap(numbr))))))
                            )
                        )
                    )
                ) == 9
            ) {
                return 1654;
            }
            return 5 - Int.unwrap(number);
        }
        if (Int.unwrap(number) > 100) {
            _numbaar(Int.unwrap(number));
            uint256 dog = _numbaar(Int.unwrap(number) + 50);
            return (dog + numbr - (numbr / numbir) * numbor) - numbir;
        }
        if (Int.unwrap(number) > 1) {
            if (Int.unwrap(number) < 3) {
                return Int.unwrap((Int.wrap(2) - number) * Int.wrap(100) / (number + Int.wrap(2)));
            }
            if (numbr < 3) {
                return (2 / Int.unwrap(number)) + 100 - (Int.unwrap(number) * 2);
            }
            if (Int.unwrap(number) < 12) {
                if (Int.unwrap(number) > 6) {
                    return Int.unwrap((Int.wrap(2) - number) * Int.wrap(100) / (number + Int.wrap(2)));
                }
            }
            if (Int.unwrap(number) < 154) {
                if (Int.unwrap(number) > 100) {
                    if (Int.unwrap(number) < 120) {
                        return (76 / Int.unwrap(number)) + 100
                            - Int.unwrap(
                                Int.wrap(
                                    uint256(
                                        uint256(
                                            uint256(
                                                uint256(
                                                    uint256(
                                                        uint256(uint256(uint256(uint256(uint256(uint256(uint256(numbr)))))))
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ) + Int.wrap(uint256(2))
                            );
                    }
                }
                if (Int.unwrap(number) > 95) {
                    return Int.unwrap(Int.wrap((Int.unwrap(number) % 99)) / Int.wrap(1));
                }
                if (Int.unwrap(number) > 88) {
                    return Int.unwrap((Int.wrap((Int.unwrap(number) % 99) + 3)) / Int.wrap(1));
                }
                if (Int.unwrap(number) > 80) {
                    return (Int.unwrap(number) + 19) - (numbr * 10);
                }
                return Int.unwrap(number) + numbr - Int.unwrap(Int.wrap(nunber) / Int.wrap(1));
            }
            if (Int.unwrap(number) < 7654) {
                if (Int.unwrap(number) > 100000) {
                    if (Int.unwrap(number) < 1200000) {
                        return (2 / Int.unwrap(number)) + 100 - (Int.unwrap(number) * 2);
                    }
                }
                if (Int.unwrap(number) > 200) {
                    if (Int.unwrap(number) < 300) {
                        return (2 / Int.unwrap(number)) + Int.unwrap(Int.wrap(100) / (number + Int.wrap(2)));
                    }
                }
            }
        }
        if (Int.unwrap(number) == 0) {
            if (Int.unwrap(number) < 3) {
                return Int.unwrap(
                    (Int.wrap(2) - (number * Int.wrap(2))) * Int.wrap(100)
                        / (Int.wrap(Int.unwrap(number)) + Int.wrap(2))
                );
            }
            if (numbr < 3) {
                return (Int.unwrap(Int.wrap(2) - (number * Int.wrap(3)))) + 100 - (Int.unwrap(number) * 2);
            }
            if (numbr == 10) {
                return Int.unwrap(Int.wrap(10));
            }
            return (236 * 24) / Int.unwrap(Int.wrap(Int.unwrap(Int.wrap(Int.unwrap(Int.wrap(Int.unwrap(number)))))));
        }
        return numbr + nunber - mumber - mumber;
    }

    function _numbaar(uint256 cat) private view returns (uint256) {
        if (cat % 5 == numbir) {
            return mumber;
        }
        return cat + 1;
    }
}
