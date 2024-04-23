// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title Weighted Voting
 * @dev A contract for weighted voting using an ERC20 token.
 *      Each token represents a vote, and the weight of a vote is proportional to the number of tokens held.
 */
contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    struct SerializedIssue {
        address[] voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    Issue[] private issues;
    mapping(address => bool) public tokensClaimed;

    uint256 public maxSupply = 1000000; // Maximum token supply
    uint256 public claimAmount = 100; // Tokens claimable per address

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh();
    error AlreadyVoted();
    error VotingClosed();

    /**
     * @dev Constructor to initialize the ERC20 token with a name and symbol.
     * @param name The name of the ERC20 token.
     * @param symbol The symbol of the ERC20 token.
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        issues.push(); // Initialize with a dummy issue to start indexing from 1
    }

    /**
     * @notice Allows a user to claim a designated amount of tokens once.
     */
    function claim() public {
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true;
    }

    
    /**
 * @dev Creates a new voting issue with a specified description and quorum.
 * This function allows token holders to create new issues for voting where the quorum
 * specifies the minimum number of votes required to make a decision on the issue.
 * 
 * Reverts if:
 * - The caller holds no tokens.
 * - The specified quorum is higher than the current total supply of tokens,
 *   implying it would be impossible to reach a decision.
 *
 * @param _issueDesc The description of the issue to be created.
 * @param _quorum The minimum number of votes required to decide the issue.
 * @return issueIndex The index of the newly created issue in the array of issues.
 */
function createIssue(string calldata _issueDesc, uint256 _quorum)
    external
    returns (uint256 issueIndex)
{
    // Ensure the caller has tokens before allowing them to create an issue
    if (balanceOf(msg.sender) == 0) {
        revert NoTokensHeld();
    }
    // Ensure the quorum does not exceed the total supply of tokens
    if (_quorum > totalSupply()) {
        revert QuorumTooHigh();
    }
    // Add a new issue to the list
    Issue storage _issue = issues.push();
    _issue.issueDesc = _issueDesc;
    _issue.quorum = _quorum;

    // Return the index of the newly created issue
    issueIndex = issues.length - 1;
}

    /**
     * @notice Retrieves detailed information about a specific issue.
     * @param issueId The index of the issue.
     * @return SerializedIssue The details of the issue.
     */
    function getIssue(uint256 issueId) external view returns (SerializedIssue memory) {
        Issue storage issue = issues[issueId];
        return SerializedIssue({
            voters: issue.voters.values(),
            issueDesc: issue.issueDesc,
            quorum: issue.quorum,
            totalVotes: issue.totalVotes,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    /**
     * @notice Casts a vote on a specific issue.
     * @param issueId The index of the issue to vote on.
     * @param voteoption The voting option (AGAINST, FOR, ABSTAIN).
     */
    function vote(uint256 issueId, Vote voteoption) public {
        Issue storage issue = issues[issueId];
        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        uint256 nTokens = balanceOf(msg.sender);
        if (nTokens == 0) {
            revert NoTokensHeld();
        }

        if (voteoption == Vote.AGAINST) {
            issue.votesAgainst += nTokens;
        } else if (voteoption == Vote.FOR) {
            issue.votesFor += nTokens;
        } else {
            issue.votesAbstain += nTokens;
        }

        issue.voters.add(msg.sender);
        issue.totalVotes += nTokens;

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed = issue.votesFor > issue.votesAgainst;
        }
    }
}
