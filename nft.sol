// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

contract YTTokens is ERC1155PresetMinterPauser {
    
    uint256 public gameIDCounter;
    
    mapping(string => uint256) public idmap;
    mapping(uint256 => string) public lookupmap;


    constructor() ERC1155PresetMinterPauser("https://img.youtube.com/vi/") { //base URI
        
    }
    
    function addGameID( string memory gameID, uint256 initialSupply ) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "YTTokens: must have minter role to mint");
        
        require(idmap[gameID] == 0, "YTTokens: This gameID already exists");
        
        gameIDCounter = gameIDCounter + 1;
        idmap[gameID] = gameIDCounter;
        lookupmap[gameIDCounter] = gameID;

        _mint(msg.sender, gameIDCounter, initialSupply, "");        
    }
    
    function uri(uint256 id) public view virtual override returns (string memory) {
        return string( abi.encodePacked( super.uri(id), lookupmap[id], "/hqdefault.jpg" ));
    }
    
    function getAllTokens(address account) public view returns (uint256[] memory){
        uint256 numTokens = 0;
        for (uint i = 0; i <= gameIDCounter; i++) {
            if ( balanceOf(account, i) > 0) {
                numTokens++;
            }
        }
        
        uint256[] memory ret = new uint256[](numTokens);
        uint256 counter = 0;
        for (uint i = 0; i <= gameIDCounter; i++) {
            if ( balanceOf(account, i) > 0) {
                ret[counter] = i;
                counter++;
            }
        }
        
        return ret;
    }
}