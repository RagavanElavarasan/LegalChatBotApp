from pymongo import MongoClient

def get_db():
    """
    Establishes connection to MongoDB Atlas and returns the database.
    Replace the connection string with your actual MongoDB Atlas connection string.
    """
    client = MongoClient("mongodb+srv://chatbot:chatbot123@cluster0.i1lqs.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")

    # Replace 'mydatabase' with your actual database name
    db = client["chatbot"]
    
    return db
