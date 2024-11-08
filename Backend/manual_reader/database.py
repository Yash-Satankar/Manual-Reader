import mysql.connector

db_config = {
    "host": "localhost",
    "user": "root", #Enter your username
    "password": "Yks@251198", #Enter your password
    "database": "manual_reader_db"
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

def save_pdf_info(user_id, filename, file_path):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO pdf_files (user_id, filename, file_path) VALUES (%s, %s, %s)",
        (user_id, filename, file_path)
    )
    conn.commit()
    pdf_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return pdf_id

def save_qa_history(user_id, question, answer, pdf_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO qa_history (user_id, question, answer, pdf_id) VALUES (%s, %s, %s, %s)",
        (user_id, question, answer, pdf_id)
    )
    conn.commit()
    cursor.close()
    conn.close()
