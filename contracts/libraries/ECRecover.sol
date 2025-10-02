// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library ECRecover {
    error InvalidSignature();

    /**
     * @notice Recover signer's address from a signed message
     * @param digest Keccak-256 hash digest of the signed message
     * @param v v of the signature
     * @param r r of the signature
     * @param s s of the signature
     * @return Signer address
     */
    function recover(
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        // Validate signature parameters
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            revert InvalidSignature();
        }
        if (v != 27 && v != 28) {
            revert InvalidSignature();
        }

        address signer = ecrecover(digest, v, r, s);
        if (signer == address(0)) {
            revert InvalidSignature();
        }

        return signer;
    }
}
