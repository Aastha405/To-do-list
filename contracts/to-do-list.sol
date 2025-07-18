// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    enum Priority { Low, Medium, High }

    struct Task {
        string description;
        bool completed;
        uint timestamp;
        uint expiration;
        Priority priority;
    }

    mapping(address => Task[]) private userTasks;

    event TaskAdded(address indexed user, uint indexed taskId, string description);
    event TaskCompleted(address indexed user, uint indexed taskId);
    event TaskUpdated(address indexed user, uint indexed taskId, string newDescription);
    event TaskDeleted(address indexed user, uint indexed taskId);
    event TaskToggled(address indexed user, uint indexed taskId);
    event AllTasksCleared(address indexed user);
    event AllTasksMarkedCompleted(address indexed user);
    event AllTasksMarkedPending(address indexed user);
    event TaskExpirationUpdated(address indexed user, uint indexed taskId, uint newExpiration);
    event TaskPriorityUpdated(address indexed user, uint indexed taskId, Priority newPriority);

    modifier validIndex(uint _index) {
        require(_index < userTasks[msg.sender].length, "Invalid index");
        _;
    }

    function addTask(string memory _description, uint _expiration, Priority _priority) public {
        userTasks[msg.sender].push(Task(_description, false, block.timestamp, _expiration, _priority));
        emit TaskAdded(msg.sender, userTasks[msg.sender].length - 1, _description);
    }

    function completeTask(uint _index) public validIndex(_index) {
        userTasks[msg.sender][_index].completed = true;
        emit TaskCompleted(msg.sender, _index);
    }

    function updateTask(uint _index, string memory _newDescription) public validIndex(_index) {
        userTasks[msg.sender][_index].description = _newDescription;
        emit TaskUpdated(msg.sender, _index, _newDescription);
    }

    function deleteTask(uint _index) public validIndex(_index) {
        Task[] storage tasks = userTasks[msg.sender];
        for (uint i = _index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
        emit TaskDeleted(msg.sender, _index);
    }

    function toggleTask(uint _index) public validIndex(_index) {
        userTasks[msg.sender][_index].completed = !userTasks[msg.sender][_index].completed;
        emit TaskToggled(msg.sender, _index);
    }

    function getTask(uint _index) public view validIndex(_index) returns (
        string memory, bool, uint, uint, Priority
    ) {
        Task memory task = userTasks[msg.sender][_index];
        return (task.description, task.completed, task.timestamp, task.expiration, task.priority);
    }

    function getAllTasks() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    function clearAllTasks() public {
        delete userTasks[msg.sender];
        emit AllTasksCleared(msg.sender);
    }

    function markAllCompleted() public {
        Task[] storage tasks = userTasks[msg.sender];
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = true;
        }
        emit AllTasksMarkedCompleted(msg.sender);
    }

    function markAllPending() public {
        Task[] storage tasks = userTasks[msg.sender];
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = false;
        }
        emit AllTasksMarkedPending(msg.sender);
    }

    function getTasksByStatus(bool _completed) public view returns (Task[] memory) {
        Task[] storage tasks = userTasks[msg.sender];
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed == _completed) count++;
        }

        Task[] memory filtered = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed == _completed) filtered[j++] = tasks[i];
        }
        return filtered;
    }

    function getExpiredTasks() public view returns (Task[] memory) {
        Task[] storage tasks = userTasks[msg.sender];
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].expiration > 0 && block.timestamp > tasks[i].expiration) count++;
        }

        Task[] memory expired = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].expiration > 0 && block.timestamp > tasks[i].expiration) {
                expired[j++] = tasks[i];
            }
        }
        return expired;
    }

    function getTasksByPriority(Priority _priority) public view returns (Task[] memory) {
        Task[] storage tasks = userTasks[msg.sender];
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].priority == _priority) count++;
        }

        Task[] memory priorityTasks = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].priority == _priority) {
                priorityTasks[j++] = tasks[i];
            }
        }
        return priorityTasks;
    }

    function getUpcomingTasks(uint _withinSeconds) public view returns (Task[] memory) {
        Task[] storage tasks = userTasks[msg.sender];
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].expiration > block.timestamp && tasks[i].expiration <= block.timestamp + _withinSeconds) {
                count++;
            }
        }

        Task[] memory upcoming = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].expiration > block.timestamp && tasks[i].expiration <= block.timestamp + _withinSeconds) {
                upcoming[j++] = tasks[i];
            }
        }
        return upcoming;
    }

    function getOverdueIncompleteTasks() public view returns (Task[] memory) {
        Task[] storage tasks = userTasks[msg.sender];
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed && tasks[i].expiration > 0 && block.timestamp > tasks[i].expiration) {
                count++;
            }
        }

        Task[] memory overdue = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed && tasks[i].expiration > 0 && block.timestamp > tasks[i].expiration) {
                overdue[j++] = tasks[i];
            }
        }
        return overdue;
    }

    function updateTaskExpiration(uint _index, uint _newExpiration) public validIndex(_index) {
        userTasks[msg.sender][_index].expiration = _newExpiration;
        emit TaskExpirationUpdated(msg.sender, _index, _newExpiration);
    }

    function updateTaskPriority(uint _index, Priority _newPriority) public validIndex(_index) {
        userTasks[msg.sender][_index].priority = _newPriority;
        emit TaskPriorityUpdated(msg.sender, _index, _newPriority);
    }

    // 🆕 New Function: Provide a task summary
    function getTaskSummary() public view returns (
        uint totalTasks, uint completedTasks, uint pendingTasks, uint expiredTasks, uint overdueTasks
    ) {
        Task[] storage tasks = userTasks[msg.sender];
        totalTasks = tasks.length;

        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed) completedTasks++;
            else pendingTasks++;

            if (tasks[i].expiration > 0 && block.timestamp > tasks[i].expiration) {
                expiredTasks++;
                if (!tasks[i].completed) overdueTasks++;
            }
        }
    }
}
