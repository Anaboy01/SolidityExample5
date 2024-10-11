// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./DltToken.sol";

contract ClaimFaucet is DltToken{

    uint256 public constant CLAIMABLE_AMOUNT = 10; 

    constructor(string memory _name, string memory _symbol)DltToken(_name, _symbol){}

    struct User{
        uint256 lastClaimedTime;
        uint256 totalClaimed;
    }

    mapping (address => User) users;

    mapping (address => bool) hasClaimedBefore;

    event ClaimSuccessful(address indexed user, uint256 _amount, uint256 _time);

    function clainmToken() public {
        require(msg.sender != address(0), "Zero Address not allowed");

        if(hasClaimedBefore[msg.sender]){

            User storage currentUser = users[msg.sender];

            require(currentUser.lastClaimedTime + 1 days >= block.timestamp, "Baba come back in 24 hours");

            currentUser.lastClaimedTime = block.timestamp;
            currentUser.totalClaimed += CLAIMABLE_AMOUNT;

            mint(CLAIMABLE_AMOUNT, msg.sender);

            emit ClaimSuccessful(msg.sender, CLAIMABLE_AMOUNT, block.timestamp);


        }else{
           
            hasClaimedBefore[msg.sender] = true;
            mint(CLAIMABLE_AMOUNT, msg.sender);

            User memory currenttUser;
            currenttUser.lastClaimedTime = block.timestamp;
            currenttUser.totalClaimed = CLAIMABLE_AMOUNT;

             emit ClaimSuccessful(msg.sender, CLAIMABLE_AMOUNT, block.timestamp);

        }
    }
}