from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from db_connection import get_db

app = Flask(__name__)

# Get the MongoDB database and access the 'users' collection
db = get_db()
users_collection = db['users']

# Route for user signup
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    user_name = data.get('user_name')
    email = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    # Check for required fields
    if not all([user_name, email, password, confirm_password]):
        return jsonify({"error": "All fields are required"}), 400

    # Check if the passwords match
    if password != confirm_password:
        return jsonify({"error": "Passwords do not match"}), 400

    # Check if the email is already in use
    if users_collection.find_one({"email": email}):
        return jsonify({"error": "Email already exists"}), 400

    # Hash the password for security
    hashed_password = generate_password_hash(password)

    # Insert the user into the MongoDB collection
    user_id = users_collection.insert_one({
        "user_name":user_name,
        "email": email,
        "password": hashed_password
    }).inserted_id

    return jsonify({"message": "User created", "user_id": str(user_id)}), 201

# Route for user login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data['email']
    password = data['password']

    # Find the user in the MongoDB collection
    user = users_collection.find_one({"email": email})

    if not user:
        return jsonify({"error": "Invalid email or password"}), 400

    # Check if the password matches the stored hashed password
    if check_password_hash(user['password'], password):
        return jsonify({"message": "Login successful", "user_id": str(user['_id'])}), 200
    else:
        return jsonify({"error": "Invalid email or password"}), 400

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True, port=5001)