module challenge::day_06 {
    use std::string::{Self, String}; 
    use std::vector;

    public struct Habit has copy, drop {
        name: String, 
        completed: bool,
    }

    public struct HabitList has copy, drop {
        habits: vector<Habit>,
    }

    
    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name_string = string::utf8(name_bytes); 
        Habit {
            name: name_string,
            completed: false,
        }
    }

    
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    
    public fun empty_list(): HabitList {
        HabitList { habits: vector::empty<Habit>() }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }
}