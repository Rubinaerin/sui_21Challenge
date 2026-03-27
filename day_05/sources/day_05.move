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

    // GÖREV: Alışkanlığı tamamlandı olarak işaretle
    public fun complete_habit(list: &mut HabitList, index: u64) {
        // Önce listenin uzunluğunu alalım
        let list_length = vector::length(&list.habits);

        // KONTROL AKIŞI (if/else): Gelen index listede var mı?
        if (index < list_length) {
            // Eğer index geçerliyse, o elemana "değiştirilebilir" (&mut) olarak eriş
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            // Durumunu true yap
            habit_ref.completed = true;
        } 
        // Not: else kısmına bir şey yazmasak da olur, geçersiz index gelirse kod bir şey yapmaz.
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }
}