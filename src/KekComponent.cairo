#[starknet::interface]
trait IKekComponent<TContractState> {
    fn kek_get_val(self: @TContractState) -> u256;
    fn kek_increase_other_call(ref self: TContractState);
}


#[starknet::component]
mod kek_component {
    use lolkek::LolComponent::lol_component::InternalLol;
    use lolkek::LolComponent::lol_component;
    use lol_component::{LolComponentImpl, InternalLolComponentImpl};

    #[storage]
    struct Storage {
        val_kek: u256,
    }

    #[embeddable_as(Kek)]
    impl KekComponentImpl<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        +lol_component::HasComponent<TContractState>
    > of super::IKekComponent<ComponentState<TContractState>> {
        fn kek_get_val(self: @ComponentState<TContractState>) -> u256 {
            self.val_kek.read()
        }
        fn kek_increase_other_call(ref self: ComponentState<TContractState>) {
            self.increase_other();
        }
    }

    #[generate_trait]
    impl InternalKekComponentImpl<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        +lol_component::HasComponent<TContractState>
    > of InternalKek<TContractState> {
        fn increase(ref self: ComponentState<TContractState>) {
            self.val_kek.write(self.val_kek.read() + 1);
        }
        fn increase_other(ref self: ComponentState<TContractState>) {
            let mut lol = self.get_lol_mut();
            lol.increase();
        }
    }

    #[generate_trait]
    impl ExternalComponentCalls<
        TContractState,
        +HasComponent<TContractState>,
        +lol_component::HasComponent<TContractState>,
        +Drop<TContractState>
    > of ILolComponentTrait<TContractState> {
        fn get_lol(
            self: @ComponentState<TContractState>
        ) -> @lol_component::ComponentState<TContractState> {
            let contract = self.get_contract();
            lol_component::HasComponent::<TContractState>::get_component(contract)
        }

        fn get_lol_mut(
            ref self: ComponentState<TContractState>
        ) -> lol_component::ComponentState<TContractState> {
            let mut contract = self.get_contract_mut();
            lol_component::HasComponent::<TContractState>::get_component_mut(ref contract)
        }
    }
}
