module challenge::day_04 {
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

    
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }
}