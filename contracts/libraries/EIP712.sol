// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./ECRecover.sol";

/**
 * @notice EIP712 Library for creating domain separators and recovering signers
 */
library EIP712 {
    /**
     * @notice Make EIP712 domain separator
     */
    function makeDomainSeparator(
        string memory name,
        string memory version,
        address verifyingContract
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    ),
                    keccak256(bytes(name)),
                    keccak256(bytes(version)),
                    block.chainid,
                    verifyingContract
                )
            );
    }

    /**
     * @notice Recover signer's address from an EIP712 signature
     */
    function recover(
        bytes32 domainSeparator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes memory typeHashAndData
    ) internal pure returns (address) {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(typeHashAndData)
            )
        );
        return ECRecover.recover(digest, v, r, s);
    }
}
