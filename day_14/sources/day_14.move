module challenge::day_14 {
    use std::string::{Self, String};
    use std::vector;

    #[test_only]
    use std::unit_test::assert_eq;

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
        TaskBoard { owner, tasks: vector::empty<Task>() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
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
                TaskStatus::Open => {},
            };
            i = i + 1;
        };
        count
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    

    
    #[test]
    fun test_board_and_add() {
        let owner = @0xACE;
        let mut board = new_board(owner);
        add_task(&mut board, new_task(string::utf8(b"Gorev 1"), 100));
        
        assert_eq!(vector::length(&board.tasks), 1);
        assert_eq!(board.owner, owner);
    }

    
    #[test]
    fun test_complete_and_count() {
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Gorev 1"), 100));
        
        let task_ref = vector::borrow_mut(&mut board.tasks, 0);
        complete_task(task_ref);
        
        assert_eq!(completed_count(&board), 1);
    }

    
    #[test]
    fun test_total_reward_calculation() {
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Gorev 1"), 100));
        add_task(&mut board, new_task(string::utf8(b"Gorev 2"), 250));
        
        assert_eq!(total_reward(&board), 350);
    }
}