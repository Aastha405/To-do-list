// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {
    struct Task {
        string description;
        bool completed;
    }

    Task[] public tasks;

    // Function to add a new task
    function addTask(string memory _description) public {
        tasks.push(Task(_description, false));
    }

    // Function to mark a task as completed
    function completeTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].completed = true;
    }

    // Function to update the description of a task
    function updateTask(uint _index, string memory _newDescription) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].description = _newDescription;
    }

    // Helper function to get total number of tasks
    function getTasksCount() public view returns (uint) {
        return tasks.length;
    }

    // Function to delete a task by index
    function deleteTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");

        for (uint i = _index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
    }

    // Function to get task details by index
    function getTask(uint _index) public view returns (string memory description, bool completed) {
        require(_index < tasks.length, "Invalid task index");
        Task storage task = tasks[_index];
        return (task.description, task.completed);
    }

    // Function to get all tasks
    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }

    // Function to toggle the completion status of a task
    function toggleCompleteTask(uint _index) public {
        require(_index < tasks.length, "Invalid task index");
        tasks[_index].completed = !tasks[_index].completed;
    }

    // Function to clear all completed tasks
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

    // Function to get the count of pending tasks (not completed)
    function getPendingTasksCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (!tasks[i].completed) {
                count++;
            }
        }
        return count;
    }

    // Function to get the count of completed tasks
    function getCompletedTasksCount() public view returns (uint) {
        uint count = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].completed) {
                count++;
            }
        }
        return count;
    }

    // Function to get the description of a task by index
    function getTaskDescriptionByIndex(uint _index) public view returns (string memory) {
        require(_index < tasks.length, "Invalid task index");
        return tasks[_index].description;
    }

    // Function to mark all tasks as completed
    function markAllTasksCompleted() public {
        for (uint i = 0; i < tasks.length; i++) {
            tasks[i].completed = true;
        }
    }
}
