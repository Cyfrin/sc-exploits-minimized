-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all:  remove install build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit && forge install runtimeverification/kontrol-cheatcodes --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

coverage :; forge coverage 

coverage-report :; forge coverage --report debug > coverage-report.txt

scope :; tree ./src/ | sed 's/└/#/g; s/──/--/g; s/├/#/g; s/│ /|/g; s/│/|/g'

scopefile :; @tree ./src/ | sed 's/└/#/g' | awk -F '── ' '!/\.sol$$/ { path[int((length($$0) - length($$2))/2)] = $$2; next } { p = "src"; for(i=2; i<=int((length($$0) - length($$2))/2); i++) if (path[i] != "") p = p "/" path[i]; print p "/" $$2; }' > scope.txt

slither :; slither . --config-file slither.config.json 

aderyn :; aderyn --root .

certora :; certoraRun ./test/invariant-break/formal-verification/certora/conf/FVCatches.conf

# Why doesn't this one work?
certoraInvariant :; certoraRun ./test/invariant-break/formal-verification/certora/conf/FVCatchesInvariant.conf

# createMutation :; certoraRun ./test/invariant-break/formal-verification/certora/conf/FVCatchesInvariant.conf --generate_mutation_conf mutations.mconf 
# mutate :; certoraMutate --prover_conf ./test/invariant-break/formal-verification/certora/conf/FVCatchesInvariant.conf --mutation_conf  mutations.mconf 

kontrol-build :;  kontrol build --rekompile --require lemmas.k --module-import KontrolTest:FV-LEMMAS
kontrol-prove :;  kontrol prove --match-test KontrolTest.test_hellFunc_doesnt_revert_kontrol --fail-fast --counterexample-information --auto-abstract-gas --no-break-on-calls
kontrol-view :; kontrol view-kcfg KontrolTest.test_hellFunc_doesnt_revert_kontrol
kontrol-node :; kontrol get-model KontrolTest.test_hellFunc_doesnt_revert_kontrol --node 86

halmos :; halmos --function check_hellFunc_doesnt_revert_halmos
