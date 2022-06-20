// this is an attempted circuit for the quiz in the zKuiz
// final project for the ZKU cohort 3
// @author cypg
// @date 10/6/22
// @date modified 20/6/22

pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

//this circuit takes in the user's public answers to the quiz question,
// the actual private answers, and a private salt. The output signal
// is a hash of the number of correct answers, and the salt
template Kuiz(n) {
    // Public inputs
    //signal input questionTypes[n];
    signal input pubUserAnswers[n];
    //signal input pubSolutionHash;

    // Private inputs
    signal input privQuizAnswers[n];
    signal input privSalt;

    // Output
    //signal output correctAnswers[n];
    signal output numCorrectAnswersHashOut;


    // component isEqualArray[n];
    // component mark[n];
    component poseidon = Poseidon(2);
    var numCorrectAnswers = 0;
    

    // Verify that the hash of the private solution matches pubSolnHash
    //component poseidon = Poseidon(n+1);
    poseidon.inputs[0] <== privSalt;
    for(var i = 0; i < n; i++)
    {
        //incrementing the number of correct answers by using the conditional
        //expression. Specifically, we ask if the current index of the user's
        //answers matches the quiz answers. If true, we increment by 1.
        // Otherwise, we do not incrememnt.
        numCorrectAnswers += pubUserAnswers[i] == privQuizAnswers[i] ? 1 : 0;
    }

    // adding the number of correct answers to the poseidon hash
    poseidon.inputs[1] <== numCorrectAnswers;
    numCorrectAnswersHashOut <== poseidon.out;

    //pubSolutionHash === solutionHashOut;
 }

 component main{public [pubUserAnswers]}  = Kuiz();