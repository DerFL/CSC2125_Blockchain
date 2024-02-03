// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ITicketNFT} from "./interfaces/ITicketNFT.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TicketNFT} from "./TicketNFT.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol"; 
import {ITicketMarketplace} from "./interfaces/ITicketMarketplace.sol";
import "hardhat/console.sol";

contract TicketMarketplace is ITicketMarketplace {
    // your code goes here (you can do it!)
    
    address public erc20Address;
    address private _owner;
    TicketNFT public ticketNFT;
    uint128 public eventId;
    
    constructor(address _erc20Address) {
        erc20Address = _erc20Address;
        _owner = msg.sender;
        ticketNFT = new TicketNFT(address(this));
        eventId = 0;
    }

    function nftContract() public view returns (address) {
        return address(ticketNFT);
    }

    function ERC20Address() public view returns (address) {
        return erc20Address;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function currentEventId() public view returns (uint128) {
        return eventId;
    }

    function createEvent(uint128 maxTickets, uint256 pricePerTicket, uint256 pricePerTicketERC20) external override {
        // placeholder
    }

    function setMaxTicketsForEvent(uint128 eventId, uint128 newMaxTickets) external override {
        // placeholder
    }

    function setPriceForTicketETH(uint128 eventId, uint256 price) external override {
        // placeholder
    }

    function setPriceForTicketERC20(uint128 eventId, uint256 price) external override {
        // placeholder
    }

    function buyTickets(uint128 eventId, uint128 ticketCount) payable external override {
        // placeholder
    }

    function buyTicketsERC20(uint128 eventId, uint128 ticketCount) external override {
        // placeholder
    }

    function setERC20Address(address newERC20Address) external override {
        // placeholder
    }
}