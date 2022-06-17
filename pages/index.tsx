// This code fulfills Assignment 3.2. The Semaphore boilderplate code
// is used as a base, and some parts of the code (including usage
// of the Yup package) is heavily based on Francisco Mendes' tutorial
// found here: https://dev.to/franciscomendes10866/react-form-validation-with-react-hook-form-and-yup-4a98

import detectEthereumProvider from "@metamask/detect-provider"
import { Strategy, ZkIdentity } from "@zk-kit/identity"
import { generateMerkleProof, Semaphore } from "@zk-kit/protocols"
import { providers } from "ethers"
import Head from "next/head"
import React from "react"
import styles from "../styles/Home.module.css"
import Link from "next/link"
// importing additional packages for the form, yup validation
// and having yup play nicely with the form hook
import { useForm } from "react-hook-form";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";
// import {
//     BrowserRouter as Router,
//     Switch,
//     Route,
//     Link
// } from "react-router-dom"

// Using Yup to develop a schema, where each item we require for
// our form (name, age, address), is validated with the correct
// input (e.g. a positive integer for the age.)
const schema = yup.object().shape({
    name: yup.string().required(),
    age: yup.number().required().positive().integer(),
    address: yup.string().required(),
  }); 


export default function Home() {

    const [logs, setLogs] = React.useState("Connect your wallet and greet!")
    const [greets, setGreets] = React.useState("Greetings will go here")
    const { register, handleSubmit, formState: { errors }, reset } = useForm({resolver: yupResolver(schema)});
    
    // when we submit the form data, log the JSON of the data to the console
    // and then clear the input fields to get ready for the next input
    const onSubmitHandler = (data: any) => {
        console.log(JSON.stringify(data));
        reset();
    };  

    async function greet() {
        setLogs("Creating your Semaphore identity...")
        setGreets("Your greeting is in progress...")

        const provider = (await detectEthereumProvider()) as any

        await provider.request({ method: "eth_requestAccounts" })

        const ethersProvider = new providers.Web3Provider(provider)
        const signer = ethersProvider.getSigner()
        const message = await signer.signMessage("Sign this message to create your identity!")

        const identity = new ZkIdentity(Strategy.MESSAGE, message)
        const identityCommitment = identity.genIdentityCommitment()
        const identityCommitments = await (await fetch("./identityCommitments.json")).json()

        const merkleProof = generateMerkleProof(20, BigInt(0), identityCommitments, identityCommitment)

        setLogs("Creating your Semaphore proof...")
        setGreets("Creating your greeting...")

        const greeting = "Hello world"

        const witness = Semaphore.genWitness(
            identity.getTrapdoor(),
            identity.getNullifier(),
            merkleProof,
            merkleProof.root,
            greeting
        )

        const { proof, publicSignals } = await Semaphore.genProof(witness, "./semaphore.wasm", "./semaphore_final.zkey")
        const solidityProof = Semaphore.packToSolidityProof(proof)

        const response = await fetch("/api/greet", {
            method: "POST",
            body: JSON.stringify({
                greeting,
                nullifierHash: publicSignals.nullifierHash,
                solidityProof: solidityProof
            })
        })

        if (response.status === 500) {
            const errorMessage = await response.text()

            setLogs(errorMessage)
            setGreets("Sorry, no greeting :(")

        } else {
            setLogs("Your anonymous greeting is onchain :)")
            // Setting our greeting textbox, when a new greeting is initiated
            setGreets(greeting)
        }
    }

    return (
        <div className={styles.container}>
            
            {/* First, we set the title of the page.*/}
            <Head>
                <title>cypg's zKuiz</title>
                <meta name="description" content="A simple Next.js/Hardhat privacy application with Semaphore." />
                <link rel="icon" href="/favicon.ico" />
            </Head>

            <main className={styles.main}>

            {/* Then we start adding content to the page itself, starting
            with the greeting! */}

            <h1 className={styles.title}>zKuiz</h1>
            <h2>
            <Link href="create-kuiz">
                <a className={styles.link}>Create a Kuiz</a>
            </Link>
            </h2>
            <h2>
            <Link href="take-kuiz">
                <a>Take a Kuiz</a>
            </Link>
            </h2>
            <h2>
            <Link href="kuiz-results">
                <a>Kuiz results</a>
            </Link>
            </h2>
                
                {/* The first part will be based off of the Semaphore
                boilerplate, with minor modifications as described below. */}
                {/* <p className={styles.description}>A simple classroom/quiz project secured by ZKPS.</p> */}

                <div className={styles.logs}>{logs}</div>

                <div onClick={() => greet()} className={styles.button}>
                    Connect wallet
                </div>

                {/* This textbox listens for new greetings, and changes the box based on the new greetings made. (Part 3.2.3) */}
                <div className={styles.logs}>{greets}</div>

                {/* Now, we create a form which logs the information to the console in JSON format.*/}
                {/* <p>Below is a simple form that will take your name, age, and address and log the JSON form of it to the console. Note that values are validated for proper input (e.g. positive integers for age). After submitting the form, the fields will reset. </p>

                <form onSubmit={handleSubmit(onSubmitHandler)} className={styles.description}>
                    {/* This textbox is for the name, and requires a string. */}
                    {/* <input {...register("name")} placeholder="Your name" type="string" required/>
                    <p>{errors.name?.message}</p>
                    {/* This textbox is for the age, and requires a positive integer */}
                    {/* <input {...register("age")} placeholder="Age" type="number" required/> */}
                    {/* <p>{errors.age?.message}</p> */}
                    {/* This textbox is for the address, and requires a string. */}
                    {/* <input {...register("address")} placeholder="Your address" type="string" required/> */}
                    {/* <p className={styles.log}>{errors.address?.message}</p> */}
                    {/* This button submits the information from the form.*/}
                    {/* <button type="submit" className={styles.button}>Button</button> */}
                {/* </form> */} 
            </main>
        </div>
    )
}
