// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanExample is FlashLoanSimpleReceiverBase {
    using SafeMath for uint256;
    event Log(address asset, uint256 val);

    constructor(IPoolAddressesProvider provider)
        public
        FlashLoanSimpleReceiverBase
    {}

    function createFlashLoan(address asset, uint256 amount) external {
        address receiver = address(this);
        bytes memory params = ""; // use this to pass arbitary data to executeOperation
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        // do things like arbitrage here
        // abi.decode(params) to decode params

        uint256 amountOwing = amount.add(premium);
        IERC20(asset).approve(address(POOL), amountOwing);
        emit Log(asset, amountOwing);
        return true;
    }
}
