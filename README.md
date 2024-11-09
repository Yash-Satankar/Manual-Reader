# Manual Reader Q&A Project

This project is an end-to-end solution that allows users to upload PDF manuals and ask questions about them. The backend (Python) handles PDF uploads, text extraction, and question-answering using Retrieval-Augmented Generation (RAG) with FAISS and Transformers, while user data and Q&A history are stored in a MySQL database. The frontend is built with Flutter for a mobile-friendly user interface.

## Features
- PDF upload and text extraction
- Question-answering based on manual contents
- MySQL database integration for user data and Q&A history
- Flutter mobile app for easy access and user interaction

---

## Table of Contents
1. [Backend Setup](#backend-setup)
2. [Database Setup](#database-setup)
3. [Flutter Frontend](#flutter-frontend)
4. [Testing the API](#testing-the-api)
5. [Project Structure](#project-structure)

---

## Backend Setup

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Yash-Satankar/Manual-Reader.git
    cd Manual-Reader/backend
    ```

2. **Set up a virtual environment** (recommended):
    ```bash
    python -m venv rag_env
    source rag_env/bin/activate  # On Windows: rag_env\Scripts\activate
    ```

3. **Configure the MySQL Database**: (see [Database Setup](#database-setup) for details)

4. **Start the Flask Server**:
    ```bash
    python app.py
    ```
    The server should now be running at `http://127.0.0.1:5000`.

---

## Database Setup

1. **Install MySQL**: Download and install MySQL Server from [here](https://dev.mysql.com/downloads/installer/).

2. **Create a Database and User**:
   - Open your MySQL client and run the following commands:
     ```sql
     CREATE DATABASE manual_reader_db;
     CREATE USER 'your_username'@'localhost' IDENTIFIED BY 'your_password';
     GRANT ALL PRIVILEGES ON manual_reader_db.* TO 'your_username'@'localhost';
     FLUSH PRIVILEGES;
     ```

3. **Add Database Credentials**:
   - Open `database.py` in the backend code and replace `your_username`, `your_password`, and `manual_reader_db` with your MySQL credentials:
     ```python
     # database.py
     import mysql.connector

     connection = mysql.connector.connect(
         host="localhost",
         user="your_username",
         password="your_password",
         database="manual_reader_db"
     )
     ```
4. **Run Initial Database Migration** (if needed):
   - You may want to add a table for user data and Q&A history. Here’s an example script you can run in your MySQL client:
     ```sql
     CREATE TABLE user_history (
         id INT AUTO_INCREMENT PRIMARY KEY,
         user_id VARCHAR(255),
         question TEXT,
         answer TEXT,
         timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );
     ```

---

## Flutter Frontend

1. **Set Up Flutter**: Install Flutter by following the instructions from the official [Flutter website](https://flutter.dev/docs/get-started/install).

2. **Navigate to the Flutter Directory**:
    ```bash
    cd ../frontend
    ```

3. **Run Flutter App**:
    ```bash
    flutter pub get
    flutter run
    ```

Make sure to add the URL of the backend API in your Flutter app’s configuration to enable communication with the Flask server.

---

## Testing the API

Once the backend is running, you can test it with tools like [Postman](https://www.postman.com/) or directly from the Flutter app. Here’s a sample workflow:

1. **Upload a PDF**:
   - Make a `POST` request to `http://127.0.0.1:5000/upload_pdf` with a form-data field named `file` containing your PDF file.

2. **Ask a Question**:
   - Make a `POST` request to `http://127.0.0.1:5000/ask_question` with a JSON payload:
     ```json
     {
       "question": "How do I turn on the appliance?"
     }
     ```

---

## Project Structure

```plaintext
Manual-Reader/
├── backend/
│   ├── app.py              # Flask app entry point
│   ├── database.py         # MySQL database connection
│   ├── question_answer.py  # QA model and RAG functions
│   ├── document_processing.py  # Document processing functions
├── frontend/
│   ├── lib/
│   ├── pubspec.yaml        # Flutter dependencies
│   └── ...
├── README.md               # Project documentation
└── ...
