/*
 * ./src/invariant-break/FormalVerificationCatches.sol 
 *
 * Certora Formal Verification Spec
 */ 

methods {
  function hellFunc(uint128) external returns uint256 envfree;
}

// Invariant: hellFunc must never revert
rule hellFuncMustNeverRevert(uint128 number) {
  require(currentContract.numbr == 10);
  require(currentContract.namber == 3);
  require(currentContract.nunber == 5);
  require(currentContract.mumber == 7);
  require(currentContract.numbor == 2);
  require(currentContract.numbir == 10);
  env e;
  require(e.msg.value == 0);

  hellFunc@withrevert(number);
  assert(lastReverted == false);
}