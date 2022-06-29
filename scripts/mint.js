require("dotenv").config()

const API_URL = process.env.API_URL
const PUBLIC_KEY = process.env.PUBLIC_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const HARDHAT_PUBLIC_KEY = process.env.HARDHAT_PUBLIC_KEY


async function main() {

    const nftcontractAddress = "0x854655230D0eFeAdEb027F48C1bADf14f48e7EEb";
    const nftcontract = await ethers.getContractAt("GenericNFT", nftcontractAddress);
  
    console.log('Contract address is: ', nftcontract.address);
    //console.log('Contract ABI is: ', JSON.stringify(nftcontract.interface));

    let data = "{\"description\":\"HashiMukh\",\"image\":\"ipfs://Qmc8wct6Gi58NzvymufaujRKyToiWmmyWABtYQMaruAhg2\",\"name\":\"Smiley\"}";
    // Send Transaction to mint the NFT
   const txnReceipt = await nftcontract.mintToken(PUBLIC_KEY, "QmUDzZxanc2sAbfLWixW5yrV63nStkiatKVufYHazW6Wj8", data); 
   await txnReceipt.wait();
   
   console.log("Output is ", txnReceipt);
}

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    });
