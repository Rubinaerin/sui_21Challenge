module challenge::day_21 {
    use sui::event;
    use std::vector;

    // --- Hata Kodları (Sabitler) ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;

    // --- Yapılar ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

    // --- Fonksiyonlar ---
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = Farm {
            id: object::new(ctx),
            counters: FarmCounters { planted: 0, harvested: 0, plots: vector::empty<u8>() },
        };
        transfer::share_object(farm);
    }

    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id >= 1 && plot_id <= 20, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < 20, EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        plant_on_farm(farm, plot_id);
        event::emit(PlantEvent { planted_after: farm.counters.planted });
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }

    // --- TESTLER ---
    #[test_only] use sui::test_scenario;

    #[test]
    fun test_create_farm() {
        let owner = @0xACE;
        let mut scenario = test_scenario::begin(owner);
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, owner);
        let farm = test_scenario::take_shared<Farm>(&scenario);
        assert!(farm.counters.planted == 0, 0);
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_planting_increases_counter() {
        let owner = @0xACE;
        let mut scenario = test_scenario::begin(owner);
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, owner);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        assert!(farm.counters.planted == 1, 0);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let owner = @0xACE;
        let mut scenario = test_scenario::begin(owner);
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, owner);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        harvest_from_farm_entry(&mut farm, 1);
        assert!(farm.counters.planted == 1 && farm.counters.harvested == 1, 0);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_multiple_operations() {
        let owner = @0xACE;
        let mut scenario = test_scenario::begin(owner);
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, owner);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 3);
        plant_on_farm_entry(&mut farm, 5);
        plant_on_farm_entry(&mut farm, 18);
        harvest_from_farm_entry(&mut farm, 5);
        
        assert!(farm.counters.planted == 3 && farm.counters.harvested == 1, 0);
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EInvalidPlotId)]
    fun test_invalid_plot_id_low() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 0); // Hata vermeli
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EPlotAlreadyPlanted)]
    fun test_duplicate_plot() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        plant_on_farm_entry(&mut farm, 1); // Hata vermeli
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EMaxPlotsReached)]
    fun test_plot_limit() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        let mut i = 1;
        while (i <= 20) { plant_on_farm_entry(&mut farm, i); i = i + 1; };
        plant_on_farm_entry(&mut farm, 21); // Limit aşımı (ya ID hatası ya limit hatası)
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EPlotNotPlanted)]
    fun test_harvest_nonexistent_plot() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        harvest_from_farm_entry(&mut farm, 10); // Olmayan plot
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }
}