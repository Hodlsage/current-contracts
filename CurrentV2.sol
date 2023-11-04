// ----------------------------------------------------------------------------
// --- Name        : Current V2 - [CRNT]
// --- Symbol      : Format - {---}
// --- Total supply: Generated from minter accounts
// --- @Legal      : 
// --- @title for 01101101 01111001 01101101 01100101
// --- BlockHaus.Company - EJS32 - 2018-2023
// --- @dev pragma solidity version:0.8.19+commit.7dd64d404
// --- SPDX-License-Identifier: MIT
// ----------------------------------------------------------------------------

pragma solidity ^0.8.19;

// ----------------------------------------------------------------------------
// --- Interface IERC20
// ----------------------------------------------------------------------------

interface IERC20 {
  // --- Returns the total supply of tokens
  function totalSupply() external view returns (uint256);

  // --- Returns the number of decimal places the token has
  function decimals() external view returns (uint8);

  // --- Returns the symbol of the token (e.g., CRNT)
  function symbol() external view returns (string memory);

  // --- Returns the name of the token (e.g., Current)
  function name() external view returns (string memory);

  // --- Returns the owner of the contract
  function getOwner() external view returns (address);

  // --- Returns the balance of a specific account
  function balanceOf(address account) external view returns (uint256);

  // --- Transfers tokens from the sender to the recipient
  function transfer(address recipient, uint256 amount) external returns (bool);

  // --- Returns the allowance for a spender on the owner's tokens
  function allowance(address _owner, address spender) external view returns (uint256);

  // --- Approves a spender to spend a specific amount of tokens
  function approve(address spender, uint256 amount) external returns (bool);

  // --- Transfers tokens from a sender to a recipient on behalf of the owner
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  // --- Event emitted when tokens are transferred
  event Transfer(address indexed from, address indexed to, uint256 value);

  // --- Event emitted when approval for spending tokens is granted
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ----------------------------------------------------------------------------
// --- Abstract Contract Context 
// ----------------------------------------------------------------------------

abstract contract Context {
  // --- Returns the sender's address, which is the address of the account that initiated the current transaction.
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  // --- Returns the transaction data as a bytes array, which includes the function call data and additional information about the transaction.
  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}

// ----------------------------------------------------------------------------
// --- Library SafeMath 
// ----------------------------------------------------------------------------

library SafeMath {
  // --- Safely adds two numbers without overflow
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }

  // --- Safely subtracts two numbers without underflow
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  // --- Safely subtracts two numbers without underflow and provides a custom error message
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;
    return c;
  }

  // --- Safely multiplies two numbers without overflow
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }

  // --- Safely divides two numbers without division by zero
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  // --- Safely divides two numbers without division by zero and provides a custom error message
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    return c;
  }

  // --- Safely calculates the modulo of two numbers without division by zero
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  // --- Safely calculates the modulo of two numbers without division by zero and provides a custom error message
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// ----------------------------------------------------------------------------
// --- Abstract Contract Ownable 
// ----------------------------------------------------------------------------

abstract contract Ownable is Context {
  // --- The address of the current owner of the contract
  address private _owner;

  // --- Custom error for unauthorized account access
  error OwnableUnauthorizedAccount(address account);

  // --- Custom error for an invalid owner address
  error OwnableInvalidOwner(address owner);

  // --- Event emitted when ownership is transferred
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  // --- Constructor that sets the initial owner of the contract
  constructor(address initialOwner) {
    // --- Ensure the initial owner address is not 0x0 (invalid)
    if (initialOwner == address(0)) {
      revert OwnableInvalidOwner(address(0));
    }
    // --- Transfer ownership to the initial owner
    _transferOwnership(initialOwner);
  }

  // --- Modifier to restrict access to functions only to the owner
  modifier onlyOwner() {
    _checkOwner();
    _;
  }

  // --- Returns the address of the current owner
  function owner() public view virtual returns (address) {
    return _owner;
  }

  // --- Internal function to check if the sender is the owner
  function _checkOwner() internal view virtual {
    if (owner() != _msgSender()) {
      revert OwnableUnauthorizedAccount(_msgSender());
    }
  }

  // --- Allows the current owner to renounce ownership
  function renounceOwnership() public virtual onlyOwner {
    _transferOwnership(address(0));
  }

  // --- Allows the current owner to transfer ownership to a new address
  function transferOwnership(address newOwner) public virtual onlyOwner {
    // --- Ensure the new owner address is not 0x0 (invalid)
    if (newOwner == address(0)) {
      revert OwnableInvalidOwner(address(0));
    }
    // --- Transfer ownership to the new owner
    _transferOwnership(newOwner);
  }

  // --- Internal function to perform the ownership transfer
  function _transferOwnership(address newOwner) internal virtual {
    address oldOwner = _owner;
    _owner = newOwner;
    // --- Emit an event to indicate the ownership transfer
    emit OwnershipTransferred(oldOwner, newOwner);
  }
}

// ----------------------------------------------------------------------------
// --- Abstract Contract CurrentV2 
// ----------------------------------------------------------------------------

contract CurrentV2 is Context, IERC20, Ownable {
  using SafeMath for uint256;

  // --- Mapping to track token balances for each address
  mapping (address => uint256) private _balances;
  
  // --- Mapping to track allowances for token transfers
  mapping (address => mapping (address => uint256)) private _allowances;

  // --- Total supply of the token
  uint256 private _totalSupply;

  // --- Number of decimal places for the token
  uint8 public _decimals;

  // --- Token symbol (e.g., CRNT)
  string public _symbol;

  // --- Token name (e.g., Current)
  string public _name;

  constructor() Ownable(msg.sender) {
    // --- Initialize token properties and supply when the contract is deployed
    _name = "Current";
    _symbol = "CRNT";
    _decimals = 0;
    _totalSupply = 27000000000000000000000000;
    _balances[msg.sender] = _totalSupply;

    // --- Emit a transfer event to indicate the initial distribution of tokens
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  // --- External function to get the current owner of the contract
  function getOwner() external view returns (address) {
    return owner();
  }

  // --- External function to get the number of decimal places for the token
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  // --- External function to get the token symbol (e.g., CRNT)
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  // --- External function to get the token name (e.g., Current)
  function name() external view returns (string memory) {
    return _name;
  }

  // --- External function to get the total token supply
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  // --- External function to get the token balance of a specific address
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  // --- External function to transfer tokens to another address
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  // --- External function to get the allowance for a specific address to spend tokens on behalf of the owner
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  // --- External function to approve an address to spend a certain amount of tokens on behalf of the owner
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  // --- External function to transfer tokens from one address to another
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }

  // --- Public function to increase the allowance for a spender to spend tokens on behalf of the owner
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  // --- Public function to decrease the allowance for a spender to spend tokens on behalf of the owner
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
    return true;
  }

  // --- Public function to mint additional tokens, can only be called by the owner
  function mint(uint256 amount) public onlyOwner returns (bool) {
    _mint(_msgSender(), amount);
    return true;
  }

  // --- Public function to burn a specific amount of tokens
  function burn(uint256 amount) public returns (bool) {
    _burn(_msgSender(), amount);
    return true;
  }

  // --- Internal function to transfer tokens from one address to another
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    // --- Check if the sender has sufficient balance and update balances
    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  // --- Internal function to mint additional tokens and update total supply
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "ERC20: mint to the zero address");

    // --- Update total supply and recipient's balance
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  // --- Internal function to burn a specific amount of tokens and update total supply
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "ERC20: burn from the zero address");

    // --- Check if the account has sufficient balance and update balances and total supply
    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  // --- Internal function to approve an address to spend a certain amount of tokens on behalf of the owner
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    // --- Update the allowance for the owner and spender
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  // --- Internal function to burn tokens from an account, used with allowance
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
  }
}

