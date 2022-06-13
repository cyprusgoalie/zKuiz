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
    signal input quizAnswers[n];
    signal input questionTypes[n];
    signal input userAnswers[n];
    signal input sub

    // Private inputs
    signal input privSalt;

    // Output
    signal output correctAnswers[n];

    // var guess[4] = [pubGuessA, pubGuessB, pubGuessC, pubGuessD];
    // var soln[4] =  [privSolnA, privSolnB, privSolnC, privSolnD];
    // var j = 0;
    // var k = 0;
    // component lessThan[8];
    component isEqualArray[n];
    component mark[n];
    // var equalIdx = 0;

    // Create a constraint that the solution and guess digits are all less than 10.
    
    for (var i = 0; i < n; i++) {
        isEqualArray[i] = IsEqual();
        isEqualArray[i].in[0] <== quizAnswers[i];
        isEqualArray[i].in[1] <== userAnswers[i];
        correctAnswers[i] <== isEqualArray[i].out;
    }

    // // Count hit & blow
    // var hit = 0;
    // var blow = 0;
    // component equalHB[16];

    // for (j=0; j<4; j++) {
    //     for (k=0; k<4; k++) {
    //         equalHB[4*j+k] = IsEqual();
    //         equalHB[4*j+k].in[0] <== soln[j];
    //         equalHB[4*j+k].in[1] <== guess[k];
    //         blow += equalHB[4*j+k].out;
    //         if (j == k) {
    //             hit += equalHB[4*j+k].out;
    //             blow -= equalHB[4*j+k].out;
    //         }
    //     }
    // }

    // // Create a constraint around the number of hit
    // component equalHit = IsEqual();
    // equalHit.in[0] <== pubNumHit;
    // equalHit.in[1] <== hit;
    // equalHit.out === 1;
    
    // // Create a constraint around the number of blow
    // component equalBlow = IsEqual();
    // equalBlow.in[0] <== pubNumBlow;
    // equalBlow.in[1] <== blow;
    // equalBlow.out === 1;

    // // Verify that the hash of the private solution matches pubSolnHash
    // component poseidon = Poseidon(5);
    // poseidon.inputs[0] <== privSalt;
    // poseidon.inputs[1] <== privSolnA;
    // poseidon.inputs[2] <== privSolnB;
    // poseidon.inputs[3] <== privSolnC;
    // poseidon.inputs[4] <== privSolnD;

    // solnHashOut <== poseidon.out;
    // pubSolnHash === solnHashOut;
 }

 //component main  = Kuiz();