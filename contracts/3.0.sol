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
    event TaskPriorityUpdated(uint id, Priority newPriority);
    event AllTasksCleared();

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
        }
    }
}
