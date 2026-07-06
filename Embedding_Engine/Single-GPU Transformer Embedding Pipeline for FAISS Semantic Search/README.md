# Single-GPU Semantic Search Engine with PyTorch, Transformers, and FAISS

A GPU-accelerated semantic search project that generates dense embeddings for text passages using a Transformer model and retrieves the most relevant passages using FAISS vector similarity search.

---

## Overview

This project demonstrates how to build a semantic search pipeline using Transformer embeddings. Instead of relying on exact keyword matching, the system understands the meaning of a query and returns contextually similar passages.

The project supports GPU acceleration when CUDA is available and falls back to CPU otherwise.

---

## Features

- Generate dense passage embeddings using `sentence-transformers/all-MiniLM-L6-v2`
- Use mean pooling to convert token-level outputs into passage-level embeddings
- Normalize embeddings for cosine-similarity-style search
- Store vectors in a FAISS index
- Retrieve top-k semantically similar passages for a query
- Benchmark search latency across multiple queries
- Supports single-GPU execution

---

## Tech Stack

- Python
- PyTorch
- Hugging Face Transformers
- FAISS
- Pandas
- NumPy
- tqdm
- CUDA

---

## Architecture

```text
Raw passages
    ↓
Pandas DataFrame
    ↓
PyTorch Dataset
    ↓
DataLoader
    ↓
Tokenizer
    ↓
Transformer model
    ↓
Mean pooling
    ↓
L2 normalization
    ↓
FAISS index
    ↓
Semantic search results
```

---

## Dataset Format

The input dataset should contain at least these columns:

| Column | Description |
|---|---|
| `passage_id` | Unique ID for each passage |
| `passage` | Text passage to be embedded and searched |

Example:

| passage_id | passage |
|---|---|
| 1 | PyTorch is used for deep learning. |
| 2 | Transformers use attention mechanisms. |
| 3 | FAISS is used for vector similarity search. |

---

## Installation

```bash
pip install torch transformers sentence-transformers faiss-cpu pandas numpy tqdm
```

For GPU support, install the correct PyTorch CUDA version from the official PyTorch website.

---

## How It Works

1. Load text passages from a dataset.
2. Convert passages into token IDs and attention masks using a Transformer tokenizer.
3. Generate contextual token embeddings using a Transformer model.
4. Apply mean pooling to create one embedding per passage.
5. Normalize embeddings using L2 normalization.
6. Add passage embeddings to a FAISS `IndexFlatIP` index.
7. Convert a user query into an embedding.
8. Search FAISS to retrieve the most relevant passages.

---

## Usage

### Generate passage embeddings

```python
outputs = model(input_ids=input_ids, attention_mask=attention_mask)
embeddings = mean_pooling(outputs, attention_mask)
embeddings = F.normalize(embeddings, p=2, dim=1)
```

### Create FAISS index

```python
embedding_dim = embeddings_matrix.shape[1]

index = faiss.IndexFlatIP(embedding_dim)
index.add(embeddings_matrix)
```

### Run semantic search

```python
results = semantic_search("what is cloud computing", top_k=5)

for result in results:
    print(result["passage_id"])
    print(result["score"])
    print(result["passage"])
```

---

## Example Output

```text
Passage ID: 42
Score: 0.8123
Passage: Cloud computing allows users to access computing resources over the internet.
```

---

## Benchmarking

The project includes a simple benchmark to measure query latency.

Example metrics:

```text
Total queries: 10
Average search latency: 7.12 ms
Minimum latency: 5.83 ms
Maximum latency: 10.64 ms
```

Actual performance depends on hardware, batch size, dataset size, and GPU availability.

---

## Current Implementation

This project currently uses a single device:

- If CUDA is available, it runs on one GPU, usually `cuda:0`
- If CUDA is not available, it runs on CPU

Although multiple GPUs may be available in the environment, the current implementation does not use distributed or multi-GPU processing.

---

## Important Notes

- FAISS stores vectors, not the original passage text.
- FAISS returns vector row indices and similarity scores.
- Returned FAISS indices are mapped back to the original DataFrame using row position.
- `shuffle=False` is used in the DataLoader to preserve the order between DataFrame rows and FAISS vectors.
- Passage embeddings and query embeddings must both be normalized for inner product search to behave like cosine similarity.







