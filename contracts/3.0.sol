// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    enum Priority { Low, Medium, High }

    struct Task {
        uint id;
        string description;
        bool completed;
        uint deadline;
        Priority priority;
    }

    uint public taskCount = 0;
    mapping(uint => Task) public tasks;

    event TaskCreated(uint id, string description, bool completed, uint deadline, Priority priority);
    event TaskCompleted(uint id, bool completed);
    event TaskDescriptionUpdated(uint id, string newDescription);
    event TaskDeadlineUpdated(uint id, uint newDeadline);
    event TaskDeleted(uint id);

    function addTask(string memory _description, uint _deadline, Priority _priority) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _description, false, _deadline, _priority);
        emit TaskCreated(taskCount, _description, false, _deadline, _priority);
    }

    function toggleCompleted(uint _id) public {
        Task storage task = tasks[_id];
        task.completed = !task.completed;
        emit TaskCompleted(_id, task.completed);
    }

    // Retrieve all task IDs for a specific priority
    function getTasksByPriority(Priority _priority) public view returns (uint[] memory) {
        uint[] memory tempList = new uint[](taskCount);
        uint count = 0;
        for (uint i = 1; i <= taskCount; i++) {
            if (tasks[i].priority == _priority) {
                tempList[count] = i;
                count++;
            }
        }
        uint[] memory priorityTasks = new uint[](count);
        for (uint j = 0; j < count; j++) {
            priorityTasks[j] = tempList[j];
        }
        return priorityTasks;
    }

    // Retrieve all incomplete task IDs
    function getIncompleteTasks() public view returns (uint[] memory) {
        uint[] memory tempList = new uint[](taskCount);
        uint count = 0;
        for (uint i = 1; i <= taskCount; i++) {
            if (!tasks[i].completed) {
                tempList[count] = i;
                count++;
            }
        }
        uint[] memory incompleteTasks = new uint[](count);
        for (uint j = 0; j < count; j++) {
            incompleteTasks[j] = tempList[j];
        }
        return incompleteTasks;
    }

    // Retrieve all overdue task IDs
    function getOverdueTasks() public view returns (uint[] memory) {
        uint[] memory tempList = new uint[](taskCount);
        uint count = 0;
        for (uint i = 1; i <= taskCount; i++) {
            if (!tasks[i].completed && tasks[i].deadline < block.timestamp) {
                tempList[count] = i;
                count++;
            }
        }
        uint[] memory overdueTasks = new uint[](count);
        for (uint j = 0; j < count; j++) {
            overdueTasks[j] = tempList[j];
        }
        return overdueTasks;
    }

    // Retrieve all completed task IDs
    function getCompletedTasks() public view returns (uint[] memory) {
        uint[] memory tempList = new uint[](taskCount);
        uint count = 0;
        for (uint i = 1; i <= taskCount; i++) {
            if (tasks[i].completed) {
                tempList[count] = i;
                count++;
            }
        }
        uint[] memory completedTasks = new uint[](count);
        for (uint j = 0; j < count; j++) {
            completedTasks[j] = tempList[j];
        }
        return completedTasks;
    }

    // Update a task's description
    function updateTaskDescription(uint _id, string memory _newDescription) public {
        require(_id > 0 && _id <= taskCount, "Invalid task ID");
        tasks[_id].description = _newDescription;
        emit TaskDescriptionUpdated(_id, _newDescription);
    }

    // Update a task's deadline
    function updateTaskDeadline(uint _id, uint _newDeadline) public {
        require(_id > 0 && _id <= taskCount, "Invalid task ID");
        tasks[_id].deadline = _newDeadline;
        emit TaskDeadlineUpdated(_id, _newDeadline);
    }

    // NEW FUNCTION: Delete a task
    function deleteTask(uint _id) public {
        require(_id > 0 && _id <= taskCount, "Invalid task ID");
        delete tasks[_id];
        emit TaskDeleted(_id);
    }
}
