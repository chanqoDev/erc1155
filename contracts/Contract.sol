// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

contract Web3Contract is ERC1155, Ownable, ERC1155Supply {
  uint256 maxSupply = 1000;

  constructor() ERC1155('ipfs://YOUR IPFS LINK GOES HERE/') {}

  function setURI(string memory newuri) public onlyOwner {
    _setURI(newuri);
  }

  function mint(
    // address account,
    uint256 id,
    uint256 amount // bytes memory data
  ) public payable {
    // require(msg.value == 0.01 ether, 'NOT ENOUGH MONEY');
    require(msg.value == amount * 0.01 ether, 'NOT ENOUGH MONEY');
    // _mint(account, id, amount, data);

    require(totalSupply(id) + amount <= maxSupply, 'Max supply Reached');

    _mint(msg.sender, id, amount, '');
  }

  function mintBatch(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) public onlyOwner {
    _mintBatch(to, ids, amounts, data);
  }

  function uri(uint256 _id) public view override returns (string memory) {
    require(exists(_id), 'URI: nonexistent token');

    return
      string(abi.encodePacked(super.uri(_id), Strings.toString(_id), '.json'));
  }

  function withdraw(address _addr) external onlyOwner {
    uint256 balance = address(this).balance;
    payable(_addr).transfer(balance);
  }

  // The following functions are overrides required by Solidity.

  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal override(ERC1155, ERC1155Supply) {
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
  }
}
