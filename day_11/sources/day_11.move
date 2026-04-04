module challenge::day_11 {
    use std::string::String;
    use std::vector;

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

   
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty<Task>(),
        }
    }

    
    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }
}