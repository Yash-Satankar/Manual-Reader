from flask import Flask, request, jsonify
import os
from document_processing import extract_text_from_pdf, prepare_index
from question_answering import answer_question
from database import save_pdf_info, save_qa_history
from flask_cors import CORS
from database import get_db_connection

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload_pdf', methods=['POST'])
def upload_pdf():
    if 'file' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    file = request.files['file']
    user_id = request.form.get('user_id')
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    pdf_text = extract_text_from_pdf(file_path)
    pdf_id = save_pdf_info(user_id, file.filename, file_path)

    global chunks
    chunks = prepare_index(pdf_text)
    
    return jsonify({"message": "File uploaded and processed", "pdf_id": pdf_id})

@app.route('/ask_question', methods=['POST'])
def ask_question():
    data = request.get_json()
    user_id = data['user_id']
    question = data['question']
    pdf_id = data['pdf_id']

    answer = answer_question(question, chunks)

    save_qa_history(user_id, question, answer, pdf_id)

    return jsonify({"answer": answer})

@app.route('/get_history', methods=['GET'])
def get_history():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM user_history ORDER BY timestamp DESC")
    history = cursor.fetchall()
    cursor.close()
    return jsonify(history), 200

if __name__ == "__main__":
    app.run(debug=True)
