pragma solidity >=0.8.2 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "contracts/interfaces/IMyTokenError.sol";

contract MyToken is IERC20, IMyTokenError {
    uint256 _totalSupply;
    string private _name;
    string private _symbol;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_
    ) {
        _name = name_;
        _symbol = symbol_;

        _totalSupply = totalSupply_;
        _balances[msg.sender] = _totalSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _account) public view returns (uint256) {
        return _balances[_account];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        bool success = true;

        if (_from != msg.sender) {
            success = updateAllowance(_from, _to, _value);
        }

        if (success) {
            updateBalances(_from, _to, _value);
        }

        emit Transfer(_from, _to, _value);

        return success;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        if (_from == address(0)) revert InvalidSenderAddress(_from);

        if (_to == address(0)) revert InvalidReceiverAddress(_to);

        _update(_from, _to, _value);
    }

    function _update(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        if (_balances[_from] < _value) {
            revert InsufficientBalance(_from, _balances[_from], _value);
        }

        _balances[_from] -= _value;
        _balances[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    function updateAllowance(
        address _from,
        address _to,
        uint256 _value
    ) private returns (bool) {
        if (_from == address(0)) {
            revert InvalidSenderAddress(_from);
        }

        if (_to == address(0)) {
            revert InvalidReceiverAddress(_to);
        }

        if (_allowances[_from][_to] < _value) {
            return false;
        }

        _allowances[_from][_to] -= _value;
        return true;
    }

    function updateBalances(
        address _from,
        address _to,
        uint256 _value
    ) private returns (bool) {
        if (_from == address(0)) {
            revert InvalidSenderAddress(_from);
        }

        if (_to == address(0)) {
            revert InvalidReceiverAddress(_to);
        }

        _update(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256)
    {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        _approve(msg.sender, _spender, _value);
        return true;
    }

    function _approve(
        address _owner,
        address _spender,
        uint256 _value
    ) internal {
        if (_spender == address(0)) {
            revert InvalidSpenderAddress(_spender);
        }

        if (_owner == address(0)) {
            revert InvalidOwnerAddress(_owner);
        }

        _allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
    }
}
