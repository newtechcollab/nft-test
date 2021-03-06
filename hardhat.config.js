require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
   const accounts = await hre.ethers.getSigners();

   for (const account of accounts) {
     console.log(account.address);
   }
 });
const { API_URL, PRIVATE_KEY, PUBLIC_KEY } = process.env;
module.exports = {
   solidity: "0.8.1",
   defaultNetwork: "hardhat",
   networks: {
      hardhat: {},
      goerli: {
         url: API_URL,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
}