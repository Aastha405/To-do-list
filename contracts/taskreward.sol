// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskReward {
    mapping(address => uint) public earnedRewards;

    // View earned reward balance
    function viewEarnedRewards(address _user) external view returns (uint) {
        return earnedRewards[_user];
    }
}
