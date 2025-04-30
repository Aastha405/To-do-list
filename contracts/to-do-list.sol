// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    struct Task {
        string description;
        bool completed;
    }

    Task[] public tasks;

    function addTask(string memory _description) public {
        tasks.push(Task(_description, false));
    }

    function completeTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].completed = true;
    }

    function updateTask(uint _index, string memory _newDescription) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].description = _newDescription;
    }

    function getTasksCount() public view returns (uint) {
        return tasks.length;
    }

    function deleteTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");
        for (uint i = _index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
    }

    function getTask(uint _index) public view returns (string memory description, bool completed) {
        require(_index < tasks.length, "Invalid task index");
        Task storage task = tasks[_index];
        return (task.description, task.completed);
    }

    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }

    function toggleCompleteTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].completed = !tasks[_index].completed;
    }

    function clearCompletedTasks() public {
        uint i = 0;
        while (i < tasks.length) {
            if (tasks[i].completed) {
                deleteTask(i);
            } else {
                i++;
            }
        }
    }

    function getPendingTasksCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed) {
                count++;
            }
        }
        return count;
    }

    function getCompletedTasksCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed) {
                count++;
            }
        }
        return count;
    }

    function getTaskDescriptionByIndex(uint _index) public view returns (string memory) {
        require(_index < tasks.length, "Invalid task index");
        return tasks[_index].description;
    }

    function markAllTasksCompleted() public {
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = true;
        }
    }

    // ✅ New Function 1: Search task by description
    function searchTaskByDescription(string memory _description) public view returns (uint) {
        for (uint i = 0; i < tasks.length; i++) {
            if (keccak256(bytes(tasks[i].description)) == keccak256(bytes(_description))) {
                return i;
            }
        }
        revert("Task not found");
    }

    // ✅ New Function 2: Get all pending tasks
    function getAllPendingTasks() public view returns (Task[] memory) {
        uint count = getPendingTasksCount();
        Task[] memory pendingTasks = new Task[](count);
        uint j = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed) {
                pendingTasks[j] = tasks[i];
                j++;
            }
        }
        return pendingTasks;
    }
}
