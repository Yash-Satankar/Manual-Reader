import os
import PyPDF2
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np

embedder = SentenceTransformer("sentence-transformers/all-mpnet-base-v2")
nlist = 100
quantizer = faiss.IndexFlatL2(768)
index = faiss.IndexIVFFlat(quantizer, 768, nlist, faiss.METRIC_L2)

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

    if not chunks:
        raise ValueError("No text chunks found to index.")
    embeddings = embedder.encode(chunks, convert_to_tensor=True)
    embeddings = np.array(embeddings)

    nlist = min(100, len(embeddings) // 2)

    dimension = embeddings.shape[1]
    quantizer = faiss.IndexFlatL2(dimension)
    index = faiss.IndexIVFFlat(quantizer, dimension, nlist, faiss.METRIC_L2)

    if len(embeddings) >= nlist:
        index.train(embeddings)
        index.add(embeddings)
    else:
        raise ValueError("Insufficient data for training FAISS index.")
    return chunks, index