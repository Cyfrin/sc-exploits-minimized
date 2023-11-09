// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {BadExchange} from "./BadExchange.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OracleManipulation is ERC721 {
    mapping(address => uint256) public balances;
    uint256 public constant USD_PRICE_OF_NFT = 100; // $100 for an NFT
    uint256 public tokenCounter;

    BadExchange exchange;

    constructor(address _exchange) ERC721("OracleManipulation", "OM") {
        exchange = BadExchange(_exchange);
    }

    function buyNft() external payable {
        if (msg.value != getEthPriceOfNft()) {
            revert();
        }
        _safeMint(msg.sender, tokenCounter);
        tokenCounter = tokenCounter + 1;
    }

    /*
     * @notice uses BadExchange to get the price of ETH in USD
     * 1 NFT costs 100 USD, so we need to figure out how much ETH that
     * is worth. 
     */
    function getEthPriceOfNft() public view returns (uint256) {
        // Get how much 1 USDC worth of ETH/WETH is
        uint256 wethDollarCost = exchange.getPriceOfUSDCInWeth();
        return wethDollarCost * USD_PRICE_OF_NFT;
    }
}
