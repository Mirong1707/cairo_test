#[starknet::interface]
trait ILolComponent<TContractState> {
    fn lol_get_val(self: @TContractState) -> u256;
    fn lol_increase_other_call(ref self: TContractState);
}


#[starknet::component]
mod lol_component {
    use lolkek::KekComponent::kek_component;
    use kek_component::{KekComponentImpl, InternalKekComponentImpl};

    #[storage]
    struct Storage {
        val_lol: u256,
    }

    #[embeddable_as(Lol)]
    impl LolComponentImpl<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        +kek_component::HasComponent<TContractState>
    > of super::ILolComponent<ComponentState<TContractState>> {
        fn lol_get_val(self: @ComponentState<TContractState>) -> u256 {
            self.val_lol.read()
        }
        fn lol_increase_other_call(ref self: ComponentState<TContractState>) {
            self.increase_other();
        }
    }

    #[generate_trait]
    impl InternalLolComponentImpl<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        +kek_component::HasComponent<TContractState>
    > of InternalLol<TContractState> {
        fn increase(ref self: ComponentState<TContractState>) {
            self.val_lol.write(self.val_lol.read() + 1);
        }
        fn increase_other(ref self: ComponentState<TContractState>) {
            let mut kek = self.get_kek_mut();
            kek.increase();
        }
    }

    #[generate_trait]
    impl ExternalComponentCalls<
        TContractState,
        +HasComponent<TContractState>,
        +kek_component::HasComponent<TContractState>,
        +Drop<TContractState>
    > of ExternalComponentTrait<TContractState> {
        fn get_kek(
            self: @ComponentState<TContractState>
        ) -> @kek_component::ComponentState<TContractState> {
            let contract = self.get_contract();
            kek_component::HasComponent::<TContractState>::get_component(contract)
        }

        fn get_kek_mut(
            ref self: ComponentState<TContractState>
        ) -> kek_component::ComponentState<TContractState> {
            let mut contract = self.get_contract_mut();
            kek_component::HasComponent::<TContractState>::get_component_mut(ref contract)
        }
    }
}
