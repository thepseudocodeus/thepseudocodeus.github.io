# SCRIPT PORTFOLIO

## Part 1: Compression/Decompression Script:

Mathematical Invariant: The core invariant here is data redundancy. Compression exploits this redundancy to represent data more compactly. We will use this principle to structure the script.

Implementation: The script will be written to be cross-platform, using Python's subprocess module to call system commands (tar, zstd, gzip). It will first attempt to use the most efficient tools (zstd) and then fall back to more common ones (tar with gzip) if zstd is not found, providing a clear error message. This demonstrates the "discover" (check for tools), "refine" (use the best available), and "exploit" (execute the command) steps.

Code: Provide a fully functional Python script with clear comments and a robust main function to handle different file types and options.


## Part 2: Encryption/Decryption Script:

Mathematical Invariant: The invariant for this problem is cryptographic security, which relies on a one-way mathematical function (the hash) and a reversible function (the encryption algorithm). The integrity of the data is confirmed by the immutability of the hashsum.

Implementation: The script will use the cryptography library for robust, modern encryption and decryption (e.g., AES). It will generate a hashsum of the original file using a secure hashing algorithm (SHA-256) before encryption and store it. During decryption, it will generate a new hashsum and compare it to the original, providing a provable method to detect tampering.

Code: Provide a fully functional Python script with clear comments and a robust main function. Include instructions on how to install the cryptography library.


## Part 3: Universal Script Management Script:

Mathematical Invariant: The invariant for this problem is process state and behavior, which can be modeled as a monadic state machine. The script's job is to ensure predictable behavior by wrapping the process in a monadic container, tracking its state, and logging all events.

Implementation: The script will use typer for a command-line interface, rich for rich text output, tqdm for progress bars, and inquirerpy for user input. The core logic will be to wrap the subprocess call in a custom monad class that enforces a strict flow (input -> process -> output). Logging will be done to a duckdb database file for fast, structured data gathering.
