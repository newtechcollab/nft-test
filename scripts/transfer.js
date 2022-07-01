require("dotenv").config()
const API_URL = process.env.API_URL
const PUBLIC_KEY = process.env.PUBLIC_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const HARDHAT_PUBLIC_KEY = process.env.HARDHAT_PUBLIC_KEY

async function main() {

    const nftcontractAddress = "0x998abeb3E57409262aE5b751f60747921B33613E";
    const nftcontract = await ethers.getContractAt("GenericNFT", nftcontractAddress);

    console.log('Contract address is: ', nftcontract.address);

    // Transfer NFT
   const txnReceipt = await nftcontract.transferFrom(HARDHAT_PUBLIC_KEY, "0xE646Fe767ffa3f323FF299B82334626a4AC1DF55", 2); 
   await txnReceipt.wait();

   console.log("Output of Transfer is ", txnReceipt);
}

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    }) 