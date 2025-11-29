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

    // Add a new task
    function addTask(string memory _description, uint _deadline, Priority _priority) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _description, false, _deadline, _priority);
        emit TaskCreated(taskCount, _description, false, _deadline, _priority);
    }

    // Toggle task completion
    function toggleCompleted(uint _id) public {
        Task storage task = tasks[_id];
        task.completed = !task.completed;
        emit TaskCompleted(_id, task.completed);
    }

    // ✅ NEW FUNCTION: Return complete task details
    function getTask(uint _id)
        public
        view
        returns (
            uint id,
            string memory description,
            bool completed,
            uint deadline,
            Priority priority
        )
    {
        Task memory t = tasks[_id];
        return (t.id, t.description, t.completed, t.deadline, t.priority);
    }
}
