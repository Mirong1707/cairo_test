use serde::Serde;
use starknet::ContractAddress;
use starknet::contract_address_to_felt252;
use array::ArrayTrait;
use debug::PrintTrait;


#[cfg(test)]
mod tests {
    use core::traits::Into;
    use core::array::ArrayTrait;
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use core::result::ResultTrait;
    use snforge_std::declare;
    use starknet::ContractAddress;
    use snforge_std::ContractClassTrait;
    use starknet::info::get_block_number;
    use debug::PrintTrait;
    use starknet::get_caller_address;
    use snforge_std::start_prank;
    use snforge_std::start_warp;
    use snforge_std::stop_warp;
    use snforge_std::stop_prank;
    use core::dict::{Felt252Dict, Felt252DictTrait, SquashedFelt252Dict};
    use lolkek::utils::erc20::IERC20Dispatcher;
    use lolkek::utils::erc20::IERC20DispatcherTrait;
    use lolkek::A::A;
    use lolkek::A::IADispatcher;
    use lolkek::A::IADispatcherTrait;
    use lolkek::LolComponent::ILolComponentDispatcher;
    use lolkek::LolComponent::ILolComponentDispatcherTrait;
    use lolkek::KekComponent::IKekComponentDispatcher;
    use lolkek::KekComponent::IKekComponentDispatcherTrait;

    fn print_u(res: u256) {
        let a: felt252 = res.try_into().unwrap();
        let mut output: Array<felt252> = ArrayTrait::new();
        output.append(a);
        debug::print(output);
    }

    fn get_funds(reciever: ContractAddress, amount: u256) {
        let caller_who_have_funds: ContractAddress =
            0x00121108c052bbd5b273223043ad58a7e51c55ef454f3e02b0a0b4c559a925d4
            .try_into()
            .unwrap();
        let ETH_address: ContractAddress =
            0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7
            .try_into()
            .unwrap();
        let ETH = IERC20Dispatcher { contract_address: ETH_address };
        start_prank(ETH.contract_address, caller_who_have_funds);
        ETH.transfer(reciever, amount);
        stop_prank(ETH.contract_address);
    }

    fn get_balance(address: ContractAddress) -> u256 {
        let ETH_address: ContractAddress =
            0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7
            .try_into()
            .unwrap();
        let ETH = IERC20Dispatcher { contract_address: ETH_address };
        ETH.balanceOf(address)
    }

    #[test]
    // #[ignore]
    //#[available_gas(10000000000)]
    #[fork("latest")]
    fn test_01() {
        let amount = 1000000000000000000;
        assert(1 == 1, 'LOL');

        let ETH_address: ContractAddress =
            0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7
            .try_into()
            .unwrap();
        let ETH = IERC20Dispatcher { contract_address: ETH_address };
        

        let cls = declare('A');
        let mut constructor: Array::<felt252> = ArrayTrait::new();
        let a_contract_address = cls.deploy(@constructor).unwrap();
        

        get_funds(a_contract_address, amount);

        let a_contract = IADispatcher { contract_address: a_contract_address };
        
        a_contract.kek_increase_other_call();
        a_contract.lol_increase_other_call();
        a_contract.lol_increase_other_call();

        print_u(a_contract.lol_get_val());
        print_u(a_contract.kek_get_val());



        assert(a_contract.lol_get_val() == 1, 'failed_test_01_lol');
        assert(a_contract.kek_get_val() == 2, 'failed_test_01_kek');
    }
}
