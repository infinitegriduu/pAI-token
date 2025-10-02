// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title ExtendedMath
 * @dev Library for optimized mathematical operations
 */
library ExtendedMath {
    /**
     * @dev Returns the smaller of two numbers
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Limits a value to be less than a maximum
     */
    function limitLessThan(
        uint256 a,
        uint256 b
    ) internal pure returns (uint256) {
        return a > b ? b : a;
    }
}
