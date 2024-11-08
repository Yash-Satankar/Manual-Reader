from transformers import pipeline
from document_processing import index, embedder
import numpy as np

qa_pipeline = pipeline("question-answering", model="distilbert-base-cased-distilled-squad")

def retrieve_relevant_chunk(question, chunks):
    question_embedding = np.array(embedder.encode([question], convert_to_tensor=True))
    _, indices = index.search(question_embedding, k=3)
    relevant_chunks = [chunks[i] for i in indices[0] if i < len(chunks)]
    return relevant_chunks

def answer_question(question, chunks):
    relevant_chunks = retrieve_relevant_chunk(question, chunks)
    context = " ".join(relevant_chunks)
    result = qa_pipeline(question=question, context=context)
    return result["answer"]
