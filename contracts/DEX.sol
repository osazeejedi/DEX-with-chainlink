pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "./USDT.sol";


contract DEX {

  IERC20 USDT;
  AggregatorV3Interface internal priceFeed;

  address token_addr;
  uint256 public totalLiquidity;
  mapping (address => uint256) public liquidity;

  constructor(address token_addr) {
    USDT = IERC20(token_addr);
    priceFeed = AggregatorV3Interface();
  }


/**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function ethToToken() public payable returns (uint256) {
  uint256 token_reserve = token.balanceOf(address(this));
  uint256 tokens_bought = price(msg.value, address(this).balance.sub(msg.value), token_reserve);
  require(token.transfer(msg.sender, tokens_bought));
  return tokens_bought;
}

function tokenToEth(uint256 tokens) public returns (uint256) {
  uint256 token_reserve = token.balanceOf(address(this));
  uint256 eth_bought = price(tokens, token_reserve, address(this).balance);
  (bool sent, ) = msg.sender.call{value: eth_bought}("");
  require(sent, "Failed to send user eth.");
  require(token.transferFrom(msg.sender, address(this), tokens));
  return eth_bought;
}


}