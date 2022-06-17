import Link from 'next/link';
import styles from "../styles/Home.module.css"


export default function CreateKuiz() {
  return (
    <>
        <main className={styles.main}>

      <h1>Create Kuiz</h1>
      <h2>
        <Link href="/">
          <a>Back to home</a>
        </Link>
      </h2>
      </main>
    </>
  );
}
