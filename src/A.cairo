#[starknet::interface]
trait IA<TContractState> {
    fn kek_get_val(self: @TContractState) -> u256;
    fn kek_increase_other_call(ref self: TContractState);
    fn lol_get_val(self: @TContractState) -> u256;
    fn lol_increase_other_call(ref self: TContractState);
}


#[starknet::contract]
mod A {
    use lolkek::LolComponent::lol_component;
    use lolkek::KekComponent::kek_component;

    component!(path: lol_component, storage: lol_s, event: lol_e);
    component!(path: kek_component, storage: kek_s, event: kek_e);

    #[abi(embed_v0)]
    impl LolImpl = lol_component::Lol<ContractState>;
    impl LolInternalImpl = lol_component::InternalLolComponentImpl<ContractState>;

    #[abi(embed_v0)]
    impl KekImpl = kek_component::Kek<ContractState>;
    impl KekInternalImpl = kek_component::InternalKekComponentImpl<ContractState>;


    #[storage]
    struct Storage {
        #[substorage(v0)]
        lol_s: lol_component::Storage,
        #[substorage(v0)]
        kek_s: kek_component::Storage,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        lol_e: lol_component::Event,
        kek_e: kek_component::Event,
    }
}
