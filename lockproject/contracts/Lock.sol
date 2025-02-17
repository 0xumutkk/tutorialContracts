// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Token.sol";
contract Lock {
    LMToken Token;
    uint256 public lockerCount;
    uint256 public totalLocked;
    mapping(address=>uint256) public lockers;
    
    constructor(address tokenAddress){
        Token= LMToken(tokenAddress);
    }

    function lockTokens(uint256 amount) external{
        require(amount>0,"Token amount must be bigger than 0.");
        //require(Token.balanceOf(msg.sender) >= amount, "Insufficient balance.");
        //require(Token.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance.");
        //erc20 standart kontratı tarafından kontrol ediliyor zaten yazmaya gerek yok 
        //Token.allowance(owner(fonksiyonu çağıran kişi),spender(kontratın kendisi))

        if(!(lockers[msg.sender]>0)) lockerCount++;
        totalLocked += amount;
        lockers[msg.sender] += amount;

        bool ok = Token.transferFrom(msg.sender,address(this),amount);
        //syntax: function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
        require(ok,"Transfer failed.");
    
    }

    function withdrawTokens() external{
        require(lockers[msg.sender] > 0,"Not enough token");
        uint256 amount= lockers[msg.sender];
        delete(lockers[msg.sender]);
        totalLocked -=amount;
        lockerCount--;
        require(Token.transfer(msg.sender,amount),"Transfer failed");
        //syntax: 
    
    }

}
