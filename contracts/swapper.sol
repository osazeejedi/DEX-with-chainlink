// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "./ERC20.sol";

contract Swapper {
  

    AggregatorV3Interface internal priceFeed;
    int public exchangePrice;
    struct Order{uint256 amountIn;address owner;}
    uint internal Index = 1;
    mapping(uint=> Order) public swaps;

    


    constructor() {
        priceFeed = AggregatorV3Interface(0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D);
    }

    function getLatestPrice() public view returns (int) {
        (
            ,
            int price,
            ,
            ,
            
        ) = priceFeed.latestRoundData();
        exchangePrice = price;
        return exchangePrice;
    }
        
    

    function DaiToUsdt (address _fromToken,address _toToken,uint _amountIn) internal{
        uint rate = uint256(exchangePrice);
        uint swappedAmount = _amountIn * rate;
        require ( IERC20(_toToken).balanceOf(address(this))>= swappedAmount , "Insufficent funds");
        require(IERC20(_fromToken).transferFrom(msg.sender, address(this), _amountIn));
        Order storage s= swaps[swapIndex];
        s.amountIn= _amountIn;
        s.owner=msg.sender;
        swapIndex++;
        IERC20(_toToken).transferFrom(address(this), msg.sender, (swappedAmount));
        
    }


    function UsdtToDai(address _fromToken,address _toToken,uint _amountIn) internal{
        uint rate = uint256(exchangePrice);
        uint swappedAmount = (_amountIn*100000)/rate;
        require ( IERC20(_toToken).balanceOf(address(this))>= swappedAmount, "Insufficent funds");
        require(IERC20(_fromToken).transferFrom(msg.sender,address(this), _amountIn));
        Order storage s= swaps[swapIndex];
        s.amountIn= _amountIn;
        s.owner=msg.sender;
        swapIndex++;
        IERC20(_toToken).transferFrom(address(this), msg.sender, swappedAmount/100000);
        
    }
}