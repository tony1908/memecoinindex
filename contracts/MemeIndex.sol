// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyETFToken is ERC20, Ownable {
    using SafeERC20 for IERC20;

    // Mapping to track the value of underlying assets
    mapping(address => uint256) private _assetValue;

    constructor(uint256 initialSupply, address owner) ERC20("MemeCoinIndex", "MMCI") Ownable(owner) {
    _mint(msg.sender, initialSupply);
}

    // Function to deposit another ERC20 token into the contract
    function deposit(address _token, uint256 _amount) public {
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
        _assetValue[_token] = _assetValue[_token] + _amount;
        emit TokenDeposited(_token, _amount, msg.sender);
    }

    // Function to update the value of an underlying asset
    function updateAssetValue(address asset, uint256 value) public onlyOwner {
        _assetValue[asset] = value;
    }

    // Function to get the value of an underlying asset
    function getAssetValue(address asset) public view returns (uint256) {
        return _assetValue[asset];
    }

    // Function to withdraw deposited ERC20 tokens
    function withdraw(address _token, uint256 _amount) public onlyOwner {
        require(_assetValue[_token] >= _amount, "Insufficient balance");
        IERC20(_token).safeTransfer(owner(), _amount);
        _assetValue[_token] = _assetValue[_token] - _amount;
        emit TokenWithdrawn(_token, _amount, owner());
    }

    // Event to log the deposit of an ERC20 token
    event TokenDeposited(address indexed token, uint256 amount, address indexed from);
    // Event to log the withdrawal of an ERC20 token
    event TokenWithdrawn(address indexed token, uint256 amount, address indexed to);
}