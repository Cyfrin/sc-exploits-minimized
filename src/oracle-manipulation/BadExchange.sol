// SPDX-License-Identifier: MIt
pragma solidity 0.8.20;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// This is a super stripped down decentralized exchange based on UniswapV1
/// It has a billion bugs, do not use
contract BadExchange is ERC20 {
    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    IERC20 private immutable i_wethToken;
    IERC20 private immutable i_poolToken;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(
        address poolToken,
        address wethToken,
        string memory liquidityTokenName,
        string memory liquidityTokenSymbol
    ) ERC20(liquidityTokenName, liquidityTokenSymbol) {
        i_wethToken = IERC20(wethToken);
        i_poolToken = IERC20(poolToken);
    }

    /*//////////////////////////////////////////////////////////////
                        ADD AND REMOVE LIQUIDITY
    //////////////////////////////////////////////////////////////*/
    function deposit(uint256 wethToDeposit, uint256 maximumPoolTokensToDeposit)
        external
        returns (uint256 liquidityTokensToMint)
    {
        if (totalLiquidityTokenSupply() > 0) {
            uint256 wethReserves = i_wethToken.balanceOf(address(this));
            uint256 poolTokensToDeposit = getPoolTokensToDepositBasedOnWeth(wethToDeposit);

            // We do the same thing for liquidity tokens. Similar math.
            liquidityTokensToMint = (wethToDeposit * totalLiquidityTokenSupply()) / wethReserves;
            _addLiquidityMintAndTransfer(wethToDeposit, poolTokensToDeposit, liquidityTokensToMint);
        } else {
            // This will be the "initial" funding of the protocol. We are starting from blank here!
            // We just have them send the tokens in, and we mint liquidity tokens based on the weth
            _addLiquidityMintAndTransfer(wethToDeposit, maximumPoolTokensToDeposit, wethToDeposit);
            liquidityTokensToMint = wethToDeposit;
        }
    }

    /// @dev This is a sensitive function, and should only be called by addLiquidity
    /// @param wethToDeposit The amount of WETH the user is going to deposit
    /// @param poolTokensToDeposit The amount of pool tokens the user is going to deposit
    /// @param liquidityTokensToMint The amount of liquidity tokens the user is going to mint
    function _addLiquidityMintAndTransfer(
        uint256 wethToDeposit,
        uint256 poolTokensToDeposit,
        uint256 liquidityTokensToMint
    ) private {
        _mint(msg.sender, liquidityTokensToMint);

        // Interactions
        i_wethToken.safeTransferFrom(msg.sender, address(this), wethToDeposit);
        i_poolToken.safeTransferFrom(msg.sender, address(this), poolTokensToDeposit);
    }

    /// @notice Removes liquidity from the pool
    /// @param liquidityTokensToBurn The number of liquidity tokens the user wants to burn
    function withdraw(uint256 liquidityTokensToBurn) external {
        // We do the same math as above
        uint256 wethToWithdraw =
            (liquidityTokensToBurn * i_wethToken.balanceOf(address(this))) / totalLiquidityTokenSupply();
        uint256 poolTokensToWithdraw =
            (liquidityTokensToBurn * i_poolToken.balanceOf(address(this))) / totalLiquidityTokenSupply();

        _burn(msg.sender, liquidityTokensToBurn);

        i_wethToken.safeTransfer(msg.sender, wethToWithdraw);
        i_poolToken.safeTransfer(msg.sender, poolTokensToWithdraw);
    }

    /*//////////////////////////////////////////////////////////////
                              GET PRICING
    //////////////////////////////////////////////////////////////*/

    function getOutputAmountBasedOnInput(uint256 inputAmount, uint256 inputReserves, uint256 outputReserves)
        public
        pure
        returns (uint256 outputAmount)
    {
        uint256 inputAmountMinusFee = inputAmount * 1000;
        // uint256 inputAmountMinusFee = inputAmount * 997;
        uint256 numerator = inputAmountMinusFee * outputReserves;
        // uint256 denominator = (inputReserves * 1000) + inputAmountMinusFee;
        uint256 denominator = (inputReserves * 1000) + inputAmountMinusFee;
        return numerator / denominator;
    }

    function getInputAmountBasedOnOutput(uint256 outputAmount, uint256 inputReserves, uint256 outputReserves)
        public
        pure
        returns (uint256 inputAmount)
    {
        // return ((inputReserves * outputAmount) * 1000) / ((outputReserves - outputAmount) * 997);
        return ((inputReserves * outputAmount) * 1000) / ((outputReserves - outputAmount) * 1000);
    }

    function swapExactInput(IERC20 inputToken, uint256 inputAmount, IERC20 outputToken) public {
        uint256 inputReserves = inputToken.balanceOf(address(this));
        uint256 outputReserves = outputToken.balanceOf(address(this));
        uint256 outputAmount = getOutputAmountBasedOnInput(inputAmount, inputReserves, outputReserves);

        _swap(inputToken, inputAmount, outputToken, outputAmount);
    }

    /*
     * @notice figures out how much you need to input based on how much
     * output you want to receive.
     *
     * Example: You say "I want 10 output WETH, and my input is DAI"
     * The function will figure out how much DAI you need to input to get 10 WETH
     * And then execute the swap
     * @param inputToken ERC20 token to pull from caller
     * @param outputToken ERC20 token to send to caller
     * @param outputAmount The exact amount of tokens to send to caller
     */
    function swapExactOutput(IERC20 inputToken, IERC20 outputToken, uint256 outputAmount)
        public
        returns (uint256 inputAmount)
    {
        uint256 inputReserves = inputToken.balanceOf(address(this));
        uint256 outputReserves = outputToken.balanceOf(address(this));

        inputAmount = getInputAmountBasedOnOutput(outputAmount, inputReserves, outputReserves);

        _swap(inputToken, inputAmount, outputToken, outputAmount);
    }

    /**
     * @notice Swaps a given amount of input for a given amount of output tokens.
     * @dev Checks core invariant of the contract. Beware of modifying this function.
     * @dev Every 10 swaps, we give the caller an extra token as an extra incentive to keep trading on T-Swap.
     * @param inputToken ERC20 token to pull from caller
     * @param inputAmount Amount of tokens to pull from caller
     * @param outputToken ERC20 token to send to caller
     * @param outputAmount Amount of tokens to send to caller
     */
    function _swap(IERC20 inputToken, uint256 inputAmount, IERC20 outputToken, uint256 outputAmount) private {
        inputToken.safeTransferFrom(msg.sender, address(this), inputAmount);
        outputToken.safeTransfer(msg.sender, outputAmount);
    }

    /*//////////////////////////////////////////////////////////////
                   EXTERNAL AND PUBLIC VIEW AND PURE
    //////////////////////////////////////////////////////////////*/
    function getPoolTokensToDepositBasedOnWeth(uint256 wethToDeposit) public view returns (uint256) {
        uint256 poolTokenReserves = i_poolToken.balanceOf(address(this));
        uint256 wethReserves = i_wethToken.balanceOf(address(this));
        return (wethToDeposit * poolTokenReserves) / wethReserves;
    }

    /// @notice a more verbose way of getting the total supply of liquidity tokens
    function totalLiquidityTokenSupply() public view returns (uint256) {
        return totalSupply();
    }

    function getPoolToken() external view returns (address) {
        return address(i_poolToken);
    }

    function getWeth() external view returns (address) {
        return address(i_wethToken);
    }

    function getPriceOfOneWethInUSDC() external view returns (uint256) {
        return getOutputAmountBasedOnInput(
            1e18, i_wethToken.balanceOf(address(this)), i_poolToken.balanceOf(address(this))
        );
    }

    function getPriceOfUSDCInWeth() external view returns (uint256) {
        return getOutputAmountBasedOnInput(
            1e18, i_poolToken.balanceOf(address(this)), i_wethToken.balanceOf(address(this))
        );
    }
}
