// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskReward {
    address public owner;
    mapping(address => uint) public earnedRewards;
    address[] private users; // ✅ Track user list

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

    // Add reward for a specific user (modified to track users)
    function addReward(address _user, uint _amount) external payable {
        require(msg.value == _amount, "Sent value must match reward amount");
        if (earnedRewards[_user] == 0) {
            users.push(_user); // Track new user
        }
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

    // Transfer rewards between users (no Ether movement)
    function transferReward(address _from, address _to, uint _amount) external onlyOwner {
        require(earnedRewards[_from] >= _amount, "Insufficient rewards to transfer");
        if (earnedRewards[_to] == 0) {
            users.push(_to); // Track new recipient
        }
        earnedRewards[_from] -= _amount;
        earnedRewards[_to] += _amount;
    }

    // Remove/reset a user's reward
    function removeUserReward(address _user) external onlyOwner {
        require(earnedRewards[_user] > 0, "No rewards to remove");
        earnedRewards[_user] = 0;
    }

    // Check if user has any rewards
    function hasReward(address _user) external view returns (bool) {
        return earnedRewards[_user] > 0;
    }

    // ✅ NEW FUNCTION: Get all users and their rewards
    function getAllUsersWithRewards() external view returns (address[] memory, uint[] memory) {
        uint[] memory rewards = new uint[](users.length);
        for (uint i = 0; i < users.length; i++) {
            rewards[i] = earnedRewards[users[i]];
        }
        return (users, rewards);
    }
}
