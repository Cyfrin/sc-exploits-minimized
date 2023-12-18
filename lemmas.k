requires "evm.md"
requires "foundry.md"

module FV-LEMMAS
    imports BOOL
    imports FOUNDRY
    imports INFINITE-GAS
    imports INT-SYMBOLIC
    imports MAP-SYMBOLIC
    imports SET-SYMBOLIC

    syntax StepSort ::= Int
                      | Bool
                      | Bytes
                      | Set
 // -------------------------

    syntax KItem ::= runLemma ( StepSort )
                   | doneLemma( StepSort )

    rule <k> runLemma(T) => doneLemma(T) ... </k>
 // ---------------------------------------------

    syntax Bool ::= #notEq ( KItem, KItem )  [function, no-evaluators]

 // ----------------------------------------------------------------------------------------------------

    //
    // Bool
    //

    rule X ==Bool true => X [simplification]
    rule true ==Bool X => X [simplification]

    rule false ==Bool X => notBool X [simplification]
    rule X ==Bool false => notBool X [simplification]

    rule notBool notBool X => X [simplification]

    rule   notBool X ==Bool  notBool Y   =>   X ==Bool  Y   [simplification]
    rule { notBool X #Equals notBool Y } => { X #Equals Y } [simplification]

    rule bool2Word ( X ) => 1 requires X         [simplification]
    rule bool2Word ( X ) => 0 requires notBool X [simplification]

    rule   bool2Word ( X )  ==Int  bool2Word ( Y )   =>   X ==Bool  Y   [simplification]
    rule { bool2Word ( X ) #Equals bool2Word ( Y ) } => { X #Equals Y } [simplification]

    //
    // ML
    //

    rule { true  #Equals X     ==K   Y     } => { X #Equals Y } [simplification]
    rule { true  #Equals X:Int ==Int Y:Int } => { X #Equals Y } [simplification]
    rule { false #Equals X     ==K   Y     } => #Not ( { X #Equals Y } ) [simplification]
    rule { false #Equals X:Int ==Int Y:Int } => #Not ( { X #Equals Y } ) [simplification]
    rule { true  #Equals notBool X:Bool } => { false #Equals X } [simplification]
    rule { false #Equals notBool X:Bool } => { true  #Equals X } [simplification]

    rule { X     ==K   Y     #Equals true  } => { X #Equals Y } [simplification]
    rule { X:Int ==Int Y:Int #Equals true  } => { X #Equals Y } [simplification]
    rule { X     ==K   Y     #Equals false } => #Not ( { X #Equals Y } ) [simplification]
    rule { X:Int ==Int Y:Int #Equals false } => #Not ( { X #Equals Y } ) [simplification]

    rule { notBool X:Bool #Equals true  } => { false #Equals X } [simplification]
    rule { notBool X:Bool #Equals false } => { true  #Equals X } [simplification]

    //
    // Bitwise simplifications
    //

    // Concrete to the left
    rule A &Int B => B &Int A [simplification(40), concrete(B), symbolic(A)]
    rule A |Int B => B |Int A [simplification(40), concrete(B), symbolic(A)]

    // Non-zeroedness of |Int
    rule X |Int _ ==Int 0 => false
      requires 0 <Int X
      [simplification]

    // Moving from &Int to modInt
    rule 1 &Int X => X modInt 2 [simplification]

    // &Int yields zero for notMax and operand in appropriate range
    rule [bitwise-and-zero]:
      X &Int Y => 0
      requires 0 <=Int X
       andBool pow256 -Int X ==Int 2 ^Int log2Int(pow256 -Int X)
       andBool 0 <=Int Y andBool Y <Int 2 ^Int log2Int(pow256 -Int X)
       [concrete(X), simplification, comm]

    // Deconstruction of <<Int into #buf
    rule X <<Int Y => #asWord ( #buf ( 32 -Int (Y /Int 8) , X ) +Bytes #buf ( Y /Int 8 , 0 ) )
      requires 0 <=Int X andBool X <Int 2 ^Int (256 -Int Y)
       andBool 0 <=Int Y andBool Y <=Int 256 andBool Y modInt 8 ==Int 0
      [simplification, concrete(Y)]
    rule Z <Int X &Int Y => false
      requires #rangeUInt(256, X)
       andBool #rangeUInt(256, Y)
       andBool #rangeUInt(256, Z)
       andBool ((Y <Int Z) orBool (X <Int Z))
      [simplification]

    rule X &Int Y <Int Z => true
      requires #rangeUInt(256, X)
       andBool #rangeUInt(256, Y)
       andBool #rangeUInt(256, Z)
       andBool ((Y <Int Z) orBool (X <Int Z))
      [simplification]

    rule X &Int #asWord ( _Y +Bytes Z ) => X &Int #asWord ( Z )
      requires X <Int 2 ^Int (8 *Int lengthBytes(Z))
      [concrete(X, Z), simplification]

    rule X &Int #asWord ( _ +Bytes Z ) >>Int T => X &Int #asWord ( Z ) >>Int T
      requires X <Int 2 ^Int (8 *Int lengthBytes(Z) -Int T)
      [concrete(X, Z, T), simplification]

    // |Int distributivity over #asWord and +Bytes, v1
    rule A |Int #asWord ( BA1 +Bytes BA2 ) =>
      #asWord ( BA1 +Bytes #buf ( lengthBytes(BA2), A |Int #asWord ( BA2 ) ) )
      requires A <Int 2 ^Int (8 *Int lengthBytes(BA2))
      [concrete(A), simplification]

    // |Int distributivity over #asWord and +Bytes, v2
    rule A |Int #asWord ( BA1 +Bytes BA2 ) =>
      #asWord (
        #buf ( lengthBytes(BA1), (A >>Int (8 *Int lengthBytes(BA2))) |Int #asWord ( BA1 ) )
        +Bytes
        #buf ( lengthBytes(BA2), (A modInt (2 ^Int (8 *Int lengthBytes(BA2)))) |Int #asWord ( BA2 ) )
      )
      requires 0 <=Int A
      [simplification(40), concrete(A, BA1)]


    //
    // &Int
    //

    // Commutativity
    rule   A &Int B  ==Int  B &Int A   => true [simplification, smt-lemma]
    rule { A &Int B #Equals B &Int A } => #Top [simplification]

    // Distributivity of &Int and |Int
    rule A &Int (B |Int C) => (A &Int B) |Int (A &Int C)
    [concrete(A, B), simplification]

    rule A &Int (B |Int C) => (A &Int B) |Int (A &Int C)
    [concrete(A, C), simplification]

    // &Int on non-negative integers remains non-negative
    rule 0 <=Int (X &Int Y) => true
      requires 0 <=Int X
       andBool 0 <=Int Y
      [simplification, smt-lemma]

    // Result of &Int cannot be greater than the operands
    rule (X &Int Y) <=Int Z => true
      requires 0 <=Int X
       andBool 0 <=Int Y
       andBool (X <=Int Z orBool Y <=Int Z)
      [simplification]

    // Anything negative is <Int than &Int
    rule A <Int X &Int Y => true
      requires 0 <=Int X andBool 0 <=Int Y
       andBool A <Int 0
      [simplification, concrete(A)]

    // Deconstruction of (maxUInt &Int ...)
    rule maxUInt8   &Int #asWord ( BA ) => #asWord ( #range(BA, 31,  1) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt16  &Int #asWord ( BA ) => #asWord ( #range(BA, 30,  2) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt24  &Int #asWord ( BA ) => #asWord ( #range(BA, 29,  3) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt32  &Int #asWord ( BA ) => #asWord ( #range(BA, 28,  4) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt40  &Int #asWord ( BA ) => #asWord ( #range(BA, 27,  5) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt48  &Int #asWord ( BA ) => #asWord ( #range(BA, 26,  6) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt56  &Int #asWord ( BA ) => #asWord ( #range(BA, 25,  7) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt64  &Int #asWord ( BA ) => #asWord ( #range(BA, 24,  8) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt72  &Int #asWord ( BA ) => #asWord ( #range(BA, 23,  9) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt80  &Int #asWord ( BA ) => #asWord ( #range(BA, 22, 10) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt88  &Int #asWord ( BA ) => #asWord ( #range(BA, 21, 11) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt96  &Int #asWord ( BA ) => #asWord ( #range(BA, 20, 12) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt104 &Int #asWord ( BA ) => #asWord ( #range(BA, 19, 13) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt112 &Int #asWord ( BA ) => #asWord ( #range(BA, 18, 14) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt120 &Int #asWord ( BA ) => #asWord ( #range(BA, 17, 15) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt128 &Int #asWord ( BA ) => #asWord ( #range(BA, 16, 16) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt136 &Int #asWord ( BA ) => #asWord ( #range(BA, 15, 17) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt144 &Int #asWord ( BA ) => #asWord ( #range(BA, 14, 18) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt152 &Int #asWord ( BA ) => #asWord ( #range(BA, 13, 19) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt160 &Int #asWord ( BA ) => #asWord ( #range(BA, 12, 20) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt168 &Int #asWord ( BA ) => #asWord ( #range(BA, 11, 21) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt176 &Int #asWord ( BA ) => #asWord ( #range(BA, 10, 22) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt184 &Int #asWord ( BA ) => #asWord ( #range(BA,  9, 23) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt192 &Int #asWord ( BA ) => #asWord ( #range(BA,  8, 24) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt200 &Int #asWord ( BA ) => #asWord ( #range(BA,  7, 25) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt208 &Int #asWord ( BA ) => #asWord ( #range(BA,  6, 26) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt216 &Int #asWord ( BA ) => #asWord ( #range(BA,  5, 27) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt224 &Int #asWord ( BA ) => #asWord ( #range(BA,  4, 28) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt232 &Int #asWord ( BA ) => #asWord ( #range(BA,  3, 29) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt240 &Int #asWord ( BA ) => #asWord ( #range(BA,  2, 30) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt248 &Int #asWord ( BA ) => #asWord ( #range(BA,  1, 31) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule maxUInt256 &Int #asWord ( BA ) => #asWord ( #range(BA,  0, 32) ) requires lengthBytes(BA) ==Int 32 [simplification]

    // Deconstruction of (notMaxUInt &Int ...)
    rule notMaxUInt8   &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 31) +Bytes #buf (  1, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt16  &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 30) +Bytes #buf (  2, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt32  &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 28) +Bytes #buf (  4, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt64  &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 24) +Bytes #buf (  8, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt96  &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 20) +Bytes #buf ( 12, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt128 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 16) +Bytes #buf ( 16, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt160 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 12) +Bytes #buf ( 20, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt192 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 8)  +Bytes #buf ( 24, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt208 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 6)  +Bytes #buf ( 26, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt224 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 4)  +Bytes #buf ( 28, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt240 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 2)  +Bytes #buf ( 30, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]
    rule notMaxUInt248 &Int #asWord ( BA ) => #asWord ( #range(BA, 0, 1)  +Bytes #buf ( 31, 0 ) ) requires lengthBytes(BA) ==Int 32 [simplification]

    // Irrelevance of lower bits
    rule notMaxUInt8   &Int (X |Int (maxUInt8   &Int _)) => notMaxUInt8   &Int X [simplification]
    rule notMaxUInt16  &Int (X |Int (maxUInt16  &Int _)) => notMaxUInt16  &Int X [simplification]
    rule notMaxUInt32  &Int (X |Int (maxUInt32  &Int _)) => notMaxUInt32  &Int X [simplification]
    rule notMaxUInt64  &Int (X |Int (maxUInt64  &Int _)) => notMaxUInt64  &Int X [simplification]
    rule notMaxUInt96  &Int (X |Int (maxUInt96  &Int _)) => notMaxUInt96  &Int X [simplification]
    rule notMaxUInt128 &Int (X |Int (maxUInt128 &Int _)) => notMaxUInt128 &Int X [simplification]
    rule notMaxUInt160 &Int (X |Int (maxUInt160 &Int _)) => notMaxUInt160 &Int X [simplification]
    rule notMaxUInt192 &Int (X |Int (maxUInt192 &Int _)) => notMaxUInt192 &Int X [simplification]
    rule notMaxUInt208 &Int (X |Int (maxUInt208 &Int _)) => notMaxUInt208 &Int X [simplification]
    rule notMaxUInt224 &Int (X |Int (maxUInt224 &Int _)) => notMaxUInt224 &Int X [simplification]
    rule notMaxUInt240 &Int (X |Int (maxUInt240 &Int _)) => notMaxUInt240 &Int X [simplification]
    rule notMaxUInt248 &Int (X |Int (maxUInt248 &Int _)) => notMaxUInt248 &Int X [simplification]

    // Prepend 4 bytes (used for function selectors)
    rule A |Int #asWord ( BUF ) => #asWord ( #range ( #buf ( 32 , A ) , 0 , 4 ) +Bytes BUF )
        requires notMaxUInt224 &Int A ==Int A
         andBool lengthBytes ( BUF ) ==Int 28
        [simplification, concrete(A)]


    rule #buf ( 32, A |Int #asWord ( B:Bytes ) ) => #buf (32 -Int lengthBytes(B), A >>Int (8 *Int lengthBytes(B)) ) +Bytes B
      requires 0 <=Int A andBool A <Int pow256
       andBool lengthBytes(B) <=Int 32
       andBool A modInt (2 ^Int lengthBytes(B)) ==Int 0
      [simplification, concrete(A)]

    //
    // Arithmetic
    //
    rule chop ( X ) => X
      requires 0 <=Int X andBool X <Int pow256
      [simplification]
    rule 0 <=Int A +Int B => true
        requires 0 <=Int A andBool 0 <=Int B
        [simplification]
    //
    // Sets
    //

    // Empty sets has no elements
    rule _ in .Set => false [simplification]
    rule { true  #Equals _ in .Set} => #Bottom [simplification]
    rule { false #Equals _ in .Set} => #Top    [simplification]

    rule S:Set |Set SetItem( X ) => S requires X in S [simplification]
    rule X in _:Set SetItem( Y ) => true   requires X ==Int Y  [simplification]
    rule X in S:Set SetItem( Y ) => X in S requires X =/=Int Y [simplification]
    rule (S1:Set |Set SetItem( X )) |Set S2:Set => S1 |Set S2                requires         X in S2 [simplification, concrete(X, S2)]
    rule (S1:Set |Set SetItem( X )) |Set S2:Set => S1 |Set ( SetItem(X) S2 ) requires notBool X in S2 [simplification, concrete(X, S2)]
    //
    // #lookup
    //
    rule #lookup(.Map, _) => 0
      [simplification]

    rule #lookup((K:Int |-> _:Int) M:Map, X:Int) => #lookup(M, X)
      requires X =/=Int K
      [simplification]

    rule #lookup(M:Map [K:Int <- _], X:Int) => #lookup(M, X)
      requires X =/=Int K
      [simplification]

    rule M:Map [ K:Int <- V:Int ] => M
      requires V ==Int #lookup(M, K)
       andBool V =/=Int 0
       [simplification]

    //
    // keccak assumptions: these assumptions are not sound in principle, but are
    // required for verification - they should be collected at the end of execution
    //

    rule 0 <=Int keccak( _ )             => true [simplification, smt-lemma]
    rule         keccak( _ ) <Int pow256 => true [simplification, smt-lemma]

    // keccak does not equal a concrete value
    rule [keccak-eq-conc-false]: keccak(A)  ==Int B => false [symbolic(A), concrete(B), simplification, comm]
    rule [keccak-neq-conc-true]: keccak(A) =/=Int B => true  [symbolic(A), concrete(B), simplification, comm]

    rule [keccak-eq-conc-false-ml]: { keccak(_A) #Equals _B } => #Bottom [symbolic(_A), concrete(_B), simplification, comm]

    // keccak is injective
    rule [keccak-inj]: keccak(A) ==Int keccak(B) => A ==K B [simplification]

    // keccak has no "fixpoint"
    rule [keccak-no-fix-eq-false]: #buf(32, keccak(X))  ==K X => false [simplification]
    rule [keccak-no-fix-neq-true]: #buf(32, keccak(X)) =/=K X => true  [simplification]

    // chop of negative keccak
    rule chop (0 -Int keccak(BA)) => pow256 -Int keccak(BA)
       [simplification]

    // keccak cannot equal a number outside of its range
    rule { X #Equals keccak (_) } => #Bottom
      requires X <Int 0 orBool X >=Int pow256
      [concrete(X), simplification]
  
    // anything negative is smaller than a keccak
    rule X <Int keccak ( _ ) => true
      requires X <Int 0
      [concrete(X), simplification]

    // a keccak is smaller than anything greater than pow256 - 32
    rule keccak ( _ ) <Int X => true
      requires (pow256 -Int 32) <Int X
      [concrete(X), simplification]
endmodule