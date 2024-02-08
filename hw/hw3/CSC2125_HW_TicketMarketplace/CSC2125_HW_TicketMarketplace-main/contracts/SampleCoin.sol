// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract SampleCoin is ERC20 {
    // your code goes here (you can do it!)
    // reference: https://docs.openzeppelin.com/contracts/5.x/erc20
    // OpenZeppelin docs | ERC20

    constructor() ERC20("SampleCoin", "SPC"){
        // TODO: idk how to do this without hardcoding the amount at the moment...
        _mint(msg.sender, 1e20);
    }
}