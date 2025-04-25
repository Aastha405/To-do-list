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
}
