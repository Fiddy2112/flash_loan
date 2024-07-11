// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";

import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface Dex {
    function depositUSDC(uint256 _amount) external;

    function depositDAI(uint256 _amount) external;

    function buyUSDC() external;

    function sellDAI() external;
}

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase{
    address payable owner;

    address private immutable daiAddress = 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;

    address private immutable usdcAddress = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;

    // we need address deployment contract Dex
    address private immutable dexContractAddress = 0x84C18815572dE8eB68A88ef51a9927C3FA6B75e4;

    IERC20 private dai;
    IERC20 private usdc;
    Dex private dexContract;  

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)){
        owner = payable(msg.sender);

        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
        dexContract = Dex(dexContractAddress);
    }

    modifier onlyOwner{
      require(msg.sender == owner, "You don't have permission, only owner can perform this action");
      _;
    }

    function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool){

    dexContract.depositUSDC(1000000000);// 100USDC
    dexContract.depositDAI(dai.balanceOf(address(this)));
    dexContract.buyUSDC();
    dexContract.sellDAI();

    uint256 amountOwned = amount + premium;
    IERC20(asset).approve(address(POOL),amountOwned);

    return true;
  }

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

  function approveUSDC(uint256 _amount) external returns (bool){
    return usdc.approve(dexContractAddress, _amount);
  }

  function approveDAI(uint256 _amount) external returns(bool){
    return dai.approve(dexContractAddress, _amount);
  }

  function allowanceUSDC() external view returns (uint256){
   return usdc.allowance(address(this), dexContractAddress);
  }

  function allowanceDai() external view returns (uint256){
    return dai.allowance(address(this), dexContractAddress);
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