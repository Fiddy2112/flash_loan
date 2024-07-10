// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)){
        owner = payable(msg.sender);
    }

    modifier onlyOwner{
      require(msg.sender == owner, "You don't have permission, only owner can perform this action");
      _;
    }

  
   //* @notice Executes an operation after receiving the flash-borrowed asset
   //* @dev Ensure that the contract can return the debt + premium, e.g., has
   //*      enough funds to repay and has approved the Pool to pull the total amount
   //* @param asset The address of the flash-borrowed asset
   //* @param amount The amount of the flash-borrowed asset
   //* @param premium The fee of the flash-borrowed asset
   //* @param initiator The address of the flashloan initiator
   //* @param params The byte-encoded params passed when initiating the flashloan
   //* @return True if the execution of the operation succeeds, false otherwise
  
  function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool){

    uint256 amountOwned = amount + premium;
    IERC20(asset).approve(address(POOL),amountOwned);

    return true;
  }


   //* @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
   //* as long as the amount taken plus a fee is returned.
   //* @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
   //* into consideration. For further details please visit https://docs.aave.com/developers/
   //* @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
   //* @param asset The address of the asset being flash-borrowed
   //* @param amount The amount of the asset being flash-borrowed
   //* @param params Variadic packed params to pass to the receiver as extra information
   //* @param referralCode The code used to register the integrator originating the operation, for potential rewards.
   //*   0 if the action is executed directly by the user, without any middle-man


  function requestFlashLoan(address _token, uint256 _amount) public {
     address receiverAddress = address(this);
    address asset = _token;
    uint256  amount = _amount;
    bytes memory params = "";
    uint16 referralCode = 0;

    POOL.flashLoanSimple(
       receiverAddress,
       asset,
       amount,
       params,
       referralCode
    );
  }

  function getBalance(address _tokenAddress) external view returns (uint256){
    return IERC20(_tokenAddress).balanceOf(address(this));
  }

  function withdraw(address _tokenAddress)external  onlyOwner{
    IERC20 token = IERC20(_tokenAddress);
    token.transfer(msg.sender, token.balanceOf(address(this)));  
  }

  receive() external payable{
    
  }


}

