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
        // Intentionally left empty
        // console.log("TicketNFT deployed with marketplaceOwner: %s", marketplaceOwner);
        _owner = marketplaceOwner;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function mintFromMarketPlace(address to, uint256 nftId) external override {
        // Intentionally left empty
    }
}