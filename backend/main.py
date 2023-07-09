from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

students = []
last_id = 0

@app.route('/api/students', methods=['POST'])
def create_student():
    global last_id
    data = request.get_json()
    name = data['name']
    mobile_number = data['mobile_number']
    
    # increment last id
    last_id += 1

    student = {
        'id': str(last_id),
        'name': name,
        'mobile_number': mobile_number
    }

    students.append(student)

    return jsonify({'message': 'Student created successfully.'}), 201

# create student list api /api/students method get, return students in json format
@app.route('/api/students', methods=['GET'])
def get_students():
    # return jsonify({'students': students}), 200
    return jsonify(students), 200

if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=5000, debug=True)
