import { Signer } from "ethers";
import { ethers, network } from "hardhat";

const provider = new ethers.providers.JsonRpcProvider("https://polygon-mumbai.g.alchemy.com/v2/LfxdafGJ-rrWuw-kIAUG6q1REo-3Mn--")



// const DAI_USD = '0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D'
const USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7"
const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F"
const DAITokenHolder = "0x75d46b9f6a8ff92da784be6a763050f848551483";
const USDTTokenHolder = "0xffeac40c46db67aad2f02a5fe0ae283c1cb257dd";
const exchange = "0xc6f0303df68cdab5fa5338a9706f51225fd728dd"
async function main() {
  // deploying the whole contract
  const tokenPrice = await ethers.getContractFactory("Swapper");
  const feedPrice = await tokenPrice.deploy();
  await feedPrice.deployed();
  // getting the chainlink feed price
  // await feedPrice.getLatestPrice()
  console.log(await feedPrice.getLatestPrice());
 

  // deploying the dai token contract
  const DaiToken = await ethers.getContractAt("IERC20", DAI);

  const USDToken = await ethers.getContractAt("IERC20", USDT);

  console.log("DAI balance before:", await DaiToken.balanceOf(feedPrice.address))
  console.log("usdt balance before:", await USDToken.balanceOf(feedPrice.address))

  // setting dai token holder's balance so he can send tokens to my contract 

  await network.provider.send("hardhat_setBalance", [
    DAITokenHolder,
    "0x16345785D8A0000",
  ]);

//    //impersonating a DAI account in order to get the account to be a liquidity pool for the contract
// // @ts-ignore
//   await hre.network.provider.request({
//     method: "hardhat_impersonateAccount",
//     params: [DAITokenHolder], // address to impersonate
//   });
//   const signer1: Signer = await ethers.getSigner(DAITokenHolder);
//   await DaiToken
//     .connect(signer1)
//     .transfer(
//       feedPrice.address,
//       "1820342231150"
//   );
//   console.log("DAI balance:", await DaiToken.balanceOf(feedPrice.address))
//     //impersonating a USDT account in order to get the account to be a liquidity pool for the contract
// // @ts-ignore
//   await hre.network.provider.request({
//     method: "hardhat_impersonateAccount",
//     params: [USDTTokenHolder], // address to impersonate
//   });
//   const signer2: Signer = await ethers.getSigner(USDTTokenHolder);
//   await USDToken
//     .connect(signer2)
//     .transfer(
//       feedPrice.address,
//       "14200"
//   );
//   console.log("usdt balance:", await USDToken.balanceOf(feedPrice.address))
//   console.log("Greeter deployed to:", feedPrice.address);

//     //swapping from DAI to USDT
//   console.log('person about to be impersonated')
//   // @ts-ignore
//   await hre.network.provider.request({
//     method: "hardhat_impersonateAccount",
//     params: [exchange], // address to impersonate
//   });
//   const signer3: Signer = await ethers.getSigner(exchange)
//   await USDToken.connect(signer3).approve(feedPrice.address,
//     "100000000")
//   console.log('person about to swap')
//   await feedPrice.connect(signer3).checkTokens(USDT, DAI, 2)
//   console.log("DAI balance after swap:", await DaiToken.balanceOf(feedPrice.address))
//   console.log("usdt balance after swap:", await USDToken.balanceOf(feedPrice.address))

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});