// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

library Prime {
    

    // function to determine if the input is a prime number
    function isPrime(uint256 input) public pure returns(bool) {
        // return false if input is 1
        if (input == 1) return false;

        // loop variable
        uint256 i = 2;

        // loop from 2 to sqrt(input)
        while (i * i <= input){

            // check remainder of input devided by i
            if (input % i == 0) {
                // return false if devided
                return false;
            }

            // increment the variable
            i += 1;
        }

        // if no factor, input is a prime number
        return true;
    }

}