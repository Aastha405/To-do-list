// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskReward {
    mapping(address => uint) public earnedRewards;

    // View earned reward balance
    function viewEarnedRewards(address _user) external view returns (uint) {
        return earnedRewards[_user];
    }

    // Claim earned rewards and reset balance
    function claimReward() external {
        uint reward = earnedRewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        earnedRewards[msg.sender] = 0;

        // Here we simply send Ether, but this could also be an ERC20 transfer
        payable(msg.sender).transfer(reward);
    }

    // Allow contract to receive Ether
    receive() external payable {}
}
