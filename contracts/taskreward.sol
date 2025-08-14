// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskReward {
    address public owner;
    mapping(address => uint) public earnedRewards;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

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

    // Owner can withdraw unclaimed rewards
    function withdrawUnclaimedRewards(uint _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Not enough balance in contract");
        payable(owner).transfer(_amount);
    }

    // ✅ New function: Transfer rewards between users (no Ether movement)
    function transferReward(address _from, address _to, uint _amount) external onlyOwner {
        require(earnedRewards[_from] >= _amount, "Insufficient rewards to transfer");
        earnedRewards[_from] -= _amount;
        earnedRewards[_to] += _amount;
    }
}
