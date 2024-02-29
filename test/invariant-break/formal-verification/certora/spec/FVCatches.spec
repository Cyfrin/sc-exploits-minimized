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
  // env e;
  // require(e.msg.value == 0);

  hellFunc@withrevert(number);
  assert(lastReverted == false);
}

// // Wait... isn't this just a rule? 
// "If i point at the contract in some state, is it reasonable for me to ask if X holds?" 
// if the answer to this is yes, then X is an invariant.

// invariant hell_func_never_reverts(uint128 number)
//   hellFunc@withrevert(number)
//   { preserved with (env e) { require e.msg.sender != 0; } }