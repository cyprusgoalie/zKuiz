// this is an attempted circuit for the quiz in the zKuiz
// final project for the ZKU cohort 3
// @author cypg
// @date 10/6/22

pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

//this circuit takes in the quiz answers, the type of each question, the user's answers, and the private salt and outputs an array of 1/0s corresponding to a correct or incorrect answer
template Kuiz(n) {
    // Public inputs
    //signal input questionTypes[n];
    signal input pubUserAnswers[n];
    signal input pubSolutionHash;

    // Private inputs
    signal input privQuizAnswers[n];
    signal input privSalt;

    // Output
    //signal output correctAnswers[n];
    signal output solutionHashOut;


    // component isEqualArray[n];
    // component mark[n];
    component poseidon = Poseidon(n);

    // Verify that the hash of the private solution matches pubSolnHash
    component poseidon = Poseidon(n+1);
    poseidon.inputs[0] <== privSalt;
    for(var i = 1; i <= n; i++)
    {
        poseidon.inputs[i] <== privQuizAnswers[i];
    }

    solutionHashOut <== poseidon.out;

    pubSolutionHash === solutionHashOut;
 }

 component main{public [pubUserAnswers pubSolutionHash]}  = Kuiz();