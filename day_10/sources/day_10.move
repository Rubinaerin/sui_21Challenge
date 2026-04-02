module challenge::day_10 {
    use std::string::String;

    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

   
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    
    public fun complete_task(task: &mut Task) {
       
        change_status(task, TaskStatus::Completed);
    }

    
    fun change_status(task: &mut Task, new_status: TaskStatus) {
        task.status = new_status;
    }

    
    public fun is_open(task: &Task): bool {
        match (task.status) {
            TaskStatus::Open => true,
            TaskStatus::Completed => false,
        }
    }
}