//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GenericNFT is ERC721, Ownable {

    // Token counter
    uint256 private counter = 0;

    // Owner address
    address private contract_owner;

    // Stores list of Tokens owned by an address
    mapping(address => uint256[]) private ownedTokenList;

    // Token URI 
    mapping(uint256 => string) private tokenURIs;

    // Token MetaData Hash Content
    mapping(uint256 => bytes32) private tokenMetaDataHashContent;

    // Constructor
    constructor() ERC721 ("GenericNFT", "Generic") {
        
        console.log("Deploying GenericNFT Smart Contract");
        contract_owner = msg.sender;
        console.log("Contract Owner is ",contract_owner);
    }

    // Transfer token
    function transferFrom(address _from, address _to, uint256 _tokenId) public override {

        console.log("Transferring Token Id: ", _tokenId);
        console.log("From : ", _from);
        console.log("To: ", _to);
        console.log("Owner of token: ", ownerOf(_tokenId));

        require(_from != address(0), "Token Sender Address must be specified");
        require(_to != address(0), "Token Receiver Address must be specified");
        require(_from != _to, "Sender and Receiver Address can not be same");

        // Check whether this Token actually exists or not
        // The ownerOf function will throw error if the Token does not exists
        address tokenOwner = ownerOf(_tokenId); 
        // Check whether Sender is the Token owner
        require(tokenOwner == _from, "Token does not belong to Sender");

        // First, remove this Token from OwnedTokenList of Sender
        // To do this, let's get the current balance of Sender
        
        // Get current balance of Sender
        uint256 senderCurrentBalance = ERC721.balanceOf(_from);
        console.log("Before Transfer, Sender has : ", senderCurrentBalance);

        // Create an array that will store all Token Ids, except the Token being transferred, belonging to Sender
        uint256[] memory updatedlistoftokens = new uint256[] (senderCurrentBalance);
        
        // Iterate through all the Token Ids belonging to Sender
        uint j=0;
        console.log("Start: Iterating through list of Tokens of Sender");

        for (uint i=0; i < senderCurrentBalance; i++) {
            console.log("Current Index: ", i);
            console.log("Sender Token Id: ", ownedTokenList[_from][i]);
            console.log("Token Id being Transferred: ", _tokenId);
            if (ownedTokenList[_from][i] == _tokenId) {
                console.log("Token Ids have matched, so will skip this Token from being added to new list of Sender");
            }
            else {
                console.log("Token Ids did not match, so, will add to new list of Sender");
                console.log("Value of j is ", j);
                updatedlistoftokens[j] = ownedTokenList[_from][i];
                console.log("Token Id added in new list of Sender is ", updatedlistoftokens[j]);
                j++;
            }
        }

        console.log("End: Iterating through list of Tokens of Sender");
        console.log("Length of new list of Sender: ", updatedlistoftokens.length);


        // Remove all tokens from the old token list of Sender
        console.log("Removing all tokens from original list of Sender");
        for (uint i=0; i < senderCurrentBalance; i++) {
            console.log("Index i: ", i);
            ownedTokenList[_from].pop();
        }

        // Finally, re-populate the list of tokens for Sender
        for (uint i=0; i < updatedlistoftokens.length - 1; i++) {
            console.log("Value of i in re-populate: ", i);
            ownedTokenList[_from].push(updatedlistoftokens[i]);
            console.log("Token Id from new list of Sender: ", updatedlistoftokens[i]);
            console.log("Token Id inside original list of Sender: ", ownedTokenList[_from][i]);
            //emit TokenIdWithIndex(_from, i, ownedTokenList[_from][i]);
        }

        console.log("Length of new Sender Token List: ", ownedTokenList[_from].length);

        // Now, let's add this Token to OwnedTokenList of Receiver
        ownedTokenList[_to].push(_tokenId);
        
        // Get current balance of Receiver
        uint256 receiverCurrentBalance = ERC721.balanceOf(_to);
        console.log("Before Transfer, Receiver has : ", receiverCurrentBalance);
        console.log("Length of new Receiver Token List: ", ownedTokenList[_to].length);        

        // Call Base function to do the token transfer
        super.transferFrom(_from, _to, _tokenId);        
    }

    // Hashed Metadata Content
    function isMetaDataContentAuthentic(uint256 tokenId, string memory metaDataContent) public view returns (bool) {
        
        console.log("verifyMetaDataContent called");
        if (tokenMetaDataHashContent[tokenId] == keccak256(abi.encodePacked(metaDataContent))) {
            return true;
        }
        else {
            return false;
        }
    }

    // Mint a new NickName token
    function mintToken(address receiver, string memory tokenURL, string memory metaDataContent) public onlyOwner returns (uint256) {
        
        console.log("Receiver Address: ", receiver);
        console.log("Token URL: ", tokenURL);

        require(receiver != address(0), "Token Receiver Address must be specified");
        require(receiver == contract_owner, "Only Contract Owner is allowed to mint tokens");
        require(bytes(tokenURL).length > 0, "Token URL must be specified");
        require(bytes(metaDataContent).length > 0, "Token Metadata Content must be specified");

        // Increase the Counter and set it as Token Id        
        counter = counter + 1;
        uint256 tokenId = counter;
        console.log("Newly Minted Token Id: ", tokenId);

        // Set the token URL
        tokenURIs[tokenId] = tokenURL;

        // Hash the MetaData Content and then store it
        bytes32 hashedMetadata = keccak256(abi.encodePacked(metaDataContent));
        tokenMetaDataHashContent[tokenId] = hashedMetadata;
        console.log("Hashed Metadata Content is :", string(abi.encodePacked(hashedMetadata)));

        // Get current balance of token owner
        uint256 currentBalance = ERC721.balanceOf(receiver);
        console.log("Current balance: ", currentBalance);

        // Add the newly minted Token Id into the list of tokens owned by Owner
        console.log("Before -> Number of tokens Receiver has: ", ownedTokenList[receiver].length);
        ownedTokenList[receiver].push(tokenId);
        console.log("After -> Number of tokens Receiver has: ", ownedTokenList[receiver].length);

        // Send an Event with Receiver Address, Token Id and TokenList Index Number
        //emit TokenMint(receiver, tokenId, currentBalance);

        // Call Base method to mint the token
        _mint(receiver, tokenId);
        
        return tokenId;
    }

    // List of Token Ids for a given owner
    function listOfTokens(address owner) public view returns (uint256[] memory) {

        console.log("listOfTokens called with Owner Address: ", owner);
        require(owner != address(0), "Token Owner Address must be specified");

        // Get current balance of Owner
        uint256 currentBalance = ERC721.balanceOf(owner);
        console.log("Number of tokens Owner has: ", currentBalance);
        console.log("Length of OwnedTokenList : ", ownedTokenList[owner].length);

        // Create an array that will store all Token Ids belonging to Owner
        uint256[] memory tokens = new uint256[](currentBalance);
        
        // Iterate through all the Token Ids
        for (uint i=0; i < ownedTokenList[owner].length; i++) {
            console.log("Token List Index: ", i);
            console.log("Owner has token Id: ", ownedTokenList[owner][i]);
            tokens[i] = ownedTokenList[owner][i];
            console.log("Token Id inside Array : ", tokens[i]);
            //emit TokenList(owner, tokens[i]);
        }

        for (uint i=0; i < tokens.length; i++) {
            console.log("Value of i : ", i);
            console.log("With Token Id  : ", tokens[i]);
        }
        //emit TokenList(owner, tokens);

        return tokens;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        
        return tokenURIs[tokenId];
    }
}
