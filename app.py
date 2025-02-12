from flask import Flask, render_template, request, redirect, url_for 
import psycopg2 
app = Flask(__name__) 
# Database connection details 
DB_HOST = 'your_database_host' 
DB_NAME = 'your_database_name' 
DB_USER = 'your_database_user' 
DB_PASS = 'your_database_password' 
def get_db_connection(): 
  conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS) 
  return conn 
  @app.route('/') 
  def index(): 
    conn = get_db_connection() 
    cur = conn.cursor() 
    cur.execute("SELECT * FROM your_table_name;") 
    records = cur.fetchall() 
    cur.close() 
    conn.close() 
    return render_template('index.html', records=records) 
    @app.route('/add', methods=['POST']) 
    def add_record(): 
      value = request.form['value'] 
      ip = request.form['ip'] 
      conn = get_db_connection() 
      cur = conn.cursor() 
      cur.execute("INSERT INTO your_table_name (value, ip) VALUES (%s, %s)", (value, ip)) 
      conn.commit() 
      cur.close() 
      conn.close() 
      return redirect(url_for('index')) 
      @app.route('/delete/<int:id>', methods=['POST']) 
      def delete_record(id): 
        conn = get_db_connection() 
        cur = conn.cursor() 
        cur.execute("DELETE FROM your_table_name WHERE id = %s;", (id,)) 
        conn.commit() 
        cur.close() 
        conn.close() 
        return redirect(url_for('index')) 
        @app.route('/reset', methods=['POST']) 
        def reset_service(): 
          conn = get_db_connection() 
          cur = conn.cursor() cur.execute("DELETE FROM your_table_name;") # Deletes all records 
          conn.commit() 
          cur.close() 
          conn.close() 
          return redirect(url_for('index')) 
        
if __name__ == '__main__': app.run(debug=True)
