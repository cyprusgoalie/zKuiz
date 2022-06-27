cd "$(dirname "$0")"

mkdir -p ../build
mkdir -p ../zkeyFiles
mkdir -p ../contracts/kuiz

cd ../build

if [ -f ./powersOfTau28_hez_final_14.ptau ]; then
    echo "powersOfTau28_hez_final_14.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_14.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_14.ptau
fi

circom ../circuits/kuiz.circom --r1cs --wasm --sym
snarkjs r1cs export json kuiz.r1cs kuiz.r1cs.json

snarkjs groth16 setup kuiz.r1cs powersOfTau28_hez_final_14.ptau kuiz_0000.zkey

snarkjs zkey contribute kuiz_0000.zkey kuiz_0001.zkey --name="Frist contribution" -v -e="Random entropy"
snarkjs zkey contribute kuiz_0001.zkey kuiz_0002.zkey --name="Second contribution" -v -e="Another random entropy"
snarkjs zkey beacon kuiz_0002.zkey kuiz_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

snarkjs zkey export verificationkey kuiz_final.zkey verification_key.json
snarkjs zkey export solidityverifier kuiz_final.zkey verifier.sol

cp verifier.sol ../contracts/kuiz/Verifier.sol
cp verification_key.json ../zkeyFiles/verification_key.json
cp kuiz_js/kuiz.wasm ../zkeyFiles/kuiz.wasm
cp kuiz_final.zkey ../zkeyFiles/kuiz_final.zkey
