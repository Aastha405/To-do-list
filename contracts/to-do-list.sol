// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    struct Task {
        string description;
        bool completed;
        uint timestamp;
    }

    Task[] public tasks;

    event TaskAdded(uint indexed taskId, string description);
    event TaskCompleted(uint indexed taskId);
    event TaskUpdated(uint indexed taskId, string newDescription);
    event TaskDeleted(uint indexed taskId);
    event TaskToggled(uint indexed taskId);
    event AllTasksCleared();
    event AllTasksMarkedCompleted();
    event AllTasksMarkedPending();

    function addTask(string memory _description) public {
        tasks.push(Task(_description, false, block.timestamp));
        emit TaskAdded(tasks.length - 1, _description);
    }

    function completeTask(uint _index) public {
        require(_index < tasks.length, "Invalid index");
        tasks[_index].completed = true;
        emit TaskCompleted(_index);
    }

    function updateTask(uint _index, string memory _newDescription) public {
        require(_index < tasks.length, "Invalid index");
        tasks[_index].description = _newDescription;
        emit TaskUpdated(_index, _newDescription);
    }

    function deleteTask(uint _index) public {
        require(_index < tasks.length, "Invalid index");
        for (uint i = _index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
        emit TaskDeleted(_index);
    }

    function toggleTask(uint _index) public {
        require(_index < tasks.length, "Invalid index");
        tasks[_index].completed = !tasks[_index].completed;
        emit TaskToggled(_index);
    }

    function getTask(uint _index) public view returns (string memory, bool, uint) {
        require(_index < tasks.length, "Invalid index");
        Task memory task = tasks[_index];
        return (task.description, task.completed, task.timestamp);
    }

    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }

    function clearAllTasks() public {
        delete tasks;
        emit AllTasksCleared();
    }

    function getCompletedTasksCount() public view returns (uint count) {
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed) count++;
        }
    }

    function getPendingTasksCount() public view returns (uint count) {
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed) count++;
        }
    }

    function markAllCompleted() public {
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = true;
        }
        emit AllTasksMarkedCompleted();
    }

    function markAllPending() public {
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = false;
        }
        emit AllTasksMarkedPending();
    }

    function getTasksByStatus(bool _completed) public view returns (Task[] memory) {
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed == _completed) {
                count++;
            }
        }

        Task[] memory filtered = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed == _completed) {
                filtered[j++] = tasks[i];
            }
        }
        return filtered;
    }

    function getLatestTask() public view returns (string memory, bool, uint) {
        require(tasks.length > 0, "No tasks found");
        Task memory task = tasks[tasks.length - 1];
        return (task.description, task.completed, task.timestamp);
    }

    function getTaskCount() public view returns (uint) {
        return tasks.length;
    }

    function isTaskExists(uint _index) public view returns (bool) {
        return _index < tasks.length;
    }
}
