import asyncio
from pathlib import Path

from starknet_py.contract import Contract
from starknet_py.hash.casm_class_hash import compute_casm_class_hash
from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.schemas.gateway import CasmClassSchema
from starknet_py.net.signer.stark_curve_signer import KeyPair

testnet = "testnet"
MAX_FEE = 100000000000


async def deploy(contract_name, raw_calldata, net_type):
    try:
        print(contract_name)
        full_node_client = FullNodeClient(node_url="https://starknet-testnet.public.blastapi.io")

        deployer_account = Account(
                client=full_node_client,
                address="0x6626ff612ccde5792f03f60cd56704bc5abf2965feacc387dad0e41566aabb",
                key_pair=KeyPair(private_key=0x13e611b66bb297cb2776de982478a69c672852aa995bf4e5cc0608e14012292,
                                 public_key=0x99771be8e955e84b83f424a3b2ffeb1295ba241a758023b67c88fc44983997),
                chain=StarknetChainId.TESTNET,
        )

        casm_class = Path(f"../../target/dev/lolkek_{contract_name}.compiled_contract_class.json").read_text()
        compiled_contract = Path(f"../../target/dev/lolkek_{contract_name}.contract_class.json").read_text()

        declare_result = await Contract.declare(
                account=deployer_account,
                compiled_contract=compiled_contract,
                compiled_contract_casm=casm_class,
                max_fee=int(1e14),
        )
        declare_transaction = await declare_result.wait_for_acceptance()
        print(f"declare_transaction: {hex(declare_transaction.hash)}")

        deploy_invoke_transaction = await declare_result.deploy(
                constructor_args=raw_calldata, max_fee=int(1e14)
        )
        print(f"deploy_invoke_transaction: {hex(deploy_invoke_transaction.hash)}")
        await deploy_invoke_transaction.wait_for_acceptance()

        address = deploy_invoke_transaction.deployed_contract.address
        print(f"Contract address: {hex(address)}")
        file_path = f"./{contract_name}"
        with open(file_path, 'w') as file:
            file.write(hex(address))
        return int(hex(address), 16)
    except:
        file_path = f"{contract_name}"
        with open(file_path, 'r') as file:
            s = file.read()
            print(s)
            return int(s, 16)


async def main():
    contract_name = "A"
    # 0x166db0a0758b72c6c89bf5ac6942aeaa0ee281eaae34f06bee74ce29ae4cd36
    raw_calldata = []
    net_type = "testnet"
    A = await deploy(contract_name, raw_calldata, net_type)


async def run():
    task = asyncio.create_task(main())
    await task
    ex1 = task.exception()
    if ex1:
        raise ex1


asyncio.run(run())
