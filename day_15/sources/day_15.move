module challenge::day_15 {
    use std::vector;

    
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;

    
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>, // Ekili alanların Id'lerini tutan liste
    }

    
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty<u8>(),
        }
    }

    
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        
        assert!(plot_id >= 1 && plot_id <= 20, EInvalidPlotId);
        
        
        assert!(vector::length(&counters.plots) < 20, EMaxPlotsReached);

        
        assert!(!vector::contains(&counters.plots, &plot_id), EPlotAlreadyPlanted);

        
        vector::push_back(&mut counters.plots, plot_id);
        counters.planted = counters.planted + 1;
    }

    
    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        
        let (found, index) = vector::index_of(&counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        
        vector::remove(&mut counters.plots, index);
        counters.harvested = counters.harvested + 1;
    }
}