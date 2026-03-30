module challenge::day_07 {
    use std::string::{Self, String};
    use std::vector;

    
    #[test_only]
    use std::unit_test::assert_eq;

    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has copy, drop {
        habits: vector<Habit>,
    }

    

    public fun empty_list(): HabitList {
        HabitList { habits: vector::empty<Habit>() }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let list_length = vector::length(&list.habits);
        if (index < list_length) {
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            habit_ref.completed = true;
        };
    }

    public fun make_habit(name_bytes: vector<u8>): Habit {
        Habit {
            name: string::utf8(name_bytes),
            completed: false,
        }
    }

    

    
    #[test]
    fun test_add_habit() {
        let mut list = empty_list();
        let habit = make_habit(b"Su Ic");
        
        add_habit(&mut list, habit);
        
        
        assert_eq!(vector::length(&list.habits), 1);
    }

    
    #[test]
    fun test_complete_habit() {
        let mut list = empty_list();
        add_habit(&mut list, make_habit(b"Kod Yaz"));
        
        
        complete_habit(&mut list, 0);
        
        let habit_ref = vector::borrow(&list.habits, 0);
        
        assert!(habit_ref.completed == true, 0);
    }
}