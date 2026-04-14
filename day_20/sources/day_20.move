module challenge::day_20 {
    use sui::event; // GÖREV: Event modülünü içe aktar
    use std::vector;

    // --- Veri Yapıları ---

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    // GÖREV: PlantEvent struct'ını tanımla
    // Event'lerin 'key' yeteneği olmasına gerek yoktur, 'copy' ve 'drop' yeterlidir.
    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

    // --- Fonksiyonlar ---

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

    // İş mantığı fonksiyonu (İçeride kullanılan)
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id >= 1 && plot_id <= 20, 0);
        assert!(vector::length(&farm.counters.plots) < 20, 3);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), 1);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    // Sorgu fonksiyonu
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    // GÖREV: Ekme işleminden sonra event yayınlayan entry fonksiyonu
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        // 1. Ekme işlemini yap
        plant_on_farm(farm, plot_id);

        // 2. Toplam sayıyı al
        let planted_count = total_planted(farm);

        // 3. Event'i yayınla (Emit)
        event::emit(PlantEvent { 
            planted_after: planted_count 
        });
    }

    // Hasat fonksiyonu (Dünden devam)
    public entry fun harvest_from_farm_entry(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, 2);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }
}