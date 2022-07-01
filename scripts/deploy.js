async function main() {

    const [owner] = await ethers.getSigners();
    const GenericNFT = await ethers.getContractFactory("GenericNFT")

    // Start deployment, returning a promise that resolves to a contract object
    const myNFT = await GenericNFT.deploy()
    await myNFT.deployed()
    console.log("Contract deployed to address:", myNFT.address)
  }

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    }) 