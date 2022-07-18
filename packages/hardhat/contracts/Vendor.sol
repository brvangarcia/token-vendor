pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;

  address public contractOwner;

  constructor(address tokenAddress) {
    contractOwner = msg.sender;
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:

  function buyTokens() public payable  {

    require(msg.value > 0, "Send some ETH.");

    uint amountOfTokens = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() public onlyOwner  {
    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send ETH.");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public payable {
    uint256 amountOfETHToPay = _amount / tokensPerEth;
    require(yourToken.transferFrom(msg.sender, address(this), _amount), "Failed to transfer tokens.");
    (bool sent,) = msg.sender.call{value: amountOfETHToPay}("");
    require(sent, "Failed to send ETH.");

  }

}
