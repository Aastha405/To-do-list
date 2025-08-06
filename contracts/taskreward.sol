// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IToDoList {
    function completeTask(uint _index) external;
    function getTask(uint _index) external view returns (
        string memory, bool, uint, uint, uint
    );
}

interface IERC20Token {
    function transfer(address to, uint amount) external returns (bool);
}

contract TaskReward {
    IToDoList public todoList;
    IERC20Token public rewardToken;
    address public owner;
    uint public rewardPerTask;

    mapping(address => uint) public earnedRewards;

    event TaskRewarded(address indexed user, uint indexed taskId, uint reward);
    event RewardWithdrawn(address indexed user, uint amount);
    event RewardPerTaskUpdated(uint newReward);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    constructor(address _todoListAddress, address _rewardTokenAddress, uint _rewardPerTask) {
        todoList = IToDoList(_todoListAddress);
        rewardToken = IERC20Token(_rewardTokenAddress);
        rewardPerTask = _rewardPerTask;
        owner = msg.sender;
    }

    // Complete task & earn rewards
    function completeAndEarn(uint _taskId) external {
        (, bool completed,,,) = todoList.getTask(_taskId);
        require(!completed, "Task already completed");

        todoList.completeTask(_taskId);
        earnedRewards[msg.sender] += rewardPerTask;

        emit TaskRewarded(msg.sender, _taskId, rewardPerTask);
    }

    // Withdraw earned tokens
    function withdrawRewards() external {
        uint reward = earnedRewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");

        earnedRewards[msg.sender] = 0;
        require(rewardToken.transfer(msg.sender, reward), "Token transfer failed");

        emit RewardWithdrawn(msg.sender, reward);
    }

    // Owner can update reward amount per task
    function updateRewardPerTask(uint _newReward) external onlyOwner {
        rewardPerTask = _newReward;
        emit RewardPerTaskUpdated(_newReward);
    }

    // Owner can transfer contract ownership
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "New owner can't be zero address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    // View earned reward balance
    function viewEarnedRewards(address _user) external view returns (uint) {
        return earnedRewards[_user];
    }
}

