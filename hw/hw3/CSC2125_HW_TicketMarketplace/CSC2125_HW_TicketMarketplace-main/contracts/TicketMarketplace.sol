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
    
    struct Event {
        uint128 nextTicketToSell;
        uint128 maxTickets;
        uint256 pricePerTicket;
        uint256 pricePerTicketERC20;
    }
    
    mapping (uint128 => Event) public events;

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
        // Authorization check
        if (msg.sender != _owner) 
            revert("Unauthorized access");

        // Create a new event
        events[eventId] = Event(0, maxTickets, pricePerTicket, pricePerTicketERC20);
        eventId += 1;

        emit EventCreated(eventId - 1, maxTickets, pricePerTicket, pricePerTicketERC20);
    }
    
    function setMaxTicketsForEvent(uint128 eventId, uint128 newMaxTickets) external override {
        // Authorization check
        if (msg.sender != _owner) 
            revert("Unauthorized access");
        
        // Check validity of the new maxTickets
        if (events[eventId].maxTickets > newMaxTickets)
            revert("The new number of max tickets is too small!");

        // Update the maxTickets for the event
        events[eventId].maxTickets = newMaxTickets;
        emit MaxTicketsUpdate(eventId, newMaxTickets);
    }

    function setPriceForTicketETH(uint128 eventId, uint256 price) external override {
        // Authorization check
        if (msg.sender != _owner) 
            revert("Unauthorized access");

        // Update the price for the ticket in ETH
        events[eventId].pricePerTicket = price;
        emit PriceUpdate(eventId, price, "ETH");
    }

    function setPriceForTicketERC20(uint128 eventId, uint256 price) external override {
        // Authorization check
        if (msg.sender != _owner) 
            revert("Unauthorized access");

        // Update the price for the ticket in ERC20
        events[eventId].pricePerTicketERC20 = price;
        emit PriceUpdate(eventId, price, "ERC20");
    }

    function setERC20Address(address newERC20Address) external override {
        // Authorization check
        if (msg.sender != _owner) 
            revert("Unauthorized access");

        erc20Address = newERC20Address;

        emit ERC20AddressUpdate(newERC20Address);
    }

    function buyTickets(uint128 eventId, uint128 ticketCount) payable external override {
        // no owner check.

        // check for overflow
        if (ticketCount > (type(uint256).max / events[eventId].pricePerTicket)) {
            revert("Overflow happened while calculating the total price of tickets. Try buying smaller number of tickets.");
        }

        // check if the user has enough funds
        if (msg.value < (events[eventId].pricePerTicket * ticketCount)) {
            revert("Not enough funds supplied to buy the specified number of tickets.");
        }

        // check if we have enough tickets to sell
        if (events[eventId].maxTickets < (events[eventId].nextTicketToSell + ticketCount)) {
            revert("We don't have that many tickets left to sell!");
        }

        // Mint the tickets
        for (uint128 i = 0; i < ticketCount; i++) {
            // get nftId of the ticket
            // Recall that ticket has unique ID of 256 bits
            // eventID takes the first 128 bits, and the seat number takes the last 128 bits
            uint256 nftId = (uint256(eventId) << 128) | (uint256(events[eventId].nextTicketToSell + i));
            ticketNFT.mintFromMarketPlace(msg.sender, nftId);
        }
        // Update the nextTicketToSell
        events[eventId].nextTicketToSell += ticketCount;

        emit TicketsBought(eventId, ticketCount, "ETH");
    }

    function buyTicketsERC20(uint128 eventId, uint128 ticketCount) external override {
        // no owner check.

        // check for overflow
        if (ticketCount > (type(uint256).max / events[eventId].pricePerTicketERC20)) {
            revert("Overflow happened while calculating the total price of tickets. Try buying smaller number of tickets.");
        }

        // check if the user has enough funds
        if (IERC20(erc20Address).balanceOf(msg.sender) < (events[eventId].pricePerTicketERC20 * ticketCount)) {
            revert("Not enough funds supplied to buy the specified number of tickets.");
        }

        // check if we have enough tickets to sell
        if (events[eventId].maxTickets < (events[eventId].nextTicketToSell + ticketCount)) {
            revert("We don't have that many tickets left to sell!");
        }

        // Transfer the funds
        IERC20(erc20Address).transferFrom(msg.sender, address(this), (events[eventId].pricePerTicketERC20 * ticketCount));

        // Mint the tickets
        for (uint128 i = 0; i < ticketCount; i++) {
            // Same as above
            uint256 nftId = (uint256(eventId) << 128) | (uint256(events[eventId].nextTicketToSell + i));
            ticketNFT.mintFromMarketPlace(msg.sender, nftId);
        }
        events[eventId].nextTicketToSell += ticketCount;

        emit TicketsBought(eventId, ticketCount, "ERC20");
    }
}