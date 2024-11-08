import os
import PyPDF2
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np

embedder = SentenceTransformer("sentence-transformers/all-mpnet-base-v2")
embedding_dim = 768
nlist = 100
quantizer = faiss.IndexFlatL2(embedding_dim)
index = faiss.IndexIVFFlat(quantizer, embedding_dim, nlist)

def extract_text_from_pdf(file_path):
    text = ""
    with open(file_path, "rb") as file:
        pdf = PyPDF2.PdfReader(file)
        for page_num in range(len(pdf.pages)):
            page = pdf.pages[page_num]
            text += page.extract_text()
    return text

def prepare_index(text):
    chunks = text.split("\n\n")
    embeddings = embedder.encode(chunks, convert_to_tensor=True)
    embeddings = np.array(embeddings)
    index.train(embeddings)
    index.add(embeddings)
    return chunks
