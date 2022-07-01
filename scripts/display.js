require("dotenv").config()
const API_URL = process.env.API_URL
const PUBLIC_KEY = process.env.PUBLIC_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const HARDHAT_PUBLIC_KEY = process.env.HARDHAT_PUBLIC_KEY

async function main() {

    const nftcontractAddress = "0x29ab16f752cf2c79E2d48a49C546635bf3Ec8D72";
    const nftcontract = await ethers.getContractAt("GenericNFT", nftcontractAddress);
  
    console.log('Contract address is: ', nftcontract.address);
    //console.log('Contract ABI is: ', JSON.stringify(nftcontract.interface));

    // Display Balance of Token Owner
    const tokenBalance = await nftcontract.balanceOf(PUBLIC_KEY); 
    console.log("Owner Token Balance " + tokenBalance);

    // Display List of Tokens of Owner
    const listOfTokens = await nftcontract.listOfTokens(PUBLIC_KEY); 
    console.log("Owner Token Ids ",await listOfTokens);
    

    // Display Owner of Token
    const ownerOfToken = await nftcontract.ownerOf(1); 
    console.log("Owner of Token 1 is " + ownerOfToken);

    // Display Token URI
    var tokenURI = await nftcontract.tokenURI(1);
    console.log("Token URI is ", tokenURI);

    // Hashed Metadata Content
    let data = "{\"description\":\"HashiMukh\",\"image\":\"ipfs://Qmc8wct6Gi58NzvymufaujRKyToiWmmyWABtYQMaruAhg2\",\"name\":\"Smiley\"}";
    var hash = await nftcontract.isMetaDataContentAuthentic(1, data);
    console.log("Token hashed Metadata is ", hash);
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })