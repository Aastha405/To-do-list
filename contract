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

    // Helper function to get total number of tasks
    function getTasksCount() public view returns (uint) {
        return tasks.length;
    }
}
