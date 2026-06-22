// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
 * @notice A minimal, vulnerable on-chain governance contract.
 * @notice Voting power is read from the LIVE token balance at vote time, instead
 *         of a historical snapshot/checkpoint. Because of this, anyone who can
 *         momentarily hold a large amount of the governance token (for example by
 *         taking a flash loan) can single-handedly pass and execute any proposal.
 */
contract Governance {
    struct Proposal {
        address target;
        bytes data;
        uint256 votesFor;
        bool executed;
    }

    IERC20 public immutable i_governanceToken;
    uint256 public immutable i_quorum;
    uint256 public s_proposalCount;

    mapping(uint256 proposalId => Proposal) public s_proposals;
    mapping(uint256 proposalId => mapping(address voter => bool)) public s_hasVoted;

    error Governance__AlreadyVoted();
    error Governance__AlreadyExecuted();
    error Governance__QuorumNotReached();
    error Governance__CallFailed();

    constructor(IERC20 governanceToken, uint256 quorum) {
        i_governanceToken = governanceToken;
        i_quorum = quorum;
    }

    function propose(address target, bytes calldata data) external returns (uint256 proposalId) {
        proposalId = s_proposalCount++;
        Proposal storage proposal = s_proposals[proposalId];
        proposal.target = target;
        proposal.data = data;
    }

    // This is vulnerable! The voting weight is the caller's CURRENT token balance.
    // There is no snapshot, so flash-loaned tokens are counted as votes.
    function vote(uint256 proposalId) external {
        if (s_hasVoted[proposalId][msg.sender]) {
            revert Governance__AlreadyVoted();
        }
        s_hasVoted[proposalId][msg.sender] = true;
        s_proposals[proposalId].votesFor += i_governanceToken.balanceOf(msg.sender);
    }

    // This is vulnerable too! A proposal can be proposed, voted on, and executed in
    // the same block. There is no voting delay and no timelock, so the entire attack
    // fits inside a single flash-loan callback.
    function execute(uint256 proposalId) external {
        Proposal storage proposal = s_proposals[proposalId];
        if (proposal.executed) {
            revert Governance__AlreadyExecuted();
        }
        if (proposal.votesFor < i_quorum) {
            revert Governance__QuorumNotReached();
        }
        proposal.executed = true;
        (bool success,) = proposal.target.call(proposal.data);
        if (!success) {
            revert Governance__CallFailed();
        }
    }

    // Prevention:
    // - Snapshot voting power at proposal creation and read it with a historical
    //   lookup (e.g. OpenZeppelin's ERC20Votes + getPastVotes). Tokens acquired
    //   after the snapshot then carry no weight, which neutralizes flash loans.
    // - Add a voting delay between when a proposal is created and when voting opens.
    // - Add a timelock between a successful vote and execution.
}
