/*
 * ./src/invariant-break/FormalVerificationCatches.sol 
 *
 * Certora Formal Verification Spec
 */ 

methods {
  function tryCatchHellFunc(uint128) external returns bool envfree;
}

// This is technically unsound... and doesn't work anyways! 
invariant hell_func_never_reverts(uint128 number)
  tryCatchHellFunc(number) == true
  { 
    preserved with (env e) { require e.msg.sender != 0; } 
  }