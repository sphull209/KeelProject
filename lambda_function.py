import psycopg2
import os

def lambda_handler(event, context):
    try:
        # Establish connection to PostgreSQL RDS
        connection = psycopg2.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            dbname=os.environ['DB_NAME'],
            port=5432
        )

        cursor = connection.cursor()

        # Define the SQL delete query
        delete_query = "DELETE FROM my_table WHERE condition = %s"
        condition = event['condition']

        # Execute the query
        cursor.execute(delete_query, (condition,))
        connection.commit()

        cursor.close()
        connection.close()

        return {
            'statusCode': 200,
            'body': f"Records deleted where condition = {condition}"
        }

    except Exception as error:
        return {
            'statusCode': 500,
            'body': f"Error deleting records: {str(error)}"
        }
