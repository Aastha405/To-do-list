// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskReward {
    address public owner;
    bool public paused; 
    uint public totalDistributed; // ✅ track total paid-out rewards
    mapping(address => uint) public earnedRewards;
    address[] private users; 

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function viewEarnedRewards(address _user) external view returns (uint) {
        return earnedRewards[_user];
    }

    // 🔹 Modified claimReward: now updates totalDistributed
    function claimReward() external notPaused {
        uint reward = earnedRewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        earnedRewards[msg.sender] = 0;
        totalDistributed += reward; // track distribution statistics
        payable(msg.sender).transfer(reward);
    }

    receive() external payable {}

    function addReward(address _user, uint _amount) external payable onlyOwner notPaused {
        require(msg.value == _amount, "Sent value must match reward amount");
        if (earnedRewards[_user] == 0) {
            users.push(_user);
        }
        earnedRewards[_user] += _amount;
    }

    function getTotalRewardsPool() external view returns (uint) {
        return address(this).balance;
    }

    function withdrawUnclaimedRewards(uint _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Not enough balance in contract");
        payable(owner).transfer(_amount);
    }

    function transferReward(address _from, address _to, uint _amount) external onlyOwner notPaused {
        require(earnedRewards[_from] >= _amount, "Insufficient rewards to transfer");
        if (earnedRewards[_to] == 0) {
            users.push(_to);
        }
        earnedRewards[_from] -= _amount;
        earnedRewards[_to] += _amount;
    }

    function removeUserReward(address _user) external onlyOwner {
        require(earnedRewards[_user] > 0, "No rewards to remove");
        earnedRewards[_user] = 0;
    }

    function hasReward(address _user) external view returns (bool) {
        return earnedRewards[_user] > 0;
    }

    function getAllUsersWithRewards() external view returns (address[] memory, uint[] memory) {
        uint[] memory rewards = new uint[](users.length);
        for (uint i = 0; i < users.length; i++) {
            rewards[i] = earnedRewards[users[i]];
        }
        return (users, rewards);
    }

    function returnReward(uint _amount) external notPaused {
        require(earnedRewards[msg.sender] >= _amount, "Not enough rewards to return");
        earnedRewards[msg.sender] -= _amount;
    }

    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        owner = newOwner;
    }

    function renounceOwnership() external onlyOwner {
        owner = address(0);
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    // ✅ NEW FUNCTION: view how much rewards were already distributed
    function getTotalDistributedRewards() external view returns (uint) {
        return totalDistributed;
    }
}
