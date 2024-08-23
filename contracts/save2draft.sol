// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract Save2DraftContract {
   
    struct Save2DraftFields {
        uint amount;
        uint unlockTime;
        address payable owner;
        bool withdrawn;
    }
    mapping (address=>Save2DraftFields) public save2DraftFields;

    event Withdrawal(uint amount, uint whenWithdrawalWasMade);
    event Locked(address indexed owner, uint amount, uint whenDepositWasMade);

    function lockAsset(uint _amount, uint _unlockTime) external payable {
        require(msg.value == _amount, "You need to send the exact amount of ETH");
        require(block.timestamp < _unlockTime, "Unluck must be in the future");
         require(_amount > 0, "You must lock a positive amount");

         save2DraftFields[msg.sender] = Save2DraftFields({
            unlockTime: _unlockTime,
            amount: _amount,
            owner: payable(msg.sender),
            withdrawn: false
         });
         emit Locked(msg.sender, _amount, _unlockTime);
    }
 
 function withdrawAsset() external {
    Save2DraftFields storage lockedAsset = save2DraftFields[msg.sender];
    require(lockedAsset.owner == msg.sender, "You are not the owner of this asset");
    require(lockedAsset.amount > 0, 'You have no assets to withdraw');
    require(block.timestamp >= lockedAsset.unlockTime, "You cannot withdraw yet");

    uint amount = lockedAsset.amount;
    lockedAsset.amount = 0;
    lockedAsset.owner.transfer(amount);
 }

 function getWithdrawDate(address _address) external view returns (uint) {
    return save2DraftFields[_address].unlockTime;
 }
 function getLockedAmount(address _address) external view returns (uint) {
    return save2DraftFields[_address].amount;
 }
}
