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
        payable(msg.sender).transfer(reward);
    }

    // Allow contract to receive Ether
    receive() external payable {}

    // Add reward for a specific user
    function addReward(address _user, uint _amount) external payable {
        require(msg.value == _amount, "Sent value must match reward amount");
        earnedRewards[_user] += _amount;
    }

    // View total Ether available in the contract for rewards
    function getTotalRewardsPool() external view returns (uint) {
        return address(this).balance;
    }
}
