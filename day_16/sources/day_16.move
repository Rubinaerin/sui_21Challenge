module challenge::day_16 {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::vector;

    
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;

    
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    
    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    

    public fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx), // Nesneye benzersiz bir kimlik atar
            counters: FarmCounters {
                planted: 0,
                harvested: 0,
                plots: vector::empty<u8>(),
            },
        }
    }

    
    public fun plant(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id >= 1 && plot_id <= 20, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < 20, EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public fun harvest(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }
}