# Restaurant Review Q&A (RAG with Ollama + LangChain + ChromaDB)

A simple RAG project that answers questions about restaurant reviews using a local LLM.

# Overview
- Uses Ollama to run `llama3.2`
- Creates embeddings with mxbai-embed-large
- Stores vectors in ChromaDB
- Retrieves top-k relevant reviews for each question
- Generates answers through LangChain using a CLI chat loop

# Tech Stack
Python, Ollama, LangChain, ChromaDB, Pandas

# Project Structure
.
├── main.py                  # Q&A chat loop  
├── vector.py                # Embedding + retriever setup  
├── requirements.txt         # Dependencies  
└── realistic_restaurant_reviews.csv  # Review dataset  


