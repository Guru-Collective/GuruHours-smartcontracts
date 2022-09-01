/*
This file is part of the Guru Collective DAO.

The GuruHoursFactory Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The GuruHoursFactory Contract is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the GuruHoursFactory Contract. If not, see <http://www.gnu.org/licenses/>.

@author Ilya Svirin <is.svirin@gmail.com>
*/
// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "./guruhourstoken.sol";


contract GuruHoursFactory is Ownable, IGuruHoursFactory
{
    event FeeChanged(uint256 fee);
    event DAOChanged(address dao);
    event TokenCreated(address indexed token, address owner, string name, string symbod);
    event Transfer(address indexed token, address indexed sender, address indexed recepient, uint256 amount);
    event TokenOwnershipTransferred(address indexed token, address indexed newOwner);
    event BioChanged(address indexed token, string bioCID);
    event AvatarChanged(address indexed token, string avatarCID);

    uint256 public _fee;
    address public _dao;
    mapping (address => address) public _tokens;

    constructor ()
    {
        setFee(20);
        setDAO(_msgSender());
    }

    function setFee(uint256 newFee) public onlyOwner
    {
        _fee = newFee;
        emit FeeChanged(_fee);
    }

    function fee() view external override returns(uint256)
    {
        return _fee;
    }

    function setDAO(address newdao) public onlyOwner
    {
        _dao = newdao;
        emit DAOChanged(_dao);
    }

    function dao() view external override returns(address)
    {
        return _dao;
    }

    function deployGuruHoursToken(string memory name, string memory symbol) public payable
    {
        GuruHoursToken token = new GuruHoursToken(address(this), name, symbol);
        _tokens[address(token)] = _msgSender();
        emit TokenCreated(address(token), _msgSender(), name, symbol);
        token.transferOwnership(_msgSender());
    }

    function validateToken() internal view
    {
        require(_tokens[_msgSender()] != address(0), "unknown token contract");
    }

    function onTransfer(address sender, address recipient, uint256 amount) public override
    {
        validateToken();
        emit Transfer(_msgSender(), sender, recipient, amount);
    }

    function onChangeBio(string memory bioCID) public override
    {
        validateToken();
        emit BioChanged(_msgSender(), bioCID);
    }
    
    function onChangeAvatar(string memory avatarCID) public override
    {
        validateToken();
        emit AvatarChanged(_msgSender(), avatarCID);
    }

    function onOwnershipTransfer(address newOwner) public override
    {
        validateToken();
        emit TokenOwnershipTransferred(_msgSender(), newOwner);
    }
}
