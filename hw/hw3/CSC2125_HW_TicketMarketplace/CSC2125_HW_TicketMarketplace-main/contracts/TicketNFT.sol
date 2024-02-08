// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ITicketNFT} from "./interfaces/ITicketNFT.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract TicketNFT is ERC1155, ITicketNFT {
    // your code goes here (you can do it!)
    // Reference: https://docs.openzeppelin.com/contracts/5.x/erc1155
    // OpenZeppelin docs | ERC1155

    address private _owner;

    constructor(address marketplaceOwner) ERC1155("https://api.ticketnft.com/ticket/{id}.json") {
        // console.log("TicketNFT deployed with marketplaceOwner: %s", marketplaceOwner);
        _owner = marketplaceOwner;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function mintFromMarketPlace(address to, uint256 nftId) external override {
        // _mint(to: address, id: uint256, amount: uint256, data: bytes)
        // Passing an empty string as according to "https://piazza.com/class/lqobnxugstjce/post/19"
        // Also according to ERC1155: https://docs.openzeppelin.com/contracts/5.x/erc1155#_mint 
        _mint(to, nftId, 1, "");
    }
}