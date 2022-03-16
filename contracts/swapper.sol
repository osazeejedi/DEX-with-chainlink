// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "./ERC20.sol";

contract Swapper {
  

    AggregatorV3Interface internal priceFeed;
    int public exchangePrice;
    uint96 public decimals;
    constructor(address feedAddress) {
        priceFeed = AggregatorV3Interface(feedAddress);
    }

    function getLatestPrice() public {
        (
        // uint80 roundId,
        ,int256 price,,,
        // uint256 startedAt,
        // uint256 updatedAt,
        // uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        exchangePrice = price;
        decimals = priceFeed.decimals();
    }

    function viewPrice() view public returns(uint){
        return uint256(exchangePrice);
    }


    function DaiToUsdt (address _fromToken,address _toToken,uint _amountIn) internal{
        uint rate = uint256(exchangePrice)/decimals;
        uint swappedAmount = _amountIn * rate;
        require ( IERC20(_toToken).balanceOf(address(this))>= swappedAmount , "Insufficent funds");
        require(IERC20(_fromToken).transferFrom(msg.sender, address(this), _amountIn),"");
        
    }


    function UsdtToDai(address _fromToken,address _toToken,uint _amountIn) internal{
        uint rate = uint256(exchangePrice)/decimals;
        uint swappedAmount = (_amountIn*100000)/rate;
        require ( IERC20(_toToken).balanceOf(address(this))>= swappedAmount, "Insufficent funds");
        require(IERC20(_fromToken).transferFrom(msg.sender,address(this), _amountIn),"OGBENI!!!!!");
        
    }
}