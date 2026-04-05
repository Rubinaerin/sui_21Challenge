module challenge::day_13 {
    use std::string::String;
    use std::vector;
    use std::option::{Self, Option};

    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has copy, drop, store {
        owner: address,
        tasks: vector<Task>,
    }

    
    public fun total_reward(board: &TaskBoard): u64 {
        let mut total = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    
    public fun completed_count(board: &TaskBoard): u64 {
        let mut count = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            
            match (task.status) {
                TaskStatus::Completed => { count = count + 1; },
                TaskStatus::Open => { /* Bir şey yapma */ },
            };
            i = i + 1;
        };
        count
    }

    
    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty<Task>() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }
}