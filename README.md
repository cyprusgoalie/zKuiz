<p align="center">
    <h1 align="center">
      zKuiz
    </h1>
    <p align="center">A simple quiz building protocol forked from ZKU projects <a href="https://talk.harmony.one/t/ninja-survey-a-dao-tooling-platform-for-anonymous-survey-with-zk/15133">Survey Ninja</a> and <a href="https://talk.harmony.one/t/zk-survey-anonymous-survey-application/19477">ZK Survey</a>, with a little bit of <a href="https://github.com/semaphore-protocol/semaphore">Semaphore</a>.</p>
</p>

## Description

Blockchain technologies and zero-knowledge proofs could fundamentally impact multiple sectors of everyday life, including education. Currently, educational applications of blockchain, like on-chain testing, is still in its infancy, but there is room to grow! zKuiz is a small "proof of concept" project to implement on-chain quizes, with privacy secured by the "moon math" of zero-knowledge proofs. zKuiz was developed as a final project for ZKU's cohort 3. 

## 🛠 Install

Clone this repository and install the dependencies:

```bash
git clone https://github.com/cyprusgoalie/zKuiz.git
cd zKuiz
yarn
```

## 📜 Usage

#### 1. Compile & test the contract

```bash
yarn compile
yarn test
```

#### 2. Run Next.js server & Hardhat network

```bash
yarn dev
```

#### 3. Deploy the contract

```bash
yarn deploy --network localhost
```

#### 4. Open the app

You can open the web app on http://localhost:3000.

#### 5. Install Metamask and connect the Hardhat wallet

You can find the mnemonic phrase [here](https://hardhat.org/hardhat-network/reference/#accounts).

#### 6. Create your proof

You must use one of the first 3 Hardhat accounts.


