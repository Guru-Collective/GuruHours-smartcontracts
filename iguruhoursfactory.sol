/*
This file is part of the Guru Collective DAO.

The IGuruHoursFactory Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The IGuruHoursFactory Contract is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the IGuruHoursFactory Contract. If not, see <http://www.gnu.org/licenses/>.

@author Ilya Svirin <is.svirin@gmail.com>
*/
// SPDX-License-Identifier: GNU lesser General Public License

pragma solidity ^0.8.0;


interface IGuruHoursFactory
{
    function fee() view external returns(uint256);
    function dao() view external returns(address);
    function onTransfer(address sender, address recipient, uint256 amount) external;
    function onChangeBio(string memory bioCID) external;
    function onChangeAvatar(string memory avatarCID) external;
    function onOwnershipTransfer(address newOwner) external;
}
