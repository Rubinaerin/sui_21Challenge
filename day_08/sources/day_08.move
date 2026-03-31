module challenge::day_08 {
    use std::string::String;

    
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        done: bool,
    }

 
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            done: false, 
        }
    }
}