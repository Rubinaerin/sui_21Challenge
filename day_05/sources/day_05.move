module challenge::day_05 {
    use std::string::String;
    use std::vector;

    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has copy, drop {
        habits: vector<Habit>,
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty<Habit>(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    
    public fun complete_habit(list: &mut HabitList, index: u64) {
        let list_length = vector::length(&list.habits);

        
        if (index < list_length) {
            
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            habit_ref.completed = true;
        }
        
    }

    
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }
}