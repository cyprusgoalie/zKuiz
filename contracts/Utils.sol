// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Utils {
    function getArraySum(uint[] memory _array) public pure returns (uint sum_) {
        sum_ = 0;
        for (uint i = 0; i < _array.length; i++) {
            sum_ += _array[i];
        }
    }
}