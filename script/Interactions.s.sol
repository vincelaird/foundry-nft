// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {
    string public constant PUG =
        "ipfs://QmYkRTFiHyELLFPiKPZe7A1VnLSNhsrWPvWLzxCyh6uPoE";

    function run() external {
        address mostRecentlyDeployed = getMostRecentlyDeployed();
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(PUG);
        vm.stopBroadcast();
    }

    function getMostRecentlyDeployed() public view virtual returns (address) {
        return DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
    }
}