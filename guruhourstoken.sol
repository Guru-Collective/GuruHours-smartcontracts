/*
This file is part of the Guru Collective DAO.

The GuruHoursToken Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The GuruHoursToken Contract is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the GuruHoursToken Contract. If not, see <http://www.gnu.org/licenses/>.

@author Ilya Svirin <is.svirin@gmail.com>
*/
// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./iguruhoursfactory.sol";


contract GuruHoursToken is ERC20, Ownable
{
    event BioChanged(string bioCID);
    event AvatarChanged(string avatarCID);

    IGuruHoursFactory private _factory;
    string            public  _name;
    string            public  _bioCID;
    string            public  _avatarCID;

    constructor(address factory, string memory name, string memory symbol) ERC20(name, symbol)
    {
        _factory = IGuruHoursFactory(factory);
    }
    
    function burn(uint256 amount) public
    {
        _burn(_msgSender(), amount);
        _factory.onTransfer(_msgSender(), address(0), amount);
    }

    function mint(address recipient, uint256 amount) public onlyOwner
    {
        _mint(recipient, amount);
        _factory.onTransfer(address(0), recipient, amount);

        address dao = _factory.dao();
        uint256 fee = amount * _factory.fee() / 100;
        if (fee != 0 && dao != address(0))
        {
            _mint(dao, fee);
            _factory.onTransfer(address(0), dao, fee);
        }
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override 
    {
        super._transfer(sender, recipient, amount);
        _factory.onTransfer(_msgSender(), recipient, amount);
    }

    function transferOwnership(address newOwner) public override onlyOwner
    {
        super.transferOwnership(newOwner);
        _factory.onOwnershipTransfer(newOwner);
    }

    function setBio(string memory bioCID) public onlyOwner
    {
        _bioCID = bioCID;
        _factory.onChangeBio(bioCID);
        emit BioChanged(bioCID);
    }

    function setAvatar(string memory avatarCID) public onlyOwner
    {
        _avatarCID = avatarCID;
        _factory.onChangeAvatar(avatarCID);
        emit AvatarChanged(avatarCID);
    }
}
