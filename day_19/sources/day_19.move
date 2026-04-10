module challenge::day_19 {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use std::vector;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    // --- Entry Fonksiyonlar (Dünden) ---

    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = Farm {
            id: object::new(ctx),
            counters: FarmCounters {
                planted: 0,
                harvested: 0,
                plots: vector::empty<u8>(),
            },
        };
        transfer::share_object(farm);
    }

    
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    
    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        // PlotId 1-20 kontrolü
        assert!(plot_id >= 1 && plot_id <= 20, 0);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), 1);
        
        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, 2);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }
}